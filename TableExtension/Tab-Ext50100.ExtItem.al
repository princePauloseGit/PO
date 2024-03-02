tableextension 50100 ExtItem extends Item
{
    fields
    {
        field(50100; ItemPOError; Text[100])
        {
            Caption = 'Item PO Error';
            DataClassification = CustomerContent;
        }
        field(50101; "Exclude From Discount"; Boolean)
        {
            Caption = 'Exclude From Discount';
            DataClassification = CustomerContent;
        }
    }
}
