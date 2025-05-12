page 50012 "CRM Fixed Asset Buffer"
{
    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v1.0';
    Caption = 'crmFixedAssetBuffer';
    DelayedInsert = true;
    EntityName = 'entityName1';
    EntitySetName = 'entitySetName1';
    PageType = API;
    SourceTable = "CRM Fixed Asset Buffer";
    ApplicationArea = all;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(lineNo; Rec."Line No.")
                // {
                //     Caption = 'Line No.';
                //     ApplicationArea = all;
                // }
                field(crmFANo; Rec."CRM FA No.")
                {
                    Caption = 'CRM FA No.';
                    ApplicationArea = all;
                }
                field(navFANo; Rec."NAV FA No.")
                {
                    Caption = 'NAV FA No.';
                    ApplicationArea = all;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                    ApplicationArea = all;
                }
                field(faClassCode; Rec."FA Class Code")
                {
                    Caption = 'FA Class Code';
                    ApplicationArea = all;
                }
                field(faSubclassCode; Rec."FA Subclass Code")
                {
                    Caption = 'FA Subclass Code';
                    ApplicationArea = all;
                }

                field(faLocationCode; Rec."FA Location Code")
                {
                    Caption = 'FA Location Code';
                    ApplicationArea = all;
                }
                field("GSTGroupCode"; Rec."GST Group Code")
                {
                    ApplicationArea = all;
                }
                field("HSN_SAC_Code"; Rec."HSN\SAC Code")
                {
                    ApplicationArea = all;
                }

            }
        }
    }

    var

        RecFA: Record "Fixed Asset";
        RecFA1: Record "Fixed Asset";
        RecFABuff: Record "CRM Fixed Asset Buffer";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        InsertFA();
    end;

    procedure InsertFA(): Text
    var
        FASetup: Record "FA Setup";
        FAClass: Record "FA Class";
        FASubClass: Record "FA Subclass";
    begin
        Rec.TestField(Description);
        Rec.TestField("Description 2");
        FASetup.Get();
        RecFABuff.Reset();
        RecFABuff.SetRange("CRM FA No.", Rec."CRM FA No.");
        if RecFABuff.FindLast() then
            Rec."Line No." := RecFABuff."Line No." + 10000
        Else
            Rec."Line No." := 10000;

        IF Rec."NAV FA No." = '' then begin
            RecFA1.RESET;
            RecFA1.SETRANGE("No.", Rec."NAV FA No.");
            IF NOT RecFA1.FINDFIRST THEN BEGIN
                RecFA.Init();
                RecFA."No." := NoSeriesMgt.GetNextNo(FASetup."Nav FA Nos", WorkDate(), true);
                RecFA.Validate(Description, Rec.Description);
                RecFA."Description 2" := Rec."Description 2";
                RecFA.Validate("GST Group Code", Rec."GST Group Code");
                RecFA.Validate("HSN/SAC Code", Rec."HSN\SAC Code");
                RecFA."Created On" := CurrentDateTime;
                IF RecFA.Insert() then begin
                    Rec."NAV FA No." := RecFA."No.";
                    Rec."Created By" := UserId();
                    Rec."Created On" := Today();
                    // IF Rec."FA Class Code" <> '' then begin
                    //     FAClass.Init();
                    //     FAClass.Code := Rec."FA Class Code";
                    //     FAClass.Name := Rec."FA Class Code";
                    //     FAClass.Insert();

                    //     FAsubClass.Init();
                    //     FAsubClass.Code := Rec."FA subClass Code";
                    //     FAsubClass.Name := Rec."FA subClass Code";
                    //     FASubClass."FA Class Code" := Rec."FA Class Code";
                    //     FAsubClass.Insert();
                    // end;
                end;
            end;
        end else begin
            RecFA.Reset();
            RecFA.SetRange("No.", Rec."Nav FA No.");
            IF RecFA.FindFirst() then begin
                RecFA.Validate(Description, Rec.Description);
                RecFA."Description 2" := Rec."Description 2";
                RecFA.Validate("GST Group Code", Rec."GST Group Code");
                RecFA.Validate("HSN/SAC Code", Rec."HSN\SAC Code");
                RecFA."Updatet On" := CurrentDateTime;
                IF RecFA.Modify(true) then begin
                    Rec."Updated By" := UserId();
                    Rec."Updated On" := Today();
                    // IF Rec."FA Class Code" <> '' then begin
                    //     FAClass.Reset();
                    //     FAClass.SetRange(Code, Rec."FA Class Code");
                    //     IF FAClass.FindFirst() then begin
                    //         FAClass.Code := Rec."FA Class Code";
                    //         FAClass.Name := Rec."FA Class Code";
                    //         FAClass.Insert();
                    //     end;
                    //     FAsubClass.Reset();
                    //     FASubClass.SetRange(Code, Rec."FA Subclass Code");
                    //     if FASubClass.FindFirst() then begin
                    //         FAsubClass.Code := Rec."FA subClass Code";
                    //         FAsubClass.Name := Rec."FA subClass Code";
                    //         FASubClass."FA Class Code" := Rec."FA Class Code";
                    //         FAsubClass.Insert();
                    //     end;
                    // end;
                end;

            end else
                EXIT('FA Not Found');
        end;
    end;

}
