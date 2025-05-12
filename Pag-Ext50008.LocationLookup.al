pageextension 50008 "LocationLookup" extends "Location List"
{
    layout
    {
        addafter(Name)
        {
            field("Lab Code"; Rec."Lab Code")
            {

                ApplicationArea = all;
            }
        }
    }
}