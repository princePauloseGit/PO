tableextension 50102 ExtVendors extends Vendor
{
    fields
    {
        field(50100; "autoporecipient email address"; Text[100])
        {
            Caption = 'Autoporecipient Email address';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }
        field(50101; "Vendor Discount"; Decimal)
        {
            Caption = 'Vendor Discount';
            DataClassification = CustomerContent;
        }
    }
}
