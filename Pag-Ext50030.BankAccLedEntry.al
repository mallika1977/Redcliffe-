/// <summary>
/// PageExtension Bank Acc Led. Entry (ID 50030) extends Record Bank Account Ledger Entries.
/// </summary>
pageextension 50030 "Bank Acc Led. Entry" extends "Bank Account Ledger Entries"
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
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
        modify("Bal. Account No.")
        {
            Visible = true;
        }
        addafter(Narration)
        {
            field("Vendor Name"; Rec."Vendor Name")
            {
                Caption = 'Source Name';
                ApplicationArea = all;
            }
        }
    }
    trigger OnOpenPage()
    var
        BALE: Record "Bank Account Ledger Entry";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FixAc: Record "Fixed Asset";
        Emp: Record Employee;
        GLA: Record "G/L Account";
    begin
        BALE.Reset();
        BALE.SetRange("Vendor Name", '');
        IF BALE.FindFirst() then
            repeat
                Cust.Reset();
                Vend.Reset();
                BankAcc.Reset();
                FixAc.Reset();
                Emp.Reset();
                GLA.Reset();
                IF BALE."Bal. Account Type" = BALE."Bal. Account Type"::"Bank Account" then begin
                    if BankAcc.get(BALE."Bal. Account No.") then
                        BALE."Vendor Name" := BankAcc.Name;
                end;
                IF BALE."Bal. Account Type" = BALE."Bal. Account Type"::Customer then begin
                    if Cust.get(BALE."Bal. Account No.") then
                        BALE."Vendor Name" := Cust.Name;
                end;
                IF BALE."Bal. Account Type" = BALE."Bal. Account Type"::Vendor then begin
                    if Vend.get(BALE."Bal. Account No.") then
                        BALE."Vendor Name" := Vend.Name;
                end;
                IF BALE."Bal. Account Type" = BALE."Bal. Account Type"::"Fixed Asset" then begin
                    if FixAc.get(BALE."Bal. Account No.") then
                        BALE."Vendor Name" := FixAc.Description;
                end;
                IF BALE."Bal. Account Type" = BALE."Bal. Account Type"::"G/L Account" then begin
                    if GLA.get(BALE."Bal. Account No.") then
                        BALE."Vendor Name" := GLA.Name;
                end;
                IF BALE."Bal. Account Type" = BALE."Bal. Account Type"::Employee then begin
                    if Emp.get(BALE."Bal. Account No.") then
                        BALE."Vendor Name" := Emp."First Name" + ' ' + Emp."Last Name";
                end;
                BALE.Modify();
            until BALE.Next() = 0;
    end;
}
