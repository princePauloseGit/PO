table 50119 EntryDateProduction
{
    Caption = 'EntryDateProduction';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; StartingDate; Date)
        {
            Caption = 'StartingDate';
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
