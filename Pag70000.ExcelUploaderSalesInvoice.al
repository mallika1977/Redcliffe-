page 70000 "Excel Uploader Sales Invoice"
{
    Caption = 'Excel Uploader Sales Invoice';
    PageType = List;
    SourceTable = "Excel Upload Sale Order";
    UsageCategory = Administration;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Code field.';
                }
                field("Dimension 1"; Rec."Dimension 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimension 1 field.';
                }
                field("Dimesion 4"; Rec."Dimesion 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimesion 4 field.';
                }
                field("Dimesnion 2"; Rec."Dimesnion 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimesnion 2 field.';
                }
                field("Dimesnion 3"; Rec."Dimesnion 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dimesnion 3 field.';
                }
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Doc No. field.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("External Doc No"; Rec."External Doc No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Doc No field.';
                }
                field("Invoice Discount"; Rec."Invoice Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Discount field.';
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Type field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Line Discount"; Rec."Line Discount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line Discount field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting No. Series field.';
                }
                field(Quanity; Rec.Quanity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quanity field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
                }
            }
        }
    }
}
