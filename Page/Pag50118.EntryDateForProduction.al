page 50118 EntryDateForProduction
{
    Caption = 'Entry Date For Production';
    PageType = XmlPort;
    SourceTable = EntryDateProduction;
    DataCaptionExpression = 'Entry Date';
    UsageCategory = Administration;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    LinksAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(StartingDate; Rec.StartingDate)
                {
                    Caption = 'Start Date';
                    ApplicationArea = All;
                    Editable = true;
                }
            }
        }
    }
}
