query 50100 GetAllItemforAvgleadTime
{
    Caption = 'Get All Item for Avg lead Time';
    QueryType = Normal;

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Location Code" = CONST('MAIN'), "Entry Type" = const(Purchase), "Posting Date" = filter(<> 0D);

            column(ItemNo; "Item No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
            {
                DataItemLink = "No." = ItemLedgerEntry."Document No.";

                dataitem(Purchase_Line; "Purchase Line")
                {
                    DataItemLink = "Document No." = PurchRcptHeader."Order No.", "No." = ItemLedgerEntry."Item No.";
                    SqlJoinType = InnerJoin;
                    DataItemTableFilter = "Order Date" = filter(<> 0D);
                    column(Order_Date; "Order Date")
                    {
                    }
                    column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
                    {

                    }
                    column(Document_No_; "Document No.")
                    {

                    }
                    dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                    {
                        DataItemLink = STKCODE = Purchase_Line."No.",
                             SUPPLIER1 = Purchase_Line."Buy-from Vendor No.";
                        SqlJoinType = InnerJoin;
                        dataitem(Rules_Matrix; "Rules Matrix")
                        {
                            DataItemLink = MIN_ID = ENHPOP_StockMinCalc.RULE_PK;
                            SqlJoinType = InnerJoin;

                            column(DAYS_TO_USE_PO_LEAD; DAYS_TO_USE_PO_LEAD)
                            {

                            }
                        }
                    }
                }
            }
        }
    }
}
