page 50109 "Rules Matrix Listing"
{
    ApplicationArea = All;
    Caption = 'Rules Matrix Listing';
    PageType = List;
    SourceTable = "Rules Matrix";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(MIN_ID; Rec.MIN_ID)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RULETYPE; Rec.RULETYPE)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STKCODE; Rec.STKCODE)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STK_SORT_KEY; Rec.STK_SORT_KEY)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STK_SORT_KEY1; Rec.STK_SORT_KEY1)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(STK_SUPPLIER1; Rec.STK_SUPPLIER1)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(PRIORITY; Rec.PRIORITY)
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }

        }
    }

}
