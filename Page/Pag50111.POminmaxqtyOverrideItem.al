page 50111 POminmaxqtyOverrideItem
{
    Caption = 'PO Min/Max Qty. Override Item';
    PageType = Card;
    SourceTable = POMinMaxQtyOverrideItem;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ItemCode; Rec.ItemCode)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;

                }
                field(ExpiryDate; Rec.ExpiryDate)
                {
                    ApplicationArea = All;

                }
                field(AllowHigherMin; Rec.AllowHigherMin)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
}
