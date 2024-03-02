page 50103 "Vendor Order Schedules list"
{
    ApplicationArea = All;
    Caption = 'Vendor Order Schedules list';
    PageType = List;
    SourceTable = VendorOrderSchedules;
    UsageCategory = Administration;
    CardPageID = "VendorOrderSchedules";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Vendor; Rec.Vendor)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(VendorName; Rec.VendorName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Cycle; Rec.Cycle)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
