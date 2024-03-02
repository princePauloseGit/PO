query 50111 GetPurchaseLeadTime
{
    Caption = 'GetPurchaseLeadTime';
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
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = ENHPOP_StockMinCalc.SUPPLIER1;
                column(enhDaysForPO; enhDaysForPO)
                {

                }

            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
