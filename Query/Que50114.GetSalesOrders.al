query 50114 GetSalesOrders
{
    Caption = 'GetSalesOrders';
    QueryType = Normal;
    OrderBy = ascending(Sales_Line_No_, SystemCreatedAt);

    elements
    {
        dataitem(Sales_Line; "Sales Line")
        {
            DataItemTableFilter = "Location Code" = const('MAIN');
            column(Sales_Line_No_; "No.")
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            dataitem(Sales_Header; "Sales Header")
            {
                DataItemLink = "No." = Sales_Line."Document No.";
                SqlJoinType = InnerJoin;

                DataItemTableFilter = "Document Type" = const(Order),
                ExcludeSOOrder = const(false);
                column(Order_Date; "Order Date")
                {

                }
                column(Sales_Header_No_; "No.")
                {

                }

                dataitem(Item; Item)
                {
                    DataItemLink = "No." = Sales_Line."No.";
                    SqlJoinType = InnerJoin;
                    column(SystemCreatedAt; SystemCreatedAt)
                    {

                    }

                    //Mail 8-Nov-22
                    column(Vendor_No_; "Vendor No.")
                    {

                    }
                    column(Item_Category_Code; "Item Category Code")
                    {

                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        day, month, year : Integer;
        lastyear: Date;
    begin
        day := DATE2DMY(Today, 1);
        month := DATE2DMY(Today, 2);
        year := DATE2DMY(Today, 3);
        lastyear := DMY2DATE(day, month, year - 1);
        CurrQuery.SetFilter(Order_Date, '%1..%2', lastyear, Today);
    end;
}

