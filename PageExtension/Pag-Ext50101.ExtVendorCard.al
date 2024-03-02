pageextension 50101 ExtVendorCard extends "Vendor Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("autoporecipient email address"; Rec."autoporecipient email address")
            {
                Caption = 'Auto PO Recipient Email Address';
                ApplicationArea = All;
            }
            field("Vendor Discount"; Rec."Vendor Discount")
            {
                Caption = 'Vendor Discount';
                ApplicationArea = all;
            }
        }
    }
}
