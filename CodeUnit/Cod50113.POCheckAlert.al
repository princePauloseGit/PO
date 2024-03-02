codeunit 50113 "PO Check Alert"
{
    var
        myInt: Integer;
        rec_ResultMinMaxCalc: Record ResultMinMaxCalc;
        recItem: Record Item;
        freePlusPO: Decimal;
        OutS: OutStream;
        InS: InStream;
        CU_EmailMessage: Codeunit "Email Message";
        CU_Email: Codeunit Email;
        MsgBody: Text[250];
        EmailList: List of [Text];
        CSVText: Text;
        Char1310: Char;
        Rec_TempBlob: Codeunit "Temp Blob";
        flagCheckCSV: Boolean;
        cu_ResultMinMax: Codeunit ResultMinMaxCalc;
        stkCode, vendorVar, sortkey : Code[30];
        recEmailInternalPO: Record "Email Internal PO";
        enum_EmailScenario: Enum "Email Scenario";


    trigger OnRun()

    begin
        CLEAR(Char1310);
        Char1310 := 10;
        CSVText := CSVText + '"Vendor No"' + ',' + '"Item No"' + ',' + '"Description"' + ',' + '"Free + PO"' + ',' + '"Lead Time Days"' + ',' + '"Sales Per Day"' + FORMAT(Char1310);
        flagCheckCSV := false;

        //cu_ResultMinMax.ProcessCal(stkCode, vendorVar, sortkey);

        rec_ResultMinMaxCalc.Reset();

        if rec_ResultMinMaxCalc.FindSet() then begin
            repeat
                recItem.SetRange("No.", rec_ResultMinMaxCalc."Item No");
                if recItem.FindFirst() then begin
                    recItem.CalcFields(Inventory);
                    recItem.CalcFields("Qty. on Purch. Order");
                    recItem.CalcFields("Qty. on Sales Order");
                    freePlusPO := (recItem.Inventory - recItem."Qty. on Sales Order") + recItem."Qty. on Purch. Order";
                    if (freePlusPO) < (rec_ResultMinMaxCalc."Meas Lead Time Days" * rec_ResultMinMaxCalc."Nos Sales Order Per Day") then begin
                        CreateCSV(FORMAT(rec_ResultMinMaxCalc.Vendor), FORMAT(rec_ResultMinMaxCalc."Item No"), FORMAT(rec_ResultMinMaxCalc.Description), FORMAT(freePlusPO), FORMAT(rec_ResultMinMaxCalc."Meas Lead Time Days"),
                                      FORMAT(rec_ResultMinMaxCalc."Nos Sales Order Per Day"));
                        flagCheckCSV := true;
                    end
                    else begin
                    end;
                end;
            until rec_ResultMinMaxCalc.Next() = 0;
        end;

        if flagCheckCSV = true then begin
            EmailtheCSV();
        end;
    end;

    local procedure CreateCSV(VendorNo: Text; ItemNo: Text; Description: Text; FreeplusPO: Text; LeadTimeDays: Text; SalesPerDay: Text)
    begin
        CSVText := CSVText + '"' + VendorNo + '","' + ItemNo + '","' + Description + '","' + FreeplusPO + '","' + LeadTimeDays + '","' + SalesPerDay + '"' + FORMAT(Char1310);
    end;

    local procedure EmailtheCSV()
    begin
        Rec_TempBlob.CREATEOUTSTREAM(OutS);
        OutS.WRITETEXT(CSVText);
        Rec_TempBlob.CREATEINSTREAM(InS);

        recEmailInternalPO.Reset();
        if recEmailInternalPO.FindSet() then begin
            repeat
                if recEmailInternalPO."Is Active" then begin
                    MsgBody := 'Hello, <br/><br/> Please find the attached Item file.<br/><br/> Kind Regards';
                    CU_EmailMessage.Create(recEmailInternalPO."Email Address", 'PO Check - free below next PO lead time', MsgBody, true);
                    CU_EmailMessage.AddAttachment('Items.csv', 'CSV', InS);
                    CU_Email.Send(CU_EmailMessage, enum_EmailScenario::"Purchase Order");
                end;
            until recEmailInternalPO.Next() = 0;
        end;
    end;
}
