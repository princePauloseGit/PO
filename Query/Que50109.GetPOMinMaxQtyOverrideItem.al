query 50109 GetPOMinMaxQtyOverrideItem
{
    Caption = 'GetPOMinMaxQtyOverrideItem';
    QueryType = Normal;

    elements
    {
        dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
        {
            DataItemTableFilter = STK_DO_NOT_USE = const(false);
            column(STKCODE; STKCODE)
            {

            }
            dataitem(POMinMaxQtyOverrideItem; POMinMaxQtyOverrideItem)
            {
                DataItemLink = ItemCode = ENHPOP_StockMinCalc.STKCODE;
                SqlJoinType = InnerJoin;
                column(Quantity; Quantity)
                {

                }
                column(ExpiryDate; ExpiryDate)
                {

                }
                column(AllowHigherMin; AllowHigherMin)
                {

                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        CurrQuery.SetFilter(ExpiryDate, '>%1', CurrentDateTime);

    end;
}
