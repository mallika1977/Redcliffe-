pageextension 50013 "GeneralLedgerSetupExt" extends "General Ledger Setup"
{
    layout
    {
        addafter(Application)
        {
            group(Customized)
            {
                field("Item Nos"; Rec."Item Nos")
                {
                    ApplicationArea = All;
                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = ALL;
                }

                field("Item Nos New"; Rec."Item Nos New")
                {
                    ApplicationArea = all;
                }
                field("User Access 1"; Rec."User Access 1")
                {
                    ApplicationArea = all;
                }
                field("User Access 2"; Rec."User Access 2")
                {
                    ApplicationArea = all;
                }
                group(Payment)
                {
                    field("Auto Payment Nos"; Rec."Auto Payment Nos")
                    {
                        ApplicationArea = All;
                    }

                    field("Auto Payment Template Name"; Rec."Auto Payment Template Name")
                    {
                        ApplicationArea = all;
                    }
                    field("Auto Payment Jnl Batch Name"; Rec."Auto Payment Jnl Batch Name")
                    {
                        ApplicationArea = All;
                    }

                }

            }

        }
    }
    actions
    {
        addafter("Bank Posting")
        {
            action("Update Rounding")
            {
                ApplicationArea = ALl;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;
                trigger OnAction()
                begin
                    Rec."Inv. Rounding Precision (LCY)" := 0.01;
                    Rec."Amount Rounding Precision" := 0.01;
                    Rec.Modify();
                end;
            }

        }
    }

}
