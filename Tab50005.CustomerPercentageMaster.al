table 50005 "Customer Percentage Master"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Customer Percentage List";
    LookupPageId = "Customer Percentage List";
    fields
    {
        field(1; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
            Caption = 'Location Code';
        }
        field(3; "Customer Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            Caption = 'Customer Code';
        }
        field(5; Percentage; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Percentage %';
        }
    }

    keys
    {
        key(Key1; "Location Code", "Customer Code")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}