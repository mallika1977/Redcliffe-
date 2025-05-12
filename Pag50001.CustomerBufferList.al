page 50001 "Customer Buffer List"
{
    PageType = API;
    APIVersion = 'v1.0';
    APIPublisher = 'ANI';
    APIGroup = 'CustomerBuffer';
    SourceTable = "Customer Buffer";
    Caption = 'Customer Buffer List';
    ApplicationArea = All;
    UsageCategory = Administration;
    EntityName = 'tB';
    EntitySetName = 'tB';
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            repeater(GroupName)
            {

                field("CrmReferenceId"; Rec."CRM Reference Id")
                {
                    ApplicationArea = all;
                }
                field("customerNo"; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }

                field(namE; Rec."Name")
                {
                    ApplicationArea = All;
                }
                field("Name2"; Rec."Name 2")
                {
                    ApplicationArea = All;
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("countryCode"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("StateCode"; Rec."State Code")
                {
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("PostCode"; Rec."Post Code")
                {
                    ApplicationArea = All;
                }
                field("LocationCode"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

                field("EMail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }

                field("PhoneNo"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }

                field("UserID"; Rec."User_ID")
                {
                    ApplicationArea = All;
                }
                field("GSTCustromerType"; Rec."GST Customer Type")
                {
                    ApplicationArea = all;
                }
                field("GSTRegistrationNo"; Rec."GST Registration No.")
                {
                    ApplicationArea = all;
                }

            }


        }

    }

    var

        RecCust: Record Customer;
        RecCustBuff: Record "Customer Buffer";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RecCust: Record Customer;
    begin
        RecCust.Reset();
        RecCust.SetRange("No.", Rec."Customer No.");
        RecCust.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        IF RecCust.FindFirst() then begin
            Error('CRM Reference Id already exist');
        end;
        InsertCust();
    end;

    procedure InsertCust(): Text
    var
        SalesRecSetup: Record "Sales & Receivables Setup";
    begin
        SalesRecSetup.Get();
        RecCustBuff.Reset();
        RecCustBuff.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        if RecCustBuff.FindLast() then
            Rec."Line No." := RecCustBuff."Line No." + 10000
        Else
            Rec."Line No." := 10000;

        IF Rec."Customer No." = '' then begin
            Rec.TestField("CRM Reference Id");
            Rec.TestField(Name);
            Rec.TestField(Address);
            Rec.TestField("Country/Region Code");
            Rec.TestField("State Code");
            SalesRecSetup.TestField("Cust Nos");
            RecCust.Init();
            RecCust."No." := NoSeriesMgt.GetNextNo(SalesRecSetup."Cust Nos", WorkDate(), true);
            RecCust."CRM Reference Id" := Rec."CRM Reference Id";
            RecCust.Validate(Name, Rec.Name);
            RecCust."Name 2" := Rec."Name 2";
            RecCust.Validate(Address, Rec.Address);
            RecCust.Validate("Address 2", Rec."Address 2");
            RecCust.Validate("Country/Region Code", Rec."Country/Region Code");
            RecCust.Validate("State Code", Rec."State Code");
            RecCust.Validate(City, Rec.City);
            RecCust.Validate("Post Code", Rec."Post Code");
            RecCust.Validate("E-Mail", Rec."E-Mail");
            RecCust.Validate("Phone No.", Rec."Phone No.");
            RecCust.Validate("Location Code", Rec."Location Code");
            RecCust.Validate("GST Registration No.", Rec."GST Registration No.");
            RecCust.Status := RecCust.Status::Open;
            IF Rec."GST Customer Type" = 1 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::" ");
            IF Rec."GST Customer Type" = 2 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::"Deemed Export");
            IF Rec."GST Customer Type" = 3 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Exempted);
            IF Rec."GST Customer Type" = 4 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Export);
            IF Rec."GST Customer Type" = 5 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Registered);
            IF Rec."GST Customer Type" = 6 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::"SEZ Development");
            IF Rec."GST Customer Type" = 7 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::"SEZ Unit");
            IF Rec."GST Customer Type" = 8 then
                RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Unregistered);
            //SalesRecSetup.TestField("Customer Posting Group");
            //SalesRecSetup.TestField("Gen. Bus. Posting Group");
            //RecCust.Validate("Customer Posting Group", SalesRecSetup."Customer Posting Group");
            //RecCust.Validate("Gen. Bus. Posting Group", SalesRecSetup."Gen. Bus. Posting Group");
            RecCust."Created On" := CurrentDateTime;
            RecCust.Status := RecCust.Status::open;
            IF RecCust.Insert() then begin
                Rec."Customer No." := RecCust."No.";
                Rec."Created By" := UserId();
                Rec."Created On" := Today();
            end;
        end else begin
            Rec.TestField("Customer No.");
            Rec.TestField("CRM Reference Id");
            Rec.TestField(Name);
            Rec.TestField(Address);
            Rec.TestField("Country/Region Code");
            Rec.TestField("State Code");
            RecCust.Reset();
            RecCust.SetRange("No.", Rec."Customer No.");
            IF RecCust.FindFirst() then begin
                RecCust.Validate(Name, Rec.Name);
                RecCust."Name 2" := Rec."Name 2";
                RecCust.Validate(Address, Rec.Address);
                RecCust.Validate("Address 2", Rec."Address 2");
                RecCust.Validate("Country/Region Code", Rec."Country/Region Code");
                RecCust.Validate(City, Rec.City);
                RecCust.Validate("State Code", Rec."State Code");
                RecCust.Validate("Post Code", Rec."Post Code");
                RecCust.Validate("E-Mail", Rec."E-Mail");
                RecCust.Validate("Phone No.", Rec."Phone No.");
                RecCust.Validate("Location Code", Rec."Location Code");
                //RecCust.Validate("Customer Posting Group", SalesRecSetup."Customer Posting Group");
                //RecCust.Validate("Gen. Bus. Posting Group", SalesRecSetup."Gen. Bus. Posting Group");
                RecCust.Validate("GST Registration No.", Rec."GST Registration No.");
                RecCust.Status := RecCust.Status::Open;
                IF Rec."GST Customer Type" = 1 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::" ");
                IF Rec."GST Customer Type" = 2 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::"Deemed Export");
                IF Rec."GST Customer Type" = 3 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Exempted);
                IF Rec."GST Customer Type" = 4 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Export);
                IF Rec."GST Customer Type" = 5 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Registered);
                IF Rec."GST Customer Type" = 6 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::"SEZ Development");
                IF Rec."GST Customer Type" = 7 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::"SEZ Unit");
                IF Rec."GST Customer Type" = 8 then
                    RecCust.Validate("GST Customer Type", RecCust."GST Customer Type"::Unregistered);
                RecCust."Updatet On" := CurrentDateTime;
                IF RecCust.Modify(true) then begin
                    Rec."Updated By" := UserId();
                    Rec."Updated On" := Today();
                end;
            end else
                EXIT('Customer Not Found');
        end
    end;

}

