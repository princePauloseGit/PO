table 50122 ActiveUsers
{
    Caption = 'ActiveUsers';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(2; UserID; Text[100])
        {
            Caption = 'UserID';
        }
        field(3; "UserCount"; Integer)
        {
            Caption = 'Count';
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
