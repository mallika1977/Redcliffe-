pageextension 50014 "InventorySetupCardExt" extends "Inventory Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(Customized)
            {
                field("Location Nos"; Rec."Location Nos")
                {
                    ApplicationArea = All;
                }
                field("Nav Transfer Order Nos"; Rec."Nav Transfer Order Nos")
                {
                    ApplicationArea = All;
                }


            }
        }

    }
}
