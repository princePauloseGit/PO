query 50113 GetMinMaxResult
{
    Caption = 'GetMinMaxResult';
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter = Blocked = const(false);
            column(ItemNo; "No.")
            {

            }
            column(Description; Description)
            {

            }
            column(Item_Category_Code; "Item Category Code")
            {

            }
            column(Vendor_No_; "Vendor No.")
            {

            }
            column(SystemCreatedAt; SystemCreatedAt)
            {

            }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = Item."Vendor No.";
                SqlJoinType = LeftOuterJoin;
                DataItemTableFilter = "Location Code" = const('MAIN');
                column(VendorNo; "No.")
                {

                }
                column(enhDaysForPO; enhDaysForPO)
                {

                }
                dataitem(ENHPOP_StockMinCalc; ENHPOP_StockMinCalc)
                {
                    DataItemLink = STKCODE = Item."No.";
                    SqlJoinType = InnerJoin;
                    column(MAX_CALC; MAX_CALC)
                    {

                    }
                    column(MIN_CALC; MIN_CALC)
                    {

                    }
                    column(STK_MIN_QTY; STK_MIN_QTY)
                    {

                    }
                    column(STK_MAX_QTY; STK_MAX_QTY)
                    {

                    }
                    column(MIN_RECALC; MIN_RECALC)
                    {

                    }
                    column(RULE_PK; RULE_PK)
                    {

                    }
                    column(ORDERS_IN_PERIOD; ORDERS_IN_PERIOD)
                    {

                    }
                    column(SALES_PER_DAY_QNTY; SALES_PER_DAY_QNTY)
                    {

                    }
                    column(SUPPLIER_LEAD_TIME; SUPPLIER_LEAD_TIME)
                    {

                    }
                    column(SUPPLIER_ORDER_CYCLE; SUPPLIER_ORDER_CYCLE)
                    {

                    }
                    column(MEAN_LEAD_TIME_DAYS; MEAN_LEAD_TIME_DAYS)
                    {

                    }
                    column(DAYS_TO_NEXT_ORDER_CYCLE; DAYS_TO_NEXT_ORDER_CYCLE)
                    {

                    }
                    column(EXCLUDE; EXCLUDE)
                    {

                    }
                    column(EXCLUDEREASON; EXCLUDEREASON)
                    {

                    }
                    dataitem(Rules_Matrix; "Rules Matrix")
                    {
                        DataItemLink = min_id = ENHPOP_StockMinCalc.RULE_PK;
                        SqlJoinType = LeftOuterJoin;
                        column(RULETYPE; RULETYPE)
                        {

                        }
                        column(PRIORITY; PRIORITY)
                        {

                        }
                        column(DAYS_TO_USE; DAYS_TO_USE)
                        {

                        }
                        column(IGNORE_TOP_BOT_SALES_QTY; IGNORE_TOP_BOT_SALES_QTY)
                        {

                        }

                    }
                }
            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
