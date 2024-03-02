codeunit 50109 ForecastData
{
    var
        recTempSalesCalculation: Record TempSalesCalculation; //TempSalesCalculation
        recEnhPOPStockMinCalc: Record ENHPOP_StockMinCalc;

    procedure ForecastGetAllSalesItem(LiveCurrentBeginningMonth: Date; ForecastDate: Date)
    var

        que_GetSalesForecastData: Query GetSalesForecastData; //GetSalesForecastData
        que_GetSalesCalculation: Query GetSalesCalculation; //GetSalesCalculation

        recTempSalesCalculation: Record TempSalesCalculation; //TempSalesCalculation
        recENHPOPStockMinCalc: Record ENHPOP_StockMinCalc;

        expr: Text;
        rowCountDesc, multiplierSupplierOrderCycle : Integer;
        totQuantity, salesPerDay, newMin : Decimal;
        varItemNo: Code[20];
        math: Codeunit Math; //Standard CodeUnit for performing maths operation

    begin
        que_GetSalesForecastData.SetRange(que_GetSalesForecastData.Forecast_Date, ForecastDate, LiveCurrentBeginningMonth - 1);

        que_GetSalesForecastData.Open();
        while que_GetSalesForecastData.Read() do begin
            recTempSalesCalculation.Init();
            recTempSalesCalculation.Id := CreateGuid();
            recTempSalesCalculation.ItemNo := que_GetSalesForecastData.Forecast_Item_No_;
            recTempSalesCalculation.Quantity := que_GetSalesForecastData.Forecast_Quantity;
            recTempSalesCalculation.IgnoreTopBOTSalesQty := que_GetSalesForecastData.IGNORE_TOP_BOT_SALES_QTY;
            recTempSalesCalculation.DaysToUse := que_GetSalesForecastData.DAYS_TO_USE;
            recTempSalesCalculation.SupplierOrderCycle := que_GetSalesForecastData.SUPPLIER_ORDER_CYCLE;
            recTempSalesCalculation.QueSystemCreatedAt := que_GetSalesForecastData.Min_SystemCreatedAt;
            recTempSalesCalculation.Insert();
        end;
        que_GetSalesForecastData.Close();

    end;

    procedure ForecastCalculateMinSales()
    var
        que_GetSalesCalculation: Query GetSalesCalculation; //GetSalesCalculation
        recENHPOPStockMinCalc: Record ENHPOP_StockMinCalc;

        multiplierSupplierOrderCycle: Integer;
        totQuantity, salesPerDay, newMin : Decimal;
        math: Codeunit Math; //Standard CodeUnit for performing maths operation

    begin
        que_GetSalesCalculation.Open();

        while que_GetSalesCalculation.Read() do begin
            recENHPOPStockMinCalc.Reset();
            //recEnhPOPStockMinCalc.STKCODE := que_GetSalesCalculation.ItemNo;
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetSalesCalculation.ItemNo);
            if recENHPOPStockMinCalc.FindFirst() then begin
                //if (recEnhPOPStockMinCalc.Find('=')) then begin
                //Total the sales Quantity
                totQuantity := (math.Ceiling(que_GetSalesCalculation.Quantity * 1000)) / 1000;

                //Calculate average Sales Per Day
                salesPerDay := (math.Ceiling((que_GetSalesCalculation.Quantity / que_GetSalesCalculation.DaysToUse) * 1000)) / 1000;

                if (que_GetSalesCalculation.SupplierOrderCycle > 0) then
                    multiplierSupplierOrderCycle := que_GetSalesCalculation.SupplierOrderCycle
                // else if (when coalesce(su_usrnum2,0)>0 then su_usrnum2 )
                else
                    if que_GetSalesCalculation.enhDaysForPO > 0 then
                        multiplierSupplierOrderCycle := que_GetSalesCalculation.enhDaysForPO
                    else
                        multiplierSupplierOrderCycle := 1;

                //Calculate new min based on today sales 
                newMin := salesPerDay * multiplierSupplierOrderCycle;

                //Store the new min & order cycle in temp EnhPOPStockMinCalc table
                recEnhPOPStockMinCalc.MIN_CALC := newMin;
                recEnhPOPStockMinCalc.SUPPLIER_ORDER_CYCLE := que_GetSalesCalculation.SupplierOrderCycle;
                recEnhPOPStockMinCalc.ORDERS_IN_PERIOD := totQuantity;
                recEnhPOPStockMinCalc.SALES_PER_DAY_QNTY := (math.Ceiling(salesPerDay * 1000)) / 1000;
                recEnhPOPStockMinCalc.Modify();
            end;
        end;
        que_GetSalesCalculation.Close();
    end;

    procedure ForecastGetAllSalesHeaderandArchieve()
    var
        que_GetAllSalesItem: Query GetAllSalesItem; //GetAllSalesItem
        que_GetAllSalesArchieveItem: Query GetAllSalesArchieveItem; //GetAllSalesArchieveItem-InvoiveOrder

        recTempSalesCalculation: Record TempSalesCalculation; //TempSalesCalculation
        recCustomerExclude: Record Customer;

        rowCountDesc: Integer;
        varItemNo: Code[30];
        expr: Text;
    begin
        rowCountDesc := 0;
        varItemNo := '';

        // Read query GetAllSalesItem and insert into TempSalesCalculation
        que_GetAllSalesItem.Open();

        while que_GetAllSalesItem.Read() do begin
            expr := '-' + format(que_GetAllSalesItem.DAYS_TO_USE) + 'D';

            if (que_GetAllSalesItem.Amount > 0) and (que_GetAllSalesItem.Order_Date > CalcDate(expr, Today))
            then begin
                recCustomerExclude."No." := que_GetAllSalesItem.Sell_to_Customer_No_;
                //Ignore any customers flagged to ignoreFromMinMax
                if (recCustomerExclude.Find('=')) and (not recCustomerExclude.ignoreFromMinMax) then begin
                    recTempSalesCalculation.Init();
                    recTempSalesCalculation.Id := CreateGuid();
                    recTempSalesCalculation.ItemNo := que_GetAllSalesItem.SalesLine_No;
                    recTempSalesCalculation.Quantity := que_GetAllSalesItem.Quantity;
                    recTempSalesCalculation.IgnoreTopBOTSalesQty := que_GetAllSalesItem.IGNORE_TOP_BOT_SALES_QTY;
                    recTempSalesCalculation.DaysToUse := que_GetAllSalesItem.DAYS_TO_USE;
                    recTempSalesCalculation.SupplierOrderCycle := que_GetAllSalesItem.SUPPLIER_ORDER_CYCLE;
                    recTempSalesCalculation.QueSystemCreatedAt := que_GetAllSalesItem.Min_SystemCreatedAt;
                    recTempSalesCalculation.Insert();
                end;
            end;
        end;
        que_GetAllSalesItem.Close();

        // Read query GetAllSalesArchieveItem and insert into TempSalesCalculation
        // que_GetAllSalesArchieveItem.Open();

        // while que_GetAllSalesArchieveItem.Read() do begin
        //     expr := '-' + format(que_GetAllSalesArchieveItem.DAYS_TO_USE) + 'D';

        //     if (que_GetAllSalesArchieveItem.Amount > 0) and (que_GetAllSalesArchieveItem.Order_Date > CalcDate(expr, Today))
        //     then begin
        //         recCustomerExclude."No." := que_GetAllSalesArchieveItem.Sell_to_Customer_No_;
        //         //Ignore any customers flagged to ignoreFromMinMax
        //         if (recCustomerExclude.Find('=')) and (not recCustomerExclude.ignoreFromMinMax) then begin
        //             recTempSalesCalculation.Init();
        //             recTempSalesCalculation.Id := CreateGuid();
        //             recTempSalesCalculation.ItemNo := que_GetAllSalesArchieveItem.SalesLine_No;
        //             recTempSalesCalculation.Quantity := que_GetAllSalesArchieveItem.Quantity;
        //             recTempSalesCalculation.IgnoreTopBOTSalesQty := que_GetAllSalesArchieveItem.IGNORE_TOP_BOT_SALES_QTY;
        //             recTempSalesCalculation.DaysToUse := que_GetAllSalesArchieveItem.DAYS_TO_USE;
        //             recTempSalesCalculation.SupplierOrderCycle := que_GetAllSalesArchieveItem.SUPPLIER_ORDER_CYCLE;
        //             recTempSalesCalculation.QueSystemCreatedAt := que_GetAllSalesArchieveItem.Min_SystemCreatedAt;
        //             recTempSalesCalculation.Insert();
        //         end;
        //     end;
        // end;
        // que_GetAllSalesArchieveItem.Close();
        GetSalesArchiveDatawithlastestVersion();

        //Set TempSalesCalculation's Table Data order by ItemNo, Qunatity in descending for ignoring top Sales Order
        recTempSalesCalculation.Reset();
        recTempSalesCalculation.SetCurrentKey(ItemNo, Quantity, QueSystemCreatedAt);
        recTempSalesCalculation.SetAscending(ItemNo, false);
        recTempSalesCalculation.SetAscending(Quantity, false);
        recTempSalesCalculation.SetAscending(QueSystemCreatedAt, false);

        if recTempSalesCalculation.FindSet() then begin
            repeat
                if (recTempSalesCalculation.ItemNo = varItemNo) then begin
                    rowCountDesc := rowCountDesc + 1;
                end
                else begin
                    rowCountDesc := 0;
                    varItemNo := '';
                end;

                if (rowCountDesc = 0) then begin
                    varItemNo := recTempSalesCalculation.ItemNo;
                    rowCountDesc := 1;

                end;

                //Ignore top X sales where x=IGNORE_TOP_BOT_SALES_QTY(Rules Matrix) and insert into  table Temp_SalesCalculation
                if rowCountDesc <= recTempSalesCalculation.IgnoreTopBOTSalesQty then begin
                    recTempSalesCalculation.Delete();
                end;
            until recTempSalesCalculation.Next() = 0;
        end;

    end;

    procedure ForecastGetAllSalesComponent()
    var
        que_GetSalesComponent: Query GetSalesComponent; //GetSalesComponent
        expr: Text;
    begin
        que_GetSalesComponent.Open();

        while que_GetSalesComponent.Read() do begin
            expr := '-' + format(que_GetSalesComponent.DAYS_TO_USE) + 'D';

            // Insert Sales Component Data into table Temp_SalesCalculation
            if (que_GetSalesComponent.Posting_Date > CalcDate(expr, Today)) then begin
                recTempSalesCalculation.Init();
                recTempSalesCalculation.Id := CreateGuid();
                recTempSalesCalculation.ItemNo := que_GetSalesComponent.Item_No_;
                // As per Phil's Call - 16-Feb-23 Multiply by -1 for Assembly Quantity.
                if que_GetSalesComponent.Quantity < 0 then
                    recTempSalesCalculation.Quantity := que_GetSalesComponent.Quantity * -1
                else
                    recTempSalesCalculation.Quantity := que_GetSalesComponent.Quantity;
                recTempSalesCalculation.DaysToUse := que_GetSalesComponent.DAYS_TO_USE;
                recTempSalesCalculation.SupplierOrderCycle := que_GetSalesComponent.SUPPLIER_ORDER_CYCLE;
                recTempSalesCalculation.QueSystemCreatedAt := que_GetSalesComponent.Min_SystemCreatedAt;
                recTempSalesCalculation.Insert();
            end;
        end;
        que_GetSalesComponent.Close();
    end;

    procedure GetSalesArchiveDatawithlastestVersion()
    var
        que_GetAllSalesArchieveItem: Query GetAllSalesArchieveItem; //GetAllSalesArchieveItem-InvoiveOrder
        expr: Text;
        recCustomerExclude: Record Customer;
        SalesHeaderNo: Code[30];
        NoOfArchievedVersion: Integer;
    begin
        SalesHeaderNo := ' ';
        Clear(NoOfArchievedVersion);
        // Read query GetAllSalesArchieveItem and insert into TempSalesCalculation
        que_GetAllSalesArchieveItem.Open();

        while que_GetAllSalesArchieveItem.Read() do begin
            expr := '-' + format(que_GetAllSalesArchieveItem.DAYS_TO_USE) + 'D';

            if (que_GetAllSalesArchieveItem.Amount > 0) and (que_GetAllSalesArchieveItem.Order_Date > CalcDate(expr, Today))
            then begin

                if ((que_GetAllSalesArchieveItem.Sales_Header_No_ = SalesHeaderNo) and (que_GetAllSalesArchieveItem.SalesHeader_Version_No_ = NoOfArchievedVersion)) then begin
                    recCustomerExclude."No." := que_GetAllSalesArchieveItem.Sell_to_Customer_No_;
                    //Ignore any customers flagged to ignoreFromMinMax
                    if (recCustomerExclude.Find('=')) and (not recCustomerExclude.ignoreFromMinMax) then begin
                        recTempSalesCalculation.Init();
                        recTempSalesCalculation.Id := CreateGuid();
                        recTempSalesCalculation.ItemNo := que_GetAllSalesArchieveItem.SalesLine_No;
                        recTempSalesCalculation.Quantity := que_GetAllSalesArchieveItem.Quantity;
                        recTempSalesCalculation.IgnoreTopBOTSalesQty := que_GetAllSalesArchieveItem.IGNORE_TOP_BOT_SALES_QTY;
                        recTempSalesCalculation.DaysToUse := que_GetAllSalesArchieveItem.DAYS_TO_USE;
                        recTempSalesCalculation.SupplierOrderCycle := que_GetAllSalesArchieveItem.SUPPLIER_ORDER_CYCLE;
                        recTempSalesCalculation.QueSystemCreatedAt := que_GetAllSalesArchieveItem.Min_SystemCreatedAt;
                        recTempSalesCalculation.VersionNo := que_GetAllSalesArchieveItem.SalesHeader_Version_No_;
                        recTempSalesCalculation.Insert();
                    end;
                end
                else begin
                    SalesHeaderNo := que_GetAllSalesArchieveItem.Sales_Header_No_;
                    NoOfArchievedVersion := que_GetAllSalesArchieveItem.No__of_Archived_Versions;
                    if (NoOfArchievedVersion = que_GetAllSalesArchieveItem.SalesHeader_Version_No_) then begin
                        recCustomerExclude."No." := que_GetAllSalesArchieveItem.Sell_to_Customer_No_;
                        //Ignore any customers flagged to ignoreFromMinMax
                        if (recCustomerExclude.Find('=')) and (not recCustomerExclude.ignoreFromMinMax) then begin
                            recTempSalesCalculation.Init();
                            recTempSalesCalculation.Id := CreateGuid();
                            recTempSalesCalculation.ItemNo := que_GetAllSalesArchieveItem.SalesLine_No;
                            recTempSalesCalculation.Quantity := que_GetAllSalesArchieveItem.Quantity;
                            recTempSalesCalculation.IgnoreTopBOTSalesQty := que_GetAllSalesArchieveItem.IGNORE_TOP_BOT_SALES_QTY;
                            recTempSalesCalculation.DaysToUse := que_GetAllSalesArchieveItem.DAYS_TO_USE;
                            recTempSalesCalculation.SupplierOrderCycle := que_GetAllSalesArchieveItem.SUPPLIER_ORDER_CYCLE;
                            recTempSalesCalculation.QueSystemCreatedAt := que_GetAllSalesArchieveItem.Min_SystemCreatedAt;
                            recTempSalesCalculation.VersionNo := que_GetAllSalesArchieveItem.SalesHeader_Version_No_;
                            recTempSalesCalculation.Insert();
                        end;
                    end;
                end;
            end;
        end;
        que_GetAllSalesArchieveItem.Close();
    end;
}
