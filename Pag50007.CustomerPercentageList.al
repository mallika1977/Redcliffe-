page 50007 "Customer Percentage List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Customer Percentage Master";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;

                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;

                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

}