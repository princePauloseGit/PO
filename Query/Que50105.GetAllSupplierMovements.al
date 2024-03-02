query 50105 GetAllSupplierMovements
{
    Caption = 'Get All Supplier Movements';
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

                dataitem(Purchase_Line; "Purchase Line")
                {
                    DataItemLink = "Document No." = PurchRcptHeader."Order No.",
                "No." = ItemLedgerEntry."Item No.";
                    SqlJoinType = InnerJoin;
                    DataItemTableFilter = "Order Date" = filter(<> 0D);

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
