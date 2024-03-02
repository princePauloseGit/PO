codeunit 50114 "SORequirementNoStock"
{
    trigger OnRun()
    begin
        CLEAR(Char1310);
        Char1310 := 10;
        CSVText := CSVText + '"Type"' + ',' + '"Vendor No"' + ',' + '"Value of Stock required"' + ',' + '"Minimum Order Amount"' + FORMAT(Char1310);
        SumRequiredByvendor();
        if flagEmailCSV then
            EmailtheCSV();
    end;


    local procedure SumRequiredByvendor()
    begin
        flagEmailCSV := false;
        recItem.Reset();
        recItem.SetFilter("Vendor No.", '<>%1', '');
        recItem.SetCurrentKey("Vendor No.");
        recItem.SetAscending("Vendor No.", true);

        if recItem.FindSet() then begin
            repeat

                recItem.CalcFields(Inventory);
                recItem.CalcFields("Qty. on Purch. Order");
                recItem.CalcFields("Qty. on Sales Order");
                recItem.CalcFields("Reserved Qty. on Sales Orders");
                stockBackOrderQty := recItem."Qty. on Sales Order" - recItem."Reserved Qty. on Sales Orders";

                if (recItem.Inventory - recItem."Reserved Qty. on Sales Orders" - stockBackOrderQty + recItem."Qty. on Purch. Order") < 0 then begin

                    flagEmailCSV := true;

                    //Replaced unit cost by Last Direct Cost as per phil's email 23-Jan-23 
                    stockRequiredValue := recItem."Last Direct Cost" * math.Abs(recItem.Inventory - recItem."Reserved Qty. on Sales Orders" - stockBackOrderQty + recItem."Qty. on Sales Order");
                    if vendorNumber = '' then begin
                        vendorNumber := recItem."Vendor No.";
                    end;

                    if recItem."Vendor No." = vendorNumber then begin
                        sumRequiredValue := sumRequiredValue + stockRequiredValue;
                    end
                    else begin
                        CheckStock(vendorNumber, sumRequiredValue);
                        sumRequiredValue := stockRequiredValue;
                    end;
                    vendorNumber := recItem."Vendor No.";
                end;

            until recItem.Next() = 0;
            if flagEmailCSV then
                CheckStock(vendorNumber, sumRequiredValue);
        end;
    end;

    local procedure CheckStock(var vendorNo: Code[30]; var sumRequiredStock: decimal)
    var
        recVendor: Record Vendor;
        typeSpend: Text;

    begin
        recVendor.Reset();
        recVendor.SetRange("No.", vendorNo);

        if recVendor.FindFirst() then begin
            if sumRequiredStock > recVendor.MinimumOrderAmount then
                typeSpend := 'Over Min Spend'
            else
                typeSpend := 'Under Min Spend';
            CreateCSV(FORMAT(typeSpend), FORMAT(recVendor."No."), FORMAT(sumRequiredStock), FORMAT(recVendor.MinimumOrderAmount))
        end;

    end;

    local procedure CreateCSV(Type: Text; VendorNo: Text; ValueofStockRequired: Text; MinOrderAmount: Text)
    begin
        CSVText := CSVText + '"' + Type + '","' + VendorNo + '","' + ValueofStockRequired + '","' + MinOrderAmount + '"' + FORMAT(Char1310);
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
                    MsgBody := 'Hello, <br/> <br/>Please find the attached SO requirement item details.<br/><br/> Kind Regards';
                    CU_EmailMessage.Create(recEmailInternalPO."Email Address", 'SO requirement but none in stock - PO`s required', MsgBody, true);
                    CU_EmailMessage.AddAttachment('SORequirement.csv', 'CSV', InS);
                    CU_Email.Send(CU_EmailMessage, enum_EmailScenario::"Purchase Order");
                end;
            until recEmailInternalPO.Next() = 0;
        end;
    end;

    var
        recItem: Record Item;
        stockRequiredValue, stockBackOrderQty : Decimal;
        math: Codeunit Math;
        sumRequiredValue: Decimal;
        vendorNumber: Code[20];
        hasVendorChanged: Boolean;
        OutS: OutStream;
        InS: InStream;
        CU_EmailMessage: Codeunit "Email Message";
        CU_Email: Codeunit Email;
        MsgBody: Text[250];
        EmailList: List of [Text];
        CSVText: Text;
        Char1310: Char;
        Rec_TempBlob: Codeunit "Temp Blob";
        flagEmailCSV: Boolean;
        recEmailInternalPO: Record "Email Internal PO";
        enum_EmailScenario: Enum "Email Scenario";
}
