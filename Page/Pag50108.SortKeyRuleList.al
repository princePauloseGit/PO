page 50108 SortKeyRuleList
{
    ApplicationArea = All;
    Caption = 'Sort Key Rule';
    PageType = List;
    SourceTable = "Rules Matrix";
    UsageCategory = Lists;
    CardPageID = "Sort Key Rule";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(RULETYPE; Rec.RULETYPE)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PRIORITY; Rec.PRIORITY)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STK_SORT_KEY; Rec.STK_SORT_KEY)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STK_SUPPLIER1; Rec.STK_SUPPLIER1)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(IGNORE_TOP_BOT_SALES_QTY; Rec.IGNORE_TOP_BOT_SALES_QTY)
                {
                    Caption = 'Ignore Top Quantity';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DAYS_TO_USE; Rec.DAYS_TO_USE)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DAYS_TO_USE_PO_LEAD; Rec.DAYS_TO_USE_PO_LEAD)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SUPPLIER_ORDER_CYCLE; Rec.SUPPLIER_ORDER_CYCLE)
                {
                    Caption = 'No of Days Stock Held';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(MIN_ID; Rec.MIN_ID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UP)
            {
                Caption = 'Up';
                Promoted = true;
                PromotedCategory = Process;
                Image = MoveUp;
                ApplicationArea = All;
                trigger OnAction()
                var
                    tempRuleMatrix: Record "Rules Matrix";
                    recRuleMatrix: Record "Rules Matrix";
                begin
                    CurrPage.SetSelectionFilter(recRuleMatrix);
                    if recRuleMatrix.FindSet() then begin
                        repeat
                            cuSwapPriority.MovePriorityUp(recRuleMatrix, 2);
                        until recRuleMatrix.Next() = 0;
                    end;

                end;

            }

            action(Down)
            {
                Caption = 'Down';
                Promoted = true;
                PromotedCategory = Process;
                Image = MoveDown;
                ApplicationArea = All;
                trigger OnAction()
                var
                    tempRuleMatrix: Record "Rules Matrix";
                    recRuleMatrix: Record "Rules Matrix";
                begin
                    CurrPage.SetSelectionFilter(recRuleMatrix);
                    if recRuleMatrix.FindSet() then begin
                        repeat
                            cuSwapPriority.MovePriorityDown(recRuleMatrix, 2);

                        until recRuleMatrix.Next() = 0;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        recRuleMatrix: Record "Rules Matrix";
    begin
        Rec.SetFilter(Rec.RULETYPE, '2');
        Rec.SetCurrentKey(Rec.PRIORITY);
        Rec.SetAscending(Rec.PRIORITY, true);
    end;

    var
        cuSwapPriority: Codeunit SwapPriority;
}

