pageextension 50003 "CustomerListExt" extends "Customer List"
{

    layout
    {
        addafter("Name 2")
        {
            field(Address; Rec.Address) { ApplicationArea = All; Editable = false; }
            field(City; Rec.City) { ApplicationArea = All; Editable = false; }
            field("GST Registration No."; Rec."GST Registration No.") { ApplicationArea = All; Editable = false; }
            field("P.A.N. No."; Rec."P.A.N. No.") { ApplicationArea = All; Editable = false; }
            field("Assessee Code"; Rec."Assessee Code") { ApplicationArea = All; Editable = false; }
            field("Debit Amount"; REC."Debit Amount") { ApplicationArea = All; Editable = false; }
            field("Credit Amount"; Rec."Credit Amount") { ApplicationArea = All; Editable = false; }

        }
        addafter(Contact)
        {
            field("CRM Reference Id"; Rec."CRM Reference Id")
            {
                ApplicationArea = All;
            }
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter(CustomerLedgerEntries)
        {
            action("Running Amount")
            {
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    VLE: Report "Customer Running Amount";
                    V: Record "Cust. Ledger Entry";
                begin
                    V.Reset();
                    V.SetRange("Customer No.", Rec."No.");
                    if V.FindFirst() then begin
                        Clear(VLE);
                        VLE.SetTableView(V);
                        VLE.Run();
                    end;
                end;
            }
        }
    }
}

