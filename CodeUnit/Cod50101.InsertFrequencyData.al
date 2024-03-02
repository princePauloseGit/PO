/// <summary>
/// Initial Insertion of Frequency Data when extension is installed
/// </summary>
codeunit 50101 "InsertFrequencyData"
{
    Subtype = Install;
    trigger OnInstallAppPerCompany();
    var
        myAppInfo: ModuleInfo;
    begin
        // Get info about the currently executing module
        NavApp.GetCurrentModuleInfo(myAppInfo);

        // A 'DataVersion' of 0.0.0.0 indicates a 'fresh/new' install
        if myAppInfo.DataVersion = Version.Create(0, 0, 0, 0) then begin
            InsertFrequencyData();
            InsertEntryDateForProduction();
        end
        else begin
            InsertFrequencyData();
            InsertEntryDateForProduction();
        end;

    end;

    procedure InsertFrequencyData()
    var
        rec_ENHPOPPOFrequency: Record ENHPOP_POFrequency;
    begin
        if rec_ENHPOPPOFrequency.Count = 0 then begin
            rec_ENHPOPPOFrequency.Init();
            rec_ENHPOPPOFrequency.Frequency := 'D';
            rec_ENHPOPPOFrequency.Description := 'Daily';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'W1';
            rec_ENHPOPPOFrequency.Description := 'Weekly Order Monday';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'W2';
            rec_ENHPOPPOFrequency.Description := 'Weekly Order Tuesday';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'W3';
            rec_ENHPOPPOFrequency.Description := 'Weekly Order Wednesday';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'W4';
            rec_ENHPOPPOFrequency.Description := 'Weekly Order Thursday';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'W5';
            rec_ENHPOPPOFrequency.Description := 'Weekly Order Friday';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M1';
            rec_ENHPOPPOFrequency.Description := 'First working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M2';
            rec_ENHPOPPOFrequency.Description := 'Second working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M3';
            rec_ENHPOPPOFrequency.Description := 'Third working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M4';
            rec_ENHPOPPOFrequency.Description := 'Fourth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M5';
            rec_ENHPOPPOFrequency.Description := 'Fifth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M6';
            rec_ENHPOPPOFrequency.Description := 'Sixth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M7';
            rec_ENHPOPPOFrequency.Description := 'Seventh working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M8';
            rec_ENHPOPPOFrequency.Description := 'Eighth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M9';
            rec_ENHPOPPOFrequency.Description := 'Nineth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M10';
            rec_ENHPOPPOFrequency.Description := 'Tenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M11';
            rec_ENHPOPPOFrequency.Description := 'Eleventh working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M12';
            rec_ENHPOPPOFrequency.Description := 'Twelveth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M13';
            rec_ENHPOPPOFrequency.Description := 'Thirteenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M14';
            rec_ENHPOPPOFrequency.Description := 'Fourteenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M15';
            rec_ENHPOPPOFrequency.Description := 'Fifteenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M16';
            rec_ENHPOPPOFrequency.Description := 'Sixteenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M17';
            rec_ENHPOPPOFrequency.Description := 'Seventeenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M18';
            rec_ENHPOPPOFrequency.Description := 'Eighteenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M19';
            rec_ENHPOPPOFrequency.Description := 'Nineteenth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M20';
            rec_ENHPOPPOFrequency.Description := 'Twentieth working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M21';
            rec_ENHPOPPOFrequency.Description := 'Twenty-first working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'M22';
            rec_ENHPOPPOFrequency.Description := 'Twenty-Second working Day of the Month';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'NA';
            rec_ENHPOPPOFrequency.Description := 'DO NOT PROCESS';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y1';
            rec_ENHPOPPOFrequency.Description := 'January';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y2';
            rec_ENHPOPPOFrequency.Description := 'February';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y3';
            rec_ENHPOPPOFrequency.Description := 'March';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y4';
            rec_ENHPOPPOFrequency.Description := 'April';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y5';
            rec_ENHPOPPOFrequency.Description := 'May';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y6';
            rec_ENHPOPPOFrequency.Description := 'June';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y7';
            rec_ENHPOPPOFrequency.Description := 'July';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y8';
            rec_ENHPOPPOFrequency.Description := 'August';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y9';
            rec_ENHPOPPOFrequency.Description := 'September';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y10';
            rec_ENHPOPPOFrequency.Description := 'October';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y11';
            rec_ENHPOPPOFrequency.Description := 'November';
            rec_ENHPOPPOFrequency.Insert();
            rec_ENHPOPPOFrequency.Frequency := 'Y12';
            rec_ENHPOPPOFrequency.Description := 'December';
            rec_ENHPOPPOFrequency.Insert();
        end;
    end;

    procedure InsertEntryDateForProduction()
    var
        recEntryDateProduction: Record EntryDateProduction;
    begin
        if recEntryDateProduction.Count = 0 then begin
            recEntryDateProduction.Init();
            recEntryDateProduction.StartingDate := Today;
            recEntryDateProduction.Insert(true);
        end;

    end;
}
