pageextension 50104 ItemCardExtension extends "Item Card"
{
    layout
    {
        addafter("Vendor No.")
        {
            field("Exclude From Discount"; Rec."Exclude From Discount")
            {
                ApplicationArea = all;
            }

        }
    }
}
