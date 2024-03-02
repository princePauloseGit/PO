codeunit 50108 JobRoutinePO
{
    trigger OnRun()
    var
        cu_GeneratePO: Codeunit GeneratePO;
        cu_POCheckAlert: Codeunit "PO Check Alert";
        stkCode, vendorVar, sortkey : Code[30];
        PObackOrders, overridePO, zeroValuePO, backOrders : boolean;
    begin
        PObackOrders := true;
        overridePO := false;
        backOrders := false;
        zeroValuePO := false;
        cu_GeneratePO.GetPOData(stkCode, vendorVar, sortkey, PObackOrders, overridePO, zeroValuePO, backOrders);
        AutoGeneratePO();
        cu_POCheckAlert.Run();
    end;

    local procedure AutoGeneratePO()
    var
        recRoutinePO: Record RoutinePO;
        varVendor: Code[30];
        varDocumentNo: Code[20];
        linecnt: Integer;
        listPurchaseOrder: list of [Code[30]];
        element: Integer;

    begin
        recRoutinePO.Reset();
        recRoutinePO.SetCurrentKey(Vendor);
        recRoutinePO.SetAscending(Vendor, true);
        recRoutinePO.SetFilter("PO Qty", '<>%1', 0.00);

        Clear(listPurchaseOrder);

        if recRoutinePO.FindSet() then begin
            repeat
                if recRoutinePO.Vendor = varVendor then begin
                    linecnt := linecnt + 10000;
                    CreatePurchaseLine(linecnt, varDocumentNo, recRoutinePO);
                end
                else begin
                    varVendor := recRoutinePO.Vendor;
                    varDocumentNo := CreatePurchaseHeader(recRoutinePO);
                    linecnt := 10000;
                    CreatePurchaseLine(linecnt, varDocumentNo, recRoutinePO);
                    listPurchaseOrder.Add(varDocumentNo);
                end;
            until recRoutinePO.Next() = 0;

        end;

        //Raising purchase order which are generated.
        FOR element := 1 TO listPurchaseOrder.Count do begin
            RaisedPO(listPurchaseOrder.Get(element));
        end;

    end;

    local procedure CreatePurchaseLine(var linecnt: Integer; var documentNo: code[20]; var recRoutinePO: Record RoutinePO)
    var
        recPurchaseLine: Record "Purchase Line";
        recItem: Record Item;
        excludeDiscount: Boolean;
        recVendor: Record Vendor;
        discountPercentage, discountedAmount, discountDivided, discountMinus, ItemCost : Decimal;
    begin
        excludeDiscount := false;
        discountPercentage := 0;
        discountDivided := 0;
        discountMinus := 0;

        recPurchaseLine.Init();
        linecnt := linecnt;
        recPurchaseLine."Line No." := linecnt;
        recPurchaseLine."Document No." := documentNo;
        recPurchaseLine.Type := "Purchase Line Type"::Item;
        recPurchaseLine."Document Type" := "Purchase Document Type"::Order;
        recPurchaseLine."No." := recRoutinePO.ItemNo;
        recPurchaseLine.Validate("No.");
        recPurchaseLine.UpdateAmounts();
        recPurchaseLine.Insert(true);


        recPurchaseLine.Reset();
        recPurchaseLine.SetRange("Document Type", "Purchase Document Type"::Order);
        recPurchaseLine.SetRange(Type, "Purchase Line Type"::Item);
        recPurchaseLine.SetRange("Line No.", linecnt);
        recPurchaseLine.SetRange("Document No.", documentNo);
        recPurchaseLine.SetRange("No.", recRoutinePO.ItemNo);

        if recPurchaseLine.FindFirst() then begin
            recPurchaseLine.Quantity := recRoutinePO."PO Qty";
            recPurchaseLine.ClearFieldCausedPriceCalculation();
            recPurchaseLine.PlanPriceCalcByField(15);
            recPurchaseLine.Validate(Quantity);
            recPurchaseLine.Modify(true);
        end;

        recItem.reset();
        recItem.SetRange("No.", recRoutinePO.ItemNo);
        if recItem.FindFirst() then begin
            if recItem."Exclude From Discount" = true then begin
                excludeDiscount := true;
            end else begin
                excludeDiscount := false;
            end;
        end;

        recVendor.Reset();
        recVendor.SetRange("No.", recRoutinePO.Vendor);
        if recVendor.FindFirst() then begin
            if (recVendor."Vendor Discount" > 0) then begin
                discountPercentage := recVendor."Vendor Discount";
                excludeDiscount := false;
            end else begin
                excludeDiscount := true;
            end;
        end;

        if excludeDiscount = false then begin

            recPurchaseLine.Reset();
            recPurchaseLine.SetRange("Document Type", "Purchase Document Type"::Order);
            recPurchaseLine.SetRange(Type, "Purchase Line Type"::Item);
            recPurchaseLine.SetRange("Document No.", documentNo);
            recPurchaseLine.SetRange("No.", recRoutinePO.ItemNo);

            if recPurchaseLine.FindFirst() then begin
                discountDivided := discountPercentage / 100;
                discountMinus := 1 - discountDivided;

                discountedAmount := ItemCost / discountMinus;
                recPurchaseLine."Direct Unit Cost" := discountedAmount;
                recPurchaseLine."Line Discount %" := discountPercentage;
                recPurchaseLine.Modify(true);
            end;
        end;
    end;

    local procedure CreatePurchaseHeader(var recRoutinePO: Record RoutinePO) varPurchaseHeaderNo: Code[30]
    var
        recPurchHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
        pay: code[30];
    begin
        recPurchHeader.Init();
        recPurchHeader.InitRecord;
        recPurchHeader."Buy-from Vendor No." := recRoutinePO.Vendor;
        recPurchHeader.Validate("Buy-from Vendor No.");
        recPurchHeader."Document Type" := "Purchase Document Type"::Order;
        recPurchHeader.Insert(true);

        recPurchHeader.Validate("Pay-to Vendor No.");
        recPurchHeader."Document Date" := Today;
        recPurchHeader."Order Date" := Today;
        recPurchHeader.Modify(true);
        varPurchaseHeaderNo := recPurchHeader."No.";

    end;

    procedure RaisedPO(PurchaseHeader: Code[30])
    var
        recPurchaseHeader: Record "Purchase Header";
        refPurchaseHeader: Record "Purchase Header";
        BodyReportLayoutSelection: Record "Report Layout Selection";
        PurchaseReportLayoutSelection: Record "Report Layout Selection";
        recReportSelection: Record "Report Selections";
        recEmailInternalPO: Record "Email Internal PO";
        recVendor: Record Vendor;
        ReleasePurchDoc: Codeunit "Release Purchase Document";
        tmpBlob: Codeunit "Temp Blob";
        cu_CommonHelper: Codeunit CommonHelper;
        cnv64: Codeunit "Base64 Convert";
        InStr: InStream;
        OutStr: OutStream;
        txtB64: Text;
        format: ReportFormat;
        email: Codeunit Email;
        emailMsg: Codeunit "Email Message";
        recRef: RecordRef;
        enum1: Enum "Email Recipient Type";
        enum_EmailScenario: Enum "Email Scenario";

        ToRecipients, EmailBody, EmailSubject : Text;

    begin
        clear(ToRecipients);
        recPurchaseHeader.Reset();
        recPurchaseHeader.SetRange("No.", PurchaseHeader);

        if recPurchaseHeader.FindFirst() then begin
            recVendor.Reset();
            recVendor.SetRange("No.", recPurchaseHeader."Buy-from Vendor No.");

            if recVendor.FindFirst() then begin
                Clear(ToRecipients);
                recPurchaseHeader.CalcFields(Amount);
                if recPurchaseHeader.Amount > recVendor.MinimumOrderAmount then begin

                    //Realeased the PO
                    ReleasePurchDoc.PerformManualRelease(recPurchaseHeader);
                    ClearTotalPurchaseHeader();

                    recReportSelection.Reset();
                    recReportSelection.SetFilter(Usage, Format("Report Selection Usage"::"P.Order"));
                    if recReportSelection.FindFirst() then begin
                        //Attaching Pdf
                        Clear(OutStr);
                        tmpBlob.CreateOutStream(OutStr);
                        refPurchaseHeader.SetRange("No.", recPurchaseHeader."No.");
                        recRef.GetTable(refPurchaseHeader);
                        PurchaseReportLayoutSelection.Reset();
                        PurchaseReportLayoutSelection.SetRange("Report ID", 1322);
                        if PurchaseReportLayoutSelection.FindFirst() then begin
                            PurchaseReportLayoutSelection.SetTempLayoutSelected(PurchaseReportLayoutSelection."Custom Report Layout Code");
                            if Report.SaveAs(PurchaseReportLayoutSelection."Report ID", '', format::Pdf, OutStr, recRef) then begin
                                //if Report.SaveAs(recReportSelection."Report ID", '', format::Pdf, OutStr, recRef) then begin
                                tmpBlob.CreateInStream(InStr);
                                txtB64 := cnv64.ToBase64(InStr, true);
                                EmailSubject := 'Purchase Order';
                            end;

                            //Attaching Body
                            Clear(OutStr);
                            Clear(tmpBlob);
                            Clear(InStr);
                            tmpBlob.CreateOutStream(OutStr);
                            if recReportSelection."Email Body Layout Code" <> '' then begin
                                BodyReportLayoutSelection.SetTempLayoutSelected(recReportSelection."Email Body Layout Code");
                                if Report.SaveAs(recReportSelection."Report ID", '', ReportFormat::Html, OutStr, RecRef) then begin
                                    tmpBlob.CreateInStream(InStr);
                                    InStr.ReadText(EmailBody);
                                end;
                            end;
                            ToRecipients := recVendor."autoporecipient email address".Trim();

                            //If a vendor recipient email is not there then email to purchasing@jesuk.com
                            if ToRecipients = '' then begin
                                recEmailInternalPO.Reset();
                                if recEmailInternalPO.FindSet() then begin
                                    repeat
                                        if recEmailInternalPO."Is Active" then begin
                                            emailMsg.Create(recEmailInternalPO."Email Address", EmailSubject, EmailBody, true);
                                            // emailMsg.AddRecipient(enum1::Cc, 'purchasing@jesuk.co.uk');
                                            emailMsg.AddRecipient(enum1::Cc, cu_CommonHelper.GetCCEmailAddress());
                                            emailMsg.AddAttachment('PurchaseOrder' + recPurchaseHeader."No." + '.pdf', 'application/pdf', txtB64);
                                            email.Send(emailMsg, enum_EmailScenario::"Purchase Order");
                                        end;
                                    until recEmailInternalPO.Next() = 0;
                                end;
                            end
                            else begin
                                emailMsg.Create(ToRecipients, EmailSubject, EmailBody, true);
                                //emailMsg.AddRecipient(enum1::Cc, 'purchasing@jesuk.co.uk');
                                emailMsg.AddRecipient(enum1::Cc, cu_CommonHelper.GetCCEmailAddress());
                                emailMsg.AddAttachment('PurchaseOrder' + recPurchaseHeader."No." + '.pdf', 'application/pdf', txtB64);
                                email.Send(emailMsg, enum_EmailScenario::"Purchase Order");
                            end;
                        end;
                    end;
                end

                //Send Mail internal
                else begin
                    recReportSelection.Reset();
                    recReportSelection.SetFilter(Usage, Format("Report Selection Usage"::"P.Order"));
                    if recReportSelection.FindFirst() then begin
                        //Attaching Pdf
                        Clear(OutStr);
                        Clear(tmpBlob);
                        Clear(InStr);
                        tmpBlob.CreateOutStream(OutStr);
                        refPurchaseHeader.SetRange("No.", recPurchaseHeader."No.");
                        recRef.GetTable(refPurchaseHeader);
                        PurchaseReportLayoutSelection.Reset();
                        PurchaseReportLayoutSelection.SetRange("Report ID", 1322);
                        if PurchaseReportLayoutSelection.FindFirst() then begin
                            PurchaseReportLayoutSelection.SetTempLayoutSelected(PurchaseReportLayoutSelection."Custom Report Layout Code");
                            if Report.SaveAs(PurchaseReportLayoutSelection."Report ID", '', format::Pdf, OutStr, recRef) then begin
                                tmpBlob.CreateInStream(InStr);
                                txtB64 := cnv64.ToBase64(InStr, true);
                                EmailSubject := 'PO automatically raised but on hold';

                                Clear(OutStr);
                                Clear(tmpBlob);
                                Clear(InStr);
                                tmpBlob.CreateOutStream(OutStr);
                                if recReportSelection."Email Body Layout Code" <> '' then begin
                                    BodyReportLayoutSelection.SetTempLayoutSelected(recReportSelection."Email Body Layout Code");
                                    if Report.SaveAs(recReportSelection."Report ID", '', ReportFormat::Html, OutStr, RecRef) then begin
                                        tmpBlob.CreateInStream(InStr);
                                        InStr.ReadText(EmailBody);
                                    end;
                                end;

                                recEmailInternalPO.Reset();
                                if recEmailInternalPO.FindSet() then begin
                                    repeat
                                        if recEmailInternalPO."Is Active" then begin
                                            emailMsg.Create(recEmailInternalPO."Email Address", EmailSubject, EmailBody, true);
                                            // emailMsg.AddRecipient(enum1::Cc, 'purchasing@jesuk.co.uk');
                                            emailMsg.AddRecipient(enum1::Cc, cu_CommonHelper.GetCCEmailAddress());
                                            emailMsg.AddAttachment('PurchaseOrder' + recPurchaseHeader."No." + '.pdf', 'application/pdf', txtB64);
                                            email.Send(emailMsg, enum_EmailScenario::"Purchase Order");
                                        end;
                                    until recEmailInternalPO.Next() = 0;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;

    procedure ClearTotalPurchaseHeader();
    var
        TotalPurchaseHeader: Record "Purchase Header";
    begin
        Clear(TotalPurchaseHeader);
    end;
}
