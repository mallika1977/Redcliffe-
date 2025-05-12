pageextension 50023 "FASetupExt" extends "Fixed Asset Setup"
{
    layout
    {
        addafter(Numbering)
        {

            group(Customized)
            {
                field("Nav FA Nos"; rEC."Nav FA Nos")
                {
                    ApplicationArea = aLL;
                }
            }

        }
    }
    actions
    {
        addafter("Depreciation Books")
        {
            action(FAInsert)
            {
                ApplicationArea = all;
                trigger OnAction()
                Var
                    fa: Record "CRM Fixed Asset Buffer";
                begin
                    fa.Init();
                    fa."CRM FA No." := '0001';
                    fa.Insert();

                end;
            }
        }
    }
}
