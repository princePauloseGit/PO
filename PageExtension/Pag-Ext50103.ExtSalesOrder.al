pageextension 50103 ExtSalesOrder extends "Sales Order"
{
    layout
    {
        addafter("Sell-to Customer Name")
        {
            field(ExcludeSOOrder; Rec.ExcludeSOOrder)
            {
                Caption = 'Exclude Order';
                ApplicationArea = All;
            }
        }


    }
}
