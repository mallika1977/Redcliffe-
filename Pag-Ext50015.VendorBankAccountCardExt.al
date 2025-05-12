pageextension 50015 "VendorBankAccountCardExt" extends "Vendor Bank Account Card"
{
    layout
    {
        addafter(Transfer)
        {
            group(Customized)
            {
                field("IFSC Code"; Rec."IFSC Code")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = ALL;
                }
                field("Account Holder Name"; Rec."Account Holder Name")
                {
                    ApplicationArea = ALL;
                }
                field("Signatory Name"; Rec."Signatory Name")
                {
                    ApplicationArea = ALL;
                }

            }

        }
    }
}
