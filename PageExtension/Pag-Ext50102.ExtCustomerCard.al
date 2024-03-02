pageextension 50102 ExtCustomerCard extends "Customer Card"
{
    layout
    {
        addafter("Privacy Blocked")
        {
            field(ignoreFromMinMax; Rec.ignoreFromMinMax)
            {
                Caption = 'Ignore From Min-Max';
                ApplicationArea = All;

            }
        }
    }
}
