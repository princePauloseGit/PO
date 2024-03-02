page 50114 "View Min Max"
{
    Caption = 'View Min-Max';
    PageType = ListPlus;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ResultMinMaxCalc;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DataCaptionExpression = 'View Min-Max Calculation';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Criteria';
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
            group(Result)
            {
                repeater(Data)
                {
                    Editable = false;
                    field("Item No"; Rec."Item No")
                    {
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
                    field("Current Min"; Rec."Current Min")
                    {
                        ApplicationArea = All;
                    }
                    field("New Min"; Rec."New Min")
                    {
                        ApplicationArea = All;
                    }
                    field("Current Max"; Rec."Current Max")
                    {
                        ApplicationArea = All;
                    }
                    field("New Max"; Rec."New Max")
                    {
                        ApplicationArea = All;
                    }
                    field("New Po Qnty"; Rec."New Po Qnty")
                    {
                        ApplicationArea = All;
                    }
                    field("Min Source"; Rec."Min Source")
                    {
                        ApplicationArea = All;
                    }
                    field("Nos Order Days"; Rec."Nos Order Days")
                    {
                        ApplicationArea = All;
                    }
                    field("Nos Order Excluded"; Rec."Nos Order Excluded")
                    {
                        ApplicationArea = All;
                    }
                    field("Nos Sales Order In Prd"; Rec."Nos Sales Order In Prd")
                    {
                        ApplicationArea = All;
                    }
                    field("Nos Sales Order Per Day"; Rec."Nos Sales Order Per Day")
                    {
                        ApplicationArea = All;
                    }
                    field("Supplier Lead Time"; Rec."Supplier Lead Time")
                    {
                        ApplicationArea = All;
                    }
                    field("Supplier Order Cycle"; Rec."Supplier Order Cycle")
                    {
                        ApplicationArea = All;
                    }
                    field("Meas Lead Time Days"; Rec."Meas Lead Time Days")
                    {
                        ApplicationArea = All;
                    }
                    field("Days To Next Order Cycle"; Rec."Days To Next Order Cycle")
                    {
                        ApplicationArea = All;
                    }
                    field(Excluded; Rec.Excluded)
                    {
                        ApplicationArea = All;
                    }
                    field("Excluded Reason"; Rec."Excluded Reason")
                    {
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
            action(Process)
            {
                Caption = 'Process';
                Promoted = true;
                PromotedCategory = Process;
                Image = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    cu_ApplyMinCalc: Codeunit ApplyMinCalc;
                    cu_ApplyMaxCalc: Codeunit ApplyMaxCalc;
                    cu_ResultMinMax: Codeunit ResultMinMaxCalc;

                begin
                    cu_ApplyMinCalc.ApplyMinCalculation(stkCode, vendorVar, sortkey);
                    cu_ApplyMaxCalc.Run();
                    // cu_ApplyMinCalc.SOStockAvg();
                    cu_ResultMinMax.ProcessCal(stkCode, vendorVar, sortkey);
                end;

            }
            action(UpdateMin)
            {
                Caption = 'Update Min';
                Promoted = true;
                PromotedCategory = Process;
                Image = Save;
                ApplicationArea = All;
                trigger OnAction()
                var
                    cu_updateMinMax: Codeunit UpdateMinMax;
                    cu_ApplyMinCalc: Codeunit ApplyMinCalc;
                    cu_ApplyMaxCalc: Codeunit ApplyMaxCalc;
                    cu_ResultMinMax: Codeunit ResultMinMaxCalc;
                begin
                    CurrPage.SetSelectionFilter(recResultMinMaxCalc);
                    if recResultMinMaxCalc.FindSet then begin
                        repeat
                            cu_updateMinMax.updateMin(recResultMinMaxCalc."Item No", recResultMinMaxCalc."New Min");
                        until recResultMinMaxCalc.Next() = 0;
                    end;
                    cu_ApplyMinCalc.ApplyMinCalculation(stkCode, vendorVar, sortkey);
                    cu_ApplyMaxCalc.Run();
                    cu_ResultMinMax.ProcessCal(stkCode, vendorVar, sortkey);
                    Message('Item`s Min Calculation Updated Successfully');
                end;

            }
            action(UpdateMax)
            {
                Caption = 'Update Max';
                Promoted = true;
                PromotedCategory = Process;
                Image = Save;
                ApplicationArea = All;
                trigger OnAction()
                var
                    cu_updateMinMax: Codeunit UpdateMinMax;
                    cu_ApplyMinCalc: Codeunit ApplyMinCalc;
                    cu_ApplyMaxCalc: Codeunit ApplyMaxCalc;
                    codResultMinMax: Codeunit ResultMinMaxCalc;
                begin
                    CurrPage.SetSelectionFilter(recResultMinMaxCalc);
                    if recResultMinMaxCalc.FindSet then begin
                        repeat
                            cu_updateMinMax.updateMax(recResultMinMaxCalc."Item No", recResultMinMaxCalc."New Max");
                        until recResultMinMaxCalc.Next() = 0;
                    end;
                    cu_ApplyMinCalc.ApplyMinCalculation(stkCode, vendorVar, sortkey);
                    cu_ApplyMaxCalc.Run();
                    codResultMinMax.ProcessCal(stkCode, vendorVar, sortkey);
                    Message('Item`s Max Calculation Updated Successfully');
                end;
            }
            action(UpdateMinMax)
            {
                Caption = 'Update Min Max';
                Promoted = true;
                PromotedCategory = Process;
                Image = Save;
                ApplicationArea = All;
                trigger OnAction()
                var
                    cu_updateMinMax: Codeunit UpdateMinMax;
                    cu_ApplyMinCalc: Codeunit ApplyMinCalc;
                    cu_ApplyMaxCalc: Codeunit ApplyMaxCalc;
                    cu_ResultMinMax: Codeunit ResultMinMaxCalc;
                begin
                    CurrPage.SetSelectionFilter(recResultMinMaxCalc);
                    if recResultMinMaxCalc.FindSet and not recResultMinMaxCalc.Excluded then begin
                        repeat
                            cu_updateMinMax.updateMinMax(recResultMinMaxCalc."Item No", recResultMinMaxCalc."New Min", recResultMinMaxCalc."New Max", recResultMinMaxCalc."Current Min", recResultMinMaxCalc."Current Max");
                        until recResultMinMaxCalc.Next() = 0;
                    end;
                    cu_ApplyMinCalc.ApplyMinCalculation(stkCode, vendorVar, sortkey);
                    cu_ApplyMaxCalc.Run();
                    cu_ResultMinMax.ProcessCal(stkCode, vendorVar, sortkey);
                    Message('Item`s Min Max Calculation Updated Successfully');
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        recResultMinMaxCalc.DeleteAll();
    end;

    var
        stkCode, vendorVar, sortkey : Code[50];
        recResultMinMaxCalc: Record ResultMinMaxCalc;
}