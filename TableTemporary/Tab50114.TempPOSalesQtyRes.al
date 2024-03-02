table 50114 TempPOSalesQtyRes
{
    Caption = 'TempPOSalesQtyRes';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(2; ItemNo; Code[50])
        {
            Caption = 'ItemNo';
            DataClassification = ToBeClassified;
        }
        field(3; QtyReserved; Decimal)
        {
            Caption = 'QtyReserved';
            DataClassification = ToBeClassified;
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
