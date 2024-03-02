tableextension 50103 ExtSalesHeader extends "Sales Header"
{
    fields
    {
        field(50100; ExcludeSOOrder; Boolean)
        {
            Caption = 'Exclude SO Order';
            DataClassification = CustomerContent;
        }
    }
}
