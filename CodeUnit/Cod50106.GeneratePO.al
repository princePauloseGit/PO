codeunit 50106 GeneratePO
{
    procedure GetPOData(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50]; parPObackOrders: Boolean; paroverridePO: Boolean; parzeroValuePO: Boolean; parbackOrders: Boolean)
    var
        StartTime: DateTime;
        EndTime: DateTime;
        ElapsedTime: Duration;
    begin
        POCalculateSales(parItemNo, parVendor, parItemCategoryCode);
        Clear(StartTime);
        Clear(EndTime);
        Clear(ElapsedTime);
        StartTime := System.CurrentDateTime;
        POStockAvg(parItemNo, parVendor);
        EndTime := System.CurrentDateTime;
        ElapsedTime := EndTime - StartTime;
        // Message('POStockAvg:  %1', ElapsedTime);

        POSalesQuantityRes();
        if paroverridePO then begin
            OveridePODate();
            OverideRaisePO(parItemNo, parVendor, parItemCategoryCode, parPObackOrders, paroverridePO, parzeroValuePO, parbackOrders);
        end
        else begin
            NoOveridePODate();
            RaisePO(parItemNo, parVendor, parItemCategoryCode, parPObackOrders, paroverridePO, parzeroValuePO, parbackOrders);
        end;
    end;

    local procedure GetForecastSalesOrder(parItemNo: Code[50]; parvendor: code[50]; parItemCategoryCode: Code[50])
    var
        que_GetForecastSalesOrders: Query GetForecastSalesOrders;
        recTempPOSalesPerDay: Record TempPOSalesPerDay;
    begin
        // recTempPOSalesPerDay.DeleteAll();

        // Get Sales Forecast Data
        que_GetForecastSalesOrders.SetFilter(Item_No_, parItemNo);

        //8-Nov-22
        if parvendor <> '' then
            que_GetForecastSalesOrders.SetFilter(Vendor_No_, parvendor);
        if parItemCategoryCode <> '' then
            que_GetForecastSalesOrders.SetFilter(Item_Category_Code, parItemCategoryCode);


        que_GetForecastSalesOrders.Open();

        while que_GetForecastSalesOrders.Read() do begin

            if DT2DATE(que_GetForecastSalesOrders.SystemCreatedAt) <= CalcDate('-1D', Today) then begin
                recTempPOSalesPerDay.SetRange(ItemNo, que_GetForecastSalesOrders.Item_No_);
                if recTempPOSalesPerDay.FindFirst() then begin
                    recTempPOSalesPerDay.SalesPerDayQty := recTempPOSalesPerDay.SalesPerDayQty + que_GetForecastSalesOrders.Forecast_Quantity;
                    recTempPOSalesPerDay.Modify();
                end
                else begin
                    recTempPOSalesPerDay.Init();
                    recTempPOSalesPerDay.Id := CreateGuid();
                    recTempPOSalesPerDay.ItemNo := que_GetForecastSalesOrders.Item_No_;
                    recTempPOSalesPerDay.SalesPerDayQty := que_GetForecastSalesOrders.Forecast_Quantity;
                    if (Today - DT2DATE(que_GetForecastSalesOrders.SystemCreatedAt) < 365) then
                        recTempPOSalesPerDay.Days := Today - DT2DATE(que_GetForecastSalesOrders.SystemCreatedAt)
                    else
                        recTempPOSalesPerDay.Days := 365;
                    recTempPOSalesPerDay.Insert();
                end;
            end;
        end;
        que_GetForecastSalesOrders.Close();
    end;

    local procedure POCalculateSales(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        que_GetSalesOrders: Query GetSalesOrders;
        que_GetSalesArchiveOrders: Query GetSalesArchiveOrders;

        varItemNo: Code[30];
        recCustomerExclude: Record Customer;
        recTempPOSalesPerDay: Record TempPOSalesPerDay;
        recEntryDateProduction: Record EntryDateProduction;

        sumQuantity: Decimal;
        flagInsert: Integer;

        cu_ArchievedVersion: Codeunit ArchievedVersion;
        math: Codeunit Math;
    begin

        sumQuantity := 0;
        varItemNo := '';

        recTempPOSalesPerDay.DeleteAll();

        que_GetSalesOrders.SetFilter(Sales_Line_No_, parItemNo);

        //8-Nov-22
        if parvendor <> '' then
            que_GetSalesOrders.SetFilter(Vendor_No_, parvendor);
        if parItemCategoryCode <> '' then
            que_GetSalesOrders.SetFilter(Item_Category_Code, parItemCategoryCode);

        // Get Sales  Data
        que_GetSalesOrders.Open();

        while que_GetSalesOrders.Read() do begin

            recCustomerExclude."No." := que_GetSalesOrders.Sell_to_Customer_No_;

            //Ignore any customers flagged to ignoreFromMinMax
            if (recCustomerExclude.Find('=')) and (not recCustomerExclude.ignoreFromMinMax) then begin
                if DT2DATE(que_GetSalesOrders.SystemCreatedAt) <= CalcDate('-1D', Today) then begin
                    if que_GetSalesOrders.Sales_Line_No_ = varItemNo then begin
                        sumQuantity := sumQuantity + que_GetSalesOrders.Quantity; //Sum of all quantity according to itemno
                        flagInsert := 1;
                    end
                    else begin
                        varItemNo := que_GetSalesOrders.Sales_Line_No_;
                        sumQuantity := que_GetSalesOrders.Quantity;
                        flagInsert := 0;
                    end;

                    if flagInsert = 0 then begin
                        recTempPOSalesPerDay.Init();
                        recTempPOSalesPerDay.Id := CreateGuid();
                        recTempPOSalesPerDay.ItemNo := que_GetSalesOrders.Sales_Line_No_;
                        recTempPOSalesPerDay.SalesPerDayQty := sumQuantity;
                        if (Today - DT2DATE(que_GetSalesOrders.SystemCreatedAt) < 365) then
                            recTempPOSalesPerDay.Days := Today - DT2DATE(que_GetSalesOrders.SystemCreatedAt)
                        else
                            recTempPOSalesPerDay.Days := 365;
                        recTempPOSalesPerDay.Insert();
                    end
                    else begin
                        recTempPOSalesPerDay.Reset();
                        recTempPOSalesPerDay.SetRange(ItemNo, que_GetSalesOrders.Sales_Line_No_);
                        recTempPOSalesPerDay.SalesPerDayQty := sumQuantity;
                        recTempPOSalesPerDay.Modify();
                    end;
                end;
            end;
        end;
        que_GetSalesOrders.Close();

        //Get Latest Version
        cu_ArchievedVersion.GetSalesArchieveForPO(parItemNo, parvendor, parItemCategoryCode);
        // Forecast Data will be taking for first 12 months, no need after that as there will be enough 12 month actual BC History
        if (recEntryDateProduction.FindFirst()) and (Today <= CALCDATE('<12M>', recEntryDateProduction.StartingDate)) and (Today >= recEntryDateProduction.StartingDate) then begin
            GetForecastSalesOrder(parItemNo, parVendor, parItemCategoryCode);
        end;

        recTempPOSalesPerDay.Reset();
        if recTempPOSalesPerDay.FindSet() then
            repeat
                recTempPOSalesPerDay.SalesPerDayQty := math.Ceiling((recTempPOSalesPerDay.SalesPerDayQty / recTempPOSalesPerDay.Days) * 1000) / 1000;
                recTempPOSalesPerDay.Modify();
            until recTempPOSalesPerDay.Next() = 0;
    end;

    local procedure POStockAvg(ItemNo: code[50]; vendorNo: Code[50])
    var
        que_GetAllSupplierMovements: Query GetAllSupplierMovements;
        que_GetAllArchiveSupplierMovements: Query GetAllArchiveSupplierMovements;
        recTempPOStockAvg: Record TempPOStockAvg;
        varItemNo: Code[30];
        avgDiff: Integer;
        flagInsert, avgCount : Integer;
        math: Codeunit Math;

    begin
        varItemNo := '';

        recTempPOStockAvg.DeleteAll();

        // Read Purchase Line data
        que_GetAllSupplierMovements.Open();

        while que_GetAllSupplierMovements.Read() do begin
            if (que_GetAllSupplierMovements.Posting_Date > que_GetAllSupplierMovements.Order_Date) then begin
                if que_GetAllSupplierMovements.ItemNo_ = varItemNo then begin
                    avgDiff := avgDiff + (que_GetAllSupplierMovements.Posting_Date - que_GetAllSupplierMovements.Order_Date); //Sum of all quantity according to itemno
                    flagInsert := 1;
                    avgCount := avgCount + 1;
                end
                else begin
                    varItemNo := que_GetAllSupplierMovements.ItemNo_;
                    avgDiff := que_GetAllSupplierMovements.Posting_Date - que_GetAllSupplierMovements.Order_Date; //Sum of all quantity according to itemno
                    flagInsert := 0;
                    avgCount := 1;
                end;

                if flagInsert = 0 then begin
                    recTempPOStockAvg.Init();
                    recTempPOStockAvg.Id := CreateGuid();
                    recTempPOStockAvg.ItemNo := que_GetAllSupplierMovements.ItemNo_;
                    recTempPOStockAvg.LeadTime := math.Floor(avgDiff / avgCount);
                    recTempPOStockAvg.AvgCnt := avgCount;
                    recTempPOStockAvg.Insert();
                end
                else begin
                    recTempPOStockAvg.Reset();
                    recTempPOStockAvg.SetRange(ItemNo, que_GetAllSupplierMovements.ItemNo_);
                    recTempPOStockAvg.LeadTime := math.Floor(avgDiff / avgCount);
                    recTempPOStockAvg.AvgCnt := avgCount;
                    recTempPOStockAvg.Modify();
                end;
            end;

        end;
        que_GetAllSupplierMovements.Close();

        // Read Purchase line Archive data 
        if vendorNo <> '' then begin
            que_GetAllArchiveSupplierMovements.SetRange(que_GetAllArchiveSupplierMovements.Vendor_No_, vendorNo);
        end;

        if ItemNo <> '' then begin
            que_GetAllArchiveSupplierMovements.SetRange(que_GetAllArchiveSupplierMovements.ItemNo_, ItemNo);
        end;

        que_GetAllArchiveSupplierMovements.Open();

        while que_GetAllArchiveSupplierMovements.Read() do begin

            if (que_GetAllArchiveSupplierMovements.Posting_Date > que_GetAllArchiveSupplierMovements.Order_Date) then begin
                recTempPOStockAvg.Reset();
                recTempPOStockAvg.SetRange(ItemNo, que_GetAllArchiveSupplierMovements.ItemNo_);

                if recTempPOStockAvg.FindFirst() then begin
                    avgCount := recTempPOStockAvg.AvgCnt + 1;
                    avgDiff := recTempPOStockAvg.LeadTime + (que_GetAllArchiveSupplierMovements.Posting_Date - que_GetAllArchiveSupplierMovements.Order_Date); //Sum of all diffrence between PODates according to itemno
                    recTempPOStockAvg.LeadTime := math.Floor(avgDiff / avgCount);
                    recTempPOStockAvg.AvgCnt := avgCount;
                    recTempPOStockAvg.Modify();
                end
                else begin
                    avgCount := 1;
                    avgDiff := que_GetAllArchiveSupplierMovements.Posting_Date - que_GetAllArchiveSupplierMovements.Order_Date; //Sum of all diffrence between PO Dates according to itemno
                    recTempPOStockAvg.Init();
                    recTempPOStockAvg.Id := CreateGuid();
                    recTempPOStockAvg.ItemNo := que_GetAllArchiveSupplierMovements.ItemNo_;
                    recTempPOStockAvg.LeadTime := math.Floor(avgDiff / avgCount);
                    recTempPOStockAvg.AvgCnt := avgCount;
                    recTempPOStockAvg.Insert();
                end;
            end;
        end;
        que_GetAllArchiveSupplierMovements.Close();

    end;

    local procedure POSalesQuantityRes()
    var
        que_GetPOSalesQuantityRes: Query GetPOSalesQuantityRes;
        recTempPOSalesQtyRes: Record TempPOSalesQtyRes;
    begin
        recTempPOSalesQtyRes.DeleteAll();

        que_GetPOSalesQuantityRes.Open();

        while que_GetPOSalesQuantityRes.Read() do begin
            recTempPOSalesQtyRes.Init();
            recTempPOSalesQtyRes.Id := CreateGuid();
            recTempPOSalesQtyRes.ItemNo := que_GetPOSalesQuantityRes.No_;
            recTempPOSalesQtyRes.QtyReserved := que_GetPOSalesQuantityRes.Reserved_Quantity;
            recTempPOSalesQtyRes.Insert();
        end;
        que_GetPOSalesQuantityRes.Close();
    end;

    local procedure OveridePODate()
    var
        recEnhPoPFrequency: Record ENHPOP_POFrequency;
        recVendorOrderSchedules: Record VendorOrderSchedules;
        recTempPOVendorFrequency: Record TempPOVendorFrequency;

        minMothlyFrequencyDate, minyearlyFrequencyDate, minWeeklyFrequencyDate, compdate : Date;
        minMothlyFrequency, minyearlyFrequency, minWeeklyFrequency : code[5];

        insertFlag, modifyFlag : Integer;
        compFreq: Code[10];
        varVendor, varFrequency : Code[30];

    begin
        recEnhPoPFrequency.Reset();
        recEnhPoPFrequency.SetFilter(Frequency, 'M*');
        recEnhPoPFrequency.SetCurrentKey(NextFrequencyDate);
        recEnhPoPFrequency.SetAscending(NextFrequencyDate, true);
        if recEnhPoPFrequency.FindFirst() then begin
            minMothlyFrequencyDate := recEnhPoPFrequency.NextFrequencyDate;
            minMothlyFrequency := recEnhPoPFrequency.Frequency;
        end;

        recEnhPoPFrequency.Reset();
        recEnhPoPFrequency.SetFilter(Frequency, 'Y*');
        recEnhPoPFrequency.SetCurrentKey(NextFrequencyDate);
        recEnhPoPFrequency.SetAscending(NextFrequencyDate, true);
        if recEnhPoPFrequency.FindFirst() then begin
            minyearlyFrequencyDate := recEnhPoPFrequency.NextFrequencyDate;
            minyearlyFrequency := recEnhPoPFrequency.Frequency;
        end;

        recEnhPoPFrequency.Reset();
        recEnhPoPFrequency.SetFilter(Frequency, 'W*');
        recEnhPoPFrequency.SetCurrentKey(NextFrequencyDate);
        recEnhPoPFrequency.SetAscending(NextFrequencyDate, true);
        if recEnhPoPFrequency.FindFirst() then begin
            minWeeklyFrequencyDate := recEnhPoPFrequency.NextFrequencyDate;
            minWeeklyFrequency := recEnhPoPFrequency.Frequency;
        end;

        recTempPOVendorFrequency.DeleteAll();

        recVendorOrderSchedules.Reset();
        recVendorOrderSchedules.SetCurrentKey(Vendor);
        recVendorOrderSchedules.SetAscending(Vendor, true);
        varVendor := '';
        varFrequency := '';

        if recVendorOrderSchedules.FindSet() then begin
            repeat
                if (varVendor = recVendorOrderSchedules.Vendor) and (varFrequency = CopyStr(recVendorOrderSchedules.Cycle, 1, 1)) then begin
                    insertFlag := 1;
                    modifyFlag := 1;
                end
                else begin
                    if varVendor = recVendorOrderSchedules.Vendor then begin
                        modifyFlag := 0;
                        varFrequency := CopyStr(recVendorOrderSchedules.Cycle, 1, 1);
                        case varFrequency of
                            'M':
                                begin
                                    compFreq := minMothlyFrequency;
                                    compdate := minMothlyFrequencyDate;
                                end;
                            'Y':
                                begin
                                    compdate := minyearlyFrequencyDate;
                                    compFreq := minyearlyFrequency;
                                end;
                            'W':
                                begin
                                    compdate := minWeeklyFrequencyDate;
                                    compFreq := minWeeklyFrequency;
                                end;
                            else begin
                                compdate := Today;
                                compFreq := recVendorOrderSchedules.Cycle;
                            end;
                        end;
                    end
                    else begin
                        varVendor := recVendorOrderSchedules.Vendor;
                        varFrequency := CopyStr(recVendorOrderSchedules.Cycle, 1, 1);
                        insertFlag := 0;
                        modifyFlag := 1;
                    end;
                end;
                if insertFlag = 0 then begin
                    if modifyFlag = 0 then begin
                        recTempPOVendorFrequency.SetRange(Vendor, varVendor);
                        if recTempPOVendorFrequency.FindFirst() then begin
                            repeat
                                if recTempPOVendorFrequency.NextFrequencyDate > compdate then begin
                                    recTempPOVendorFrequency.NextFrequencyDate := compdate;
                                    recTempPOVendorFrequency.Frequency := compFreq;
                                    recTempPOVendorFrequency.Modify();
                                end;
                            until recTempPOVendorFrequency.Next() = 0;
                        end
                    end
                    else begin
                        recTempPOVendorFrequency.Init();
                        recTempPOVendorFrequency.Id := CreateGuid();
                        recTempPOVendorFrequency.Vendor := varVendor;

                        case varFrequency of
                            'M':
                                begin
                                    recTempPOVendorFrequency.NextFrequencyDate := minMothlyFrequencyDate;
                                    recTempPOVendorFrequency.Frequency := minMothlyFrequency;
                                end;
                            'Y':
                                begin
                                    recTempPOVendorFrequency.NextFrequencyDate := minyearlyFrequencyDate;
                                    recTempPOVendorFrequency.Frequency := minyearlyFrequency;
                                end;
                            'W':
                                begin
                                    recTempPOVendorFrequency.NextFrequencyDate := minWeeklyFrequencyDate;
                                    recTempPOVendorFrequency.Frequency := minWeeklyFrequency;
                                end;
                            else begin
                                recTempPOVendorFrequency.NextFrequencyDate := Today;
                                recTempPOVendorFrequency.Frequency := recVendorOrderSchedules.Cycle;
                            end;
                        end;
                        recTempPOVendorFrequency.Insert();
                    end;
                end;
            until recVendorOrderSchedules.Next = 0;
        end;
    end;

    local procedure NoOveridePODate()
    var
        que_GetVendorPOCycle: Query GetVendorPOCycle;
        recTempPOVendorFrequency: Record TempPOVendorFrequency;
        getTopVendorRecord: Boolean;
        varVendor: Code[30];
    begin
        recTempPOVendorFrequency.DeleteAll();
        varVendor := '';

        que_GetVendorPOCycle.SetFilter(NextFrequencyDate, '=%1', Today);
        que_GetVendorPOCycle.Open();

        while que_GetVendorPOCycle.Read() do begin
            if que_GetVendorPOCycle.Vendor = varVendor then begin
                getTopVendorRecord := false;
            end
            else begin
                varVendor := que_GetVendorPOCycle.Vendor;
                getTopVendorRecord := true;
            end;

            if getTopVendorRecord then begin
                recTempPOVendorFrequency.Init();
                recTempPOVendorFrequency.Id := CreateGuid();
                recTempPOVendorFrequency.Vendor := que_GetVendorPOCycle.Vendor;
                recTempPOVendorFrequency.Frequency := que_GetVendorPOCycle.Cycle;
                recTempPOVendorFrequency.NextFrequencyDate := que_GetVendorPOCycle.NextFrequencyDate;
                recTempPOVendorFrequency.Insert();
            end;
        end;
        que_GetVendorPOCycle.Close();
    end;

    local procedure RaisePO(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50]; parPObackOrders: Boolean; paroverridePO: Boolean; parzeroValuePO: Boolean; parbackOrders: Boolean)
    var
        que_GetRoutineToRaisePOData: Query GetRoutineToRaisePOData;
        recRoutinePO: Record RoutinePO;
        POQTY, varPOQty, varPOQty2, varBackPOQty, varCalcPO, varBackOrderQty, varOrderMultiple, varCeil, varEOQ : Decimal;
        math: Codeunit Math;
        varDaysToNextOrderCycle: Integer;
        varNarrative: Text;
    begin
        recRoutinePO.DeleteAll();

        //filter by itemno,item category code and vendor
        que_GetRoutineToRaisePOData.SetFilter(No_, parItemNo);
        que_GetRoutineToRaisePOData.SetFilter(Vendor_No_, parVendor);
        que_GetRoutineToRaisePOData.SetFilter(Item_Category_Code, parItemCategoryCode);

        que_GetRoutineToRaisePOData.Open();

        while que_GetRoutineToRaisePOData.Read() do begin
            recRoutinePO.Init();
            recRoutinePO.Id := CreateGuid();
            recRoutinePO.ItemNo := que_GetRoutineToRaisePOData.No_;
            recRoutinePO.Description := que_GetRoutineToRaisePOData.Description;
            recRoutinePO."Item Category Code" := que_GetRoutineToRaisePOData.Item_Category_Code;
            recRoutinePO.Vendor := que_GetRoutineToRaisePOData.Vendor_No_;

            //-----------------------------------------------------------------------------------
            varEOQ := que_GetRoutineToRaisePOData.Order_Multiple;
            // varDaysToNextOrderCycle := que_GetRoutineToRaisePOData.NextFrequencyDate - Today;
            if que_GetRoutineToRaisePOData.NextFrequencyDate <> 0D then begin
                varDaysToNextOrderCycle := que_GetRoutineToRaisePOData.NextFrequencyDate - Today;
                recRoutinePO.NextSupplierDate := que_GetRoutineToRaisePOData.NextFrequencyDate;
            end
            else begin
                recRoutinePO.NextSupplierDate := Today;
                varDaysToNextOrderCycle := 0;
            end;

            //BackOrders 26-Dec-22 PO-New Requirement
            // if parbackorders selected then ignore other rules
            if parbackOrders then begin
                varBackPOQty := que_GetRoutineToRaisePOData.Inventory + que_GetRoutineToRaisePOData.Qty__on_Purch__Order;
                //PO Quantity - ASM Component(Qty__on_Asm__Component) to include in backorders
                varBackOrderQty := que_GetRoutineToRaisePOData.Qty__on_Asm__Component + que_GetRoutineToRaisePOData.Qty__on_Sales_Order - varBackPOQty;
                varNarrative := '';
                if (que_GetRoutineToRaisePOData.Qty__on_Sales_Order > varBackPOQty) then begin
                    POQTY := que_GetRoutineToRaisePOData.Qty__on_Sales_Order - varBackPOQty;
                    recRoutinePO."PO Qty" := calEOQ(que_GetRoutineToRaisePOData.No_, POQTY);
                    recRoutinePO.PO_Qty_To_Max := calEOQ(que_GetRoutineToRaisePOData.No_, POQTY);
                end
                else begin
                    recRoutinePO."PO Qty" := 0;
                    recRoutinePO.PO_Qty_To_Max := 0;
                end;
            end
            // If not parBackOrders then all rules
            else begin
                varBackOrderQty := que_GetRoutineToRaisePOData.Qty__on_Asm__Component + que_GetRoutineToRaisePOData.Qty__on_Sales_Order - que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders;
                //varCalcPO := que_GetRoutineToRaisePOData.Inventory + que_GetRoutineToRaisePOData.Qty__on_Sales_Order - que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders - varBackOrderQty;
                varCalcPO := que_GetRoutineToRaisePOData.Inventory + que_GetRoutineToRaisePOData.Qty__on_Purch__Order - que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders - varBackOrderQty;
                //if (radRegularOnly.Checked == true)
                if parPObackOrders then begin
                    if varCalcPO >= que_GetRoutineToRaisePOData.Reorder_Point then
                        varPOQty := 0
                    else begin
                        if que_GetRoutineToRaisePOData.Order_Multiple = 0 then
                            varOrderMultiple := 1
                        else
                            varOrderMultiple := que_GetRoutineToRaisePOData.Order_Multiple;
                        //8-Nov-22 Mail Sandbox
                        varCeil := (que_GetRoutineToRaisePOData.Maximum_Inventory - varCalcPO) / varOrderMultiple;
                        //varCeil := (que_GetRoutineToRaisePOData.Maximum_Inventory - varBackOrderQty) / varOrderMultiple;
                        varPOQty := math.Ceiling(varCeil) * varOrderMultiple;
                    end;
                end
                //else (radRegularOnly.Checked == false)
                else begin
                    varPOQty := varBackOrderQty - que_GetRoutineToRaisePOData.Qty__on_Purch__Order;
                end;
                //if (chkOverridePOSchedule.Checked)
                if paroverridePO then begin
                    if varPOQty < 0 then begin
                        varPOQty2 := 0;
                        varNarrative := 'NO PO REQUIRED, SUFFICIENT STOCK AVAILABLE';
                    end
                    else begin
                        varNarrative := '';
                        if varEOQ = 0 then
                            varPOQty2 := varPOQty
                        else
                            varPOQty2 := math.Ceiling(varPOQty / varEOQ) * varEOQ;
                    end;
                end

                //else (!chkOverridePOSchedule.Checked)
                else begin
                    if varDaysToNextOrderCycle > 1 then begin
                        varPOQty2 := 0;
                        varNarrative := 'NO PURCHASE ORDER DUE YET';
                    end

                    else begin
                        if varPOQty < 0 then begin
                            varPOQty2 := 0;
                            varNarrative := 'NO PO REQUIRED, SUFFICIENT STOCK AVAILABLE'
                        end
                        else begin
                            varNarrative := '';
                            if varEOQ = 0 then
                                varPOQty2 := varPOQty
                            else
                                varPOQty2 := math.Ceiling(varPOQty / varEOQ) * varEOQ;
                        end;
                    end;
                end;

                // if (radRegularOnly.Checked == true)
                if parPObackOrders then begin
                    POQTY := calEOQ(que_GetRoutineToRaisePOData.No_, varPOQty2);
                    recRoutinePO."PO Qty" := POQTY;
                end
                else
                    if que_GetRoutineToRaisePOData.Inventory > varPOQty2 then begin
                        recRoutinePO."PO Qty" := 0;
                    end
                    else begin
                        POQTY := calEOQ(que_GetRoutineToRaisePOData.No_, varPOQty2);
                        recRoutinePO."PO Qty" := POQTY;
                    end;

                //------------------------------------------------------------------------------------------
                if varPOQty < 0 then
                    recRoutinePO.PO_Qty_To_Max := 0
                else begin
                    POQTY := calEOQ(que_GetRoutineToRaisePOData.No_, varPOQty);
                    recRoutinePO.PO_Qty_To_Max := POQTY;
                end;
            end;

            recRoutinePO.Inventory := que_GetRoutineToRaisePOData.Inventory;
            recRoutinePO.Reserved := que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders;
            recRoutinePO.BackOrders := varBackOrderQty;
            recRoutinePO.Order_In := que_GetRoutineToRaisePOData.Qty__on_Purch__Order;
            recRoutinePO.Supp_Min_Order_Level := que_GetRoutineToRaisePOData.MinimumOrderAmount;

            recRoutinePO.Current_Min := que_GetRoutineToRaisePOData.Reorder_Point;
            recRoutinePO.Current_Max := que_GetRoutineToRaisePOData.Maximum_Inventory;

            recRoutinePO.Costprice := (math.Ceiling(que_GetRoutineToRaisePOData.Last_Direct_Cost * 100)) / 100;
            recRoutinePO.EOQ := que_GetRoutineToRaisePOData.Order_Multiple;
            recRoutinePO.Sales_Per_Day_Qnty := que_GetRoutineToRaisePOData.SalesPerDayQty;
            recRoutinePO.Supplier_Lead_Time := que_GetRoutineToRaisePOData.LeadTime;
            recRoutinePO.Narrative := varNarrative;

            if que_GetRoutineToRaisePOData.Frequency <> '' then
                recRoutinePO.POFrequency := que_GetRoutineToRaisePOData.Frequency
            else
                recRoutinePO.POFrequency := 'D';

            recRoutinePO.Days_To_Next_Order := varDaysToNextOrderCycle;

            recRoutinePO.Insert();
        end;
        que_GetRoutineToRaisePOData.Close();

    end;

    local procedure OverideRaisePO(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50]; parPObackOrders: Boolean; paroverridePO: Boolean; parzeroValuePO: Boolean; parbackOrders: Boolean)
    var
        que_GetRoutineToRaisePOData: Query GetRoutineToRaiseOveridePOData;
        recRoutinePO: Record RoutinePO;
        varPOQty, varPOQty2, varBackPOQty, varCalcPO, varBackOrderQty, varOrderMultiple, varCeil, varEOQ : Decimal;
        math: Codeunit Math;
        varDaysToNextOrderCycle: Integer;
        varNarrative: Text;
        POQTY: Integer;
    begin
        recRoutinePO.DeleteAll();

        //filter by itemno,item category code and vendor
        que_GetRoutineToRaisePOData.SetFilter(No_, parItemNo);
        que_GetRoutineToRaisePOData.SetFilter(Vendor_No_, parVendor);
        que_GetRoutineToRaisePOData.SetFilter(Item_Category_Code, parItemCategoryCode);

        que_GetRoutineToRaisePOData.Open();

        while que_GetRoutineToRaisePOData.Read() do begin
            recRoutinePO.Init();
            recRoutinePO.Id := CreateGuid();
            recRoutinePO.ItemNo := que_GetRoutineToRaisePOData.No_;
            recRoutinePO.Description := que_GetRoutineToRaisePOData.Description;
            recRoutinePO."Item Category Code" := que_GetRoutineToRaisePOData.Item_Category_Code;
            recRoutinePO.Vendor := que_GetRoutineToRaisePOData.Vendor_No_;

            //-----------------------------------------------------------------------------------
            varEOQ := que_GetRoutineToRaisePOData.Order_Multiple;
            // varDaysToNextOrderCycle := que_GetRoutineToRaisePOData.NextFrequencyDate - Today;
            if que_GetRoutineToRaisePOData.NextFrequencyDate <> 0D then begin
                varDaysToNextOrderCycle := que_GetRoutineToRaisePOData.NextFrequencyDate - Today;
                recRoutinePO.NextSupplierDate := que_GetRoutineToRaisePOData.NextFrequencyDate;
            end
            else begin
                recRoutinePO.NextSupplierDate := Today;
                varDaysToNextOrderCycle := 0;
            end;

            //BackOrders 26-Dec-22 PO-New Requirement
            // if parbackorders selected then ignore other rules
            if parbackOrders then begin
                varBackPOQty := que_GetRoutineToRaisePOData.Inventory + que_GetRoutineToRaisePOData.Qty__on_Purch__Order;
                //PO Quantity - ASM Component to include in backorders
                varBackOrderQty := que_GetRoutineToRaisePOData.Qty__on_Asm__Component + que_GetRoutineToRaisePOData.Qty__on_Sales_Order - varBackPOQty;
                varNarrative := '';
                if (que_GetRoutineToRaisePOData.Qty__on_Sales_Order > varBackPOQty) then begin
                    POQTY := que_GetRoutineToRaisePOData.Qty__on_Sales_Order - varBackPOQty;
                    recRoutinePO."PO Qty" := calEOQ(que_GetRoutineToRaisePOData.No_, POQTY);
                    recRoutinePO.PO_Qty_To_Max := calEOQ(que_GetRoutineToRaisePOData.No_, POQTY);
                end
                else begin
                    recRoutinePO."PO Qty" := 0;
                    recRoutinePO.PO_Qty_To_Max := 0;
                end;
            end
            // If not parBackOrders then all rules
            else begin
                //PO Quantity - ASM Component to include in backorders
                varBackOrderQty := que_GetRoutineToRaisePOData.Qty__on_Asm__Component + que_GetRoutineToRaisePOData.Qty__on_Sales_Order - que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders;
                //varCalcPO := que_GetRoutineToRaisePOData.Inventory + que_GetRoutineToRaisePOData.Qty__on_Sales_Order - que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders - varBackOrderQty;
                varCalcPO := que_GetRoutineToRaisePOData.Inventory + que_GetRoutineToRaisePOData.Qty__on_Purch__Order - que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders - varBackOrderQty;
                //if (radRegularOnly.Checked == true)
                if parPObackOrders then begin
                    if varCalcPO >= que_GetRoutineToRaisePOData.Reorder_Point then
                        varPOQty := 0
                    else begin
                        if que_GetRoutineToRaisePOData.Order_Multiple = 0 then
                            varOrderMultiple := 1
                        else
                            varOrderMultiple := que_GetRoutineToRaisePOData.Order_Multiple;
                        //8-Nov-22 Mail Sandbox
                        varCeil := (que_GetRoutineToRaisePOData.Maximum_Inventory - varCalcPO) / varOrderMultiple;

                        // varCeil := (que_GetRoutineToRaisePOData.Maximum_Inventory - varBackOrderQty) / varOrderMultiple;
                        varPOQty := math.Ceiling(varCeil) * varOrderMultiple;
                    end;
                end
                //else (radRegularOnly.Checked == false)
                else begin
                    varPOQty := varBackOrderQty - que_GetRoutineToRaisePOData.Qty__on_Purch__Order;
                end;

                //if (chkOverridePOSchedule.Checked)
                if paroverridePO then begin
                    if varPOQty < 0 then begin
                        varPOQty2 := 0;
                        varNarrative := 'NO PO REQUIRED, SUFFICIENT STOCK AVAILABLE';
                    end
                    else begin
                        varNarrative := '';
                        if varEOQ = 0 then
                            varPOQty2 := varPOQty
                        else
                            varPOQty2 := math.Ceiling(varPOQty / varEOQ) * varEOQ;
                    end;
                end

                //else (!chkOverridePOSchedule.Checked)
                else begin
                    if varDaysToNextOrderCycle > 1 then begin
                        varPOQty2 := 0;
                        varNarrative := 'NO PURCHASE ORDER DUE YET';
                    end

                    else begin
                        if varPOQty < 0 then begin
                            varPOQty2 := 0;
                            varNarrative := 'NO PO REQUIRED, SUFFICIENT STOCK AVAILABLE'
                        end
                        else begin
                            varNarrative := '';
                            if varEOQ = 0 then
                                varPOQty2 := varPOQty
                            else
                                varPOQty2 := math.Ceiling(varPOQty / varEOQ) * varEOQ;
                        end;
                    end;
                end;

                if parPObackOrders then begin

                    POQTY := calEOQ(que_GetRoutineToRaisePOData.No_, varPOQty2);
                    recRoutinePO."PO Qty" := POQTY;
                end else begin
                    if que_GetRoutineToRaisePOData.Inventory > varPOQty2 then begin
                        recRoutinePO."PO Qty" := 0
                    end else begin
                        POQTY := calEOQ(que_GetRoutineToRaisePOData.No_, varPOQty2);
                        recRoutinePO."PO Qty" := POQTY;
                    end;
                end;
                //------------------------------------------------------------------------------------------
                if varPOQty < 0 then
                    recRoutinePO.PO_Qty_To_Max := 0
                else begin
                    POQTY := calEOQ(que_GetRoutineToRaisePOData.No_, varPOQty);
                    recRoutinePO.PO_Qty_To_Max := POQTY;
                end;
            end;

            recRoutinePO.Inventory := que_GetRoutineToRaisePOData.Inventory;
            recRoutinePO.Reserved := que_GetRoutineToRaisePOData.Reserved_Qty__on_Sales_Orders;
            //PO Quantity - ASM Component to include in backorders
            recRoutinePO.BackOrders := varBackOrderQty;
            recRoutinePO.Order_In := que_GetRoutineToRaisePOData.Qty__on_Purch__Order;
            recRoutinePO.Supp_Min_Order_Level := que_GetRoutineToRaisePOData.MinimumOrderAmount;

            recRoutinePO.Current_Min := que_GetRoutineToRaisePOData.Reorder_Point;
            recRoutinePO.Current_Max := que_GetRoutineToRaisePOData.Maximum_Inventory;

            recRoutinePO.Costprice := (math.Ceiling(que_GetRoutineToRaisePOData.Last_Direct_Cost * 100)) / 100;
            recRoutinePO.EOQ := que_GetRoutineToRaisePOData.Order_Multiple;
            recRoutinePO.Sales_Per_Day_Qnty := que_GetRoutineToRaisePOData.SalesPerDayQty;
            recRoutinePO.Supplier_Lead_Time := que_GetRoutineToRaisePOData.LeadTime;
            recRoutinePO.Narrative := varNarrative;

            if que_GetRoutineToRaisePOData.Frequency <> '' then
                recRoutinePO.POFrequency := que_GetRoutineToRaisePOData.Frequency
            else
                recRoutinePO.POFrequency := 'D';

            recRoutinePO.Days_To_Next_Order := varDaysToNextOrderCycle;
            recRoutinePO.Insert();
        end;
        que_GetRoutineToRaisePOData.Close();

    end;

    procedure calEOQ(ItemNo: Code[50]; Quantity: Decimal): Decimal
    var
        recItem: Record Item;
        QtyonPO, dividend, RoundDividend : Decimal;
        recItemVendor: Record "Item Vendor";
        vendorEOQ: Integer;
    begin
        Clear(QtyonPO);
        Clear(dividend);
        Clear(RoundDividend);
        Clear(vendorEOQ);

        if Quantity <= 0 then begin
            exit(Quantity);
        end;

        recItem.Reset();
        recItem.SetRange("No.", ItemNo);
        if recItem.FindFirst() then begin
            recItemVendor.Reset();
            recItemVendor.SetRange("Item No.", recItem."No.");

            if recItemVendor.FindFirst() then begin
                vendorEOQ := recItemVendor."Vendor EOQ";
                if vendorEOQ <= 0 then begin
                    exit(Quantity);
                end;
                dividend := Quantity / vendorEOQ;
                RoundDividend := Round(dividend, 1, '<');
                QtyonPO := RoundDividend * vendorEOQ;
                if QtyonPO < Quantity then begin
                    dividend := Round(RoundDividend, 1, '>') + 1;
                    QtyonPO := dividend * vendorEOQ;
                    exit(QtyonPO);
                end;
                exit(QtyonPO);
            end;
        end;
        exit(Quantity);
    end;
}