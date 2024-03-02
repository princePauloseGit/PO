codeunit 50111 ArchievedVersion
{
    procedure GetLatestVersionforGetRecalculateMinForArchive(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        que_GetRecalculateMinForArchive: Query GetRecalculateMinForArchive; //GetAllSalesArchieveItem-InvoiveOrder
        recTempRecalcMin2Sales: Record TempRecalcMin2Sales;
        varSalesHeaderNo: Code[30];
        NoOfArchievedVersion: Integer;
    begin
        varSalesHeaderNo := ' ';
        Clear(NoOfArchievedVersion);

        que_GetRecalculateMinForArchive.SetFilter(No_, parItemNo);
        que_GetRecalculateMinForArchive.SetFilter(Vendor_No_, parVendor);
        que_GetRecalculateMinForArchive.SetFilter(Item_Category_Code, parItemCategoryCode);

        // Read query GetRecalculateMinForArchive and insert into TempRecalcMin2Sales with latest version
        que_GetRecalculateMinForArchive.Open();

        while que_GetRecalculateMinForArchive.Read() do begin
            if que_GetRecalculateMinForArchive.Order_Date >= CalcDate('-12M', Today) then begin
                if ((que_GetRecalculateMinForArchive.SalesHeaderNo = varSalesHeaderNo) and (que_GetRecalculateMinForArchive.SalesHeader_Version_No_ = NoOfArchievedVersion)) then begin
                    recTempRecalcMin2Sales.Init();
                    recTempRecalcMin2Sales.Id := CreateGuid();
                    recTempRecalcMin2Sales."Item No" := que_GetRecalculateMinForArchive.No_;
                    recTempRecalcMin2Sales."Vendor No" := que_GetRecalculateMinForArchive.Vendor_No_;

                    recTempRecalcMin2Sales."Reorder Point" := que_GetRecalculateMinForArchive.Reorder_Point;
                    recTempRecalcMin2Sales."Maximum Inventory" := que_GetRecalculateMinForArchive.Maximum_Inventory;

                    recTempRecalcMin2Sales.Insert();

                end
                else begin
                    varSalesHeaderNo := que_GetRecalculateMinForArchive.SalesHeaderNo;
                    NoOfArchievedVersion := que_GetRecalculateMinForArchive.No__of_Archived_Versions;
                    if (NoOfArchievedVersion = que_GetRecalculateMinForArchive.SalesHeader_Version_No_) then begin
                        recTempRecalcMin2Sales.Init();
                        recTempRecalcMin2Sales.Id := CreateGuid();
                        recTempRecalcMin2Sales."Item No" := que_GetRecalculateMinForArchive.No_;
                        recTempRecalcMin2Sales."Vendor No" := que_GetRecalculateMinForArchive.Vendor_No_;

                        recTempRecalcMin2Sales."Reorder Point" := que_GetRecalculateMinForArchive.Reorder_Point;
                        recTempRecalcMin2Sales."Maximum Inventory" := que_GetRecalculateMinForArchive.Maximum_Inventory;

                        recTempRecalcMin2Sales.Insert();
                    end;
                end;
            end;
        end;
        que_GetRecalculateMinForArchive.Close();
    end;

    procedure GetSalesArchieveForPO(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        que_GetSalesArchiveOrders: Query GetSalesArchiveOrders;
        recCustomerExclude: Record Customer;
        recTempPOSalesPerDay: Record TempPOSalesPerDay;
        varSalesHeaderNo: Code[30];
        NoOfArchievedVersion: Integer;
    begin
        // Get Sales Archieve Data
        que_GetSalesArchiveOrders.SetFilter(Sales_Line_No_, parItemNo);
        //8-Nov-22
        if parvendor <> '' then
            que_GetSalesArchiveOrders.SetFilter(Vendor_No_, parvendor);
        if parItemCategoryCode <> '' then
            que_GetSalesArchiveOrders.SetFilter(Item_Category_Code, parItemCategoryCode);

        que_GetSalesArchiveOrders.Open();

        while que_GetSalesArchiveOrders.Read() do begin
            recCustomerExclude."No." := que_GetSalesArchiveOrders.Sell_to_Customer_No_;
            //Ignore any customers flagged to ignoreFromMinMax
            if (recCustomerExclude.Find('=')) and (not recCustomerExclude.ignoreFromMinMax) and (DT2DATE(que_GetSalesArchiveOrders.SystemCreatedAt) <= CalcDate('-1D', Today)) then begin
                // Latest Version logic
                if ((que_GetSalesArchiveOrders.Sales_Header_No_ = varSalesHeaderNo) and (que_GetSalesArchiveOrders.SalesHeader_Version_No_ = NoOfArchievedVersion)) then begin
                    recTempPOSalesPerDay.SetRange(ItemNo, que_GetSalesArchiveOrders.Sales_Line_No_);
                    if recTempPOSalesPerDay.FindFirst() then begin
                        recTempPOSalesPerDay.SalesPerDayQty := recTempPOSalesPerDay.SalesPerDayQty + que_GetSalesArchiveOrders.Quantity;
                        recTempPOSalesPerDay.Modify();
                    end
                    else begin
                        recTempPOSalesPerDay.Init();
                        recTempPOSalesPerDay.Id := CreateGuid();
                        recTempPOSalesPerDay.ItemNo := que_GetSalesArchiveOrders.Sales_Line_No_;
                        recTempPOSalesPerDay.SalesPerDayQty := que_GetSalesArchiveOrders.Quantity;
                        if (Today - DT2DATE(que_GetSalesArchiveOrders.SystemCreatedAt) < 365) then
                            recTempPOSalesPerDay.Days := Today - DT2DATE(que_GetSalesArchiveOrders.SystemCreatedAt)
                        else
                            recTempPOSalesPerDay.Days := 365;
                        recTempPOSalesPerDay.Insert();
                    end;
                end
                else begin
                    varSalesHeaderNo := que_GetSalesArchiveOrders.Sales_Header_No_;
                    NoOfArchievedVersion := que_GetSalesArchiveOrders.No__of_Archived_Versions;
                    // Latest Version logic
                    if (NoOfArchievedVersion = que_GetSalesArchiveOrders.SalesHeader_Version_No_) then begin
                        recTempPOSalesPerDay.SetRange(ItemNo, que_GetSalesArchiveOrders.Sales_Line_No_);
                        if recTempPOSalesPerDay.FindFirst() then begin
                            recTempPOSalesPerDay.SalesPerDayQty := recTempPOSalesPerDay.SalesPerDayQty + que_GetSalesArchiveOrders.Quantity;
                            recTempPOSalesPerDay.Modify();
                        end
                        else begin
                            recTempPOSalesPerDay.Init();
                            recTempPOSalesPerDay.Id := CreateGuid();
                            recTempPOSalesPerDay.ItemNo := que_GetSalesArchiveOrders.Sales_Line_No_;
                            recTempPOSalesPerDay.SalesPerDayQty := que_GetSalesArchiveOrders.Quantity;
                            if (Today - DT2DATE(que_GetSalesArchiveOrders.SystemCreatedAt) < 365) then
                                recTempPOSalesPerDay.Days := Today - DT2DATE(que_GetSalesArchiveOrders.SystemCreatedAt)
                            else
                                recTempPOSalesPerDay.Days := 365;
                            recTempPOSalesPerDay.Insert();
                        end;
                    end;
                end;
            end;
        end;
        que_GetSalesArchiveOrders.Close();
    end;
}
