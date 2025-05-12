pageextension 50026 "Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Item No.")
        {
            field("Test Type"; Rec."Test Type")
            {
                ApplicationArea = all;
            }
        }
    }
}
