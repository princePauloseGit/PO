codeunit 50105 JobMinMaxCalculation
{
    trigger OnRun()
    var
        cu_ApplyMinCalc: Codeunit ApplyMinCalc;
        cu_ApplyMaxCalc: Codeunit ApplyMaxCalc;
        cu_ResultMinMaxCalc: Codeunit ResultMinMaxCalc;
        cu_updateMinMax: Codeunit UpdateMinMax;

        recResultMinMaxCal: Record ResultMinMaxCalc;
        stkCode, vendorVar, sortkey : Code[50];

    begin
        Clear(stkCode);
        Clear(vendorVar);
        Clear(sortkey);
        cu_ApplyMinCalc.ApplyMinCalculation(stkCode, vendorVar, sortkey);
        cu_ApplyMaxCalc.Run();
        cu_ResultMinMaxCalc.ProcessCal(stkCode, vendorVar, sortkey);

        // As per Phil Mail - Card Item PO Error - Min Error - Should Update Min Max in Job also
        recResultMinMaxCal.Reset();
        if recResultMinMaxCal.FindSet(true) then begin
            repeat
                cu_updateMinMax.updateMinMax(recResultMinMaxCal."Item No", recResultMinMaxCal."New Min", recResultMinMaxCal."New Max", recResultMinMaxCal."Current Min", recResultMinMaxCal."Current Max");
            until recResultMinMaxCal.Next() = 0;
        end;
        // cu_ApplyMinCalc.ApplyMinCalculation(stkCode, vendorVar, sortkey);
        // cu_ApplyMaxCalc.Run();
        // cu_ResultMinMaxCalc.ProcessCal(stkCode, vendorVar, sortkey);

    end;
}
