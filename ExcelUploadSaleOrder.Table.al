table 70014 "Excel Upload Sale Order"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
            //AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(2; "Doc No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Quanity; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Customer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Order Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Posting No. Series"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Invoice Type"; Enum "Sales Invoice Type")
        {
            Caption = 'Invoice Type';
        }
        field(11; "Dimension 1"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Dimesnion 2"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Dimesnion 3"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Dimesion 4"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(15; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Invoice Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "External Doc No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Line Discount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(19; "Applies-to Doc. Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Applies-to Doc. Type';
            DataClassification = ToBeClassified;
        }
        field(20; "Applies-to Doc. No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
    trigger OnInsert()
    var
        RE_USI: Record "Excel Upload Sale Order";
    begin
        RE_USI.Reset();
        RE_USI.SetCurrentKey("Entry No.");
        if RE_USI.FindLast() then
            "Entry No." := RE_USI."Entry No." + 1;

    end;
}

