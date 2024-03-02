query 50107 GetRecalculateMin
{
    Caption = 'Get Recalculate Min';
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            column(No_; "No.")
            {

            }
            column(Vendor_No_; "Vendor No.")
            {

            }
            column(Reorder_Point; "Reorder Point")
            {

            }
            column(Maximum_Inventory; "Maximum Inventory")
            {

            }
            column(Item_Category_Code; "Item Category Code")
            {

            }

            dataitem(Sales_Line; "Sales Line")
            {
                DataItemLink = "No." = Item."No.";
                SqlJoinType = InnerJoin;
                // column(Posting_Date; "Posting Date") as per mail for od_date consider order  date at header level
                // {

                // }
                dataitem(Sales_Header; "Sales Header")
                {
                    DataItemLink = "No." = Sales_Line."Document No.";
                    SqlJoinType = InnerJoin;
                    DataItemTableFilter = "Document Type" = const(Order);
                    column(Order_Date; "Order Date")
                    {

                    }
                    column(SalesHeaderNo; "No.")
                    {
                        Caption = 'Sales Header No.';
                    }
                }
            }

        }
    }
}