codeunit 50102 ResultMinMaxCalc
{
    var
        recResultMinMaxCal: Record ResultMinMaxCalc;
        que_GetMinMaxResult: Query GetMinMaxResult;
        math: Codeunit Math;

    procedure ProcessCal(parItemNo: Code[50]; parVendor: Code[50]; parItemCategoryCode: Code[50])
    var
        CalcPOQty: Decimal;
        recItem: Record Item;
        Rec_TempSOStockAvg: Record TempSOStockAvg;
    begin

        recResultMinMaxCal.DeleteAll();

        que_GetMinMaxResult.SetFilter(ItemNo, parItemNo);
        que_GetMinMaxResult.SetFilter(Item_Category_Code, parItemCategoryCode);
        que_GetMinMaxResult.SetFilter(Vendor_No_, parVendor);

        que_GetMinMaxResult.Open();
        while que_GetMinMaxResult.Read() do begin
            recResultMinMaxCal."Item No" := que_GetMinMaxResult.ItemNo;
            recResultMinMaxCal.Description := que_GetMinMaxResult.Description;
            recResultMinMaxCal."Item Category Code" := que_GetMinMaxResult.Item_Category_Code;
            recResultMinMaxCal.Vendor := que_GetMinMaxResult.Vendor_No_;
            recResultMinMaxCal."Current Min" := que_GetMinMaxResult.STK_MIN_QTY;
            recResultMinMaxCal."Current Max" := que_GetMinMaxResult.STK_MAX_QTY;



            if que_GetMinMaxResult.MIN_CALC = 0 then begin
                //recResultMinMaxCal."New Min" := que_GetMinMaxResult.MIN_RECALC - Change as no decimal required
                recResultMinMaxCal."New Min" := Round(que_GetMinMaxResult.MIN_RECALC, 1);
                CalcPOQty := que_GetMinMaxResult.MIN_RECALC;
            end
            else begin
                //recResultMinMaxCal."New Min" := que_GetMinMaxResult.MIN_CALC; - Changed
                recResultMinMaxCal."New Min" := Round(que_GetMinMaxResult.MIN_CALC, 1);
                CalcPOQty := que_GetMinMaxResult.MIN_CALC;
            end;

            //recResultMinMaxCal."New Max" := Round(que_GetMinMaxResult.MAX_CALC, 0.001); 0 Changed 
            recResultMinMaxCal."New Max" := Round(que_GetMinMaxResult.MAX_CALC, 1);

            if que_GetMinMaxResult.Item_Category_Code = 'NOLO' then
                recResultMinMaxCal."New Po Qnty" := 0
            else
                recResultMinMaxCal."New Po Qnty" := math.Ceiling(math.Ceiling(que_GetMinMaxResult.MAX_CALC) - CalcPOQty);
            //recResultMinMaxCal."New Po Qnty" := math.Ceiling(math.Ceiling(que_GetMinMaxResult.MAX_CALC) - recResultMinMaxCal."New Min");

            case que_GetMinMaxResult.RULE_PK OF
                0:
                    recResultMinMaxCal."Min Source" := 'WFF Override';
                0 .. 100000:
                    recResultMinMaxCal."Min Source" := Format(que_GetMinMaxResult.RULETYPE) + ' ' + Format(que_GetMinMaxResult.PRIORITY);
                100000:
                    recResultMinMaxCal."Min Source" := 'MEDIAN 2';
                100001:
                    recResultMinMaxCal."Min Source" := 'MEDIAN 3';
                else
                    recResultMinMaxCal."Min Source" := '';
            end;

            if (que_GetMinMaxResult.DAYS_TO_USE) < (CurrentDateTime - que_GetMinMaxResult.SystemCreatedAt) then
                recResultMinMaxCal."Nos Order Days" := que_GetMinMaxResult.DAYS_TO_USE
            else
                recResultMinMaxCal."Nos Order Days" := CurrentDateTime - que_GetMinMaxResult.SystemCreatedAt;

            recResultMinMaxCal."Nos Order Excluded" := que_GetMinMaxResult.IGNORE_TOP_BOT_SALES_QTY;
            recResultMinMaxCal."Nos Sales Order In Prd" := que_GetMinMaxResult.ORDERS_IN_PERIOD;
            recResultMinMaxCal."Nos Sales Order Per Day" := (math.Ceiling(que_GetMinMaxResult.SALES_PER_DAY_QNTY * 1000)) / 1000;

            recResultMinMaxCal."Supplier Lead Time" := que_GetMinMaxResult.SUPPLIER_LEAD_TIME;
            // Rec_TempSOStockAvg.SetRange(VendorNo, que_GetMinMaxResult.Vendor_No_);
            // Rec_TempSOStockAvg.SetRange(ItemNo, que_GetMinMaxResult.ItemNo);
            // if Rec_TempSOStockAvg.FindFirst() then begin
            //     recResultMinMaxCal."Supplier Lead Time" := Rec_TempSOStockAvg.LeadTime;
            // end;

            if que_GetMinMaxResult.SUPPLIER_ORDER_CYCLE > 0 then
                recResultMinMaxCal."Supplier Order Cycle" := que_GetMinMaxResult.SUPPLIER_ORDER_CYCLE
            else
                if que_GetMinMaxResult.enhDaysForPO > 0 then
                    recResultMinMaxCal."Supplier Order Cycle" := que_GetMinMaxResult.enhDaysForPO
                else
                    recResultMinMaxCal."Supplier Order Cycle" := 1;

            recResultMinMaxCal."Meas Lead Time Days" := que_GetMinMaxResult.MEAN_LEAD_TIME_DAYS;
            recResultMinMaxCal."Days To Next Order Cycle" := que_GetMinMaxResult.DAYS_TO_NEXT_ORDER_CYCLE;

            if que_GetMinMaxResult.EXCLUDE = 1 then
                recResultMinMaxCal.Excluded := true
            else
                recResultMinMaxCal.Excluded := false;
            recResultMinMaxCal."Excluded Reason" := que_GetMinMaxResult.EXCLUDEREASON;

            //// Updated this code on 5-6-2023 
            //// From
            // if (recResultMinMaxCal."Current Min" = recResultMinMaxCal."Current Max") and ((recResultMinMaxCal."Current Min" > 0) and (recResultMinMaxCal."New Min" > 0)) then begin
            //     recItem.SetRange("No.", recResultMinMaxCal."Item No");
            //     if recItem.FindSet(true) then begin
            //         recItem."Reorder Point" := recItem."Reorder Point" - 1;
            //         recItem.Modify();
            //         recResultMinMaxCal."Current Min" := recItem."Reorder Point";
            //     end;
            // end;

            if (recResultMinMaxCal."New Min" = recResultMinMaxCal."New Max") and (recResultMinMaxCal."New Min" > 0) and (recResultMinMaxCal.Vendor = 'JAG001') then begin
                recResultMinMaxCal."New Min" := recResultMinMaxCal."New Min" - 1;
            end;

            if (recResultMinMaxCal."New Min" = 1) and (recResultMinMaxCal."New Max" = 2) and (recResultMinMaxCal.Vendor <> 'JAG001') then begin
                recResultMinMaxCal."New Min" := 2;
                recResultMinMaxCal."New Max" := 2;
            end;
            ////
            //// To 

            recResultMinMaxCal.Insert();
        end;
        que_GetMinMaxResult.Close();

        // Rec_TempSOStockAvg.DeleteAll();
    end;
}
