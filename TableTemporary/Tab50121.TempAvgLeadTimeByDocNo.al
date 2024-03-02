table 50121 TempAvgLeadTimeByDocNo
{
    Caption = 'TempAvgLeadTimeByDocNo';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ItemNo; Code[20])
        {
            Caption = 'ItemNo';
            DataClassification = CustomerContent;
        }
        field(2; Buy_from_Vendor_No_; Code[20])
        {
            Caption = 'Buy_from_Vendor_No_';
            DataClassification = CustomerContent;
        }
        field(3; dateDiffDays; Integer)
        {
            Caption = 'dateDiffDays';
            DataClassification = CustomerContent;
        }
        field(4; RowNo; Code[50])
        {
            Caption = 'Row No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(5; AvgLeadTime; Decimal)
        {
            Caption = 'AvgLeadTime';
            DataClassification = CustomerContent;
        }
        field(6; DocumentNo; Text[100])
        {
            Caption = 'DocumentNo';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(Pk; RowNo)
        {

        }

    }
}
