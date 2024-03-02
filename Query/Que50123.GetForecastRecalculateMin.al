query 50123 GetForecastRecalculateMin
{
    Caption = 'GetForecastRecalculateMin';
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
            dataitem(Production_Forecast_Entry; "Production Forecast Entry")
            {
                DataItemLink = "Item No." = Item."No.";
                SqlJoinType = InnerJoin;

                column(Item_No_; "Item No.")
                {

                }
                column(Forecast_Date; "Forecast Date")
                {

                }
                column(Forecast_Quantity; "Forecast Quantity")
                {

                }
            }

        }
    }
}
