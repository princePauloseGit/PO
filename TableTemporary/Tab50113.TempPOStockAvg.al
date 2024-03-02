table 50113 TempPOStockAvg
{
    Caption = 'TempPOStockAvg';
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
        field(3; LeadTime; Decimal)
        {
            Caption = 'LeadTime';
            DataClassification = ToBeClassified;
        }
        field(4; AvgCnt; Integer)
        {
            Caption = 'AvgCnt';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
        key(ItemNo; ItemNo)
        {
            Clustered = false;
        }
    }
}
