query 50108 GetRecalcMin2Sales
{
    Caption = 'GetRecalcMin2Sales';
    QueryType = Normal;

    elements
    {
        dataitem(TempRecalcMin2Sales; TempRecalcMin2Sales)
        {
            column(Item_No; "Item No")
            {

            }
            column(Vendor_No; "Vendor No")
            {

            }
            column(Reorder_Point; "Reorder Point")
            {

            }
            column(Maximum_Inventory; "Maximum Inventory")
            {

            }
            column(UniqueCount)
            {
                Method = Count;
                //https://trello.com/c/SgIZnDF5/14-question-selling-3-in-12-months
                //changed filter >=2 to 2 (18 Aug 2023)
                ColumnFilter = UniqueCount = filter(> 2);
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
