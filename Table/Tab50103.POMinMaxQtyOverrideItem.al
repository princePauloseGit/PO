table 50103 POMinMaxQtyOverrideItem
{
    Caption = 'PO Min Max Qty Override Item';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            AutoIncrement = true;
            DataClassification = CustomerContent;
        }
        field(2; ItemCode; Code[30])
        {
            Caption = 'Item Code';
            DataClassification = CustomerContent;
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(4; ExpiryDate; DateTime)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(5; AllowHigherMin; Boolean)
        {
            Caption = 'Allow Higher Minimum';
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
