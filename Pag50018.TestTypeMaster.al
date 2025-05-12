page 50018 "Test Type Master"
{
    Caption = 'Test Type Master';
    PageType = List;
    SourceTable = "Test Type Master";
    ApplicationArea = all;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
}
