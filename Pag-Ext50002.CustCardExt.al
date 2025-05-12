pageextension 50002 "CustCardExt" extends "Customer Card"
{

    layout
    {
        addafter("Primary Contact No.")
        {
            field("Contact Name"; "Contact Name")
            {
                ApplicationArea = all;
            }
        }

        addafter(Statistics)
        {
            group(Customized)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("CRM Customer Ref No."; Rec."CRM Customer Ref No.")
                {
                    ApplicationArea = all;
                }

                field("CRM Reference Id"; Rec."CRM Reference Id")
                {
                    ApplicationArea = All;

                }
                field(Create; Rec."Created On")
                {
                    ApplicationArea = All;

                }

                field(Update; Rec."Updatet On")
                {
                    ApplicationArea = All;

                }
            }
        }
        addafter("GST Registration No.")
        {
            field("Custom GSTIN"; Rec."Custom GSTIN")
            {
                ApplicationArea = all;
            }
        }


    }

    actions
    {

        addlast(Approval)
        {
            action("Running Amount")
            {
                PromotedIsBig = true;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    VLE: Report "Customer Running Amount";
                    V: Record "Cust. Ledger Entry";
                begin
                    V.Reset();
                    V.SetRange("Customer No.", Rec."No.");
                    if V.FindFirst() then begin
                        Clear(VLE);
                        VLE.SetTableView(V);
                        VLE.Run();
                    end;
                end;
            }
            // action("Create Customer to Lims")
            // {
            //     ApplicationArea = All;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //         RecCust: Record Customer;
            //         RecAPIJson: Codeunit APIJson;
            //     begin
            //         RecCust.Reset();
            //         RecCust.SetRange("No.", Rec."No.");
            //         IF RecCust.FindFirst() then
            //             RecAPIJson.CustomerPost()
            //     end;

            // }
            action("Update Customer to Lims")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                // trigger OnAction()
                // var
                //     RecCust: Record Customer;
                //     RecAPIJson: Codeunit APIJson;
                // begin
                //     RecAPIJson.CustomerPut();

                // end;

            }
            action("Release Customer")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Release_VISIBLE;
                trigger OnAction()
                var
                    User_Setup: Record "User Setup";
                begin
                    User_Setup.Get(UserId);
                    if User_Setup."Allow Customer Release" then begin
                        Rec.TestField("Gen. Bus. Posting Group");
                        Rec.TestField("Customer Posting Group");
                        Rec.TestField("GST Customer Type");
                        Rec.Status := Rec.Status::Released;
                        CurrPage.Update();
                    end else
                        Error('You are not allowed to release the customer');
                end;
            }

        }

    }
    trigger OnOpenPage()
    begin
        if Rec.Status = Rec.Status::Open then
            Release_VISIBLE := true
        else
            Release_VISIBLE := false;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Rec.Status = Rec.Status::Open then
            Release_VISIBLE := true
        else
            Release_VISIBLE := false;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Open then
            Release_VISIBLE := true
        else
            Release_VISIBLE := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.Status = Rec.Status::Open then
            Release_VISIBLE := true
        else
            Release_VISIBLE := false;
    end;

    var
        Release_VISIBLE: Boolean;
}



