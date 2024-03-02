query 50102 GetAllSalesItem
{
    Caption = 'Get All Sales Item';
    QueryType = Normal;
    OrderBy = descending(SalesLine_No, Quantity, SalesHeader_SystemCreatedAt);

    elements
    {
        dataitem(SalesLine; "Sales Line")
        {
            DataItemTableFilter = Type = const(Item),
            Quantity = filter(> 0),
            "Location Code" = const('MAIN');
            column(SalesLine_No; "No.")
            {

            }
            column(Quantity; Quantity)
            {
            }
            column(Outstanding_Qty___Base_; "Outstanding Qty. (Base)")
            { }
            column(Amount; Amount)
            {

            }
            column(Sell_to_Customer_No_; "Sell-to Customer No.")
            {

            }
            dataitem(Sales_Header; "Sales Header")
            {
                DataItemLink = "No." = SalesLine."Document No.";
                SqlJoinType = InnerJoin;

                DataItemTableFilter = "Document Type" = const(Order),
                ExcludeSOOrder = const(false);
                column(Order_Date; "Order Date")
                {

                }
                column(Sales_Header_No_; "No.")
                {

                }
                column(Status; Status)
                { }
                column(SalesHeader_SystemCreatedAt; SystemCreatedAt)
                {

                }


                dataitem(Item; Item)
                {
                    DataItemLink = "No." = SalesLine."No.";
                    SqlJoinType = InnerJoin;
                    column(SystemCreatedAt; SystemCreatedAt)
                    {

                    }
                    // column(Qty__on_Sales_Order; "Qty. on Sales Order")
                    // {

                    // }
                    dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                    {
                        DataItemLink = STKCODE = SalesLine."No.";
                        SqlJoinType = InnerJoin;
                        column(Min_SystemCreatedAt; SystemCreatedAt)
                        {

                        }
                        dataitem(Rules_Matrix; "Rules Matrix")
                        {
                            DataItemLink = Min_Id = ENHPOP_StockMinCalc.RULE_PK;
                            SqlJoinType = InnerJoin;

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
