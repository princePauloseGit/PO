table 50101 ENHPOP_POFrequency
{
    Caption = 'ENHPOP_POFrequency';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Frequency; Code[5])
        {
            Caption = 'Frequency';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; NextFrequencyDate; Date)
        {
            Caption = 'Next FrequencyDate';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; Frequency)
        {
            Clustered = true;
        }
    }
}
