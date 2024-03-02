query 50112 GetVendorPOCycle
{
    Caption = 'GetVendorPOCycle';
    QueryType = Normal;
    OrderBy = ascending(Vendor, NextFrequencyDate);
    elements
    {
        dataitem(VendorOrderSchedules; VendorOrderSchedules)
        {
            column(Vendor; Vendor)
            {

            }
            column(Cycle; Cycle)
            {


            }
            dataitem(ENHPOP_POFrequency; ENHPOP_POFrequency)
            {
                DataItemLink = Frequency = VendorOrderSchedules.Cycle;
                SqlJoinType = InnerJoin;
                column(NextFrequencyDate; NextFrequencyDate)
                {

                }

            }
        }
    }

    trigger OnBeforeOpen()
    begin

    end;
}
