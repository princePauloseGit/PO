codeunit 50103 ApplyMinCalc
{
    trigger OnRun()
    var
        stkCode, vendorVar, sortkey : Code[50];
    begin
        ApplyMinCalculation(stkCode, vendorVar, sortkey);
    end;

    var
        recENHPOPStockMinCalc: Record ENHPOP_StockMinCalc;

    procedure ApplyMinCalculation(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        recEntryDateProduction: Record EntryDateProduction;
        recTempSalesCalculation: Record TempSalesCalculation; //TempSalesCalculation

        LiveStartDate, EndHistoryDate, ForecastDate, LiveCurrentBeginningMonth : Date;
        expr: Text;
        NoOfMonths: Integer;
        cu_ForecastData: Codeunit ForecastData;
        cu_MinSalesCalculation: Codeunit MinSalesCalculation;
    begin

        CalcFrequencyDate();
        InsertENHPOP_StockMinCalc(parItemNo, parVendor, parItemCategoryCode);
        UpdateItemMinError(parItemNo, parVendor, parItemCategoryCode);
        AssignRule();

        if recEntryDateProduction.FindFirst() then begin
            LiveStartDate := recEntryDateProduction.StartingDate;
            EndHistoryDate := CALCDATE('<5M+CM>', LiveStartDate);
            LiveCurrentBeginningMonth := CALCDATE('-CM', LiveStartDate);
        end;

        // can remove if code after 6 months from live date
        if (LiveStartDate <> 0D) and (Today <= EndHistoryDate) and (Today >= LiveCurrentBeginningMonth) then begin
            NoOfMonths := DATE2DMY(Today, 2) - DATE2DMY(LiveStartDate, 2) + 12 * (DATE2DMY(Today, 3) - DATE2DMY(LiveStartDate, 3));
            expr := '<-' + format(6 - NoOfMonths) + 'M-CM>';
            ForecastDate := CALCDATE(expr, LiveStartDate);
            // First six months until sufficient history exists in Business Central – for that time, use the value in new field AverageLeadTime
            CalcAvgLeadTimeForFirstSixMonths();
        end
        else begin
            CalcAverageLeadTime();
            // CalculateMinSales();
        end;
        cu_MinSalesCalculation.CalculateMinSales(LiveStartDate);
        PostItemSupplierHasNoPO();
        CalcSupplierAverageLeadTime(parVendor);
        CalcZeroMinRecalcMin2Sales(parItemNo, parVendor, parItemCategoryCode);
        ApplyOverrideRules();
    end;

    local procedure CalcFrequencyDate()
    var
        recENHPOP_DaysOfMonth: Record ENHPOP_DaysOfMonth;
        recENHPOP_POFrequency: Record ENHPOP_POFrequency;
        currentDate, startDate, endDate, fDate : Date;
        day, month, year, numberOfDays, workingDayOfMonth, dayOfWeek, index, minWorkingDayOfCurrentMonth, frequencyCount, weekDay : Integer;
        expr, vJsonText, ddate : Text;
        blnIsWeekDay, flag : Boolean;
        pParams: JsonObject;
        vJsonArray: JsonArray;
        vJsonToken, wJsonToken : JsonToken;
        codInsertFrequencyDate: Codeunit "InsertFrequencyData";
    begin
        //if ENHPOP_POFrequency Initial Data is not inserted
        if recENHPOP_POFrequency.Count = 0 then begin
            codInsertFrequencyDate.InsertFrequencyData();
        end;

        recENHPOP_DaysOfMonth.DeleteAll(); // Delete all records in ENHPOP_DaysOfMonth;

        flag := true;
        currentDate := TODAY;
        day := DATE2DMY(currentDate, 1);
        month := DATE2DMY(currentDate, 2);
        year := DATE2DMY(currentDate, 3);
        startDate := DMY2Date(1, month, year); //first of the current month
        expr := '<-CM+2M-1D>';
        endDate := CalcDate(expr, Today); //last day of next month
        numberOfDays := endDate - startDate; //number of days between the end of next month and the first of the month
        workingDayOfMonth := 0;

        recENHPOP_POFrequency.Reset();
        recENHPOP_POFrequency.ModifyAll(NextFrequencyDate, Today);

        FOR index := 0 TO numberOfDays DO begin
            pParams.Add('pDayPeriod', startDate + index);
            dayOfWeek := Date2DWY(startDate + index, 1);
            pParams.Add('pDayOfWeek', dayOfWeek);

            if dayOfWeek > 5 then begin
                pParams.Add('pIsWeekDay', 0); //1=yes,0=no
                blnIsWeekDay := false;
            end
            else begin
                pParams.Add('pIsWeekDay', 1);
                blnIsWeekDay := true;
            end;

            //if it is the first of the month, reset the workingDayOfMonth incrementer to 0
            if Date2DMY(startDate + index, 2) <> Date2DMY(startDate + (index - 1), 2) then begin
                workingDayOfMonth := 0;
            end;

            //if the current date is a working day then add one to the working day of month counter
            if blnIsWeekDay then begin
                workingDayOfMonth := workingDayOfMonth + 1;
                pParams.Add('pWorkingDayOfMonth', workingDayOfMonth);
                pParams.Add('pFrequencyM', 'M' + Format(workingDayOfMonth));
                pParams.Add('pFrequencyW', 'W' + Format(dayOfWeek));

                if workingDayOfMonth = 1 then begin
                    pParams.Get('pDayPeriod', vJsonToken);
                    pParams.Add('pFrequencyY', 'Y' + Format(DATE2DMY(vJsonToken.AsValue().AsDate(), 2)));
                    Clear(vJsonToken);
                end
                else begin
                    pParams.Add('pFrequencyY', 'Y0');
                end;
            end
            else begin
                pParams.Add('pWorkingDayOfMonth', 0);
                pParams.Add('pFrequencyM', 'M0');
                pParams.Add('pFrequencyW', 'W0');
                pParams.Add('pFrequencyY', 'Y0');
            end;
            vJsonArray.Add(pParams);
            vJsonArray.WriteTo(vJsonText);

            // Calculating minimum working day of month from current month
            if (recENHPOP_DaysOfMonth.FindFirst() and flag)
            then begin
                if DATE2DMY(recENHPOP_DaysOfMonth.DayPeriod, 2) = DATE2DMY(Today, 2) then begin
                    minWorkingDayOfCurrentMonth := recENHPOP_DaysOfMonth.WorkingDayOfMonth;
                    flag := false;

                    //Updating EnhPOPFrequency for Daily frequency
                    recENHPOP_POFrequency.Reset();
                    recENHPOP_POFrequency.Frequency := 'D';

                    if recENHPOP_POFrequency.Find('=') then begin
                        recENHPOP_POFrequency.NextFrequencyDate := recENHPOP_DaysOfMonth.DayPeriod;
                        recENHPOP_POFrequency.Modify();
                    end;
                end;
            end;

            pParams.Get('pDayPeriod', WJsonToken);

            if (WJsonToken.AsValue().AsDate() >= Today) then begin
                recENHPOP_DaysOfMonth.Init();
                recENHPOP_DaysOfMonth.DayPeriod := WJsonToken.AsValue().AsDate();

                pParams.Get('pIsWeekDay', vJsonToken);

                if (vJsonToken.AsValue().AsInteger() = 1) then begin
                    // recENHPOP_DaysOfMonth.IsWeekDay := vJsonToken.AsValue().AsBoolean();
                    Clear(vJsonToken);
                    pParams.Get('pDayOfWeek', vJsonToken);
                    recENHPOP_DaysOfMonth.DayOfWeek := vJsonToken.AsValue().AsInteger();

                    Clear(vJsonToken);
                    pParams.Get('pWorkingDayOfMonth', vJsonToken);

                    if ((DATE2DMY(WJsonToken.AsValue().AsDate(), 2) = Date2DMY(Today, 2))) then begin
                        recENHPOP_DaysOfMonth.WorkingDayOfMonth := vJsonToken.AsValue().AsInteger();

                        Clear(vJsonToken);
                        pParams.Get('pFrequencyM', vJsonToken);
                        recENHPOP_DaysOfMonth.FrequencyM := vJsonToken.AsValue().AsCode();

                        //Updating EnhPOPFrequency for Monthy frequency
                        recENHPOP_POFrequency.Reset();
                        recENHPOP_POFrequency.Frequency := recENHPOP_DaysOfMonth.FrequencyM;

                        if recENHPOP_POFrequency.Find('=') then begin
                            recENHPOP_POFrequency.NextFrequencyDate := recENHPOP_DaysOfMonth.DayPeriod;
                            recENHPOP_POFrequency.Modify();
                        end;

                        Clear(vJsonToken);
                        pParams.Get('pFrequencyW', vJsonToken);
                        recENHPOP_DaysOfMonth.FrequencyW := vJsonToken.AsValue().AsCode();

                        Clear(vJsonToken);
                        pParams.Get('pFrequencyY', vJsonToken);
                        recENHPOP_DaysOfMonth.FrequencyY := vJsonToken.AsValue().AsCode();

                        recENHPOP_DaysOfMonth.Insert();
                        Clear(WJsonToken);
                        Clear(pParams);
                    end
                    else
                        if (vJsonToken.AsValue().AsInteger() < minWorkingDayOfCurrentMonth) then begin
                            recENHPOP_DaysOfMonth.WorkingDayOfMonth := vJsonToken.AsValue().AsInteger();

                            Clear(vJsonToken);
                            pParams.Get('pFrequencyM', vJsonToken);
                            recENHPOP_DaysOfMonth.FrequencyM := vJsonToken.AsValue().AsCode();

                            //Updating EnhPOPFrequency for Monthy frequency
                            recENHPOP_POFrequency.Reset();
                            recENHPOP_POFrequency.Frequency := recENHPOP_DaysOfMonth.FrequencyM;
                            if recENHPOP_POFrequency.Find('=') then begin
                                recENHPOP_POFrequency.NextFrequencyDate := recENHPOP_DaysOfMonth.DayPeriod;
                                recENHPOP_POFrequency.Modify();
                            end;

                            Clear(vJsonToken);
                            pParams.Get('pFrequencyW', vJsonToken);
                            recENHPOP_DaysOfMonth.FrequencyW := vJsonToken.AsValue().AsCode();

                            Clear(vJsonToken);
                            pParams.Get('pFrequencyY', vJsonToken);
                            recENHPOP_DaysOfMonth.FrequencyY := vJsonToken.AsValue().AsCode();

                            recENHPOP_DaysOfMonth.Insert();
                            Clear(WJsonToken);
                            Clear(pParams);
                        end
                        else
                            break;
                end;

            end;
            Clear(pParams);
        end;

        //Updating EnhPOPFrequency
        frequencyCount := 0;

        //Updating EnhPOPFrequency for weekly frequency
        recENHPOP_DaysOfMonth.Reset();

        if recENHPOP_DaysOfMonth.FindSet() then begin
            repeat
                recENHPOP_POFrequency.Frequency := recENHPOP_DaysOfMonth.FrequencyW;
                if recENHPOP_POFrequency.Find('=') then
                    recENHPOP_POFrequency.NextFrequencyDate := recENHPOP_DaysOfMonth.DayPeriod;
                recENHPOP_POFrequency.Modify();

                frequencyCount := frequencyCount + 1;
                recENHPOP_DaysOfMonth.Next();
            UNTIL frequencyCount = 5;
        END;

        //Updating EnhPOPFrequency for yearly frequency
        FOR index := 1 TO 12 DO begin
            recENHPOP_POFrequency.Reset();
            recENHPOP_POFrequency.Frequency := 'Y' + Format(index);

            if recENHPOP_POFrequency.Find('=') then begin
                fDate := DMY2DATE(01, index, Year);
                if fDate < Today then begin
                    fDate := DMY2DATE(01, index, Year + 1);
                    weekDay := Date2DWY(fDate, 1);
                    case weekDay of
                        6:
                            fDate := DMY2DATE(03, index, Year + 1);
                        7:
                            fDate := DMY2DATE(02, index, Year + 1);
                        else
                            fDate := DMY2DATE(01, index, Year + 1);
                    end;

                    recENHPOP_POFrequency.NextFrequencyDate := fDate;
                    recENHPOP_POFrequency.Modify();

                end
                else
                    recENHPOP_POFrequency.NextFrequencyDate := fDate;
                recENHPOP_POFrequency.Modify();
            end;
        end;
    end;

    local procedure InsertENHPOP_StockMinCalc(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        recItem: Record Item;
        recVendor: Record Vendor;
    begin
        //Delete table data for use
        recENHPOPStockMinCalc.DeleteAll();

        // Filtering items records who have vendors
        recItem.SetFilter("Vendor No.", '<>%1', '');

        if parItemNo <> '' then
            recItem.SetFilter("No.", parItemNo);
        if parVendor <> '' then
            recItem.SetFilter("Vendor No.", parVendor);
        if parItemCategoryCode <> '' then
            recItem.SetFilter("Item Category Code", parItemCategoryCode);

        if recItem.FindSet() then begin
            repeat
                recVendor."No." := recItem."Vendor No.";
                if recVendor.Find('=') and not recItem.Blocked then begin
                    if recVendor."Location Code" = 'MAIN' then begin
                        // As per Phil's Call - 16-Feb-23 Include Assembly in View Min Max Calcultaion
                        //if recItem."Replenishment System" <> "Replenishment System"::Assembly then begin
                        recENHPOPStockMinCalc.Init();
                        recENHPOPStockMinCalc.STK_PRIMARY := recItem.SystemCreatedAt;
                        recENHPOPStockMinCalc.STKCODE := recItem."No.";
                        recENHPOPStockMinCalc.STKNAME := recItem.Description;
                        recENHPOPStockMinCalc.STK_SORT_KEY := recItem."Item Category Code";
                        recENHPOPStockMinCalc.STK_SORT_KEY1 := recItem."Vendor Item No.";
                        recENHPOPStockMinCalc.STK_MIN_QTY := recItem."Reorder Point";
                        recENHPOPStockMinCalc.STK_MAX_QTY := recItem."Maximum Inventory";
                        recENHPOPStockMinCalc.STK_PHYSICAL := recItem.Inventory;
                        recENHPOPStockMinCalc.STK_BIN_NUMBER := recItem."Reordering Policy";

                        recItem.CalcFields("Qty. on Sales Order");
                        recItem.CalcFields("Reserved Qty. on Sales Orders");
                        recENHPOPStockMinCalc.STK_BACK_ORDER_QTY := recItem."Qty. on Sales Order" - recItem."Reserved Qty. on Sales Orders";
                        recENHPOPStockMinCalc.STK_DO_NOT_USE := recItem.Blocked;
                        recENHPOPStockMinCalc.RULE_PK := -1;
                        recENHPOPStockMinCalc.SUPPLIER_LEAD_TIME := 1;
                        recENHPOPStockMinCalc.SUPPLIER1 := recItem."Vendor No.";
                        recENHPOPStockMinCalc.Insert();
                        // end;
                    end;
                end;
            until recItem.Next() = 0;
        end;
    end;

    local procedure UpdateItemMinError(parItemNo: Code[30]; parVendor: Code[30]; parItemCategoryCode: Code[50])
    var
        recItem: Record Item;
    begin
        recItem.Reset();
        if (parItemNo <> '') AND (parVendor <> '') then begin
            recItem.SetRange("No.", parItemNo);
            recItem.SetRange("Vendor No.", parVendor);

            if (parItemCategoryCode <> '') then begin
                recItem.SetRange("Item Category Code", parItemCategoryCode);
            end;

            recItem.SetRange(ItemPOError, 'Min Error');
            recItem.ModifyAll(ItemPOError, '');

            recItem.Reset();
            recItem.SetRange("No.", parItemNo);
            recItem.SetRange("Vendor No.", parVendor);
            recItem.SetRange("Replenishment System", "Replenishment System"::Assembly);

            if recItem.FindFirst() then begin
                recItem.ItemPOError := 'Min Error';
                recItem.Modify();
            end;
        end else
            if parItemNo <> '' then begin
                if (parItemCategoryCode <> '') then begin
                    recItem.SetRange("Item Category Code", parItemCategoryCode);
                end;
                recItem.SetRange(ItemPOError, 'Min Error');
                recItem.ModifyAll(ItemPOError, '');
                //---------------
                recItem.Reset();
                recItem.SetRange("No.", parItemNo);
                recItem.SetRange("Vendor No.", '');

                if recItem.FindFirst() then begin
                    recItem.ItemPOError := 'Min Error';
                    recItem.Modify();
                end;

                recItem.Reset();
                if (parItemCategoryCode <> '') then begin
                    recItem.SetRange("Item Category Code", parItemCategoryCode);
                end;
                recItem.SetRange("No.", parItemNo);
                recItem.SetRange("Replenishment System", "Replenishment System"::Assembly);

                if recItem.FindFirst() then begin
                    recItem.ItemPOError := 'Min Error';
                    recItem.Modify();
                end;
            end
            else
                if parVendor <> '' then begin
                    if (parItemCategoryCode <> '') then begin
                        recItem.SetRange("Item Category Code", parItemCategoryCode);
                    end;
                    // if item has vendor and po error is set, then update item po error to empty
                    recItem.SetRange("Vendor No.", parVendor);
                    recItem.SetRange(ItemPOError, 'Min Error');
                    recItem.ModifyAll(ItemPOError, '');

                    recItem.Reset();
                    if (parItemCategoryCode <> '') then begin
                        recItem.SetRange("Item Category Code", parItemCategoryCode);
                    end;
                    // if item has replenishment and po error is set, then update item por error to empty
                    recItem.SetRange("Vendor No.", parVendor);
                    recItem.SetRange("Replenishment System", "Replenishment System"::Assembly);
                    recItem.ModifyAll(ItemPOError, 'Min Error');
                end
                else begin

                    if (parItemCategoryCode <> '') then begin
                        recItem.SetRange("Item Category Code", parItemCategoryCode);
                    end;
                    // if item has vendor and po error is set, then update item po error to empty
                    recItem.SetRange(ItemPOError, 'Min Error');
                    recItem.SetRange("Vendor No.", '<>%1', '');
                    recItem.ModifyAll(ItemPOError, '');

                    recItem.Reset();
                    if (parItemCategoryCode <> '') then begin
                        recItem.SetRange("Item Category Code", parItemCategoryCode);
                    end;
                    // if item has replenishment and po error is set, then update item por error to empty
                    recItem.SetRange(ItemPOError, 'Min Error');
                    recItem.SetFilter("Replenishment System", '<>%1', "Replenishment System"::Assembly);
                    recItem.ModifyAll(ItemPOError, '');

                    recItem.Reset();
                    if (parItemCategoryCode <> '') then begin
                        recItem.SetRange("Item Category Code", parItemCategoryCode);
                    end;
                    // Take all items having no vendor
                    recItem.SETRANGE("Vendor No.", '');
                    recItem.ModifyAll(ItemPOError, 'Min Error');

                    recItem.Reset();
                    if (parItemCategoryCode <> '') then begin
                        recItem.SetRange("Item Category Code", parItemCategoryCode);
                    end;
                    // Take all items having replenishment
                    recItem.SetRange("Replenishment System", "Replenishment System"::Assembly);
                    recItem.ModifyAll(ItemPOError, 'Min Error');
                end;
    end;

    local procedure TempUpdateItemMinError(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        recItem: Record Item;
    begin
        recItem.Reset();
        if parItemNo <> '' then
            recItem.SetFilter("No.", parItemNo);
        if parVendor <> '' then
            recItem.SetFilter("Vendor No.", parVendor);
        if parItemCategoryCode <> '' then
            recItem.SetFilter("Item Category Code", parItemCategoryCode);
        //else begin


        recItem.SetFilter(ItemPOError, 'Min Error');
        recItem.ModifyAll(ItemPOError, '');

        // recItem.Reset();
        recItem.SETRANGE("Vendor No.", '');
        recItem.ModifyAll(ItemPOError, 'Min Error');

        //  recItem.Reset();
        recItem.SetFilter("Replenishment System", Format("Replenishment System"::Assembly));
        recItem.ModifyAll(ItemPOError, 'Min Error');
    end;

    local procedure AssignRule()
    var
        recRuleMatrix: Record "Rules Matrix";
        varMinPriority: Integer;
        varMinId: Integer;
        flag: Boolean;

    begin
        recENHPOPStockMinCalc.Reset();
        recENHPOPStockMinCalc.SetFilter(RULE_PK, '-1');

        if recENHPOPStockMinCalc.FindSet()
        then begin
            repeat
                // As per Phil's Mail - 07-Feb-23
                varMinPriority := -1;
                if recRuleMatrix.FindSet() then
                    repeat
                        if ((recRuleMatrix.STKCODE = recENHPOPStockMinCalc.STKCODE) or (recRuleMatrix.STKCODE = '*')) and
                      ((recRuleMatrix.STK_SORT_KEY = recENHPOPStockMinCalc.STK_SORT_KEY) or (recRuleMatrix.STK_SORT_KEY = '*')) and
                      ((recRuleMatrix.STK_SORT_KEY1 = recENHPOPStockMinCalc.STK_SORT_KEY1) or (recRuleMatrix.STK_SORT_KEY1 = '*')) and
                       ((recRuleMatrix.STK_SUPPLIER1 = recENHPOPStockMinCalc.SUPPLIER1) or (recRuleMatrix.STK_SUPPLIER1 = '*'))
                     then begin
                            if varMinPriority = -1 then begin
                                varMinPriority := recRuleMatrix.PRIORITY;
                                recENHPOPStockMinCalc.RULE_PK := recRuleMatrix.MIN_ID;
                                recENHPOPStockMinCalc.Modify();
                            end;

                            if varMinPriority > recRuleMatrix.PRIORITY then begin
                                varMinPriority := recRuleMatrix.PRIORITY;
                                recENHPOPStockMinCalc.RULE_PK := recRuleMatrix.MIN_ID;
                                recENHPOPStockMinCalc.Modify();
                            end;
                        end;

                    until recRuleMatrix.Next() = 0;

            until recENHPOPStockMinCalc.Next() = 0;
        end;
    end;

    local procedure CalcAvgLeadTimeForFirstSixMonths()
    var
        recitem: Record Item;
    begin
        recitem.Reset();
        recENHPOPStockMinCalc.Reset();
        if recENHPOPStockMinCalc.FindSet() then begin
            repeat
                recitem.SetRange("No.", recENHPOPStockMinCalc.STKCODE);
                if recitem.FindFirst() then begin
                    recENHPOPStockMinCalc.MEAN_LEAD_TIME_DAYS := recItem.enhAverageLeadTime;
                    recENHPOPStockMinCalc.Modify();
                end;

            until recENHPOPStockMinCalc.Next() = 0;
        end;
    end;

    local procedure CalcAverageLeadTime()
    var
        que_GetAllItemforAvgleadTime: Query GetAllItemforAvgleadTime; //GetAllItemforAvgleadTime
        que_GetAllArchveItemforAvgleadTime: Query GetAllArchveItemforAvgleadTime;
        que_GetItemWithAverageLeadTime: Query GetItemWithAverageLeadTime; //GetItemWithAverageLeadTime
        recTempAverageLeadTime: Record TempAverageLeadTime; //TempAverageLeadTime
        rec_TempAvgLeadTimeByDocNo: Record TempAvgLeadTimeByDocNo;
        recRuleMatrix: Record "Rules Matrix";
        expr, itemNumber : Text;
        itemDocumentList, itemDocument, avgDiffItemDocument : Dictionary of [Text, Integer];
        index, totalDiff : Integer;
        math: Codeunit Math;
    begin
        index := 1;
        itemNumber := '';
        //Delete data from Temp_AverageLeadTime
        recTempAverageLeadTime.DeleteAll();
        rec_TempAvgLeadTimeByDocNo.DeleteAll();

        // Add Archived entries in Temp table
        que_GetAllArchveItemforAvgleadTime.Open();

        while que_GetAllArchveItemforAvgleadTime.Read() do begin
            expr := '-' + format(que_GetAllArchveItemforAvgleadTime.DAYS_TO_USE_PO_LEAD) + 'M';
            if (que_GetAllArchveItemforAvgleadTime.PostingDate > que_GetAllArchveItemforAvgleadTime.Order_Date) and (que_GetAllArchveItemforAvgleadTime.PostingDate > CalcDate(expr, Today))
            then begin
                rec_TempAvgLeadTimeByDocNo.Init();
                rec_TempAvgLeadTimeByDocNo.RowNo := CreateGuid();
                rec_TempAvgLeadTimeByDocNo.ItemNo := que_GetAllArchveItemforAvgleadTime.ItemNo;
                rec_TempAvgLeadTimeByDocNo.Buy_from_Vendor_No_ := que_GetAllArchveItemforAvgleadTime.Buy_from_Vendor_No_;
                rec_TempAvgLeadTimeByDocNo.dateDiffDays := que_GetAllArchveItemforAvgleadTime.PostingDate - que_GetAllArchveItemforAvgleadTime.Order_Date;
                rec_TempAvgLeadTimeByDocNo.DocumentNo := que_GetAllArchveItemforAvgleadTime.Document_No_;
                rec_TempAvgLeadTimeByDocNo.Insert();
            end;
        end;
        que_GetAllArchveItemforAvgleadTime.Close();

        // Add Purchase Line Entries in Temp table which are not present in Archived
        que_GetAllItemforAvgleadTime.Open();

        while que_GetAllItemforAvgleadTime.Read() do begin
            expr := '-' + format(que_GetAllItemforAvgleadTime.DAYS_TO_USE_PO_LEAD) + 'M';
            if (que_GetAllItemforAvgleadTime.PostingDate > que_GetAllItemforAvgleadTime.Order_Date) and (que_GetAllItemforAvgleadTime.PostingDate > CalcDate(expr, Today))
            then begin

                rec_TempAvgLeadTimeByDocNo.SetRange(ItemNo, que_GetAllItemforAvgleadTime.ItemNo);
                rec_TempAvgLeadTimeByDocNo.SetRange(DocumentNo, que_GetAllItemforAvgleadTime.Document_No_);

                if not rec_TempAvgLeadTimeByDocNo.FindFirst() then begin

                    rec_TempAvgLeadTimeByDocNo.Init();
                    rec_TempAvgLeadTimeByDocNo.RowNo := CreateGuid();
                    rec_TempAvgLeadTimeByDocNo.ItemNo := que_GetAllItemforAvgleadTime.ItemNo;
                    rec_TempAvgLeadTimeByDocNo.Buy_from_Vendor_No_ := que_GetAllItemforAvgleadTime.Buy_from_Vendor_No_;
                    rec_TempAvgLeadTimeByDocNo.dateDiffDays := que_GetAllItemforAvgleadTime.PostingDate - que_GetAllItemforAvgleadTime.Order_Date;
                    rec_TempAvgLeadTimeByDocNo.DocumentNo := que_GetAllItemforAvgleadTime.Document_No_;
                    rec_TempAvgLeadTimeByDocNo.Insert();
                end;
            end;
        end;
        que_GetAllItemforAvgleadTime.Close();

        rec_TempAvgLeadTimeByDocNo.Reset();
        rec_TempAvgLeadTimeByDocNo.SetCurrentKey(ItemNo);
        rec_TempAvgLeadTimeByDocNo.SetAscending(ItemNo, true);

        if rec_TempAvgLeadTimeByDocNo.FindSet() then begin
            repeat
                if itemNumber = '' then begin
                    itemNumber := rec_TempAvgLeadTimeByDocNo.ItemNo;
                end else
                    if itemNumber <> rec_TempAvgLeadTimeByDocNo.ItemNo then begin
                        index := 1;
                        itemNumber := rec_TempAvgLeadTimeByDocNo.ItemNo;
                        Clear(itemDocumentList);
                        Clear(avgDiffItemDocument);
                    end;

                if itemDocumentList.ContainsKey(itemNumber) then begin
                    index := itemDocumentList.Get(itemNumber) + 1;
                    itemDocumentList.Set(itemNumber, index);

                    totalDiff := avgDiffItemDocument.Get(itemNumber);

                    recTempAverageLeadTime.SetRange(ItemNo, itemNumber);

                    if recTempAverageLeadTime.FindFirst() then begin
                        totalDiff := totalDiff + rec_TempAvgLeadTimeByDocNo.dateDiffDays;
                        avgDiffItemDocument.Set(itemNumber, totalDiff);

                        recTempAverageLeadTime.dateDiffDays := totalDiff;
                        recTempAverageLeadTime.AvgLeadTime := math.Floor(totalDiff / index);
                        recTempAverageLeadTime.Modify();
                    end;
                end
                else begin
                    itemDocumentList.Add(itemNumber, index);
                    avgDiffItemDocument.Add(itemNumber, rec_TempAvgLeadTimeByDocNo.dateDiffDays);

                    recTempAverageLeadTime.Init();
                    recTempAverageLeadTime.RowNo := CreateGuid();
                    recTempAverageLeadTime.ItemNo := itemNumber;
                    recTempAverageLeadTime.Buy_from_Vendor_No_ := rec_TempAvgLeadTimeByDocNo.Buy_from_Vendor_No_;
                    recTempAverageLeadTime.dateDiffDays := rec_TempAvgLeadTimeByDocNo.dateDiffDays;
                    recTempAverageLeadTime.AvgLeadTime := math.Floor(rec_TempAvgLeadTimeByDocNo.dateDiffDays / index);
                    recTempAverageLeadTime.Insert();
                end;
            until rec_TempAvgLeadTimeByDocNo.Next() = 0;
        end;

        //If the rules matrix specifies an override on the calculated lead time, apply that ,otherwise 
        //apply average time based on difference between PO date and received date
        que_GetItemWithAverageLeadTime.Open();

        while que_GetItemWithAverageLeadTime.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetItemWithAverageLeadTime.STKCODE);

            if recENHPOPStockMinCalc.FindFirst() then begin
                if que_GetItemWithAverageLeadTime.OverrideLeadTime = 1 then begin
                    recENHPOPStockMinCalc.MEAN_LEAD_TIME_DAYS := que_GetItemWithAverageLeadTime.OverrideLeadTimevalue;
                end
                else begin
                    recENHPOPStockMinCalc.MEAN_LEAD_TIME_DAYS := que_GetItemWithAverageLeadTime.dateDiffDays;
                end;

                if que_GetItemWithAverageLeadTime.AvgLeadTime = 0 then begin
                    recENHPOPStockMinCalc.SUPPLIER_LEAD_TIME := 1;
                end else begin
                    recENHPOPStockMinCalc.SUPPLIER_LEAD_TIME := que_GetItemWithAverageLeadTime.AvgLeadTime;
                end;

                recENHPOPStockMinCalc.Modify();
            end;
        end;
        que_GetItemWithAverageLeadTime.Close();
    end;

    // local procedure GetAllSalesHeaderandArchieve()
    // var
    //     que_GetAllSalesItem: Query GetAllSalesItem; //GetAllSalesItem
    //     que_GetAllSalesArchieveItem: Query GetAllSalesArchieveItem; //GetAllSalesArchieveItem-InvoiveOrder

    //     recTempSalesCalculation: Record TempSalesCalculation; //TempSalesCalculation
    //     recCustomerExclude: Record Customer;

    //     rowCountDesc: Integer;
    //     varItemNo: Code[50];
    //     expr: Text;
    //     cu_forecastData: Codeunit ForecastData;
    // begin
    //     rowCountDesc := 0;
    //     varItemNo := '';

    //     // Delete all data from temp table TempSalesCalculation
    //     recTempSalesCalculation.DeleteAll();

    //     // Read query GetAllSalesItem and insert into TempSalesCalculation
    //     que_GetAllSalesItem.Open();

    //     while que_GetAllSalesItem.Read() do begin
    //         expr := '-' + format(que_GetAllSalesItem.DAYS_TO_USE) + 'D';

    //         if (que_GetAllSalesItem.Amount > 0) and (que_GetAllSalesItem.Order_Date > CalcDate(expr, Today))
    //         then begin
    //             recCustomerExclude."No." := que_GetAllSalesItem.Sell_to_Customer_No_;
    //             //Ignore any customers flagged to ignoreFromMinMax
    //             if (recCustomerExclude.Find('=')) and (not recCustomerExclude.ignoreFromMinMax) then begin
    //                 recTempSalesCalculation.Init();
    //                 recTempSalesCalculation.Id := CreateGuid();
    //                 recTempSalesCalculation.ItemNo := que_GetAllSalesItem.SalesLine_No;
    //                 recTempSalesCalculation.Quantity := que_GetAllSalesItem.Quantity;
    //                 recTempSalesCalculation.IgnoreTopBOTSalesQty := que_GetAllSalesItem.IGNORE_TOP_BOT_SALES_QTY;
    //                 recTempSalesCalculation.DaysToUse := que_GetAllSalesItem.DAYS_TO_USE;
    //                 recTempSalesCalculation.SupplierOrderCycle := que_GetAllSalesItem.SUPPLIER_ORDER_CYCLE;
    //                 recTempSalesCalculation.QueSystemCreatedAt := que_GetAllSalesItem.Min_SystemCreatedAt;
    //                 recTempSalesCalculation.Insert();
    //             end;
    //         end;
    //     end;
    //     que_GetAllSalesItem.Close();

    //     cu_forecastData.GetSalesArchiveDatawithlastestVersion();

    //     //Set TempSalesCalculation's Table Data order by ItemNo, Qunatity in descending for ignoring top Sales Order
    //     recTempSalesCalculation.Reset();
    //     recTempSalesCalculation.SetCurrentKey(ItemNo, Quantity, QueSystemCreatedAt);
    //     recTempSalesCalculation.SetAscending(ItemNo, false);
    //     recTempSalesCalculation.SetAscending(Quantity, false);
    //     recTempSalesCalculation.SetAscending(QueSystemCreatedAt, false);

    //     if recTempSalesCalculation.FindSet() then begin
    //         repeat
    //             if (recTempSalesCalculation.ItemNo = varItemNo) then begin
    //                 rowCountDesc := rowCountDesc + 1;
    //             end
    //             else begin
    //                 rowCountDesc := 0;
    //                 varItemNo := '';
    //             end;

    //             if (rowCountDesc = 0) then begin
    //                 varItemNo := recTempSalesCalculation.ItemNo;
    //                 rowCountDesc := 1;

    //             end;

    //             //Ignore top X sales where x=IGNORE_TOP_BOT_SALES_QTY(Rules Matrix) and insert into  table Temp_SalesCalculation
    //             if rowCountDesc <= recTempSalesCalculation.IgnoreTopBOTSalesQty then begin
    //                 recTempSalesCalculation.Delete();
    //             end;
    //         until recTempSalesCalculation.Next() = 0;
    //     end;

    // end;

    // local procedure CalculateMinSales()
    // var

    //     que_GetSalesComponent: Query GetSalesComponent; //GetSalesComponent
    //     que_GetSalesCalculation: Query GetSalesCalculation; //GetSalesCalculation

    //     recTempSalesCalculation: Record TempSalesCalculation; //TempSalesCalculation
    //     recCustomerExclude: Record Customer;

    //     expr: Text;
    //     rowCountDesc, multiplierSupplierOrderCycle : Integer;
    //     totQuantity, salesPerDay, newMin : Decimal;
    //     varItemNo: Code[50];
    //     math: Codeunit Math; //Standard CodeUnit for performing maths operation

    // begin
    //     GetAllSalesHeaderandArchieve();

    //     que_GetSalesComponent.Open();

    //     while que_GetSalesComponent.Read() do begin
    //         expr := '-' + format(que_GetSalesComponent.DAYS_TO_USE) + 'D';

    //         // Insert Sales Component Data into table Temp_SalesCalculation
    //         if (que_GetSalesComponent.Posting_Date > CalcDate(expr, Today)) then begin
    //             recTempSalesCalculation.Init();
    //             recTempSalesCalculation.Id := CreateGuid();
    //             recTempSalesCalculation.ItemNo := que_GetSalesComponent.Item_No_;
    //             // As per Phil's Call - 16-Feb-23 Multiply by -1 for Assembly Quantity.
    //             if que_GetSalesComponent.Quantity < 0 then
    //                 recTempSalesCalculation.Quantity := que_GetSalesComponent.Quantity * -1
    //             else
    //                 recTempSalesCalculation.Quantity := que_GetSalesComponent.Quantity;
    //             recTempSalesCalculation.DaysToUse := que_GetSalesComponent.DAYS_TO_USE;
    //             recTempSalesCalculation.SupplierOrderCycle := que_GetSalesComponent.SUPPLIER_ORDER_CYCLE;
    //             recTempSalesCalculation.QueSystemCreatedAt := que_GetSalesComponent.Min_SystemCreatedAt;
    //             recTempSalesCalculation.Insert();
    //         end;
    //     end;
    //     que_GetSalesComponent.Close();

    //     que_GetSalesCalculation.Open();

    //     while que_GetSalesCalculation.Read() do begin
    //         recENHPOPStockMinCalc.Reset();
    //         //recEnhPOPStockMinCalc.STKCODE := que_GetSalesCalculation.ItemNo;
    //         recENHPOPStockMinCalc.SetRange(STKCODE, que_GetSalesCalculation.ItemNo);
    //         if recENHPOPStockMinCalc.FindFirst() then begin
    //             //if (recEnhPOPStockMinCalc.Find('=')) then begin
    //             //Total the sales Quantity
    //             totQuantity := (math.Ceiling(que_GetSalesCalculation.Quantity * 1000)) / 1000;

    //             //Calculate average Sales Per Day
    //             salesPerDay := (math.Ceiling((que_GetSalesCalculation.Quantity / que_GetSalesCalculation.DaysToUse) * 1000)) / 1000;

    //             if (que_GetSalesCalculation.SupplierOrderCycle > 0) then
    //                 multiplierSupplierOrderCycle := que_GetSalesCalculation.SupplierOrderCycle
    //             // else if (when coalesce(su_usrnum2,0)>0 then su_usrnum2 )
    //             else
    //                 if que_GetSalesCalculation.enhDaysForPO > 0 then
    //                     multiplierSupplierOrderCycle := que_GetSalesCalculation.enhDaysForPO
    //                 else
    //                     multiplierSupplierOrderCycle := 1;

    //             //Calculate new min based on today sales 
    //             newMin := salesPerDay * multiplierSupplierOrderCycle;

    //             //Store the new min & order cycle in temp EnhPOPStockMinCalc table
    //             recEnhPOPStockMinCalc.MIN_CALC := newMin;
    //             recEnhPOPStockMinCalc.SUPPLIER_ORDER_CYCLE := que_GetSalesCalculation.SupplierOrderCycle;
    //             recEnhPOPStockMinCalc.ORDERS_IN_PERIOD := totQuantity;
    //             recEnhPOPStockMinCalc.SALES_PER_DAY_QNTY := (math.Ceiling(salesPerDay * 1000)) / 1000;
    //             recEnhPOPStockMinCalc.Modify();
    //         end;
    //     end;
    //     que_GetSalesCalculation.Close();
    // end;

    local procedure PostItemSupplierHasNoPO()
    var
    begin
        recENHPOPStockMinCalc.Reset();
        recEnhPOPStockMinCalc.SetFilter(MEAN_LEAD_TIME_DAYS, '0.00');
        recEnhPOPStockMinCalc.SetFilter(EXCLUDE, '0');

        if recEnhPOPStockMinCalc.FindSet() then begin
            repeat
                recEnhPOPStockMinCalc.EXCLUDE := 1;
                recEnhPOPStockMinCalc.EXCLUDEREASON := 'LEAD TIME COULD NOT BE ESTABLISHED DUE TO LACK OF DATA';
                recEnhPOPStockMinCalc.Modify();
            UNTIL recEnhPOPStockMinCalc.Next() = 0;
        end;
    end;

    local procedure CalcSupplierAverageLeadTime(parVendor: Code[50])
    var
        que_GetAllSupplierMovements: Query GetAllSupplierMovements;
        que_GetAllArchiveSupplierMovements: Query GetAllArchiveSupplierMovements;
        que_GetSupplierWithAvgLeadTime: Query GetSupplierAverageLeadTime;
        que_GetPurchaseLeadTime: Query GetPurchaseLeadTime;

        recTempSupplierAverageLeadTime: Record TempSupplierAverageLeadTime;

        minCalcNumber: Decimal;
        math: Codeunit Math;

    begin
        recTempSupplierAverageLeadTime.DeleteAll();

        que_GetAllSupplierMovements.Open();

        while que_GetAllSupplierMovements.Read() do begin
            if (que_GetAllSupplierMovements.Posting_Date > que_GetAllSupplierMovements.Order_Date) then begin
                recTempSupplierAverageLeadTime.Init();
                recTempSupplierAverageLeadTime.Id := CreateGuid();
                recTempSupplierAverageLeadTime."Posting Date" := que_GetAllSupplierMovements.Posting_Date;
                recTempSupplierAverageLeadTime."Order Date" := que_GetAllSupplierMovements.Order_Date;
                recTempSupplierAverageLeadTime."Vendor No" := que_GetAllSupplierMovements.Vendor_No_;
                recTempSupplierAverageLeadTime."Lead Time" := que_GetAllSupplierMovements.Posting_Date - que_GetAllSupplierMovements.Order_Date;
                recTempSupplierAverageLeadTime.Insert();
            end;
        end;

        que_GetAllSupplierMovements.Close();

        // Read Archive Data

        if parVendor <> '' then begin
            que_GetAllArchiveSupplierMovements.SetRange(que_GetAllArchiveSupplierMovements.Vendor_No_, parVendor);
        end;

        que_GetAllArchiveSupplierMovements.Open();

        while que_GetAllArchiveSupplierMovements.Read() do begin
            if (que_GetAllArchiveSupplierMovements.Posting_Date > que_GetAllArchiveSupplierMovements.Order_Date) then begin
                recTempSupplierAverageLeadTime.Init();
                recTempSupplierAverageLeadTime.Id := CreateGuid();
                recTempSupplierAverageLeadTime."Posting Date" := que_GetAllArchiveSupplierMovements.Posting_Date;
                recTempSupplierAverageLeadTime."Order Date" := que_GetAllArchiveSupplierMovements.Order_Date;
                recTempSupplierAverageLeadTime."Vendor No" := que_GetAllArchiveSupplierMovements.Vendor_No_;
                recTempSupplierAverageLeadTime."Lead Time" := que_GetAllArchiveSupplierMovements.Posting_Date - que_GetAllArchiveSupplierMovements.Order_Date;
                recTempSupplierAverageLeadTime.Insert();
            end;
        end;
        que_GetAllArchiveSupplierMovements.Close();

        que_GetSupplierWithAvgLeadTime.Open();

        while que_GetSupplierWithAvgLeadTime.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetSupplierWithAvgLeadTime.STKCODE);

            if recENHPOPStockMinCalc.FindFirst() then begin
                //recEnhPOPStockMinCalc.STKCODE := que_GetSupplierWithAvgLeadTime.STKCODE;
                //if recEnhPOPStockMinCalc.Find('=') then begin
                recEnhPOPStockMinCalc.EXCLUDE := 0;
                recEnhPOPStockMinCalc.EXCLUDEREASON := '';
                recEnhPOPStockMinCalc.MEAN_LEAD_TIME_DAYS := que_GetSupplierWithAvgLeadTime.Lead_Time_;
                recEnhPOPStockMinCalc.Modify();
            end

        end;
        que_GetSupplierWithAvgLeadTime.Close();

        que_GetPurchaseLeadTime.Open();
        while que_GetPurchaseLeadTime.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetPurchaseLeadTime.STKCODE);
            if recENHPOPStockMinCalc.FindFirst() then begin
                // recEnhPOPStockMinCalc.STKCODE := que_GetPurchaseLeadTime.STKCODE;
                // if recEnhPOPStockMinCalc.Find('=') then begin
                recEnhPOPStockMinCalc.EXCLUDE := 0;
                recEnhPOPStockMinCalc.EXCLUDEREASON := '';
                recEnhPOPStockMinCalc.MEAN_LEAD_TIME_DAYS := que_GetPurchaseLeadTime.enhDaysForPO;
                recEnhPOPStockMinCalc.Modify();
            end

        end;
        que_GetPurchaseLeadTime.Close();

        recEnhPOPStockMinCalc.Reset();
        if recEnhPOPStockMinCalc.FindSet() then begin
            repeat
                //https://trello.com/c/TNdatZoT/13-explain-calculations
                minCalcNumber := recEnhPOPStockMinCalc.MIN_CALC + (recEnhPOPStockMinCalc.SUPPLIER_LEAD_TIME * recEnhPOPStockMinCalc.SALES_PER_DAY_QNTY);
                //minCalcNumber := recEnhPOPStockMinCalc.MIN_CALC + (recEnhPOPStockMinCalc.MEAN_LEAD_TIME_DAYS * recEnhPOPStockMinCalc.SALES_PER_DAY_QNTY);
                recEnhPOPStockMinCalc.MIN_CALC := Round(minCalcNumber, 0.0001, '=');
                recEnhPOPStockMinCalc.Modify();
            UNTIL recEnhPOPStockMinCalc.Next() = 0;

        end;


    end;

    local procedure CalcZeroMinRecalcMin2Sales(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        que_GetRecalculateMin: Query GetRecalculateMin;
        que_GetRecalculateMinForArchive: Query GetRecalculateMinForArchive;
        que_GetRecalcMin2Sales: Query GetRecalcMin2Sales;
        que_GetForecastRecalculateMin: Query GetForecastRecalculateMin;

        recTempRecalcMin2Sales: Record TempRecalcMin2Sales;
        recEntryDateProduction: Record EntryDateProduction;

        cu_ArchievedVersion: Codeunit ArchievedVersion;
        math: Codeunit Math;
    begin
        recEnhPOPStockMinCalc.Reset();
        recEnhPOPStockMinCalc.SetFilter(ORDERS_IN_PERIOD, '2');
        recEnhPOPStockMinCalc.SetFilter(MIN_CALC, '0');
        if recEnhPOPStockMinCalc.FindSet() then begin
            repeat
                recEnhPOPStockMinCalc.MIN_RECALC := math.Ceiling(recEnhPOPStockMinCalc.SMALLEST_ORDER_VOLUME);
                recEnhPOPStockMinCalc.RULE_PK := 100000;
                recEnhPOPStockMinCalc.Modify();
            UNTIL recEnhPOPStockMinCalc.Next() = 0;

        end;

        recTempRecalcMin2Sales.DeleteAll();

        //filter by itemno,item category code and vendor
        que_GetRecalculateMin.SetFilter(No_, parItemNo);
        que_GetRecalculateMin.SetFilter(Vendor_No_, parVendor);
        que_GetRecalculateMin.SetFilter(Item_Category_Code, parItemCategoryCode);

        que_GetRecalculateMin.Open();

        // Get SalesHeader/line data
        while que_GetRecalculateMin.Read() do begin
            //as per mail for od_date consider order date at sales header level
            if que_GetRecalculateMin.Order_Date >= CalcDate('-12M', Today) then begin
                recTempRecalcMin2Sales.Init();
                recTempRecalcMin2Sales.Id := CreateGuid();
                recTempRecalcMin2Sales."Item No" := que_GetRecalculateMin.No_;
                recTempRecalcMin2Sales."Vendor No" := que_GetRecalculateMin.Vendor_No_;

                recTempRecalcMin2Sales."Reorder Point" := que_GetRecalculateMin.Reorder_Point;
                recTempRecalcMin2Sales."Maximum Inventory" := que_GetRecalculateMin.Maximum_Inventory;
                recTempRecalcMin2Sales.Insert();
            end;
        end;
        que_GetRecalculateMin.Close();


        //--------------------------------------ARchieved------------------------------------
        cu_ArchievedVersion.GetLatestVersionforGetRecalculateMinForArchive(parItemNo, parVendor, parItemCategoryCode);

        // Forecast Data will be taking for first 12 months, no need after that as there will be enough 12 month actual BC History
        if (recEntryDateProduction.FindFirst()) and (Today <= CALCDATE('<12M>', recEntryDateProduction.StartingDate)) and (Today >= CalcDate('-CM', recEntryDateProduction.StartingDate)) then begin
            que_GetForecastRecalculateMin.SetFilter(No_, parItemNo);
            que_GetForecastRecalculateMin.SetFilter(Vendor_No_, parVendor);
            que_GetForecastRecalculateMin.SetFilter(Item_Category_Code, parItemCategoryCode);

            que_GetForecastRecalculateMin.Open();

            // Get SalesHeader/line Archive data
            while que_GetForecastRecalculateMin.Read() do begin
                //as per mail for od_date consider order date at sales header level
                if que_GetForecastRecalculateMin.Forecast_Date >= CalcDate('-12M', Today) then begin
                    recTempRecalcMin2Sales.Init();
                    recTempRecalcMin2Sales.Id := CreateGuid();
                    recTempRecalcMin2Sales."Item No" := que_GetForecastRecalculateMin.No_;
                    recTempRecalcMin2Sales."Vendor No" := que_GetForecastRecalculateMin.Vendor_No_;

                    recTempRecalcMin2Sales."Reorder Point" := que_GetForecastRecalculateMin.Reorder_Point;
                    recTempRecalcMin2Sales."Maximum Inventory" := que_GetForecastRecalculateMin.Maximum_Inventory;
                    recTempRecalcMin2Sales.Insert();
                end;
            end;
            que_GetForecastRecalculateMin.Close();
        end;

        //Update Min_Calc and Rule_Pk
        que_GetRecalcMin2Sales.Open();
        while que_GetRecalcMin2Sales.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetRecalcMin2Sales.Item_No);
            if recENHPOPStockMinCalc.FindFirst() then begin
                if recEnhPOPStockMinCalc.MIN_CALC < 1 then begin
                    // 11-2-22 - update MIN_CALC from 1 to 2
                    recEnhPOPStockMinCalc.MIN_CALC := 2;
                    recEnhPOPStockMinCalc.RULE_PK := 110000;
                    recEnhPOPStockMinCalc.Modify();
                end;

            end
        end;
        que_GetRecalcMin2Sales.Close();

    end;

    local procedure ApplyOverrideRules()
    var
        recPOminmaxqtyOverrideItem: Record POMinMaxQtyOverrideItem;

        que_GetPOMinMaxQtyOverrideItem: Query GetPOMinMaxQtyOverrideItem;
        que_GetPOminmaxqtyOverrideSK: Query GetPOminmaxqtyOverrideSK;

    begin
        //Apply any override rules from table POminmaxqtyOverrideItem
        que_GetPOMinMaxQtyOverrideItem.Open();
        while que_GetPOMinMaxQtyOverrideItem.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetPOMinMaxQtyOverrideItem.STKCODE);

            if recENHPOPStockMinCalc.FindFirst() then begin
                // recEnhPOPStockMinCalc.STKCODE := que_GetPOMinMaxQtyOverrideItem.STKCODE;
                // if recEnhPOPStockMinCalc.Find('-') then begin
                if (not que_GetPOMinMaxQtyOverrideItem.AllowHigherMin) or (que_GetPOMinMaxQtyOverrideItem.Quantity > recEnhPOPStockMinCalc.MIN_CALC) then begin
                    recEnhPOPStockMinCalc.MIN_CALC := que_GetPOMinMaxQtyOverrideItem.Quantity;
                    recEnhPOPStockMinCalc.MIN_RECALC := 0;
                    recEnhPOPStockMinCalc.RULE_PK := 0;

                    recEnhPOPStockMinCalc.MAX_CALC := que_GetPOMinMaxQtyOverrideItem.Quantity;
                    recEnhPOPStockMinCalc.Modify();
                end;
            end;
        end;
        que_GetPOMinMaxQtyOverrideItem.Close();

        // Apply any override rules from table POminmaxqtyOverrideSortkey
        que_GetPOminmaxqtyOverrideSK.Open();
        while que_GetPOminmaxqtyOverrideSK.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetPOminmaxqtyOverrideSK.STKCODE);
            if recENHPOPStockMinCalc.FindFirst() then begin
                //recEnhPOPStockMinCalc.STKCODE := que_GetPOminmaxqtyOverrideSK.STKCODE;
                //if recEnhPOPStockMinCalc.Find('-') then begin

                recEnhPOPStockMinCalc.MIN_CALC := que_GetPOminmaxqtyOverrideSK.Quantity;


                recEnhPOPStockMinCalc.MIN_RECALC := 0;
                recEnhPOPStockMinCalc.RULE_PK := 0;
                recEnhPOPStockMinCalc.Modify();
            end;
        end;
        que_GetPOminmaxqtyOverrideSK.Close();

    end;
}
