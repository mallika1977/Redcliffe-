pageextension 50001 "UserSetupext" extends "User Setup"
{
    layout
    {
        addafter(Email)
        {
            // field("Customer Posting Group"; Rec."Customer Posting Group")
            // {
            //     ApplicationArea = All;
            //     TableRelation = "Customer Posting Group";
            // }
            field("Allow Chart Of Acc."; "Allow Chart Of Acc.")
            {
                ApplicationArea = All;
            }
            field("Allow Customer Release"; "Allow Customer Release")
            {
                ApplicationArea = all;
            }
            field("Allow Vendor Release"; Rec."Allow Vendor Release")
            {
                ApplicationArea = all;
            }
            field("Allow SI"; Rec."Allow SI")
            {
                ApplicationArea = all;
            }
            field("Allow PI"; Rec."Allow PI")
            {
                ApplicationArea = all;
            }
            field("Allow Bank Pay-V"; Rec."Allow Bank Pay-V")
            {
                ApplicationArea = all;
            }
            field("Allow Bank Rec-V"; Rec."Allow Bank Rec-V")
            {
                ApplicationArea = all;
            }
            field("Allow Contra-V"; Rec."Allow Contra-V")
            {
                ApplicationArea = all;
            }
            field("Allow JV"; Rec."Allow JV")
            {
                ApplicationArea = all;
            }
            field("Allow Bank Acc."; Rec."Allow Bank Acc.")
            {
                ApplicationArea = all;
            }
            field("Allow GST Rate"; Rec."Allow GST Rate")
            {
                ApplicationArea = all;
            }



        }
    }

    actions
    {
        addlast(processing)
        {
            action("Delete Cust")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    recCust: Record "Customer Buffer";

                begin
                    // SalesInvoicePdf();
                    // recCust.Init();
                    // recCust."NAV Invoice No." := '001';
                    // recCust."CRM Invoice No." := 'INV02';
                    // recCust.Insert();
                    recCust.DeleteAll();

                    // recCust1.Init();
                    // // recCust1."NAV Invoice No." := '001';
                    // recCust1."CRM Invoice No." := 'INV02';
                    // recCust1.Insert();

                    Message('Deleted');
                end;


            }
            action("Delete Location")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    recCust: Record LocationBuffer;

                begin
                    // SalesInvoicePdf();
                    // recCust.Init();
                    // recCust."NAV Invoice No." := '001';
                    // recCust."CRM Invoice No." := 'INV02';
                    // recCust.Insert();
                    recCust.DeleteAll();

                    // recCust1.Init();
                    // // recCust1."NAV Invoice No." := '001';
                    // recCust1."CRM Invoice No." := 'INV02';
                    // recCust1.Insert();

                    Message('Deleted');
                end;
            }

            action("Delete Item")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    recCust: Record "Item Buffer";

                begin
                    // SalesInvoicePdf();

                    recCust.DeleteAll();

                    // recCust1.Init();
                    // // recCust1."NAV Invoice No." := '001';
                    // recCust1."CRM Invoice No." := 'INV02';
                    // recCust1.Insert();

                    Message('Deleted');
                end;
            }

            action("Delete Vendor")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    recCust: Record "Vendor Buffer";

                begin
                    // SalesInvoicePdf();

                    recCust.DeleteAll();

                    // recCust1.Init();
                    // // recCust1."NAV Invoice No." := '001';
                    // recCust1."CRM Invoice No." := 'INV02';
                    // recCust1.Insert();

                    Message('Deleted');
                end;
            }

            action("Insert Purch")
            {
                ApplicationArea = All;
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    recCust1: Record "Purchase Order Buffer New";

                begin


                    recCust1.Init();
                    recCust1."NAV PO No." := '001';
                    recCust1."CRM P.O No." := 'CRMPO0001';
                    recCust1.Insert();

                    Message('Insert');
                end;
            }

        }


    }

}
