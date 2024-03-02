page 50110 POMinMaxQtyOverrideItemList
{
    ApplicationArea = All;
    Caption = 'PO Min/Max Qty Override Item';
    PageType = List;
    SourceTable = POMinMaxQtyOverrideItem;
    UsageCategory = Lists;
    CardPageId = POminmaxqtyOverrideItem;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ItemCode; Rec.ItemCode)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(ExpiryDate; Rec.ExpiryDate)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(AllowHigherMin; Rec.AllowHigherMin)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
