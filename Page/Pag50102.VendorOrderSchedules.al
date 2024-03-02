page 50102 VendorOrderSchedules
{
    Caption = 'Vendor Order Schedules';
    PageType = XmlPort;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "VendorOrderSchedules";
    DataCaptionFields = Vendor;
    layout
    {
        area(content)
        {
            group(Scheduler)
            {
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = All;
                    TableRelation = Vendor."No.";
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        recVendor: Record Vendor;
                    begin

                        if recVendor.Get(Rec.Vendor) then
                            Rec.VendorName := recVendor.Name;
                    end;
                }
                field(VendorName; Rec.VendorName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Cycle; Rec.Cycle)
                {
                    ApplicationArea = All;
                    TableRelation = ENHPOP_POFrequency.Frequency;
                    ShowMandatory = true;
                    NotBlank = true;
                    trigger OnValidate()
                    var
                        recVendor: Record "VendorOrderSchedules";
                    begin

                        if rec.Vendor <> '' then begin
                            recVendor.SetFilter(Vendor, Rec.Vendor);
                            if recVendor.FindSet() then
                                repeat
                                    if Rec.Cycle = recVendor.Cycle then begin
                                        Rec.FieldError(Cycle, 'Already Exists for this Vendor');
                                    end
                                until recVendor.Next() = 0;
                        end
                        else begin
                            Rec.FieldError(Vendor, 'Please Select Vendor');
                        end;
                    end;
                }
            }
        }
    }
    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // begin
    //     if (Rec.Vendor = '') OR (Rec.Cycle = '') then
    //         Error('Required');
    // end;

    // trigger OnModifyRecord(): Boolean
    // begin
    //     if (Rec.Vendor = '') OR (Rec.Cycle = '') then
    //         Error('Required');
    // end;

}
