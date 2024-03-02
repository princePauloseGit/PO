page 50105 "Sort Key Rule"
{
    Caption = 'Sort Key Rule';
    PageType = XmlPort;
    //  ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Rules Matrix";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Criteria';
                field(RULETYPE; Rec.RULETYPE)
                {
                    Caption = 'Rule Type';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PRIORITY; Rec.PRIORITY)
                {
                    Caption = 'Priority';
                    ApplicationArea = All;
                }
                field(STK_SORT_KEY; Rec.STK_SORT_KEY)
                {
                    TableRelation = "Item Category".Code;
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field(STK_SUPPLIER1; Rec.STK_SUPPLIER1)
                {
                    ApplicationArea = All;
                    TableRelation = Vendor."No.";
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field(SUPPLIER_ORDER_CYCLE; Rec.SUPPLIER_ORDER_CYCLE)
                {
                    Caption = 'No of Days Stock Held';
                    ApplicationArea = All;
                }
                field(IGNORE_TOP_BOT_SALES_QTY; Rec.IGNORE_TOP_BOT_SALES_QTY)
                {
                    Caption = 'Number of orders to ignore(top)';
                    ApplicationArea = All;
                }
            }
            group(Result)
            {
                Caption = 'Result';
                field(DAYS_TO_USE; Rec.DAYS_TO_USE)
                {
                    Caption = 'Days to calculate sales over';
                    ApplicationArea = All;
                }
                field(DAYS_TO_USE_PO_LEAD; Rec.DAYS_TO_USE_PO_LEAD)
                {
                    Caption = 'Days to calculate purchase order lead times over';
                    ApplicationArea = All;
                }
                field(STKCODE; Rec.STKCODE)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STK_SORT_KEY1; Rec.STK_SORT_KEY1)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.RULETYPE := 2;
        Rec.STKCODE := '*';
        Rec.STK_SORT_KEY1 := '*';
    end;
}
