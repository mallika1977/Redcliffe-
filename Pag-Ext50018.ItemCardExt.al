pageextension 50018 "ItemCardExt" extends "Item Card"
{
    layout
    {
        addafter(Warehouse)
        {
            group(Customized)
            {
                field("CRM Reference Id"; Rec."CRM Reference Id")
                {
                    ApplicationArea = all;
                }
                field("Type of Test"; Rec."Type of Test")
                {
                    ApplicationArea = all;
                }
                field("Test Type"; Rec."Test Type")
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
