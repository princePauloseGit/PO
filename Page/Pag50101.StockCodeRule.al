page 50101 "Stock Code Rule"
{
    Caption = 'Stock Code Rule';
    PageType = Card;
    SourceTable = "Rules Matrix";
    //  ApplicationArea = all;
    UsageCategory = Administration;
    RefreshOnActivate = true;

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
                    NotBlank = true;
                }
                field(STKCODE; Rec.STKCODE)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    ShowMandatory = true;
                    NotBlank = true;
                    trigger OnValidate()
                    var
                        itemRec: Record Item;
                    begin
                        if itemRec.Get(Rec.STKCODE)
                        then
                            Rec.STKNAME := itemRec.Description;

                    end;
                }
                field(STKNAME; Rec.STKNAME)
                {
                    ApplicationArea = All;
                    Editable = false;
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
                    Caption = 'Number of orders to ignore(top) ';
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
                field(OverrideLeadTime; Rec.OverrideLeadTime)
                {
                    Caption = 'Override Lead Time ';
                    ApplicationArea = All;
                }
                field(OverrideLeadTimevalue; Rec.OverrideLeadTimevalue)
                {
                    Caption = 'Override Lead Time Value';
                    ApplicationArea = All;
                }
                field(STK_SORT_KEY; Rec.STK_SORT_KEY)
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
        Rec.RULETYPE := 1;
        Rec.STK_SORT_KEY := '*';
        Rec.STK_SORT_KEY1 := '*';
    end;
}
