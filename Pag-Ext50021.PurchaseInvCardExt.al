/// <summary>
/// PageExtension PurchaseInvCardExt (ID 50021) extends Record Purchase Invoice.
/// </summary>
pageextension 50021 "PurchaseInvCardExt" extends "Purchase Invoice"
{
    layout
    {
        modify("Due Date")
        {
            Editable = false;
        }
        addafter("Vendor Invoice No.")
        {
            field("Vendor Invoice Date"; Rec."Vendor Invoice Date")
            {
                ApplicationArea = all;
            }
            field("GRN No"; Rec."GRN No")
            {
                ApplicationArea = All;
            }
            field("GRN Date"; Rec."GRN Date")
            {
                ApplicationArea = ALL;
            }
            field("PO Date"; Rec."PO Date")
            {
                ApplicationArea = ALL;
            }
            field("Posting No. Series"; Rec."Posting No. Series")
            {
                ApplicationArea = ALL;
            }
            field(Narration; Rec.Narration)
            {
                ApplicationArea = All;
            }
            field("Nature Type"; Rec."Nature Type")
            {
                ApplicationArea = All;
            }
        }

        addafter("Buy-from Contact")
        {
            field("Contact Name"; Rec."Contact Name")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Vendor Invoice No."; "Location Code")
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                ShipToOptions := ShipToOptions::Location;
            end;
        }

    }
    actions
    {
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            var
                US: Record "User Setup";
            begin
                US.Reset();
                IF US.Get(UserId) THEN;
                US.TestField("Allow PI");
            end;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                US: Record "User Setup";
            begin
                US.Reset();
                IF US.Get(UserId) THEN;
                US.TestField("Allow PI");
                Rec.TestField("Nature Type");
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Get(UserId);
                UserSetup.TestField("Allow PI");
                Rec.TestField("Nature Type");
            end;
        }

        modify(Preview)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Nature Type");
            end;
        }

        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField("Nature Type");
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
