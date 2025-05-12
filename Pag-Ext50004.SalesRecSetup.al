pageextension 50004 "SalesRecSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addbefore(Archiving)
        {

            group(Customized)
            {
                field("Cust Nos"; Rec."Cust Nos")
                {
                    ApplicationArea = all;
                }

                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    ApplicationArea = All;

                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;

                }
                field("NAV Invoice Nos."; Rec."NAV Invoice Nos.")
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
            action("Insert Cust")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    recCust: Record "CRM Transfer Order Buffer";
                begin
                    recCust.Init();
                    recCust."CRM Document No." := 'INV';
                    recCust."Line No" := 10000;
                    recCust.Insert();
                    Message('Done');
                end;


            }

        }


    }

}
