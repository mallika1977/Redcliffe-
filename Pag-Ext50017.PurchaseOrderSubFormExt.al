pageextension 50017 "PurchaseOrderSubFormExt" extends "Purchase Order Subform"
{

    layout
    {

        addafter("Location Code")
        {

            field("Batch No."; Rec."Batch No.")
            {
                ApplicationArea = All;
            }

            field("Expiry Date"; Rec."Expiry Date")
            {
                ApplicationArea = All;
            }



        }
    }
}
