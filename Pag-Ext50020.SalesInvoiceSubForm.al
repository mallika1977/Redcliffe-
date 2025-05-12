pageextension 50020 "SalesInvoiceSubForm" extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Location Code")
        {

            field("Patient ID"; Rec."Patient ID")
            {
                ApplicationArea = All;
            }
            field("Patient name"; Rec."Patient name")
            {
                ApplicationArea = All;
            }
            field("Child ID"; Rec."Child ID")
            {
                ApplicationArea = All;
            }

            field("Child Name"; Rec."Child Name")
            {
                ApplicationArea = All;
            }
            field("Coupon ID"; Rec."Coupon ID")
            {
                ApplicationArea = all;
            }


        }
    }
}
