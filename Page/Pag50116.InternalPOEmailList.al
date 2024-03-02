page 50116 "Internal PO Email List"
{
    Caption = 'Internal PO Email List';
    PageType = List;
    SourceTable = "Email Internal PO";
    ApplicationArea = All;
    UsageCategory = Administration;
    CardPageId = "Internal Email PO";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Email Address"; Rec."Email Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        // Adds the action called "My Actions" to the Action menu 
        area(Processing)
        {
            action("Add Date")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Add Production''s Start Date';
                RunObject = page EntryDateForProduction;
                Image = Calendar;
            }

        }
    }
}
