query 50124 GetForecastSalesOrders
{
    Caption = 'GetForecastSalesOrders';
    QueryType = Normal;
    OrderBy = ascending(Item_No_, SystemCreatedAt);

    elements
    {
        dataitem(Production_Forecast_Entry; "Production Forecast Entry")
        {
            column(Item_No_; "Item No.")
            {

            }
            column(Forecast_Quantity; "Forecast Quantity")
            {

            }
            column(Forecast_Date; "Forecast Date")
            {

            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = Production_Forecast_Entry."Item No.";
                SqlJoinType = InnerJoin;
                column(SystemCreatedAt; SystemCreatedAt)
                {

                }
                //Mail 8-Nov-22
                column(Vendor_No_; "Vendor No.")
                {

                }
                column(Item_Category_Code; "Item Category Code")
                {

                }
            }
        }
    }

    trigger OnBeforeOpen()
    var
        day, month, year : Integer;
        lastyear: Date;
    begin
        day := DATE2DMY(Today, 1);
        month := DATE2DMY(Today, 2);
        year := DATE2DMY(Today, 3);
        lastyear := DMY2DATE(day, month, year - 1);
        CurrQuery.SetFilter(Forecast_Date, '%1..%2', lastyear, Today);
    end;
}