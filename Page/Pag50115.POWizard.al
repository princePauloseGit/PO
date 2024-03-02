page 50115 "PO Wizard"
{
    Caption = 'PO Wizard';
    PageType = ListPlus;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = RoutinePO;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DataCaptionExpression = 'PO Wizard';
    RefreshOnActivate = true;
    //DataCaptionFields = "Journal Batch Name";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Criteria';
                grid(gridDropdown)
                {
                    group("")
                    {
                        Caption = '';
                        field(stkCode; stkCode)
                        {
                            Caption = 'Item No';
                            Editable = true;
                            ApplicationArea = All;
                            TableRelation = Item."No.";
                        }
                        field(vendorVar; vendorVar)
                        {
                            Caption = 'Vendor';
                            ApplicationArea = All;
                            TableRelation = Vendor."No.";
                        }
                        field(sortkey; sortkey)
                        {
                            Caption = 'Item Category Code';
                            ApplicationArea = All;
                            TableRelation = "Item Category".Code;
                        }
                    }
                }
                grid(gridBoolean)
                {
                    group(" ")
                    {
                        Caption = '';
                        field(PObackOrders; PObackOrders)
                        {
                            Caption = 'PO to max + back orders';
                            ApplicationArea = All;

                        }
                        field(zeroValuePO; zeroValuePO)
                        {
                            Caption = 'Show zero value PO s';
                            ApplicationArea = All;
                        }

                        field(overridePO; overridePO)
                        {
                            Caption = 'Override PO Schedule Date';
                            ApplicationArea = All;

                        }
                        field(backOrder; backOrder)
                        {
                            Caption = 'Back Orders';
                            ApplicationArea = All;
                        }
                    }
                }
            }
            group(Result)
            {
                repeater(Data)
                {
                    Editable = false;
                    field("Item No"; Rec.ItemNo)
                    {
                        Caption = 'Item No';
                        ApplicationArea = All;
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                    }
                    field("Item Category Code"; Rec."Item Category Code")
                    {
                        ApplicationArea = All;
                    }
                    field(Vendor; Rec.Vendor)
                    {
                        ApplicationArea = All;
                    }
                    field("PO Qty"; Rec."PO Qty")
                    {
                        ApplicationArea = All;
                    }
                    field(Inventory; Rec.Inventory)
                    {
                        ApplicationArea = All;
                    }
                    field(Reserved; Rec.Reserved)
                    {
                        ApplicationArea = All;
                    }
                    field(BackOrders; Rec.BackOrders)
                    {
                        ApplicationArea = All;
                    }
                    field(Order_In; Rec.Order_In)
                    {
                        Caption = 'Order In';
                        ApplicationArea = All;
                    }
                    field(PO_Qty_To_Max; Rec.PO_Qty_To_Max)
                    {
                        Caption = 'PO Qty To Max';
                        ApplicationArea = All;
                    }
                    field(Supp_Min_Order_Level; Rec.Supp_Min_Order_Level)
                    {
                        Caption = 'Supp Min Order Level';
                        ApplicationArea = All;
                    }
                    field(Current_Min; Rec.Current_Min)
                    {
                        Caption = 'Current Min';
                        ApplicationArea = All;
                    }
                    field(Current_Max; Rec.Current_Max)
                    {
                        Caption = 'Current Max';
                        ApplicationArea = All;
                    }
                    field(Costprice; Rec.Costprice)
                    {
                        ApplicationArea = All;
                    }
                    field(EOQ; Rec.EOQ)
                    {
                        ApplicationArea = All;
                    }
                    field(Sales_Per_Day_Qnty; Rec.Sales_Per_Day_Qnty)
                    {
                        Caption = 'Sales Per Day Qnty';
                        ApplicationArea = All;
                    }
                    field(Supplier_Lead_Time; Rec.Supplier_Lead_Time)
                    {
                        Caption = 'Supplier Lead Time';
                        ApplicationArea = All;
                    }
                    field(Narrative; Rec.Narrative)
                    {
                        ApplicationArea = All;
                    }
                    field(POFrequency; Rec.POFrequency)
                    {
                        ApplicationArea = All;
                    }
                    field(NextSupplierDate; Rec.NextSupplierDate)
                    {
                        ApplicationArea = All;
                    }
                    field(Days_To_Next_Order; Rec.Days_To_Next_Order)
                    {
                        Caption = 'Days To Next Order';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Review)
            {
                Caption = 'Review';
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    cu_GeneratePO: Codeunit GeneratePO;
                begin
                    cu_GeneratePO.GetPOData(stkCode, vendorVar, sortkey, PObackOrders, overridePO, zeroValuePO, backOrder);
                    if not zeroValuePO then begin
                        REC.SetFilter("PO Qty", '<>%1', 0.00);
                    end
                    else
                        Rec.Reset();
                end;

            }
            action(CreatePO)
            {
                ApplicationArea = Suite;
                PromotedCategory = Process;
                Caption = 'Create Purchase Orders';
                Image = Document;
                Promoted = true;
                ToolTip = 'Create one or more new purchase orders to buy the items that are required by this sales document, minus any quantity that is already available.';

                trigger OnAction()
                var
                    CU_CreatePurchaseOrder: Codeunit CreatePurchaseOrder;
                    recTempGeneratePO: Record TempGeneratePO;
                begin
                    CurrPage.SetSelectionFilter(recRoutinePO);
                    recTempGeneratePO.DeleteAll();

                    if recRoutinePO.FindSet then begin
                        repeat
                            if recRoutinePO."PO Qty" <> 0.00 then begin
                                CU_CreatePurchaseOrder.InsertRoutinePOTemp(recRoutinePO);
                            end;
                        until recRoutinePO.Next() = 0;
                    end;

                    CU_CreatePurchaseOrder.CreateAndRaisedPO();

                    //02-11-22 Clear result pane after raising PO
                    recRoutinePO.DeleteAll();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        recRoutinePO.DeleteAll();
        PObackOrders := true;

        CurrPage.Update(true);
        CurrPage.SaveRecord();

        recActiveUsers.Reset();
        if recActiveUsers.Count > 1 then begin
            Message('This page is being used by another user');
        end else begin

            recRoutinePO.DeleteAll();
            PObackOrders := true;

            CurrPage.Update(true);
            CurrPage.SaveRecord();
        end;
    end;

    trigger OnInit()
    begin
        recActiveUsers.Reset();
        recActiveUsers.Init();
        recActiveUsers.ID := CreateGuid();
        recActiveUsers.UserID := UserId;
        recActiveUsers.UserCount := getLastUserCount();
        recActiveUsers.Insert(true);
    end;

    trigger OnClosePage()
    begin
        recActiveUsers.DeleteAll(true);
    end;

    procedure getLastUserCount(): Integer
    var
        recActiveUsers: Record ActiveUsers;
        lastCount: Integer;
    begin
        recActiveUsers.Reset();
        if recActiveUsers.FindLast() then begin
            lastCount := recActiveUsers.UserCount + 1;
        end else begin
            lastCount := 1;
        end;
        exit(lastCount);
    end;

    var
        stkCode, vendorVar, sortkey : Code[50];
        overridePO, zeroValuePO, PObackOrders, backOrder : Boolean;
        recRoutinePO: Record RoutinePO;
        recActiveUsers: Record ActiveUsers;


}