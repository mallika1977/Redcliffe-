table 50001 "Customer Buffer"
{
    Caption = 'Customer Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;

        }

        field(3; "Name 2"; Text[50])
        {
            Caption = 'Name 2';
            DataClassification = CustomerContent;
        }
        field(4; Address; Text[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(5; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
            DataClassification = CustomerContent;
        }
        field(6; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            //TableRelation = "Country/Region";
            DataClassification = CustomerContent;

        }
        field(7; City; Text[30])
        {
            Caption = 'City';
            // TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code".City
            // ELSE
            // IF ("Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            // ValidateTableRelation = false;
            DataClassification = CustomerContent;

        }
        field(8; "State Code"; Code[10])
        {
            //CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'State Code';
            DataClassification = CustomerContent;
        }

        field(9; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF ("Country/Region Code" = CONST('')) "Post Code"
            ELSE
            IF ("Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
            DataClassification = CustomerContent;


        }

        field(10; "E-Mail"; Text[80])
        {
            Caption = 'Email';
            ExtendedDatatype = EMail;
            DataClassification = CustomerContent;
        }

        field(11; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
            DataClassification = CustomerContent;

        }
        field(12; "Telex No."; Text[20])
        {
            Caption = 'Telex No.';
            DataClassification = CustomerContent;
        }
        field(13; "CRM Reference Id"; Code[20])
        {
            Caption = 'CRM Reference Id';
            DataClassification = CustomerContent;
        }
        field(14; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."));
            DataClassification = CustomerContent;
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;

        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;

        }
        field(17; "Credit Limit (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Credit Limit';
            DataClassification = CustomerContent;
        }
        field(18; "Credit Days"; Integer)
        {

            Caption = 'Credit Days';
            DataClassification = CustomerContent;

        }
        field(19; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
            DataClassification = CustomerContent;
        }
        field(20; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
            DataClassification = CustomerContent;
        }
        field(21; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
            DataClassification = CustomerContent;
        }

        field(22; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
            DataClassification = CustomerContent;
        }
        field(23; "Shipping Agent Code"; Code[10])
        {
            AccessByPermission = TableData "Shipping Agent Services" = R;
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
            DataClassification = CustomerContent;
        }

        field(24; Blocked; Enum "Customer Blocked")
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;

        }

        field(25; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
            DataClassification = CustomerContent;
        }
        field(26; "Created By"; Text[50])
        {
            Caption = 'Creation By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(27; "Created On"; Date)
        {
            Caption = 'Created On';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(28; "Updated On"; Date)
        {

            Caption = 'Updated On';
            DataClassification = CustomerContent;
        }
        field(29; "Updated By"; Text[50])
        {

            Caption = 'Updated By';
            DataClassification = CustomerContent;
        }

        field(30; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }

        field(31; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(32; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "Gen. Business Posting Group";
        }
        field(33; "User_ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = CustomerContent;

        }

        field(34; "Line No."; Integer)
        {
            Caption = 'Line No';
            DataClassification = CustomerContent;

        }
        field(35; Status; Enum "Purchase Document Status")
        {
            Caption = 'Status';
            Editable = false;
        }
        field(38; "GST Registration No."; Code[15])
        {
            DataClassification = CustomerContent;
        }
        field(39; "GST Customer Type"; Integer)
        {
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(Key1; "Line No.", "Customer No.")
        {
            Clustered = true;
        }
    }
    var
        loc: Record Location;
}
