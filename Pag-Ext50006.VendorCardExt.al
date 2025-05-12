pageextension 50006 "VendorCard_Ext" extends "Vendor Card"
{
    layout
    {
        addafter(Contact)
        {
            field("Contact Name"; "Contact Name")
            {
                ApplicationArea = all;
            }
        }
        addafter("Tax Information")
        {
            group(Customized)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("CRM Vendor Ref No."; Rec."CRM Vendor Ref No.")
                {
                    ApplicationArea = all;
                }

                field("CRM Reference Id"; Rec."CRM Reference Id")
                {
                    ApplicationArea = All;

                }
                field("T.A.N. No."; Rec."T.A.N. No.")
                {
                    ApplicationArea = all;
                }
                field(Create; Rec."Created On")
                {
                    ApplicationArea = All;

                }

                field(Update; Rec."Updated On")
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    actions
    {
        addafter("Ledger E&ntries")
        {
            action("Running Amount")
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
                    V.SetRange("Vendor No.", Rec."No.");
                    if V.FindFirst() then begin
                        Clear(VLE);
                        VLE.SetTableView(V);
                        VLE.Run();
                    end;

                end;
            }

            action("Release Vendor")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = Release_VISIBLE;
                trigger OnAction()
                var
                    USER_SETUP: Record "User Setup";
                begin
                    USER_SETUP.Get(UserId);
                    if USER_SETUP."Allow Vendor Release" then begin
                        Rec.TestField("Gen. Bus. Posting Group");
                        Rec.TestField("Vendor Posting Group");
                        Rec.TestField("GST Vendor Type");
                        Rec.Status := Rec.Status::Released;
                        CurrPage.Update();
                    end else
                        Error('You are not allowed to release the Vendor');
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