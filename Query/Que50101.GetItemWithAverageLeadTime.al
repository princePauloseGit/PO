query 50101 GetItemWithAverageLeadTime
{
    Caption = 'Get Item With Average Lead Time';
    QueryType = Normal;

    elements
    {
        dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
        {
            column(STKCODE; STKCODE)
            {
            }
            column(MEAN_LEAD_TIME_DAYS; MEAN_LEAD_TIME_DAYS)
            {
            }
            column(RULE_PK; RULE_PK)
            {
            }
            dataitem(Rules_Matrix; "Rules Matrix")
            {
                DataItemLink = Min_Id = ENHPOP_StockMinCalc.RULE_PK;
                SqlJoinType = InnerJoin;
                column(MIN_ID; MIN_ID)
                {

                }
                column(OverrideLeadTime; OverrideLeadTime)
                {

                }
                column(OverrideLeadTimevalue; OverrideLeadTimevalue)
                {

                }

                dataitem(TempAverageLeadTime; TempAverageLeadTime)
                {
                    DataItemLink = ItemNo = ENHPOP_StockMinCalc.STKCODE;
                    SqlJoinType = LeftOuterJoin;
                    column(ItemNo; ItemNo)
                    {
                    }
                    column(Buy_from_Vendor_No_; Buy_from_Vendor_No_)
                    {

                    }
                    column(dateDiffDays; dateDiffDays)
                    {
                        Method = Average;
                    }
                    column(AvgLeadTime; AvgLeadTime)
                    {

                    }
                }
            }
        }
    }
}
