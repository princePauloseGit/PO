query 50103 GetSalesComponent
{
    Caption = 'Get Sales Component';
    QueryType = Normal;

    elements
    {
        dataitem(Item_Ledger_Entry; "Item Ledger Entry")
        {
            //As per Phil's Email - 10-Feb-2022
            DataItemTableFilter = "Entry Type" = filter("Assembly Consumption");
            //Description = const('KIT BUILD');
            column(Item_No_;
            "Item No.")
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Posting_Date; "Posting Date")
            {

            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Item_Ledger_Entry."Item No.";
                SqlJoinType = InnerJoin;

                dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                {
                    DataItemLink = STKCODE = Item_Ledger_Entry."Item No.";
                    SqlJoinType = InnerJoin;
                    column(Min_SystemCreatedAt; SystemCreatedAt)
                    {

                    }

                    dataitem(Rules_Matrix; "Rules Matrix")
                    {
                        DataItemLink = Min_Id = ENHPOP_StockMinCalc.RULE_PK;
                        SqlJoinType = InnerJoin;

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
    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(Posting_Date, '<%1', Today);
    end;
}
