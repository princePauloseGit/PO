table 50118 "Email Internal PO"
{
    Caption = 'Email Internal PO';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; "Email Address"; Text[250])
        {
            Caption = 'Email Address';
            DataClassification = CustomerContent;
        }
        field(3; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
            InitValue = true;
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
