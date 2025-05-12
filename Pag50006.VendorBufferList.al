page 50006 "Vendor Buffer List"
{
    PageType = API;
    APIVersion = 'v1.0';
    APIPublisher = 'ANI';
    APIGroup = 'VendorBuffer';
    SourceTable = "Vendor Buffer";
    Caption = 'Vendor Buffer List';
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
                field("VendorNo"; Rec."Vendor No.")
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
                field("PAN_No"; Rec."P.A.N. No.")
                {
                    ApplicationArea = all;
                }

                field("GSTVendorType"; Rec."GST Vendor Type")
                {
                    ApplicationArea = all;
                }
                field("GSTRegistrationNo"; Rec."GST Registration No.")
                {
                    ApplicationArea = all;
                }
                field("EMail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field("PhoneNo"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("MobilePhoneNo"; Rec."Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field("LocationCode"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }

                field("Bank_Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Bank_Branch_No"; Rec."Bank Branch No.")
                {
                    ApplicationArea = All;
                }
                field("BankAccountNo"; Rec."Bank Account No.")
                {
                    ApplicationArea = all;
                }
                field("IFSCCode"; Rec."IFSC Code")
                {
                    ApplicationArea = all;
                }
                field("AccountType"; Rec."Account Type")
                {
                    ApplicationArea = all;
                }
                field("AccountHolderName"; Rec."Account Holder Name")
                {
                    ApplicationArea = all;
                }
                field("Signatory_Name"; Rec."Signatory Name")
                {
                    ApplicationArea = all;
                }
                field("BankCountryCode"; Rec."Bank Country Code")
                {
                    ApplicationArea = all;
                }
                field("BankStateCode"; Rec."Bank State Code")
                {
                    ApplicationArea = all;
                }
                field("BankCity"; Rec."Bank City")
                {
                    ApplicationArea = all;
                }
                field("BankPostCode"; Rec."Bank Post Code")
                {
                    ApplicationArea = all;
                }
                field("BankPhoneNo"; Rec."Bank Phone No")
                {
                    ApplicationArea = all;
                }
                field("UserID"; Rec."User_ID")
                {
                    ApplicationArea = All;
                }
                field("GenBusPostingGroup"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("TAN_No"; Rec."T.A.N. No.")
                {
                    ApplicationArea = all;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = all;
                }

            }


        }

    }

    var
        RecVend1: Record Vendor;
        RecVend: Record Vendor;
        RecVendBuff: Record "Vendor Buffer";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        VendorBankAcc: Record "Vendor Bank Account";

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RecVend: Record Vendor;
    begin
        RecVend.Reset();
        RecVend.SetRange("No.", Rec."Vendor No.");
        RecVend.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        IF RecVend.FindFirst() then begin
            Error('CRM Reference Id already exist');
        end;
        InsertCust();
    end;

    procedure InsertCust(): Text
    var
        PurchPaySetup: Record "Purchases & Payables Setup";
    begin
        PurchPaySetup.Get();
        RecVendBuff.Reset();
        RecVendBuff.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        if RecVendBuff.FindLast() then
            Rec."Line No." := RecVendBuff."Line No." + 10000
        Else
            Rec."Line No." := 10000;

        IF Rec."Vendor No." = '' then begin
            Rec.TestField("CRM Reference Id");
            Rec.TestField(Name);
            Rec.TestField(Address);
            Rec.TestField("Country/Region Code");
            Rec.TestField("State Code");
            PurchPaySetup.TestField("Vend Nos");
            RecVend.Init();
            RecVend."No." := NoSeriesMgt.GetNextNo(PurchPaySetup."Vend Nos", WorkDate(), true);
            RecVend."CRM Reference Id" := Rec."CRM Reference Id";
            RecVend.Validate(Name, Rec.Name);
            RecVend."Name 2" := Rec."Name 2";
            RecVend.Validate(Address, Rec.Address);
            RecVend.Validate("Address 2", Rec."Address 2");
            RecVend.Validate("Country/Region Code", Rec."Country/Region Code");
            RecVend.Validate("State Code", Rec."State Code");
            RecVend.Validate(City, Rec.City);
            RecVend.Validate("Post Code", Rec."Post Code");
            RecVend.Validate("E-Mail", Rec."E-Mail");
            RecVend.Validate("Phone No.", Rec."Phone No.");
            RecVend.Validate("Location Code", Rec."Location Code");
            RecVend.Validate("Gen. Bus. Posting Group", Rec."Gen. Bus. Posting Group");
            RecVend.Contact := Rec.Contact;
            RecVend."T.A.N. No." := Rec."T.A.N. No.";
            RecVend.Validate("P.A.N. No.", Rec."P.A.N. No.");
            RecVend.Validate("GST Registration No.", Rec."GST Registration No.");
            RecVend.Status := RecVend.Status::Open;
            IF Rec."GST Vendor Type" = 1 then
                RecVend.Validate("GST Vendor Type", RecVend."GST Vendor Type"::" ");
            IF Rec."GST Vendor Type" = 2 then
                RecVend.Validate("GST Vendor Type", RecVend."GST Vendor Type"::Composite);
            IF Rec."GST Vendor Type" = 3 then
                RecVend.Validate("GST Vendor Type", RecVend."GST Vendor Type"::Exempted);
            IF Rec."GST Vendor Type" = 4 then
                RecVend.Validate("GST Vendor Type", RecVend."GST Vendor Type"::Import);
            IF Rec."GST Vendor Type" = 5 then
                RecVend.Validate("GST Vendor Type", RecVend."GST Vendor Type"::Registered);
            IF Rec."GST Vendor Type" = 6 then
                RecVend.Validate("GST Vendor Type", RecVend."GST Vendor Type"::SEZ);
            IF Rec."GST Vendor Type" = 7 then
                RecVend.Validate("GST Vendor Type", RecVend."GST Vendor Type"::Unregistered);

            VendorBankAcc.RESET;
            VendorBankAcc.SETRANGE("Vendor No.", RecVend."No.");
            VendorBankAcc.SETRANGE(Code, COPYSTR(Rec."Bank Name", 1, 3));
            IF NOT VendorBankAcc.FINDFIRST THEN BEGIN
                VendorBankAcc.INIT;
                VendorBankAcc."Vendor No." := RecVend."No.";
                VendorBankAcc.Code := COPYSTR(Rec."Bank Name", 1, 3);
                VendorBankAcc.Name := Rec."Bank Name";
                VendorBankAcc."Name 2" := Rec."Bank Branch No.";
                VendorBankAcc.Address := Rec."Bank Address";
                VendorBankAcc."Country/Region Code" := Rec."Bank Country Code";
                VendorBankAcc.City := Rec."Bank City";
                VendorBankAcc."Post Code" := Rec."Bank Post Code";
                VendorBankAcc."E-Mail" := Rec."Bank E-Mail";
                VendorBankAcc."Bank Account No." := Rec."Bank Account No.";
                VendorBankAcc."IFSC Code" := Rec."IFSC Code";
                VendorBankAcc."Account Holder Name" := Rec."Account Holder Name";
                VendorBankAcc."Account Type" := Rec."Account Type";
                VendorBankAcc."Signatory Name" := Rec."Signatory Name";
                VendorBankAcc."Phone No." := Rec."Bank Phone No";
                VendorBankAcc.INSERT;
            END;
            RecVend."Created On" := CurrentDateTime;
            IF RecVend.Insert() then begin
                Rec."Vendor No." := RecVend."No.";
                Rec."Created By" := UserId();
                Rec."Created On" := Today();
            end;
        end else begin
            Rec.TestField("Vendor No.");
            Rec.TestField("CRM Reference Id");
            Rec.TestField(Name);
            Rec.TestField(Address);
            Rec.TestField("Country/Region Code");
            Rec.TestField("State Code");
            RecVend.Reset();
            RecVend.SetRange("No.", Rec."Vendor No.");
            IF RecVend.FindFirst() then begin
                RecVend.Validate(Name, Rec.Name);
                RecVend."Name 2" := Rec."Name 2";
                RecVend.Validate(Address, Rec.Address);
                RecVend.Validate("Address 2", Rec."Address 2");
                RecVend.Validate("Country/Region Code", Rec."Country/Region Code");
                RecVend.Validate(City, Rec.City);
                RecVend.Validate("Post Code", Rec."Post Code");
                RecVend.Validate("E-Mail", Rec."E-Mail");
                RecVend.Validate("Phone No.", Rec."Phone No.");
                RecVend.Validate("Location Code", Rec."Location Code");
                RecVend.Validate("Gen. Bus. Posting Group", Rec."Gen. Bus. Posting Group");
                RecVend.Contact := Rec.Contact;
                RecVend."T.A.N. No." := Rec."T.A.N. No.";
                RecVend.Validate("P.A.N. No.", Rec."P.A.N. No.");
                RecVend."GST Registration No." := '';
                RecVend."GST Vendor Type" := RecVend."GST Vendor Type"::" ";
                VendorBankAcc.RESET;
                VendorBankAcc.SETRANGE("Vendor No.", RecVend."No.");
                VendorBankAcc.SETRANGE(Code, COPYSTR(Rec."Bank Name", 1, 3));
                IF VendorBankAcc.FINDFIRST THEN BEGIN
                    VendorBankAcc.Name := Rec."Bank Name";
                    VendorBankAcc."Name 2" := Rec."Bank Branch No.";
                    VendorBankAcc.Address := Rec."Bank Address";
                    VendorBankAcc."Country/Region Code" := Rec."Bank Country Code";
                    VendorBankAcc.City := Rec."Bank City";
                    VendorBankAcc."Post Code" := Rec."Bank Post Code";
                    VendorBankAcc."E-Mail" := Rec."Bank E-Mail";
                    VendorBankAcc."Bank Account No." := Rec."Bank Account No.";
                    VendorBankAcc."IFSC Code" := Rec."IFSC Code";
                    VendorBankAcc."Account Holder Name" := Rec."Account Holder Name";
                    VendorBankAcc."Account Type" := Rec."Account Type";
                    VendorBankAcc."Signatory Name" := Rec."Signatory Name";
                    VendorBankAcc."Phone No." := Rec."Bank Phone No";
                    VendorBankAcc.Modify();
                END;
                RecVend."Updated On" := CurrentDateTime;
                IF RecVend.Modify(true) then begin
                    Rec."Updated By" := UserId();
                    Rec."Updated On" := Today();
                    RecVend1.get(RecVend."No.");
                    RecVend1.Validate("State Code", Rec."State Code");
                    RecVend1.Validate("GST Registration No.", Rec."GST Registration No.");
                    IF Rec."GST Vendor Type" = 1 then
                        RecVend1.Validate("GST Vendor Type", RecVend1."GST Vendor Type"::" ");
                    IF Rec."GST Vendor Type" = 2 then
                        RecVend1.Validate("GST Vendor Type", RecVend1."GST Vendor Type"::Composite);
                    IF Rec."GST Vendor Type" = 3 then
                        RecVend1.Validate("GST Vendor Type", RecVend1."GST Vendor Type"::Exempted);
                    IF Rec."GST Vendor Type" = 4 then
                        RecVend1.Validate("GST Vendor Type", RecVend1."GST Vendor Type"::Import);
                    IF Rec."GST Vendor Type" = 5 then
                        RecVend1.Validate("GST Vendor Type", RecVend1."GST Vendor Type"::Registered);
                    IF Rec."GST Vendor Type" = 6 then
                        RecVend1.Validate("GST Vendor Type", RecVend1."GST Vendor Type"::SEZ);
                    IF Rec."GST Vendor Type" = 7 then
                        RecVend1.Validate("GST Vendor Type", RecVend1."GST Vendor Type"::Unregistered);
                    RecVend1.Modify();
                end;
            end else
                EXIT('Vendor Not Found');
        end
    end;

}

