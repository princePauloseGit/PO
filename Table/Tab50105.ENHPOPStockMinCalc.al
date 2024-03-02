table 50105 ENHPOP_StockMinCalc
{
    Caption = 'ENH POP_StockMinCalc';
    DataClassification = ToBeClassified;

    fields
    {
        // field(1; Id; Integer)
        // {
        //     Caption = 'Id';
        //     DataClassification = CustomerContent;
        //     AutoIncrement = true;
        // }
        field(2; STK_PRIMARY; DateTime)
        {
            Caption = 'STK_PRIMARY';
            DataClassification = CustomerContent;
        }
        field(3; STKCODE; Code[25])
        {
            Caption = 'STKCODE';
            DataClassification = CustomerContent;
        }
        field(4; STKNAME; Code[80])
        {
            Caption = 'STKNAME';
            DataClassification = CustomerContent;
        }
        field(5; STK_SORT_KEY; Code[20])
        {
            Caption = 'STK_SORT_KEY';
            DataClassification = CustomerContent;
        }
        field(6; STK_SORT_KEY1; Code[50])
        {
            Caption = 'STK_SORT_KEY1';
            DataClassification = CustomerContent;
        }
        field(7; STK_MIN_QTY; Decimal)
        {
            Caption = 'STK_MIN_QTY';
            DataClassification = CustomerContent;
        }
        field(8; STK_MAX_QTY; Decimal)
        {
            Caption = 'STK_MAX_QTY';
            DataClassification = CustomerContent;
        }
        field(9; STK_PHYSICAL; Decimal)
        {
            Caption = 'STK_PHYSICAL';
            DataClassification = CustomerContent;
        }
        field(10; STK_BIN_NUMBER; Enum "Reordering Policy")
        {
            Caption = 'STK_BIN_NUMBER';
            DataClassification = CustomerContent;
        }
        field(11; STK_BACK_ORDER_QTY; Decimal)
        {
            Caption = 'STK_BACK_ORDER_QTY';
            DataClassification = CustomerContent;
        }
        field(12; STK_DO_NOT_USE; Boolean)
        {
            Caption = 'STK_DO_NOT_USE';
            DataClassification = CustomerContent;
        }
        field(13; ORDERS_IN_PERIOD; Decimal)
        {
            Caption = 'ORDERS_IN_PERIOD';
            DataClassification = CustomerContent;
        }
        field(14; SMALLEST_ORDER_VOLUME; Decimal)
        {
            Caption = 'SMALLEST_ORDER_VOLUME';
            DataClassification = CustomerContent;
        }
        field(15; SALES_PER_DAY_QNTY; Decimal)
        {
            Caption = 'SALES_PER_DAY_QNTY';
            DecimalPlaces = 4;
            DataClassification = CustomerContent;
        }
        field(16; MEDIAN_ORDER_VOLUME; Decimal)
        {
            Caption = 'MEDIAN_ORDER_VOLUME';
            DataClassification = CustomerContent;
        }
        field(17; OR_BACKORDER_QNTY; Decimal)
        {
            Caption = 'OR_BACKORDER_QNTY';
            DataClassification = CustomerContent;
        }
        field(18; MIN_CALC; Decimal)
        {
            DecimalPlaces = 4;
            Caption = 'MIN_CALC';
            DataClassification = CustomerContent;
        }
        field(19; MEAN_LEAD_TIME_DAYS; Decimal)
        {
            Caption = 'MEAN_LEAD_TIME_DAYS';
            DataClassification = CustomerContent;
        }
        field(20; MIN_RECALC; Decimal)
        {
            Caption = 'MIN_RECALC';
            DataClassification = CustomerContent;
        }
        field(21; RULE_PK; Integer)
        {
            Caption = 'RULE_PK';
            DataClassification = CustomerContent;
        }
        field(22; POREQD; Integer)
        {
            Caption = 'POREQD';
            DataClassification = CustomerContent;
        }
        field(23; DAYS_TO_NEXT_ORDER_CYCLE; Integer)
        {
            Caption = 'DAYS_TO_NEXT_ORDER_CYCLE';
            DataClassification = CustomerContent;
        }
        field(24; SUPPLIER_LEAD_TIME; Integer)
        {
            Caption = 'SUPPLIER_LEAD_TIME';
            DataClassification = CustomerContent;
        }
        field(25; SUPPLIER_ORDER_CYCLE; Integer)
        {
            Caption = 'SUPPLIER_ORDER_CYCLE';
            DataClassification = CustomerContent;
        }
        field(26; SUPPLIER_LAST_ORDER_DATE; DateTime)
        {
            Caption = 'SUPPLIER_LAST_ORDER_DATE';
            DataClassification = CustomerContent;
        }
        field(27; SUPPLIER_POFREQUENCY; Code[5])
        {
            Caption = 'SUPPLIER_POFREQUENCY';
            DataClassification = CustomerContent;
        }
        field(28; SUPPLIER1; Code[50])
        {
            Caption = 'SUPPLIER1';
            DataClassification = CustomerContent;
        }
        field(29; MAX_CALC; Decimal)
        {
            Caption = 'MAX_CALC';
            DataClassification = CustomerContent;
        }
        field(30; EXCLUDE; Integer)
        {
            Caption = 'EXCLUDE';
            DataClassification = CustomerContent;
        }
        field(31; EXCLUDEREASON; Code[200])
        {
            Caption = 'EXCLUDEREASON';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; STKCODE)
        {
            Clustered = true;
        }
    }
}
