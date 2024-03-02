query 50106 GetSupplierAverageLeadTime
{
    Caption = 'GetSupplierAverageLeadTime';
    QueryType = Normal;

    elements
    {
        dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
        {
            DataItemTableFilter = EXCLUDE = const(1),
            EXCLUDEREASON = const('LEAD TIME COULD NOT BE ESTABLISHED DUE TO LACK OF DATA');
            column(STKCODE; STKCODE)
            {

            }
            column(SUPPLIER1; SUPPLIER1)
            {

            }
            dataitem(TempSupplierAverageLeadTime; TempSupplierAverageLeadTime)
            {
                DataItemLink = "Vendor No" = ENHPOP_StockMinCalc.SUPPLIER1;
                SqlJoinType = InnerJoin;
                column(Vendor_No_; "Vendor No")
                {

                }
                column(Lead_Time_; "Lead Time")
                {
                    Method = Average;
                }
            }
        }
    }
}
