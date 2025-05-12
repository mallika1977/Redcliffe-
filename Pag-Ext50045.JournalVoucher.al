pageextension 50045 JounalVou extends "Journal Voucher"
{
    layout
    {
        // modify(Narration)
        // Add changes to page layout here

        addafter("Nature of Remittance")
        {

            field(Narration1; Rec.Narration)
            {
                Caption = 'Narration';
                ApplicationArea = All;
            }
        }
        addafter("Bal. Account No.")
        {
            field("Bal. Acc. Name"; Rec."Bal. Acc. Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                Rec.Validate("Gen. Bus. Posting Group", '');
                Rec.Validate("Gen. Posting Type", Rec."Gen. Posting Type"::" ");
                Rec.Validate("Gen. Prod. Posting Group", '');
                Rec.Validate("Bal. Gen. Bus. Posting Group");
                Rec.Validate("Bal. Gen. Posting Type", Rec."Bal. Gen. Posting Type"::" ");
                Rec.Validate("Bal. Gen. Prod. Posting Group", '');

            end;
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                US: Record "User Setup";
            begin
                US.Reset();
                IF US.Get(UserId) THEN;
                US.TestField("Allow JV");
            END;

        }
        addafter(Post)
        {
            action("Imprt Excel")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    Report_ImportBatch: Report "Import Batch File";
                    GenJ_T: Record 232;
                    Batch_N: Code[50];
                begin
                    GenJ_T.Reset();
                    clear(Report_ImportBatch);
                    //  Report_ImportBatch.Gen_Batch_Temp("Journal Template Name", "Journal Batch Name");
                    Report_ImportBatch.Run();
                    CurrPage.Update();
                end;
            }
            action("Clear Posting Groups")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ClearLog;
                trigger OnAction()
                var
                    GenLine: Record "Gen. Journal Line";
                begin
                    GenLine.Reset();
                    GenLine.CopyFilters(Rec);
                    GenLine.ModifyAll("Gen. Bus. Posting Group", '');
                    GenLine.ModifyAll("Gen. Posting Type", GenLine."Gen. Posting Type"::" ");
                    GenLine.ModifyAll("Gen. Prod. Posting Group", '');
                    GenLine.ModifyAll("Bal. Gen. Bus. Posting Group", '');
                    GenLine.ModifyAll("Bal. Gen. Posting Type", GenLine."Bal. Gen. Posting Type"::" ");
                    GenLine.ModifyAll("Bal. Gen. Prod. Posting Group", '');
                end;

            }
        }

    }
}