pageextension 50041 "Cust. Led. Entry" extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field(Narration; Rec.Narration)
            {
                ApplicationArea = all;
            }
        }
        modify("Debit Amount")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Credit Amount")
        {
            Visible = true;
            ApplicationArea = all;
        }
        addafter(Amount)
        {
            field("Running Amount"; Rec."Running Amount")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Line Narration")
        {
            action("Running Amount1")
            {
                Caption = 'Running Amount';
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    VLE: Report "Customer Running Amount";
                    V: Record "Cust. Ledger Entry";
                begin
                    V.Reset();
                    V.SetRange("Customer No.", Rec."Customer No.");
                    if V.FindFirst() then begin
                        Clear(VLE);
                        VLE.SetTableView(V);
                        VLE.Run();
                    end;
                end;
            }
        }
    }
    trigger OnOpenPage()
    var
        VLE: Record "Cust. Ledger Entry";
        VLE1: Record "Cust. Ledger Entry";
        LastAmount: Decimal;
        SN: Integer;
        X_Vend: Code[30];
    begin
        /*
        LastAmount := 0;
        X_Vend := '';
        VLE.Reset();
        VLE.SetCurrentKey("Customer No.", "Posting Date");
        VLE.ModifyAll("Running Amount", 0);

        VLE.Reset();
        VLE.SetCurrentKey("Customer No.", "Posting Date");
        IF VLE.FindFirst() then begin
            repeat
                if X_Vend <> VLE."Customer No." then
                    LastAmount := 0;
                X_Vend := VLE."Customer No.";
                VLE.CalcFields(Amount);
                VLE."Running Amount" := LastAmount + VLE.Amount;
                LastAmount := VLE."Running Amount";
                VLE.Modify();
            until VLE.Next() = 0;
            Commit();
        end;
        */
    end;

}

