page 50104 StockCodeRuleList
{
    ApplicationArea = All;
    Caption = 'Stock Code Rule';
    PageType = List;
    SourceTable = "Rules Matrix";
    UsageCategory = Lists;
    CardPageId = "Stock Code Rule";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(RULETYPE; Rec.RULETYPE)
                {
                    Caption = 'Rule Type';
                    ApplicationArea = All;
                    Editable = false;

                }
                field(PRIORITY; Rec.PRIORITY)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STKCODE; Rec.STKCODE)
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    Editable = false;
                }
                field(STKNAME; Rec.STKNAME)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STK_SUPPLIER1; Rec.STK_SUPPLIER1)
                {
                    ApplicationArea = All;
                    TableRelation = Item."Vendor No.";
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
                    currPrioriry: Integer;

                begin
                    CurrPage.SetSelectionFilter(recRuleMatrix);
                    if recRuleMatrix.FindSet() then begin
                        repeat
                            //     tempRuleMatrix.SetView(StrSubstNo('sorting (PRIORITY) order(descending) where (PRIORITY = filter (< %1), "RULETYPE" = filter(= %2))', recRuleMatrix.PRIORITY, '1'));
                            //     if tempRuleMatrix.FindFirst() then begin
                            //         currPrioriry := recRuleMatrix.PRIORITY;
                            //         recRuleMatrix.PRIORITY := tempRuleMatrix.PRIORITY;
                            //         tempRuleMatrix.PRIORITY := currPrioriry;
                            //         recRuleMatrix.Modify();
                            //         tempRuleMatrix.Modify();
                            //     end;
                            cuSwapPriority.MovePriorityUp(recRuleMatrix, 1);
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
                    currPrioriry: Integer;

                begin
                    CurrPage.SetSelectionFilter(recRuleMatrix);
                    if recRuleMatrix.FindSet() then begin
                        repeat
                            // tempRuleMatrix.SetView(StrSubstNo('sorting (PRIORITY) order(ascending ) where (PRIORITY = filter (> %1), "RULETYPE" = filter(= %2))', recRuleMatrix.PRIORITY, '1'));
                            // if tempRuleMatrix.FindFirst() then begin
                            //     currPrioriry := recRuleMatrix.PRIORITY;
                            //     recRuleMatrix.PRIORITY := tempRuleMatrix.PRIORITY;
                            //     tempRuleMatrix.PRIORITY := currPrioriry;
                            //     recRuleMatrix.Modify();
                            //     tempRuleMatrix.Modify();
                            // end;
                            cuSwapPriority.MovePriorityDown(recRuleMatrix, 1);

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
        Rec.SetFilter(Rec.RULETYPE, '1');
        Rec.SetCurrentKey(Rec.PRIORITY);
        Rec.SetAscending(Rec.PRIORITY, true);
    end;

    var
        cuSwapPriority: Codeunit SwapPriority;
}
