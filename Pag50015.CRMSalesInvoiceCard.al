page 50015 "CRM Sales Invoice Card"
{
    Caption = 'CRM Sales Invoice Card';
    PageType = Card;
    SourceTable = "CRM Sales Invoice Header";
    InsertAllowed = false;
    // Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("CRM Invoice No."; Rec."CRM Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the CRM Invoice No. field.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.';
                }
                field("NAV Invoice No."; Rec."NAV Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NAV Invoice No. field.';
                }
                field("Created At"; Rec."Created At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created At field.';
                }
                field("Updated At"; Rec."Updated At")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Updated At field.';
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Created field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the External Document No. field.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Terms Code field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Processing Centre"; Rec."Processing Centre")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Processing centre field.';
                }
            }

            part(CRMSalesInvoiceLines; "CRM Sales Invoice Subpage")
            {
                ApplicationArea = all;
                SubPageLink = "CRM Invoice No." = Field("CRM Invoice No.");
            }
        }
    }
}
