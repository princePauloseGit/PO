pageextension 50100 ExtItemList extends "Item List"
{
    layout
    {
        addafter("Vendor No.")
        {
            field(ItemPOError; Rec.ItemPOError)
            {
                ApplicationArea = All;
            }
            field("Exclude From Discount"; Rec."Exclude From Discount")
            {
                ApplicationArea = all;
            }

        }
    }
}
