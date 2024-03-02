query 50117 GetAllSalesArchieveItem
{
    Caption = 'GetAllSalesArchieveItem';
    QueryType = Normal;
    OrderBy = descending(Sales_Header_No_, SalesLine_No, Quantity, SalesHeaderArchive_SystemCreatedAt);

    elements
    {
        dataitem(Sales_Line_Archive; "Sales Line Archive")
        {
            DataItemTableFilter = Type = const(Item),
                Quantity = filter(> 0),
                "Location Code" = const('MAIN');

            column(SalesLine_No; "No.")
            {

            }
            //changed from quantity to qty shipped 6-oct-2023 https://trello.com/c/1MkKoHXz/16-min-max-calculating-but-should-be-blank
            column(Quantity; "Qty. Shipped (Base)")
            {
            }
            column(Amount; Amount)
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            column(SalesLine_Version_No_; "Version No.")
            {

            }
            dataitem(Sales_Header_Archive; "Sales Header Archive")
            {
                DataItemLink = "No." = Sales_Line_Archive."Document No.",
                "Version No." = Sales_Line_Archive."Version No.";
                SqlJoinType = InnerJoin;

                DataItemTableFilter = "Document Type" = const(Order),
                //Invoice = const(true),
                 ExcludeSOOrder = const(false);

                column(No__of_Archived_Versions; "No. of Archived Versions")
                {

                }
                column(Order_Date;
                "Order Date")
                {

                }
                column(Sales_Header_No_; "No.")
                {

                }
                column(SalesHeader_Version_No_; "Version No.")
                {

                }
                column(SalesHeaderArchive_SystemCreatedAt; SystemCreatedAt)
                {

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

                    dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                    {
                        DataItemLink = STKCODE = Sales_Line_Archive."No.";
                        SqlJoinType = InnerJoin;
                        column(Min_SystemCreatedAt; SystemCreatedAt)
                        {

                        }
                        dataitem(Rules_Matrix; "Rules Matrix")
                        {
                            DataItemLink = Min_Id = ENHPOP_StockMinCalc.RULE_PK;
                            SqlJoinType = LeftOuterJoin;

                            column(IGNORE_TOP_BOT_SALES_QTY; IGNORE_TOP_BOT_SALES_QTY)
                            {

                            }
                            column(DAYS_TO_USE; DAYS_TO_USE)
                            {

                            }
                            column(SUPPLIER_ORDER_CYCLE; SUPPLIER_ORDER_CYCLE)
                            {

                            }
                        }
                    }

                }
            }
        }
    }
    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(Order_Date, '<%1', Today);
    end;
}