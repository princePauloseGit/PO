table 50116 RoutinePO
{
    Caption = 'RoutinePO';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Id; Guid)
        {
            Caption = 'Id';
            DataClassification = ToBeClassified;
        }
        field(2; ItemNo; Code[30])
        {
            Caption = 'ItemNo';
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(4; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
        }
        field(5; Vendor; Code[30])
        {
            Caption = 'Vendor';
            DataClassification = ToBeClassified;
        }
        field(6; "PO Qty"; Decimal)
        {
            Caption = 'PO Qty';
            DataClassification = ToBeClassified;
        }
        field(7; Inventory; Decimal)
        {
            Caption = 'Inventory';
            DataClassification = ToBeClassified;
        }
        field(8; Reserved; Decimal)
        {
            Caption = 'Reserved';
            DataClassification = ToBeClassified;
        }
        field(9; BackOrders; Decimal)
        {
            Caption = 'BackOrders';
            DataClassification = ToBeClassified;
        }
        field(10; Order_In; Decimal)
        {
            Caption = 'Order_In';
            DataClassification = ToBeClassified;
        }
        field(11; PO_Qty_To_Max; Decimal)
        {
            Caption = 'PO_Qty_To_Max';
            DataClassification = ToBeClassified;
        }
        field(12; Supp_Min_Order_Level; Decimal)
        {
            Caption = 'Supp_Min_Order_Level';
            DataClassification = ToBeClassified;
        }
        field(13; Current_Min; Decimal)
        {
            Caption = 'Current_Min';
            DataClassification = ToBeClassified;
        }
        field(14; Current_Max; Decimal)
        {
            Caption = 'Current_Max';
            DataClassification = ToBeClassified;
        }
        field(15; Costprice; Decimal)
        {
            Caption = 'Costprice';
            DataClassification = ToBeClassified;
        }
        field(16; EOQ; Decimal)
        {
            Caption = 'EOQ';
            DataClassification = ToBeClassified;
        }
        field(17; Sales_Per_Day_Qnty; Decimal)
        {
            Caption = 'Sales_Per_Day_Qnty';
            DecimalPlaces = 4;
            DataClassification = ToBeClassified;
        }
        field(18; Supplier_Lead_Time; Integer)
        {
            Caption = 'Supplier_Lead_Time';
            DataClassification = ToBeClassified;
        }
        field(19; Narrative; Code[50])
        {
            Caption = 'Narrative';
            DataClassification = ToBeClassified;
        }
        field(20; POFrequency; Code[10])
        {
            Caption = 'POFrequency';
            DataClassification = ToBeClassified;
        }
        field(21; NextSupplierDate; Date)
        {
            Caption = 'NextSupplierDate';
            DataClassification = ToBeClassified;
        }
        field(22; Days_To_Next_Order; Integer)
        {
            Caption = 'Days_To_Next_Order';
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
