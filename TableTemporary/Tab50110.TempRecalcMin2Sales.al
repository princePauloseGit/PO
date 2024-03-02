table 50110 TempRecalcMin2Sales
{
    Caption = 'TempRecalcMin2Sales';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Code[50])
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(2; "Item No"; Code[50])
        {
            Caption = 'Item No';
            DataClassification = ToBeClassified;
        }
        field(3; "Vendor No"; Code[50])
        {
            Caption = 'Vendor No';
            DataClassification = ToBeClassified;
        }
        field(4; "Reorder Point"; Decimal)
        {
            Caption = 'Reorder Point';
            DataClassification = ToBeClassified;
        }
        field(5; "Maximum Inventory"; Decimal)
        {
            Caption = 'Maximum Inventory';
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
