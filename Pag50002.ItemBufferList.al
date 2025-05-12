page 50002 "Item Buffer List"
{
    PageType = API;
    APIVersion = 'v1.0';
    APIPublisher = 'ANI';
    APIGroup = 'ItemBuffer';
    SourceTable = "Item Buffer";
    Caption = 'Item Buffer List';
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
                field("ItemNo"; Rec."Item No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }
                field("BaseUnitofMeasure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("UnitPrice"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("SalesUnitofMeasure"; Rec."Sales Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("ItemCategoryCode"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }
                field("ServiceItemGroup"; Rec."Service Item Group")
                {
                    ApplicationArea = All;
                }
                field("GSTGroupCode"; Rec."GST Group Code")
                {
                    ApplicationArea = All;
                }
                field("HSN_SACCode"; Rec."HSN\SAC Code")
                {
                    ApplicationArea = All;
                }
                field("ItemUnitofMeasureCode"; Rec."Item Unit of Measure Code")
                {
                    ApplicationArea = all;
                }
                field("QtyperUnitofMeasure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = all;
                }
                field("UserID"; Rec."User_ID")
                {
                    ApplicationArea = All;
                }
                field("Type"; Rec."Type")
                {
                    ApplicationArea = all;
                }
                field("GenProdPostingGroup"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("TestType"; Rec."Test Type")
                {
                    ApplicationArea = all;
                }
            }


        }


    }

    var
        RecItem: Record Item;
        RecItemBuff: Record "Item Buffer";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecIUOM: Record "Item Unit of Measure";
        RecIUOM1: Record "Item Unit of Measure";

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RecITM: Record Item;
    begin
        RecITM.Reset();
        RecITM.SetRange("No.", Rec."Item No.");
        RecITM.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        IF RecItm.FindFirst() then begin
            Error('CRM Reference Id already exist');
        end;
        InsertItem();
    end;

    procedure InsertItem(): Text
    var
        GenLedgerSetup: Record "General Ledger Setup";
        varItem: Code[20];
        HSN_SAC: Record "HSN/SAC";
        GSTGroup: Record "GST Group";
    begin
        GenLedgerSetup.Get();
        RecItemBuff.Reset();
        RecItemBuff.SetRange("CRM Reference Id", Rec."CRM Reference Id");
        if RecItemBuff.FindLast() then
            Rec."Line No." := RecItemBuff."Line No." + 10000
        Else
            Rec."Line No." := 10000;

        IF Rec."Item No." = '' then begin
            Rec.TestField("CRM Reference Id");
            Rec.TestField(Description);
            RecItem.Init();
            RecItem."No." := NoSeriesMgt.GetNextNo(GenLedgerSetup."Item Nos", WorkDate(), true);
            varItem := RecItem."No.";
            RecItem."CRM Reference Id" := Rec."CRM Reference Id";
            RecItem.Validate(Description, Rec.Description);
            RecItem."Description 2" := Rec."Description 2";
            RecItem.Validate("Item Category Code", Rec."Item Category Code");
            RecItem.Validate("Service Item Group", Rec."Service Item Group");
            RecItem.Validate("Unit Price", Rec."Unit Price");
            RecItem.Validate("Sales Unit of Measure", Rec."Sales Unit of Measure");
            RecItem."Test Type" := Rec."Test Type";

            GSTGroup.Reset();
            GSTGroup.SetRange(Code, Rec."GST Group Code");
            IF NOT GSTGroup.FindFirst() then begin
                GSTGroup.Init();
                GSTGroup.Code := Rec."GST Group Code";
                GSTGroup."GST Group Type" := GSTGroup."GST Group Type"::Goods;
                GSTGroup."GST Place Of Supply" := GSTGroup."GST Place Of Supply"::"Location Address";
                GSTGroup.Insert();
            end;
            HSN_SAC.RESET;
            HSN_SAC.SETRANGE("GST Group Code", Rec."GST Group Code");
            HSN_SAC.SETRANGE(Code, Rec."HSN\SAC Code");
            HSN_SAC.SETRANGE(Type, HSN_SAC.Type::HSN);
            IF NOT HSN_SAC.FINDFIRST THEN BEGIN
                HSN_SAC.INIT;
                HSN_SAC."GST Group Code" := Rec."GST Group Code";
                HSN_SAC.Code := "HSN\SAC Code";
                HSN_SAC.Description := Rec."HSN\SAC Code";
                HSN_SAC.Type := HSN_SAC.Type::HSN;
                HSN_SAC.INSERT;
            END;
            RecItem.Validate("GST Group Code", Rec."GST Group Code");
            RecItem.Validate("HSN/SAC Code", Rec."HSN\SAC Code");
            RecItem.Validate("Gen. Prod. Posting Group", Rec."Gen. Prod. Posting Group");
            GenLedgerSetup.TestField("Inventory Posting Group");
            RecItem.Validate("Inventory Posting Group", GenLedgerSetup."Inventory Posting Group");
            RecItem."Created On" := CurrentDateTime;
            IF RecItem.Insert() then begin
                RecItem.Reset();
                RecItem.SetRange("No.", Rec."Item No.");
                Rec."Item No." := varItem;
                Rec."Created By" := UserId();
            end;
            IF Rec.Type = 'OPEX' then
                RecItem.Validate(Type, RecItem.Type::Inventory)
            else
                IF Rec.Type = 'SERVICES' then
                    RecItem.Validate(Type, RecItem.Type::Service)
                else
                    RecItem.Validate(Type, RecItem.Type::"Non-Inventory");
            RecItem.Validate("Base Unit of Measure", Rec."Base Unit of Measure");
            IF RecItem.Modify() then begin
                RecIUOM1.Reset();
                RecIUOM1.SetRange("Item No.", varItem);
                RecIUOM1.SetRange(Code, Rec."Base Unit of Measure");
                IF RecIUOM1.FindFirst() then;
                RecIUOM.Reset();
                RecIUOM.SetRange("Item No.", Rec."Item No.");
                RecIUOM.SetRange(Code, Rec."Item Unit of Measure Code");
                IF not RecIUOM.FindFirst() then begin
                    RecIUOM.Init();
                    RecIUOM.Validate("Item No.", Rec."Item No.");
                    RecIUOM.Validate(Code, Rec."Item Unit of Measure Code");
                    IF Rec."Qty. per Unit of Measure" <> 0 then
                        RecIUOM."Qty. per Unit of Measure" := RecIUOM1."Qty. per Unit of Measure" / Rec."Qty. per Unit of Measure";
                    RecIUOM.insert(True);
                end;
            end
        end else begin
            Rec.TestField("Item No.");
            Rec.TestField("CRM Reference Id");
            RecItem.Reset();
            RecItem.SetRange("No.", Rec."Item No.");
            IF RecItem.FindFirst() then begin
                RecItem.Validate(Description, Rec.Description);
                RecItem."Description 2" := Rec."Description 2";
                RecItem.Validate(Type, RecItem.Type::Inventory);
                RecItem.Validate("Item Category Code", Rec."Item Category Code");
                RecItem.Validate("Service Item Group", Rec."Service Item Group");
                RecItem.Validate("Base Unit of Measure", Rec."Base Unit of Measure");
                RecItem.Validate("Unit Price", Rec."Unit Price");
                RecItem.Validate("Sales Unit of Measure", Rec."Sales Unit of Measure");
                RecItem."Test Type" := Rec."Test Type";
                GSTGroup.Reset();
                GSTGroup.SetRange(Code, Rec."GST Group Code");
                IF GSTGroup.FindFirst() then begin
                    GSTGroup.Code := Rec."GST Group Code";
                    GSTGroup."GST Group Type" := GSTGroup."GST Group Type"::Goods;
                    GSTGroup."GST Place Of Supply" := GSTGroup."GST Place Of Supply"::"Location Address";
                    GSTGroup.Modify();
                end;
                HSN_SAC.RESET;
                HSN_SAC.SETRANGE("GST Group Code", Rec."GST Group Code");
                HSN_SAC.SETRANGE(Code, Rec."HSN\SAC Code");
                HSN_SAC.SETRANGE(Type, HSN_SAC.Type::HSN);
                IF HSN_SAC.FINDFIRST THEN BEGIN
                    HSN_SAC."GST Group Code" := "GST Group Code";
                    HSN_SAC.Code := "HSN\SAC Code";
                    HSN_SAC.Description := Rec."HSN\SAC Code";
                    HSN_SAC.Type := HSN_SAC.Type::HSN;
                    HSN_SAC.Modify();
                END;

                RecItem.Validate("GST Group Code", Rec."GST Group Code");
                RecItem.Validate("HSN/SAC Code", Rec."HSN\SAC Code");
                RecItem.Validate("Gen. Prod. Posting Group", Rec."Gen. Prod. Posting Group");
                GenLedgerSetup.TestField("Inventory Posting Group");
                RecItem.Validate("Inventory Posting Group", GenLedgerSetup."Inventory Posting Group");

                RecItem."Updated On" := CurrentDateTime;
                IF RecItem.Modify(true) then begin
                    Rec."Updated By" := UserId();
                    Rec."Updated On" := Today();
                    RecIUOM1.Reset();
                    RecIUOM1.SetRange("Item No.", varItem);
                    RecIUOM1.SetRange(Code, Rec."Base Unit of Measure");
                    IF RecIUOM1.FindFirst() then;
                    RecIUOM.Reset();
                    RecIUOM.SetRange("Item No.", Rec."Item No.");
                    RecIUOM.SetRange(Code, Rec."Item Unit of Measure Code");
                    IF RecIUOM.FindFirst() then begin
                        RecIUOM.Validate("Item No.", Rec."Item No.");
                        RecIUOM.Validate(Code, Rec."Item Unit of Measure Code");
                        IF Rec."Qty. per Unit of Measure" <> 0 then
                            RecIUOM."Qty. per Unit of Measure" := RecIUOM1."Qty. per Unit of Measure" / Rec."Qty. per Unit of Measure";
                        RecIUOM.Modify(True);
                    end;
                    IF RecItem.Get(Rec."Item No.") then begin
                        IF Rec.Type = 'OPEX' then
                            RecItem.Validate(Type, RecItem.Type::Inventory)
                        else
                            IF Rec.Type = 'SERVICES' then
                                RecItem.Validate(Type, RecItem.Type::Service)
                            else
                                RecItem.Validate(Type, RecItem.Type::"Non-Inventory");
                        RecItem.Modify();
                    end;
                end;
            end else
                EXIT('Item Not Found');
        end
    end;

}
