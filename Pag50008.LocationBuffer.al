page 50008 "Location Buffer"
{
    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v1.0';
    Caption = 'locationBuffer';
    DelayedInsert = true;
    EntityName = 'entityName';
    EntitySetName = 'entitySetName';
    PageType = API;
    SourceTable = LocationBuffer;
    ApplicationArea = all;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                    ApplicationArea = All;
                }
                field(crmReferenceId; Rec."CRM Reference Id")
                {
                    Caption = 'CRM Reference Id';
                    ApplicationArea = All;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                    ApplicationArea = All;
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                    ApplicationArea = All;
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                    ApplicationArea = All;
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                    ApplicationArea = All;
                }
                field(countryRegionCode; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                    ApplicationArea = All;
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                    ApplicationArea = All;
                }
                field(stateCode; Rec."State Code")
                {
                    Caption = 'State Code';
                    ApplicationArea = All;
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                    ApplicationArea = All;
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                    ApplicationArea = All;
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                    ApplicationArea = All;
                }
                field(telexNo; Rec."Telex No.")
                {
                    Caption = 'Telex No.';
                    ApplicationArea = All;
                }
                field(User_ID; Rec.User_ID)
                {
                    Caption = 'User ID';
                    ApplicationArea = All;
                }
                field("GST_RegistrationNo"; Rec."GST Registration No.")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    var

        RecLoc: Record Location;
        RecLocBuff: Record "LocationBuffer";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean

    var
        RecLoc: Record Location;
    begin
        RecLoc.Reset();
        RecLoc.SetRange(code, Rec."Location Code");
        RecLoc.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        IF RecLoc.FindFirst() then begin
            Error('CRM Reference Id already exist');
        end;
        InsertCust();
    end;

    procedure InsertCust(): Text
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        RecLocBuff.Reset();
        RecLocBuff.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        if RecLocBuff.FindLast() then
            Rec."Line No." := RecLocBuff."Line No." + 10000
        Else
            Rec."Line No." := 10000;

        IF Rec."Location Code" = '' then begin
            Rec.TestField("CRM Reference Id");
            Rec.TestField(Name);
            Rec.TestField(Address);
            Rec.TestField("Country/Region Code");
            Rec.TestField("State Code");
            InventorySetup.TestField("Location Nos");
            RecLoc.Init();
            RecLoc."Code" := Rec."CRM Reference Id";
            RecLoc."CRM Reference Id" := Rec."CRM Reference Id";
            RecLoc.Validate(Name, Rec.Name);
            RecLoc."Name 2" := Rec."Name 2";
            RecLoc.Validate(Address, Rec.Address);
            RecLoc.Validate("Address 2", Rec."Address 2");
            RecLoc.Validate("Country/Region Code", Rec."Country/Region Code");
            RecLoc.Validate("State Code", Rec."State Code");
            RecLoc.Validate(City, Rec.City);
            RecLoc.Validate("Post Code", Rec."Post Code");
            RecLoc.Validate("E-Mail", Rec."E-Mail");
            RecLoc.Validate("Phone No.", Rec."Phone No.");
            RecLoc.Validate("GST Registration No.", rec."GST Registration No.");
            RecLoc."Created On" := CurrentDateTime;

            IF RecLoc.Insert() then begin
                Rec."Location Code" := RecLoc.Code;
                Rec."Created By" := UserId();
                Rec."Created On" := Today();
            end;
        end else begin
            Rec.TestField("Location Code");
            Rec.TestField("CRM Reference Id");
            Rec.TestField(Name);
            Rec.TestField(Address);
            Rec.TestField("Country/Region Code");
            Rec.TestField("State Code");
            RecLoc.Reset();
            RecLoc.SetRange(Code, Rec."Location Code");
            IF RecLoc.FindFirst() then begin
                RecLoc.Validate(Name, Rec.Name);
                RecLoc."Name 2" := Rec."Name 2";
                RecLoc.Validate(Address, Rec.Address);
                RecLoc.Validate("Address 2", Rec."Address 2");
                RecLoc.Validate("Country/Region Code", Rec."Country/Region Code");
                RecLoc.Validate(City, Rec.City);
                RecLoc.Validate("State Code", Rec."State Code");
                RecLoc.Validate("Post Code", Rec."Post Code");
                RecLoc.Validate("E-Mail", Rec."E-Mail");
                RecLoc.Validate("Phone No.", Rec."Phone No.");
                RecLoc.Validate("GST Registration No.", rec."GST Registration No.");
                RecLoc."Updatet On" := CurrentDateTime;
                IF RecLoc.Modify(true) then begin
                    Rec."Updated By" := UserId();
                    Rec."Updated On" := Today();
                end;
            end else
                EXIT('Location Not Found');
        end
    end;

}
