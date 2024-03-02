query 50126 GetAllAssemblyLine
{
    Caption = 'Get All Assembly Line';
    QueryType = Normal;

    elements
    {
        dataitem(AssemblyLine; "Assembly Line")
        {
            DataItemTableFilter = Type = const(Item),
            Quantity = filter(> 0),
            "Location Code" = const('MAIN');
            column(No; "No.") { }
            column(Quantity; Quantity) { }
            column(Document_No_; "Document No.") { }

            dataitem(Assembly_Header; "Assembly Header")
            {
                DataItemLink = "No." = AssemblyLine."Document No.";
                SqlJoinType = InnerJoin;

                column(Posting_Date; "Posting Date") { }
                column(Document_Type; "Document Type") { }

                dataitem(Item; Item)
                {
                    DataItemLink = "No." = AssemblyLine."No.";
                    SqlJoinType = InnerJoin;
                    column(SystemCreatedAt; SystemCreatedAt)
                    {

                    }

                    dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                    {
                        DataItemLink = STKCODE = AssemblyLine."No.";
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
        CurrQuery.SetFilter(Posting_Date, '<%1', Today);
    end;
}
