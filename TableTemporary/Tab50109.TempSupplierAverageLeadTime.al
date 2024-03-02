table 50109 TempSupplierAverageLeadTime
{
    Caption = 'TempSupplierAverageLeadTime';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Code[50])
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = ToBeClassified;
        }
        field(3; "Order Date"; Date)
        {
            Caption = 'Order Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Vendor No"; Code[50])
        {
            Caption = 'Vendor No ';
            DataClassification = ToBeClassified;
        }
        field(5; "Lead Time"; Integer)
        {
            Caption = 'Lead Time ';
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
