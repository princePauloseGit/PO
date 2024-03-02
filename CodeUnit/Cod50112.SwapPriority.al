codeunit 50112 SwapPriority
{

    procedure MovePriorityUp(recRuleMatrix: Record "Rules Matrix"; ruletype: Option)
    var
        tempRuleMatrix: Record "Rules Matrix";
        currPrioriry: Integer;

    begin
        tempRuleMatrix.SetView(StrSubstNo('sorting (PRIORITY) order(descending) where (PRIORITY = filter (< %1), "RULETYPE" = filter(= %2))', recRuleMatrix.PRIORITY, ruletype));
        if tempRuleMatrix.FindFirst() then begin
            currPrioriry := recRuleMatrix.PRIORITY;
            recRuleMatrix.PRIORITY := tempRuleMatrix.PRIORITY;
            tempRuleMatrix.PRIORITY := currPrioriry;
            recRuleMatrix.Modify();
            tempRuleMatrix.Modify();
        end;
    end;

    procedure MovePriorityDown(recRuleMatrix: Record "Rules Matrix"; ruletype: Option)
    var
        tempRuleMatrix: Record "Rules Matrix";
        currPrioriry: Integer;

    begin
        tempRuleMatrix.SetView(StrSubstNo('sorting (PRIORITY) order(ascending ) where (PRIORITY = filter (> %1), "RULETYPE" = filter(= %2))', recRuleMatrix.PRIORITY, ruletype));
        if tempRuleMatrix.FindFirst() then begin
            currPrioriry := recRuleMatrix.PRIORITY;
            recRuleMatrix.PRIORITY := tempRuleMatrix.PRIORITY;
            tempRuleMatrix.PRIORITY := currPrioriry;
            recRuleMatrix.Modify();
            tempRuleMatrix.Modify();
        end;
    end;
}