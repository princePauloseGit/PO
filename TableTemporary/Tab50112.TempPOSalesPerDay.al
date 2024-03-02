table 50112 TempPOSalesPerDay
{
    Caption = 'TempPOSalesPerDay';
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
        field(3; Days; Integer)
        {

        }
        field(4; SalesPerDayQty; Decimal)
        {
            Caption = 'SalesPerDayQty';
            DecimalPlaces = 4;
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
