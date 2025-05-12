table 50002 "Item Buffer"
{
    Caption = 'Item Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

        }
        field(3; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = CustomerContent;
        }
        field(4; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            DataClassification = CustomerContent;
            TableRelation = "Unit of Measure";
        }
        field(5; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(6; "Block Reason"; Text[250])
        {
            Caption = 'Block Reason';
            DataClassification = CustomerContent;

        }
        field(7; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
            DataClassification = CustomerContent;

        }
        field(8; "Sales Unit of Measure"; Code[10])
        {
            Caption = 'Sales Unit of Measure';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }


        field(9; "CRM Reference Id"; Code[20])
        {
            Caption = 'CRM Reference Id';
            DataClassification = CustomerContent;
        }
        field(10; "Created By"; Text[50])
        {
            Caption = 'Creation By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(11; "Created On"; Date)
        {
            Caption = 'Created On';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(13; "Updated On"; Date)
        {

            Caption = 'Updated On';
            DataClassification = CustomerContent;
        }
        field(14; "Updated By"; Text[50])
        {

            Caption = 'Updated By';
            DataClassification = CustomerContent;
        }
        field(15; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';

            DataClassification = CustomerContent;
        }

        field(5900; "Service Item Group"; Code[10])
        {
            Caption = 'Service Item Group';

            DataClassification = CustomerContent;
        }
        field(16; "GST Group Code"; Code[10])
        {
            Caption = 'GST Group Code';
            DataClassification = CustomerContent;

        }
        field(17; "HSN\SAC Code"; code[10])
        {
            Caption = 'HSN\SAC Code';
            DataClassification = CustomerContent;

        }

        field(18; "User_ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;

        }

        field(19; "Line No."; Integer)
        {
            Caption = 'Line No';
            DataClassification = CustomerContent;

        }
        field(20; "Item Unit of Measure Code"; Code[10])
        {
            Caption = 'Item Unit of Measure Code';
            DataClassification = CustomerContent;

        }

        field(21; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            InitValue = 1;
            DataClassification = CustomerContent;
        }
        field(22; "Type"; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(23; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = CustomerContent;
        }

        field(24; "Test Type"; Code[20])
        {
            DataClassification = ToBeClassified;

        }


    }

    keys
    {
        key(Key1; "Line No.", "Item No.")
        {
            Clustered = true;
        }
    }
}
