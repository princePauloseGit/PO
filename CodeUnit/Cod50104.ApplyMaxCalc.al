codeunit 50104 ApplyMaxCalc
{
    trigger OnRun()
    var
    begin
        CalNoOfDaystoNextOrderCycle();
        UpdateMaxStockLevels();
        UpdateMaxStkWithWFFRules();
        UpdateMaxStockResetMin();
        UpdateMaxPOError();
    end;

    var
        recENHPOPStockMinCalc: Record ENHPOP_StockMinCalc;

    local procedure CalNoOfDaystoNextOrderCycle()
    var
        que_GetVendorPOCycle: Query GetVendorPOCycle;
        rowDateRank: Integer;
        varVendor: Code[30];
        expr: Text;
    begin
        // Update all records ,days_to_next_order_cycle to 9999;
        recEnhPOPStockMinCalc.ModifyAll(DAYS_TO_NEXT_ORDER_CYCLE, 9999);

        //Calculate Days to next order cycle for defined vendors
        rowDateRank := 0;
        varVendor := '';

        que_GetVendorPOCycle.Open();
        while que_GetVendorPOCycle.Read() do begin
            if (que_GetVendorPOCycle.Vendor = varVendor) then begin
                rowDateRank := rowDateRank + 1;
            end
            else begin
                rowDateRank := 0;
                varVendor := '';
            end;

            if (rowDateRank = 0) then begin
                varVendor := que_GetVendorPOCycle.Vendor;
                rowDateRank := 1;
            end;

            if rowDateRank = 1 then begin
                recEnhPOPStockMinCalc.Reset();
                recEnhPOPStockMinCalc.SetFilter(SUPPLIER1, que_GetVendorPOCycle.Vendor);
                if recEnhPOPStockMinCalc.FindSet() then begin
                    repeat

                        recEnhPOPStockMinCalc.DAYS_TO_NEXT_ORDER_CYCLE := que_GetVendorPOCycle.NextFrequencyDate - Today;

                        // 15-06-2023 set Days to next order cycle 1 if vendor cycle next frequency date and todays data is same;
                        if recENHPOPStockMinCalc.DAYS_TO_NEXT_ORDER_CYCLE = 0 then begin
                            recENHPOPStockMinCalc.DAYS_TO_NEXT_ORDER_CYCLE := 1;
                        end;
                        //

                        recEnhPOPStockMinCalc.Modify();
                    until recEnhPOPStockMinCalc.Next() = 0;
                end;
            end;

        end;
        que_GetVendorPOCycle.Close();

        recEnhPOPStockMinCalc.Reset();
        recEnhPOPStockMinCalc.SetFilter(DAYS_TO_NEXT_ORDER_CYCLE, '9999');
        recEnhPOPStockMinCalc.ModifyAll(EXCLUDE, 1);
        recENHPOPStockMinCalc.ModifyAll(EXCLUDEREASON, 'Missing Next Order Cycle for Vendor');
        recEnhPOPStockMinCalc.ModifyAll(DAYS_TO_NEXT_ORDER_CYCLE, 0);

    end;

    local procedure UpdateMaxStockLevels()
    var
    begin
        //updates the Max stock levels based on the calc "Min + ((Days to next order cycle * Days Lead time) * Days Average Sales)"
        recENHPOPStockMinCalc.Reset();
        if recENHPOPStockMinCalc.FindSet() then begin
            repeat
                if recENHPOPStockMinCalc.MIN_CALC = 0 then begin
                    recENHPOPStockMinCalc.MAX_CALC := recENHPOPStockMinCalc.MIN_RECALC + (recENHPOPStockMinCalc.DAYS_TO_NEXT_ORDER_CYCLE * recENHPOPStockMinCalc.SALES_PER_DAY_QNTY);
                end
                else begin
                    recENHPOPStockMinCalc.MAX_CALC := recENHPOPStockMinCalc.MIN_CALC + (recENHPOPStockMinCalc.DAYS_TO_NEXT_ORDER_CYCLE * recENHPOPStockMinCalc.SALES_PER_DAY_QNTY);
                end;
                recENHPOPStockMinCalc.Modify();
            until recENHPOPStockMinCalc.Next() = 0;
        end;
    end;

    local procedure UpdateMaxStkWithWFFRules()
    var
        que_GetPOMinMaxQtyOverrideItem: Query GetPOMinMaxQtyOverrideItem;
        que_GetPOminmaxqtyOverrideSK: Query GetPOminmaxqtyOverrideSK;
    begin
        //update the max calc to 0 where the stock code is in the min override work flow form
        que_GetPOMinMaxQtyOverrideItem.Open();
        while que_GetPOMinMaxQtyOverrideItem.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetPOMinMaxQtyOverrideItem.STKCODE);
            if recENHPOPStockMinCalc.FindFirst() then begin
                //recEnhPOPStockMinCalc.STKCODE := que_GetPOMinMaxQtyOverrideItem.STKCODE;
                // if recEnhPOPStockMinCalc.Find('=') then begin
                if (recEnhPOPStockMinCalc.MIN_CALC = que_GetPOMinMaxQtyOverrideItem.Quantity) then begin
                    recEnhPOPStockMinCalc.MAX_CALC := que_GetPOMinMaxQtyOverrideItem.Quantity;
                    recEnhPOPStockMinCalc.RULE_PK := 0;
                    recEnhPOPStockMinCalc.Modify();
                end;
            end;
        end;
        que_GetPOMinMaxQtyOverrideItem.Close();

        // update Max Stock Level for all products where there is a sort key that overrides data, from WFF 
        que_GetPOminmaxqtyOverrideSK.Open();
        while que_GetPOminmaxqtyOverrideSK.Read() do begin
            recENHPOPStockMinCalc.Reset();
            recENHPOPStockMinCalc.SetRange(STKCODE, que_GetPOminmaxqtyOverrideSK.STKCODE);
            if recENHPOPStockMinCalc.FindFirst() then begin
                //recEnhPOPStockMinCalc.STKCODE := que_GetPOminmaxqtyOverrideSK.STKCODE;
                //if recEnhPOPStockMinCalc.Find('=') then begin
                recEnhPOPStockMinCalc.MAX_CALC := que_GetPOminmaxqtyOverrideSK.Quantity;
                recEnhPOPStockMinCalc.RULE_PK := 0;
                recEnhPOPStockMinCalc.Modify();
            end;
        end;
        que_GetPOminmaxqtyOverrideSK.Close();

    end;

    local procedure UpdateMaxStockResetMin()
    var
        updateMinCalc: Decimal;
        recItem: Record Item;
    begin
        //update max to zero when min is zero.
        recEnhPOPStockMinCalc.Reset();
        if recENHPOPStockMinCalc.FindSet() then begin
            repeat
                if (recENHPOPStockMinCalc.MIN_CALC = 0) and (recEnhPOPStockMinCalc.MIN_RECALC = 0) then begin
                    recEnhPOPStockMinCalc.MAX_CALC := 0;
                    recEnhPOPStockMinCalc.Modify();
                end;
            until recENHPOPStockMinCalc.Next() = 0;
        end;

        // update min to 1 if max = 1 and min = 0
        recEnhPOPStockMinCalc.Reset();
        if recENHPOPStockMinCalc.FindSet() then begin
            repeat
                if recEnhPOPStockMinCalc.MIN_CALC = 0 then
                    updateMinCalc := recEnhPOPStockMinCalc.MIN_RECALC
                else
                    updateMinCalc := recEnhPOPStockMinCalc.MIN_CALC;

                if (Round(updateMinCalc, 1) = 0) and (Round(recEnhPOPStockMinCalc.MAX_CALC, 1) = 1) then begin
                    recEnhPOPStockMinCalc.MIN_CALC := 1;
                    recEnhPOPStockMinCalc.MIN_RECALC := 1;
                    recEnhPOPStockMinCalc.MAX_CALC := 1;
                    recEnhPOPStockMinCalc.Modify();
                end;
            until recENHPOPStockMinCalc.Next() = 0;
        end;

        // need to set max = min = 2 where max = min = 1 as per mail on 3rd oct
        recEnhPOPStockMinCalc.Reset();
        if recENHPOPStockMinCalc.FindSet() then begin
            repeat
                if (Round(recENHPOPStockMinCalc.MIN_CALC, 1) = 1) and (Round(recEnhPOPStockMinCalc.MAX_CALC, 1) = 1) and (recENHPOPStockMinCalc.STK_SORT_KEY <> 'MAIB') then begin
                    recEnhPOPStockMinCalc.MIN_CALC := 2;
                    recEnhPOPStockMinCalc.MIN_RECALC := 2;
                    recEnhPOPStockMinCalc.MAX_CALC := 2;
                    recEnhPOPStockMinCalc.Modify();
                end;
            until recENHPOPStockMinCalc.Next() = 0;
        end;

    end;

    local procedure UpdateMaxPOError()
    var
        recItem: Record Item;
    begin
        recItem.Reset();
        recItem.SetRange(ItemPOError, 'Max Error');
        if recItem.FindSet(true) then
            repeat
                recItem.ItemPOError := '';
                recItem.Modify();
            until recItem.Next = 0;

        recEnhPOPStockMinCalc.SetRange(DAYS_TO_NEXT_ORDER_CYCLE, 0);
        if recEnhPOPStockMinCalc.FindSet(true) then begin
            repeat
                recItem.Reset();
                recItem.SetRange("No.", recEnhPOPStockMinCalc.STKCODE);
                if recItem.Findfirst() then begin
                    recItem.ItemPOError := 'Max Error';
                    recItem.Modify();
                end
            until recEnhPOPStockMinCalc.Next() = 0;
        end;
    end;
}
