page 50117 "Internal Email PO"
{
    Caption = 'Internal Email PO';
    PageType = XmlPort;
    SourceTable = "Email Internal PO";
    // ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = All;
                }
                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
