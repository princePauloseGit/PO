query 50115 GetPOSalesQuantityRes
{
    Caption = 'GetPOSalesQuantityRes';
    QueryType = Normal;

    elements
    {
        dataitem(Sales_Line; "Sales Line")
        {
            DataItemTableFilter = "Location Code" = const('MAIN');
            column(No_; "No.")
            {

            }
            column(Reserved_Quantity; "Reserved Quantity")
            {
                Method = Sum;
            }
            dataitem(Sales_Header; "Sales Header")
            {
                DataItemLink = "No." = Sales_Line."Document No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Document Type" = const(Order);

            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
