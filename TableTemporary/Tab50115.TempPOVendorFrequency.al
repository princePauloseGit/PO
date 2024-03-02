table 50115 TempPOVendorFrequency
{
    Caption = 'TempPOVendorFrequency';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(2; Vendor; Code[30])
        {
            Caption = 'Vendor';
            DataClassification = ToBeClassified;
        }
        field(3; Frequency; Code[5])
        {
            Caption = 'Frequency';
            DataClassification = ToBeClassified;
        }
        field(4; NextFrequencyDate; Date)
        {
            Caption = 'NextFrequencyDate';
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
