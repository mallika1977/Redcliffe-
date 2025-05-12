pageextension 50912 "Employee Ledger Ent" extends "Employee Ledger Entries"
{
    layout
    {
        addafter("Remaining Amount")
        {
            field("Running Balance"; Rec."Running Balance")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Detailed &Ledger Entries")
        {
            action("Running Amount Report")
            {
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    VLE: Report "Employee Running Amount";
                    V: Record "Employee Ledger Entry";
                begin
                    V.Reset();
                    V.SetRange("Employee No.", Rec."Employee No.");
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
        VLE: Record "Employee Ledger Entry";
        VLE1: Record "Employee Ledger Entry";
        LastAmount: Decimal;
        SN: Integer;
        X_Vend: Code[30];
    begin
        /*
        LastAmount := 0;
        X_Vend := '';
        VLE.Reset();
        VLE.SetCurrentKey("Employee No.", "Posting Date");
        VLE.ModifyAll("Running Balance", 0);
        VLE.Reset();
        VLE.SetCurrentKey("Employee No.", "Posting Date");
        IF VLE.FindFirst() then begin
            repeat
                if X_Vend <> VLE."Employee No." then
                    LastAmount := 0;
                X_Vend := VLE."Employee No.";
                VLE.CalcFields(Amount);
                VLE."Running Balance" := LastAmount + VLE.Amount;
                LastAmount := VLE."Running Balance";
                VLE.Modify();
            until VLE.Next() = 0;
            Commit();
        end;
        */
    end;

}
