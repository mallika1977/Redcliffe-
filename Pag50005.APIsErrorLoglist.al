page 50005 "APIs Error Log list"
{

    ApplicationArea = All;
    Caption = 'APIs Error Log list';
    PageType = List;
    SourceTable = "APIs Error Log";
    UsageCategory = Administration;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the value of the Entry No field';
                    ApplicationArea = All;
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                }
                field(APIName; Rec.APIName)
                {
                    ApplicationArea = all;
                }
                field("Source No"; Rec."Source No")
                {
                    ApplicationArea = All;
                }
                field(RequestJson; Rec.RequestJson)
                {
                    ApplicationArea = All;
                }
                field(ResponseJson; Rec.ResponseJson)
                {
                    ApplicationArea = All;
                }
                field(User_ID; Rec.User_ID)
                {
                    ApplicationArea = All;
                }

            }
        }
    }

}
