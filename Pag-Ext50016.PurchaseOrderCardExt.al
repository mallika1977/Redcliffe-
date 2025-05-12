pageextension 50016 "PurchaseOrderCardExt" extends "Purchase Order"
{
    layout
    {


        addafter("Order Date")
        {
            field("PO Date"; "PO Date")
            {
                ApplicationArea = ALL;
            }
            field("GRN Date"; "GRN Date")
            {
                ApplicationArea = ALL;
            }
            field("Vendor Quotation/Reference"; Rec."Vendor Quotation/Reference")
            {
                ApplicationArea = ALL;
            }
            field(Warranty; Rec.Warranty)
            {
                ApplicationArea = ALL;
            }
            field("AMC/CMC "; Rec."AMC/CMC ")
            {
                ApplicationArea = ALL;
            }
        }
        addafter(Prepayment)
        {
            group(Customized)
            {
                field("Challan No."; Rec."Challan No.")
                {
                    ApplicationArea = All;
                }

                field("Challan Date"; Rec."Challan Date")
                {
                    ApplicationArea = All;
                }
                field("Gate Entry No."; Rec."Gate Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Gate Entry Date"; Rec."Gate Entry Date")
                {
                    ApplicationArea = All;
                }

                field("CRM P.O No."; Rec."CRM P.O No.")
                {
                    ApplicationArea = All;
                }
                field("GRN No"; Rec."GRN No")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Document PDF"; Rec."Document PDF")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = all;
            }

        }
        moveafter("Vendor Invoice No."; "Location Code")

        addafter("Buy-from Contact")
        {
            field("Contact Name"; "Contact Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                ShipToOptions := ShipToOptions::Location;
            end;
        }

    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ShipToOptions := ShipToOptions::Location;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ShipToOptions := ShipToOptions::Location;
    end;
}

