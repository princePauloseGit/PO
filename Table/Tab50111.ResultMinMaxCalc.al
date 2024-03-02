table 50111 ResultMinMaxCalc
{
    Caption = 'ResultMinMaxCalc';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No"; Code[50])
        {
            Caption = 'Item No';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Item Category Code"; Code[50])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
        }
        field(4; Vendor; Code[50])
        {
            Caption = 'Vendor';
            DataClassification = ToBeClassified;
        }
        field(5; "Current Min"; Decimal)
        {
            Caption = 'Current Min';
            DataClassification = ToBeClassified;
        }
        field(6; "New Min"; Decimal)
        {
            Caption = 'New Min';
            DataClassification = ToBeClassified;
        }
        field(7; "Current Max"; Decimal)
        {
            Caption = 'Current Max';
            DataClassification = ToBeClassified;
        }
        field(8; "New Max"; Decimal)
        {
            Caption = 'New Max';
            DataClassification = ToBeClassified;
        }
        field(9; "New Po Qnty"; Decimal)
        {
            Caption = 'New Po Qnty';
            DataClassification = ToBeClassified;
        }
        field(10; "Min Source"; Code[50])
        {
            Caption = 'Min Source';
            DataClassification = ToBeClassified;
        }
        field(11; "Nos Order Days"; Integer)
        {
            Caption = 'Nos Order Days';
            DataClassification = ToBeClassified;
        }
        field(12; "Nos Order Excluded"; Integer)
        {
            Caption = 'Nos Order Excluded';
            DataClassification = ToBeClassified;
        }
        field(13; "Nos Sales Order In Prd"; Integer)
        {
            Caption = 'Nos Sales Order In Prd';
            DataClassification = ToBeClassified;
        }
        field(14; "Nos Sales Order Per Day"; Decimal)
        {
            Caption = 'Nos Sales Order Per Day';
            DataClassification = ToBeClassified;
        }
        field(15; "Supplier Lead Time"; Integer)
        {
            Caption = 'Supplier Lead Time';
            DataClassification = ToBeClassified;
        }
        field(16; "Supplier Order Cycle"; Integer)
        {
            Caption = 'Stock Holding Days';
            DataClassification = ToBeClassified;
        }
        field(17; "Meas Lead Time Days"; Decimal)
        {
            Caption = 'Mean Lead Time Days';
            DataClassification = ToBeClassified;
        }
        field(18; "Days To Next Order Cycle"; Integer)
        {
            Caption = 'Days To Next Order Cycle';
            DataClassification = ToBeClassified;
        }
        field(19; Excluded; Boolean)
        {
            Caption = 'Excluded';
            DataClassification = ToBeClassified;
        }
        field(20; "Excluded Reason"; Text[50])
        {
            Caption = 'Excluded Reason';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Item No")
        {
            Clustered = true;
        }
    }
}
