codeunit 50115 CommonHelper
{
    procedure GetCCEmailAddress(): Text
    var
        Recipient: Text;
    begin
        Clear(Recipient);
        Recipient := 'purchasing@jesuk.co.uk';
        exit(Recipient);
    end;
}
