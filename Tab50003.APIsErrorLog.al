table 50003 "APIs Error Log"
{
    DataClassification = CustomerContent;
    Caption = 'APIs Error Log';
    fields
    {
        field(1; "Entry No"; Integer)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;

        }
        field(2; "Transaction Type"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Transaction Type';

        }
        field(3; "Source No"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(4; "APIName"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'API Name';


        }
        field(5; "RequestJson"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Request Json';


        }
        field(6; "ResponseJson"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Response Json';


        }
        field(7; "Created On"; DateTime)
        {
            DataClassification = CustomerContent;

        }

        field(8; "Created By"; Text[120])
        {
            DataClassification = CustomerContent;

        }
        field(9; "User_ID"; Text[50])
        {
            DataClassification = CustomerContent;

        }


    }
    keys
    {

        key(Key1; "Entry No")
        {
        }
    }

}