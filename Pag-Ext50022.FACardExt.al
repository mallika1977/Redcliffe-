pageextension 50022 "FACardExt" extends "Fixed Asset Card"
{
    layout
    {

        addafter(Maintenance)
        {
            group(Customized)
            {
                field("CRM FA No."; Rec."CRM FA No.")
                {
                    ApplicationArea = All;
                }

                field("Created On"; Rec."Created On")
                {
                    ApplicationArea = All;
                }
                field("Updatet On"; Rec."Updatet On")
                {
                    ApplicationArea = All;
                }




            }
        }
    }
}
