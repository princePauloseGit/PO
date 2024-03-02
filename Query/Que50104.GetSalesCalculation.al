query 50104 GetSalesCalculation
{
    Caption = 'Get Sales Calculation';
    QueryType = Normal;

    elements
    {
        dataitem(TempSalesCalculation; TempSalesCalculation)
        {
            column(ItemNo; ItemNo)
            {
            }
            column(DaysToUse; DaysToUse)
            {
            }
            column(SupplierOrderCycle; SupplierOrderCycle)
            {
            }
            column(QueSystemCreatedAt; QueSystemCreatedAt)
            {

            }
            column(Quantity; Quantity)
            {
                Method = Sum;
            }
            // dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
            // {
            //     DataItemLink = STKCODE = TempSalesCalculation.ItemNo;
            //     SqlJoinType = InnerJoin;

            //     dataitem(Vendor;Vendor){
            //         DataItemLink = "No." = 
            //     }

            // } Cross verified.
            dataitem(Item; Item)
            {
                DataItemLink = "No." = TempSalesCalculation.ItemNo;
                SqlJoinType = InnerJoin;

                dataitem(Vendor; Vendor) //left join pl_accounts2 with (nolock) on sucode2=stk_supplier1
                {
                    DataItemLink = "No." = Item."Vendor No.";
                    SqlJoinType = LeftOuterJoin;

                    column(enhDaysForPO; enhDaysForPO)
                    {

                    }
                }
            }
        }
    }
}
