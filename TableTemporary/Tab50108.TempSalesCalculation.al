table 50108 TempSalesCalculation
{
    Caption = 'Temp SalesCalculation';
    DataClassification = ToBeClassified;
    //TableType = Temporary;

    fields
    {
        field(1; Id; Code[50])
        {
            Caption = 'Id';
            DataClassification = CustomerContent;
        }
        field(2; ItemNo; Code[30])
        {
            Caption = 'Item No';
            DataClassification = CustomerContent;
        }
        field(3; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = CustomerContent;
        }
        field(4; IgnoreTopBOTSalesQty; Integer)
        {
            Caption = 'Ignore Top BOT Sales Qty';
            DataClassification = CustomerContent;
        }
        field(5; DaysToUse; Integer)
        {
            Caption = 'Days To Use';
            DataClassification = CustomerContent;
        }
        field(6; SupplierOrderCycle; Integer)
        {
            Caption = 'Stock Holding Days';
            DataClassification = CustomerContent;
        }
        field(7; QueSystemCreatedAt; DateTime)
        {
            Caption = 'Query System Created At';
            DataClassification = CustomerContent;
        }
        field(8; VersionNo; Integer)
        {
            Caption = 'VesionNo';
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
