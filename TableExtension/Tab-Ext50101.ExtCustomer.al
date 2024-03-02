tableextension 50101 ExtCustomer extends Customer
{
    fields
    {
        field(50100; ignoreFromMinMax; Boolean)
        {
            Caption = 'Ignore From MinMax';
            DataClassification = CustomerContent;
        }
    }
}
