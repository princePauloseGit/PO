query 50116 GetRoutineToRaisePOData
{
    Caption = 'GetRoutineToRaisePOData';
    QueryType = Normal;

    elements
    {
        dataitem(Item; Item)
        {
            DataItemTableFilter = Blocked = const(false),
           "Last Direct Cost" = filter(<> 0);

            column(No_; "No.")
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
            //loc
            column(Maximum_Inventory; "Maximum Inventory")
            {

            }
            column(Inventory; Inventory)
            {

            }
            column(Qty__on_Sales_Order; "Qty. on Sales Order")
            {

            }
            column(Qty__on_Purch__Order; "Qty. on Purch. Order")
            {

            }
            column(Reserved_Qty__on_Sales_Orders; "Reserved Qty. on Sales Orders")
            {

            }
            column(Qty__on_Asm__Component; "Qty. on Asm. Component")
            {

            }
            column(Order_Multiple; "Order Multiple")
            {

            }
            column(ItemCreatedAt; SystemCreatedAt)
            {

            }
            column(Last_Direct_Cost; "Last Direct Cost")
            {

            }
            column(Reorder_Point; "Reorder Point")
            {

            }

            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = Item."Vendor No.";
                SqlJoinType = InnerJoin;
                DataItemTableFilter = "Location Code" = const('MAIN');
                //main
                column(MinimumOrderAmount; MinimumOrderAmount)
                {

                }

                dataitem(TempPOStockAvg; TempPOStockAvg)
                {
                    DataItemLink = ItemNo = Item."No.";
                    SqlJoinType = LeftOuterJoin;
                    column(LeadTime; LeadTime)
                    {

                    }
                    dataitem(TempPOSalesQtyRes; TempPOSalesQtyRes)
                    {
                        DataItemLink = ItemNo = Item."No.";
                        SqlJoinType = LeftOuterJoin;
                        dataitem(TempPOSalesPerDay; TempPOSalesPerDay)
                        {
                            DataItemLink = ItemNo = Item."No.";
                            SqlJoinType = LeftOuterJoin;
                            column(SalesPerDayQty; SalesPerDayQty)
                            {

                            }
                            dataitem(TempPOVendorFrequency; TempPOVendorFrequency)
                            {
                                DataItemLink = Vendor = Item."Vendor No.";
                                SqlJoinType = InnerJoin;

                                column(Frequency; Frequency)
                                {

                                }
                                column(NextFrequencyDate; NextFrequencyDate)
                                {

                                }
                            }
                        }
                    }
                }

            }
        }
    }

    trigger OnBeforeOpen()
    var
    begin
    end;
}
