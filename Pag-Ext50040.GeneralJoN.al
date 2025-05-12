pageextension 50040 "General JoN" extends "General Journal"
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
    }
    actions
    {
        // Add changes to page actions here
        addafter(Post)
        {
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
