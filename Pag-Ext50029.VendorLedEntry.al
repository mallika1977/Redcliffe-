/// <summary>
/// PageExtension Vendor Led. Entry (ID 50029) extends Record Vendor Ledger Entries.
/// </summary>
pageextension 50029 "Vendor Led. Entry" extends "Vendor Ledger Entries"
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
        addafter("Vendor No.")
        {
            field("Vend. Name"; Rec."Vend. Name")
            {
                Caption = 'Vendor Name';
                ApplicationArea = ALL;
            }
            field("GRN No."; Rec."GRN No.")
            {
                ApplicationArea = ALL;
            }
            field("GRN Date"; Rec."GRN Date")
            {
                ApplicationArea = all;
            }
            field("Vendor Inv No."; Rec."Vendor Inv No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Inv Date"; Rec."Vendor Inv Date")
            {
                ApplicationArea = all;
            }
        }

        addafter(Amount)
        {
            field("Running Amount"; Rec."Running Amount")
            {
                ApplicationArea = all;
            }
            field("Base Amount"; Rec."Base Amount")
            {
                ApplicationArea = all;
            }
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = ALL;

            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = ALL;

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
    }
    actions
    {
        addafter("Line Narration")
        {
            action("Running Amount Report")
            {
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    VLE: Report "Vendor Running Amount";
                    V: Record "Vendor Ledger Entry";
                begin
                    V.Reset();
                    V.SetRange("Vendor No.", Rec."Vendor No.");
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
        VLE: Record "Vendor Ledger Entry";
        VLE1: Record "Vendor Ledger Entry";
        LastAmount: Decimal;
        SN: Integer;
        X_Vend: Code[30];
    begin
        /*
        LastAmount := 0;
        X_Vend := '';
        VLE.Reset();
        VLE.SetCurrentKey("Vendor No.", "Posting Date");
        VLE.ModifyAll("Running Amount", 0);

        VLE.Reset();
        VLE.SetCurrentKey("Vendor No.", "Posting Date");
        IF VLE.FindFirst() then begin
            repeat
                if X_Vend <> VLE."Vendor No." then
                    LastAmount := 0;
                X_Vend := VLE."Vendor No.";
                VLE.CalcFields(Amount);
                VLE."Running Amount" := LastAmount + (VLE.Amount * -1);
                LastAmount := VLE."Running Amount";
                VLE.Modify();
            until VLE.Next() = 0;
            Commit();
        end;
        */
    end;


}
pageextension 50047 "PSI" extends "Posted Sales Invoices"
{
    layout
    {
        addafter(Amount)
        {
            field("IGST Amount"; Rec."IGST Amount") { ApplicationArea = all; }
            field("CGST Amount"; Rec."CGST Amount") { ApplicationArea = all; }
            field("SGST Amount"; Rec."SGST Amount") { ApplicationArea = all; }
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
            }
        }
    }

}

