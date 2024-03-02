query 50120 GetAllArchveItemforAvgleadTime
{
    Caption = 'GetAllArchveItemforAvgleadTime';
    QueryType = Normal;
    OrderBy = ascending(ItemNo);

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Location Code" = CONST('MAIN'), "Entry Type" = const(Purchase);

            column(ItemNo; "Item No.")
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
            {
                DataItemLink = "No." = ItemLedgerEntry."Document No.";


                dataitem(Purchase_Line_Archive; "Purchase Line Archive")
                {
                    DataItemLink = "Document No." = PurchRcptHeader."Order No.", "No." = ItemLedgerEntry."Item No.";
                    SqlJoinType = InnerJoin;
                    DataItemTableFilter = "Order Date" = filter(<> 0D), "Completely Received" = const(true);

                    column(Order_Date; "Order Date")
                    {
                    }
                    column(Buy_from_Vendor_No_; "Buy-from Vendor No.")
                    {

                    }
                    column(Document_No_; "Document No.")
                    {

                    }
                    column(Count)
                    {
                        Method = Count;
                    }
                    dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                    {
                        DataItemLink = STKCODE = Purchase_Line_Archive."No.",
                             SUPPLIER1 = Purchase_Line_Archive."Buy-from Vendor No.";
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
