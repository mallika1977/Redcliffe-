pageextension 50005 "PurchPaySetup" extends "Purchases & Payables Setup"
{
    layout
    {
        addbefore(Archiving)
        {

            group(Customized)
            {
                field("Vend Nos"; Rec."Vend Nos")
                {
                    ApplicationArea = All;
                }
                field("Vendor Posting Group"; Rec."Vendor Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                }
                field("NAV PO Nos."; Rec."NAV PO Nos.")
                {
                    ApplicationArea = All;
                }
                field("NAV PO Nos. New"; "NAV PO Nos. New")
                {
                    ApplicationArea = All;
                }

            }
        }

    }

    actions
    {
        addlast(processing)
        {
            action("Insert Vend")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    recCust: Record "CRM Purchase Order Buffer";
                begin
                    // recCust.Init();
                    // recCust."CRM Reference Id" := 'CRM0001';
                    // recCust.Name := 'Vendor Test';
                    // recCust.Insert();
                    recCust.DeleteAll();
                end;


            }

        }


    }

}
