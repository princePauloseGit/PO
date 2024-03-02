table 50117 TempGeneratePO
{
    Caption = 'TempGeneratePO';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
            //AutoIncrement = true;
        }
        field(2; Vendor; Code[30])
        {
            Caption = 'Vendor';
            DataClassification = CustomerContent;
        }
        field(3; ItemNo; Code[30])
        {
            Caption = 'ItemNo';
            DataClassification = CustomerContent;
        }
        field(4; CostPrice; Decimal)
        {
            Caption = 'CostPrice';
            DataClassification = CustomerContent;
        }
        field(5; POQty; Decimal)
        {
            Caption = 'PO Qty';
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
