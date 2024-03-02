page 50113 POminmaxqtyOverrideSK
{
    Caption = 'PO Min/Max Qty. Override SK';
    PageType = XmlPort;
    SourceTable = POMinMaxQtyOverrideSK;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SortKey; Rec.SortKey)
                {
                    ApplicationArea = All;
                    TableRelation = "Item Category".Code;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
