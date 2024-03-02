query 50118 GetRecalculateMinForArchive
{
    Caption = 'GetRecalculateMinForArchive';
    QueryType = Normal;
    OrderBy = descending(SalesHeaderNo);

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
            dataitem(Sales_Line_Archive; "Sales Line Archive")
            {
                DataItemLink = "No." = Item."No.";
                SqlJoinType = InnerJoin;
                column(SalesLine_Version_No_; "Version No.")
                {
                    Caption = 'Sales Line Version No.';
                }
                dataitem(Sales_Header_Archive; "Sales Header Archive")
                {
                    DataItemLink = "No." = Sales_Line_Archive."Document No.",
                     "Version No." = Sales_Line_Archive."Version No.";
                    SqlJoinType = InnerJoin;

                    DataItemTableFilter = "Document Type" = const(Order);
                    //Invoice = const(true);
                    column(Order_Date;
                    "Order Date")
                    {

                    }
                    column(SalesHeaderNo; "No.")
                    {
                        Caption = 'Sales Header Archive No.';
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
                }
            }

        }
    }
}
