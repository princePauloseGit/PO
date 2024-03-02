query 50110 GetPOminmaxqtyOverrideSK
{
    Caption = 'GetPOminmaxqtyOverrideSK';
    QueryType = Normal;

    elements
    {
        dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
        {
            DataItemTableFilter = STK_DO_NOT_USE = const(false);
            column(STKCODE; STKCODE)
            {

            }
            dataitem(POMinMaxQtyOverrideSK; POMinMaxQtyOverrideSK)
            {
                DataItemLink = SortKey = ENHPOP_StockMinCalc.STK_SORT_KEY;
                SqlJoinType = InnerJoin;
                column(Quantity; Quantity)
                {

                }
            }
        }
    }
}
