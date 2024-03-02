query 50121 GetAllArchiveSupplierMovements
{
    Caption = 'GetAllArchiveSupplierMovements';
    QueryType = Normal;
    OrderBy = ascending(ItemNo_);

    elements
    {
        dataitem(ItemLedgerEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Location Code" = CONST('MAIN'), "Entry Type" = const(Purchase), "Posting Date" = filter(<> 0D);

            column(Posting_Date; "Posting Date")
            {

            }
            dataitem(PurchRcptHeader; "Purch. Rcpt. Header")
            {
                DataItemLink = "No." = ItemLedgerEntry."Document No.";

                dataitem(Purchase_Line_Archive; "Purchase Line Archive")
                {
                    DataItemLink = "Document No." = PurchRcptHeader."Order No.",
                "No." = ItemLedgerEntry."Item No.";
                    SqlJoinType = InnerJoin;

                    DataItemTableFilter = "Completely Received" = const(true), "Order Date" = filter(<> 0D);
                    column(Order_Date; "Order Date")
                    {

                    }
                    dataitem(Item; Item)
                    {
                        DataItemLink = "No." = ItemLedgerEntry."Item No.";
                        SqlJoinType = InnerJoin;

                        column(Vendor_No_; "Vendor No.")
                        {

                        }
                        column(ItemNo_; "No.")
                        {

                        }

                    }
                }
            }

        }
    }
}