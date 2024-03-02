page 50112 POminmaxqtyOverrideSKList
{
    ApplicationArea = All;
    Caption = 'PO Min/Max Qty Override SK';
    PageType = List;
    SourceTable = POMinMaxQtyOverrideSK;
    UsageCategory = Lists;
    CardPageId = POminmaxqtyOverrideSK;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SortKey; Rec.SortKey)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
