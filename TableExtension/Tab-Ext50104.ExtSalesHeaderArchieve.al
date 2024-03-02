tableextension 50104 ExtSalesHeaderArchieve extends "Sales Header Archive"
{
    fields
    {
        field(50100; ExcludeSOOrder; Boolean)
        {
            Caption = 'ExcludeSOOrder';
            DataClassification = CustomerContent;
        }
    }
}
