table 50104 POMinMaxQtyOverrideSK
{
    Caption = 'PO Min Max Qty Override SK';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; SortKey; Code[20])
        {
            Caption = 'Sort Key';
            DataClassification = CustomerContent;
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }
}
