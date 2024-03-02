query 50122 GetSalesForecastData
{
    Caption = 'GetSalesForecastData';
    QueryType = Normal;
    OrderBy = descending(Forecast_Item_No_, Forecast_Quantity);

    elements
    {
        dataitem(Production_Forecast_Entry; "Production Forecast Entry")
        {
            //DataItemTableFilter = "Forecast Quantity" = filter(> 0);
            column(Forecast_Item_No_; "Item No.")
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
                dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                {
                    DataItemLink = STKCODE = Production_Forecast_Entry."Item No.";
                    SqlJoinType = InnerJoin;
                    column(Min_SystemCreatedAt; SystemCreatedAt)
                    {

                    }
                    dataitem(Rules_Matrix; "Rules Matrix")
                    {
                        DataItemLink = Min_Id = ENHPOP_StockMinCalc.RULE_PK;
                        SqlJoinType = InnerJoin;

                        column(IGNORE_TOP_BOT_SALES_QTY; IGNORE_TOP_BOT_SALES_QTY)
                        {

                        }
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
}