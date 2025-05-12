pageextension 50048 BankAccListExt extends "Bank Account List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field(Address; Address)
            {
                ApplicationArea = All;
            }
            field("Address 2"; "Address 2")
            {
                ApplicationArea = All;
            }
            field(City; City)
            {
                ApplicationArea = All;
            }
            field("Bank Category";"Bank Category")
            {
                ApplicationArea = All;
                
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}