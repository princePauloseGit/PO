query 50119 GetSalesArchiveOrders
{
    Caption = 'GetSalesArchiveOrders';
    QueryType = Normal;
    //OrderBy = ascending(Sales_Header_No_, Sales_Line_No_, SystemCreatedAt);
    OrderBy = descending(Sales_Header_No_);


    elements
    {
        dataitem(Sales_Line_Archive; "Sales Line Archive")
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
            column(SalesLine_Version_No_; "Version No.")
            {
                Caption = 'Sales Line Version No.';
            }
            dataitem(Sales_Header_Archive; "Sales Header Archive")
            {
                DataItemLink = "No." = Sales_Line_Archive."Document No.",
                "Version No." = Sales_Line_Archive."Version No.";
                SqlJoinType = InnerJoin;

                DataItemTableFilter = "Document Type" = const(Order),
                //Invoice = const(true),
                ExcludeSOOrder = const(false);
                column(Order_Date; "Order Date")
                {

                }
                column(Sales_Header_No_; "No.")
                {

                }
                column(SalesHeader_Version_No_; "Version No.")
                {
                    Caption = 'Sales Header Version No.';
                }
                column(No__of_Archived_Versions; "No. of Archived Versions")
                {
                    Caption = 'Sales Header No of Arch Version.';
                }
                column(Source_Doc__Exists; "Source Doc. Exists")
                {
                    ColumnFilter = Source_Doc__Exists = const(false);
                }

                dataitem(Item; Item)
                {
                    DataItemLink = "No." = Sales_Line_Archive."No.";
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
