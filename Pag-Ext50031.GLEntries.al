pageextension 50031 "GL Entries" extends "General Ledger Entries"
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
        moveafter("Document No."; "Source No.")
        addafter("Source No.")
        {


            field("Source Name"; Rec."Source Name")
            {
                ApplicationArea = all;
            }
            field("Vendor Name"; Rec."Vendor Name") { ApplicationArea = all; }
            field("External Doc No."; "External Doc No.") { ApplicationArea = all; }
            field("Assessee Code"; Rec."Assessee Code") { ApplicationArea = all; }
            field("P.A.N. No."; Rec."P.A.N. No.") { ApplicationArea = all; }


        }

        addafter(Amount)
        {
            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = ALL;

            }

            field("TDS Base Amount"; Rec."TDS Base Amount")
            {
                ApplicationArea = all;
            }
            field("TDS Rate"; Rec."TDS Rate")
            {
                ApplicationArea = all;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = ALL;

            }
            field("TDS Section"; Rec."TDS Section")
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
    }
    actions
    {
        addafter("Print Voucher")
        {
            action("Update V")
            {
                ApplicationArea = ALL;
                Promoted = true;
                Visible = false;
                trigger OnAction()
                var
                    VLE: Record "Vendor Ledger Entry";
                    CLE: Record "Cust. Ledger Entry";
                    GLE: Record "G/L Entry";
                BEGIN
                    GLE.Reset();
                    GLE.SetRange("Source No.", '');
                    IF GLE.FindFirst() THEN
                        repeat
                            VLE.Reset();
                            VLE.SetRange("Document No.", GLE."Document No.");
                            VLE.SetRange("Posting Date", GLE."Posting Date");
                            IF VLE.FindFirst() THEN begin
                                GLE."Source Type" := GLE."Source Type"::Vendor;
                                GLE."Source No." := VLE."Vendor No.";
                                GLE.Modify();
                            end;
                            CLE.Reset();
                            CLE.SetRange("Document No.", GLE."Document No.");
                            CLE.SetRange("Posting Date", GLE."Posting Date");
                            IF CLE.FindFirst() THEN begin
                                GLE."Source Type" := GLE."Source Type"::Customer;
                                GLE."Source No." := CLE."Customer No.";
                                GLE.Modify();
                            end;
                        until GLE.Next() = 0;

                END;
            }
        }
    }
    trigger OnOpenPage()
    begin
        GetName()
    end;

    procedure GetName()
    var
        GL: Record "G/L Entry";
        Cust: Record Customer;
        Vend: record Vendor;
    begin
        GL.Reset();
        GL.SetFilter("Source Type", '%1|%2', GL."Source Type"::Customer, GL."Source Type"::Vendor);
        GL.SetRange("Source Name", '');
        IF GL.FindFirst() THEN
            REPEAT
                IF GL."Source Type" = GL."Source Type"::Customer then begin
                    Cust.GET(GL."Source No.");
                    GL."Source Name" := Cust.Name;
                end;
                IF GL."Source Type" = GL."Source Type"::Vendor then begin
                    Vend.GET(GL."Source No.");
                    GL."Source Name" := Vend.Name;
                end;
                GL.Modify();
            until GL.Next() = 0;
    end;

}
