codeunit 50122 CreatePurchaseOrder
{
    procedure InsertRoutinePOTemp(var routinePO: Record RoutinePO)
    var
        recTempGeneratePO: Record TempGeneratePO;
    begin
        recTempGeneratePO.Init();
        recTempGeneratePO.Id := CreateGuid();
        recTempGeneratePO.ItemNo := routinePO.ItemNo;
        recTempGeneratePO.Vendor := routinePO.Vendor;
        recTempGeneratePO.CostPrice := routinePO.Costprice;
        recTempGeneratePO.POQty := routinePO."PO Qty";
        recTempGeneratePO.Insert();
    end;

    procedure CreateAndRaisedPO()
    var
        recTempGeneratePO: Record TempGeneratePO;
        recRoutinePO: Record RoutinePO;
        varVendor: Code[30];
        recPurchHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
        linecnt: Integer;
        varDocumentNo: Code[20];
        PurchaseHeader: Record "Purchase Header";
        varTest: Text;
        listPurchaseOrder: list of [Code[30]];
        element: Integer;

    begin
        recTempGeneratePO.Reset();
        recTempGeneratePO.SetCurrentKey(Vendor);
        recTempGeneratePO.SetAscending(Vendor, true);

        if recTempGeneratePO.FindSet() then begin
            repeat
                if recTempGeneratePO.Vendor = varVendor then begin
                    linecnt := linecnt + 10000;
                    CreatePurchaseLine(linecnt, varDocumentNo, recTempGeneratePO);

                end
                else begin
                    varVendor := recTempGeneratePO.Vendor;
                    varDocumentNo := CreatePurchaseHeader(recTempGeneratePO);
                    recPurchaseLine.Init();
                    linecnt := 10000;
                    CreatePurchaseLine(linecnt, varDocumentNo, recTempGeneratePO);
                    listPurchaseOrder.Add(varDocumentNo);

                end;
            until recTempGeneratePO.Next() = 0;
        end;

        FOR element := 1 TO listPurchaseOrder.Count do begin
            cu_JobRoutinePO.RaisedPO(listPurchaseOrder.Get(element));
        end;

    end;

    local procedure CreatePurchaseHeader(var recPurchaseHeader: Record TempGeneratePO) varPurchaseHeaderNo: Code[30]
    var
        recPurchHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
    begin
        recPurchHeader.Init();
        recPurchHeader.InitRecord;
        recPurchHeader."Buy-from Vendor No." := recPurchaseHeader.Vendor;
        recPurchHeader.Validate("Buy-from Vendor No.");
        recPurchHeader."Document Type" := "Purchase Document Type"::Order;
        recPurchHeader.Insert(true);
        recPurchHeader."Document Date" := Today;
        recPurchHeader."Order Date" := Today;
        recPurchHeader.Validate("Pay-to Vendor No.");
        recPurchHeader.Modify(true);

        varPurchaseHeaderNo := recPurchHeader."No.";
    end;

    local procedure CreatePurchaseLine(var linecnt: Integer; var documentNo: code[20]; var recTempGeneratePO: Record TempGeneratePO)
    var
        recPurchaseLine: Record "Purchase Line";
        discountPercentage, discountedAmount, discountDivided, discountMinus, ItemCost : Decimal;
        excludeDiscount: Boolean;
        recVendor: Record Vendor;
        recItem: Record Item;
        pagePurchaseOrder: Page "Purchase Order Subform";
    begin
        excludeDiscount := false;
        discountPercentage := 0;
        discountDivided := 0;
        discountMinus := 0;
        ItemCost := 0;

        recPurchaseLine.Init();
        linecnt := linecnt;
        recPurchaseLine."Line No." := linecnt;
        recPurchaseLine."Document No." := documentNo;
        recPurchaseLine.Type := "Purchase Line Type"::Item;
        recPurchaseLine."Document Type" := "Purchase Document Type"::Order;
        recPurchaseLine."No." := recTempGeneratePO.ItemNo;
        recPurchaseLine.Validate("No.");
        recPurchaseLine.UpdateAmounts();
        recPurchaseLine.Insert(true);

        recPurchaseLine.Reset();
        recPurchaseLine.SetRange("Document Type", "Purchase Document Type"::Order);
        recPurchaseLine.SetRange(Type, "Purchase Line Type"::Item);
        recPurchaseLine.SetRange("Line No.", linecnt);
        recPurchaseLine.SetRange("Document No.", documentNo);
        recPurchaseLine.SetRange("No.", recTempGeneratePO.ItemNo);

        if recPurchaseLine.FindFirst() then begin
            recPurchaseLine.Quantity := recTempGeneratePO.POQty;
            recPurchaseLine.ClearFieldCausedPriceCalculation();
            recPurchaseLine.PlanPriceCalcByField(15);
            recPurchaseLine.Validate(Quantity);
            recPurchaseLine.Modify(true);
        end;

        recItem.reset();
        recItem.SetRange("No.", recTempGeneratePO.ItemNo);
        if recItem.FindFirst() then begin
            if recItem."Exclude From Discount" = true then begin
                excludeDiscount := true;
            end else begin
                excludeDiscount := false;
            end;
        end;

        recVendor.Reset();
        recVendor.SetRange("No.", recTempGeneratePO.Vendor);
        if recVendor.FindFirst() then begin
            if (recVendor."Vendor Discount" > 0) then begin
                discountPercentage := recVendor."Vendor Discount";
                excludeDiscount := false;
            end else begin
                excludeDiscount := true;
            end;
        end;

        if excludeDiscount = false then begin

            recPurchaseLine.Reset();
            recPurchaseLine.SetRange("Document Type", "Purchase Document Type"::Order);
            recPurchaseLine.SetRange(Type, "Purchase Line Type"::Item);
            recPurchaseLine.SetRange("Document No.", documentNo);
            recPurchaseLine.SetRange("No.", recTempGeneratePO.ItemNo);

            if recPurchaseLine.FindFirst() then begin
                discountDivided := discountPercentage / 100;
                discountMinus := 1 - discountDivided;
                ItemCost := recPurchaseLine."Direct Unit Cost";

                discountedAmount := ItemCost / discountMinus;
                recPurchaseLine."Direct Unit Cost" := discountedAmount;
                recPurchaseLine."Line Discount %" := discountPercentage;
                recPurchaseLine.Modify(true);
            end;
        end;

    end;

    var
        cu_JobRoutinePO: Codeunit JobRoutinePO;
}