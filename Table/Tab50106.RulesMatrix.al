table 50106 "Rules Matrix"
{
    Caption = 'Rules Matrix';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; MIN_ID; Integer)
        {
            Caption = 'Min ID';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; RULETYPE; Option)
        {
            Caption = 'Rule Type';
            OptionMembers = All,Stock,Sort;
            DataClassification = CustomerContent;
        }
        field(3; PRIORITY; Integer)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(4; STKCODE; Code[25])
        {
            Caption = 'Stock Code';
            DataClassification = CustomerContent;
        }
        field(5; STK_SORT_KEY; Code[20])
        {
            Caption = 'Sort Key';
            DataClassification = CustomerContent;
        }
        field(6; STK_SORT_KEY1; Code[20])
        {
            Caption = 'Search Ref';
            DataClassification = CustomerContent;
        }
        field(7; STK_SUPPLIER1; Code[15])
        {
            Caption = 'Supplier';
            DataClassification = CustomerContent;
        }
        field(8; IGNORE_TOP_BOT_SALES_QTY; Integer)
        {
            Caption = 'Ignore Quantity';
            DataClassification = CustomerContent;
        }
        field(9; DAYS_TO_USE; Integer)
        {
            Caption = 'Days to Use';
            DataClassification = CustomerContent;
        }
        field(10; DAYS_TO_USE_PO_LEAD; Integer)
        {
            Caption = 'Days to Use PO Lead';
            DataClassification = CustomerContent;
        }
        field(11; STKNAME; Code[50])
        {
            Caption = 'Stock Name';
            DataClassification = CustomerContent;
        }
        field(12; STK_USRNUM2; Decimal)
        {
            Caption = 'Stock Usrnum2';
            DataClassification = CustomerContent;
        }
        field(13; SUPPLIER_LAST_ORDER_DATE; DateTime)
        {
            Caption = 'Supplier Last Order Date';
            DataClassification = CustomerContent;
        }
        field(14; SUPPLIER_ORDER_CYCLE; Integer)
        {
            Caption = 'Supplier Days';
            DataClassification = CustomerContent;
        }
        field(15; OverrideLeadTime; Integer)
        {
            Caption = 'Override Lead Time';
            DataClassification = CustomerContent;
        }
        field(16; OverrideLeadTimevalue; Integer)
        {
            Caption = 'Override Lead Time value';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; MIN_ID)
        {
            Clustered = true;
        }
    }

}
