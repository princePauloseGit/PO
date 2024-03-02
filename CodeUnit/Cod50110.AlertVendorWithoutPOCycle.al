codeunit 50110 AlertVendorWithoutPOCycle
{
    trigger OnRun()
    var
        recVendorOrderSchedules: Record VendorOrderSchedules;
        recVendor: Record Vendor;
        recItem: Record Item;
        recEmailInternalPO: Record "Email Internal PO";
        flag: Integer;
        email: Codeunit Email;
        emailMsg: Codeunit "Email Message";
        ToRecipients, EmailBody, EmailSubject : Text;
        enum_EmailScenario: Enum "Email Scenario";
        cu_CommonHelper: Codeunit CommonHelper;
    begin

        recVendor.Reset();
        if recVendor.FindSet() then begin
            repeat
                Clear(ToRecipients);
                //As per phil - Vendor Without PO Cycle
                recItem.Reset();
                recItem.SetRange("Vendor No.", recVendor."No.");
                if recItem.FindFirst() then begin
                    flag := 1;
                    recVendorOrderSchedules.SetRange(Vendor, recVendor."No.");
                    if recVendorOrderSchedules.FindSet() then begin
                        repeat
                            if recVendorOrderSchedules.Cycle <> '' then begin
                                flag := 0;
                                break;
                            end
                            else begin
                                flag := 1;
                            end;
                        until recVendorOrderSchedules.Next() = 0;
                    end;
                    if flag = 1 then begin
                        EmailBody := 'Dear <b>' + recVendor.Name + '</b>,' + '<br/><br/> Please add Cycle for vendor <b> ' + recVendor."No."
                        + '</b>.<br/> <br/> Kind Regards';
                        EmailSubject := 'Vendor without PO cycle';
                        ToRecipients := recVendor."autoporecipient email address".Trim();

                        //If a vendor recipient email is not there then email to purchasing@jesuk.com
                        if ToRecipients = '' then begin
                            // ToRecipients := 'purchasing@jesuk.co.uk';
                            ToRecipients := cu_CommonHelper.GetCCEmailAddress();
                        end;
                        emailMsg.Create(ToRecipients, EmailSubject, EmailBody, true);
                        email.Send(emailMsg, enum_EmailScenario::"Purchase Order");
                    end;
                end;
            until recvendor.next() = 0;
        end;

    end;

}
