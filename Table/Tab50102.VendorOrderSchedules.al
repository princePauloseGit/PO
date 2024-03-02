table 50102 VendorOrderSchedules
{
    Caption = 'Vendor Order Schedules';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; VendorCycleId; Integer)
        {
            Caption = 'VendorCycleId';
            AutoIncrement = True;
            DataClassification = CustomerContent;
        }
        field(2; Vendor; Code[30])
        {
            Caption = 'Vendor';
            DataClassification = CustomerContent;
        }
        field(3; VendorName; Code[100])
        {
            Caption = 'Vendor Name';
            DataClassification = CustomerContent;
        }
        field(4; Cycle; Code[5])
        {
            Caption = 'Cycle';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; VendorCycleId)
        {
            Clustered = true;
        }
    }
}
