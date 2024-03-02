table 50100 ENHPOP_DaysOfMonth
{
    Caption = 'ENHPOP_DaysOfMonth';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; DayPeriod; Date)
        {
            Caption = 'DayPeriod';
            DataClassification = CustomerContent;
        }
        field(2; DayOfWeek; Integer)
        {
            Caption = 'DayOfWeek';
            DataClassification = CustomerContent;
        }
        field(4; WorkingDayOfMonth; Integer)
        {
            Caption = 'WorkingDayOfMonth';
            DataClassification = CustomerContent;
        }
        field(5; FrequencyM; Code[5])
        {
            Caption = 'FrequencyM';
            DataClassification = CustomerContent;
        }
        field(6; FrequencyW; Code[5])
        {
            Caption = 'FrequencyW';
            DataClassification = CustomerContent;
        }
        field(7; FrequencyY; Code[5])
        {
            Caption = 'FrequencyY';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; DayPeriod)
        {
            Clustered = true;
        }
    }
}
