codeunit 50107 UpdateMinMax
{
    procedure updateMinMax(ItemNo: Code[30]; parNewMin: decimal; parNewMax: decimal; parCurrentMin: Decimal; parCurrentMax: Decimal)
    var
    begin
        //if new min is greater than current max then process max first
        if parNewMin >= parNewMax then begin

            //update the Max Stock levels for those selected lines
            if parCurrentMax <> parNewMax then
                updateMax(ItemNo, parNewMax);

            //update the Min Stock levels for those selected lines
            if parCurrentMin <> parNewMin then
                updateMin(ItemNo, parNewMin);
        end
        else begin

            //update the Min Stock levels for those selected lines
            if parCurrentMin <> parNewMin then
                updateMin(ItemNo, parNewMin);

            //update the Max Stock levels for those selected lines
            if parCurrentMax <> parNewMax then
                updateMax(ItemNo, parNewMax);
        end;
    end;

    procedure updateMin(ItemNo: Code[30]; parMin: decimal)
    var
        recItem: Record Item;
    begin
        recItem.Reset();
        recItem.SetRange("No.", ItemNo);
        if recItem.FindFirst() then begin
            recItem."Reorder Point" := Round(parMin, 1);
            recItem.Modify(true);
        end;
    end;

    procedure updateMax(ItemNo: Code[30]; parMax: decimal)
    var
        recItem: Record Item;
    begin
        recItem.Reset();
        recItem.SetRange("No.", ItemNo);
        if recItem.FindFirst() then begin
            recItem."Maximum Inventory" := Round(parMax, 1);
            recItem.Modify(true);
        end;
    end;
}
