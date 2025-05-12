page 50016 "CRM Sales Invoice Subpage"
{
    Caption = 'CRM Sales Invoice Subpage';
    PageType = ListPart;
    SourceTable = "CRM Sales Invoice Line";

    layout
    {
        area(content)
        {
            repeater(General)
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
                field(UOM; Rec.UOM)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UOM field.';
                }
                field("Item Type"; Rec."Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Type field.';
                }
                field("Line No"; Rec."Line No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field("Item Code"; Rec."Item Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item Code field.';
                }
                field(Qty; Rec.Qty)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty field.';
                }
                field("Gst Group Code"; Rec."Gst Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gst Group Code field.';
                }
                field("HSN Code"; Rec."HSN Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the HSN Code field.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit Price field.';
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
                field("Patient ID"; Rec."Patient ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Patient ID field.';
                }
                field("Patient name"; Rec."Patient name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Patient name field.';
                }
                field("Child ID"; Rec."Child ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Child ID field.';
                }
                field("Child Name"; Rec."Child Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Child Name field.';
                }
                field("Coupon ID"; Rec."Coupon ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Coupon ID field.';
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment Date field.';
                }
                field("Booking ID"; Rec."Booking ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Booking ID field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("Bank Account Code"; Rec."Bank Account Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Bank Account Code field.';
                }
                field("Type of Test"; Rec."Type of Test")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type of Test field.';
                }
                field("No. of Test"; Rec."No. of Test")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. of Test field.';
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Age field.';
                }
                field("NAV Payment No."; Rec."NAV Payment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NAV Payment No. field.';
                }
                field("Brand Id"; Rec."Brand Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Brand Id field.';
                }
                field("Remove Line"; Rec."Remove Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remove Line field.';
                }
                field(UID; Rec.UID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the UID field.';
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
            }
        }
    }
}
