page 50011 "CRM Transfer Order Buffer"
{

    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v1.0';
    Caption = 'CRM Transfer Order Buffer';
    DelayedInsert = true;
    EntityName = 'tB2';
    EntitySetName = 'tB2';
    PageType = API;
    SourceTable = "CRM Transfer Order Buffer";
    ApplicationArea = All;
    UsageCategory = Administration;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(GroupName)
            {
                field("NAV_TransferOrderNo"; Rec."NAV Transfer Order No.")
                {
                    ApplicationArea = All;
                }
                field("CRM_DocumentNo"; Rec."CRM Document No.")
                {
                    ApplicationArea = All;
                }
                field("TransferfromCode"; Rec."Transfer-from Code")
                {
                    ApplicationArea = All;
                }
                field("TransferfromName"; Rec."Transfer-from Name")
                {
                    ApplicationArea = All;
                }
                field("TransferfromName2"; Rec."Transfer-from Name 2")
                {
                    ApplicationArea = All;
                }
                field("TransferfromAddress"; Rec."Transfer-from Address")
                {
                    ApplicationArea = All;
                }
                field("TransferfromAddress2"; Rec."Transfer-from Address 2")
                {
                    ApplicationArea = All;
                }
                field("TransferfromCity"; Rec."Transfer-from City")
                {
                    ApplicationArea = All;
                }
                field("TransferfromPostCode"; Rec."Transfer-from Post Code")
                {
                    ApplicationArea = All;
                }
                field("Trsf_From_Country_RegionCode"; Rec."Trsf.-from Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("TransferToCode"; Rec."Transfer-To Code")
                {
                    ApplicationArea = All;
                }
                field("TransferToName"; Rec."Transfer-To Name")
                {
                    ApplicationArea = All;
                }
                field("TransferToName2"; Rec."Transfer-To Name 2")
                {
                    ApplicationArea = All;
                }
                field("TransferToAddress"; Rec."Transfer-To Address")
                {
                    ApplicationArea = All;
                }
                field("TransferToAddress2"; Rec."Transfer-To Address 2")
                {
                    ApplicationArea = All;
                }
                field("TransferToCity"; Rec."Transfer-To City")
                {
                    ApplicationArea = All;
                }
                field("TransferToPostCode"; Rec."Transfer-To Post Code")
                {
                    ApplicationArea = All;
                }
                field("Trsf_To_Country_RegionCode"; Rec."Trsf.-To Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("PostingDate"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("ShipmentDate"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                }
                field("ReceiptDate"; Rec."Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("LineNo"; Rec."Line No")
                { ApplicationArea = all; }

                field("ItemCode"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                field(Qty; Rec."Qty")
                {
                    ApplicationArea = All;
                }

                field("TransferPrice"; Rec."Transfer Price")
                {
                    ApplicationArea = All;
                }
                field("TransferOrderPost"; Rec."Transfer Order Post")
                {
                    ApplicationArea = All;
                }
            }

        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        IF Not (Rec."CRM Document No." <> '') then
            Error('CRM Document No. required');
        IF Not (Rec."Posting Date" <> 0D) then
            Error('Posting Date required');
        IF Not (Rec."Item Code" <> '') then
            Error('Item Code required');
        IF Not (Rec."Qty" <> 0) then
            Error('Qty required');
        IF Not (Rec."Transfer-from Code" <> '') then
            Error('Transfer-from Code required');
        IF Not (Rec."Transfer-To Code" <> '') then
            Error('Transfer-To Code required');

        //CREATE TRANSFER ORDER
        CreateTranfOrder();


        //TransferAmount(Rec);//Validation
    end;

    procedure CreateTranfOrder()
    Var
        TransferHeader: Record "Transfer Header";
        TransferHeader1: Record "Transfer Header";
        TransferHeader2: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        TransferLine1: Record "Transfer Line";
        TransferLine2: Record "Transfer Line";
        CrmTransOrderBuffer: Record "CRM Transfer Order Buffer";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        InventorySetup: record "Inventory Setup";
        NoSeriesLine: Record "No. Series Line";
        Loc: Record Location;
    Begin
        InventorySetup.Get();
        InventorySetup.TestField("Nav Transfer Order Nos");
        CrmTransOrderBuffer.RESET;
        CrmTransOrderBuffer.SETRANGE("CRM Document No.", Rec."CRM Document No.");
        CrmTransOrderBuffer.SETRANGE("Line No", Rec."Line No");
        IF CrmTransOrderBuffer.FINDFIRST THEN
            CrmTransOrderBuffer.Delete();

        TransferHeader1.RESET;
        TransferHeader1.SETRANGE("No.", Rec."NAV Transfer Order No.");
        IF NOT TransferHeader1.FINDFIRST THEN BEGIN
            TransferHeader.INIT;
            TransferHeader."CRM Document No." := Rec."CRM Document No.";
            TransferHeader."No." := NoSeriesManagement.GetNextNo(InventorySetup."Nav Transfer Order Nos", TODAY(), TRUE);
            TransferHeader.INSERT();
            TransferHeader.Validate("Direct Transfer", true);
            TransferHeader.Validate("Posting Date", Rec."Posting Date");
            TransferHeader.Validate("Shipment Date", Rec."Shipment Date");
            TransferHeader.Validate("Receipt Date", Rec."Receipt Date");
            TransferHeader.validate("Transfer-from Code", Rec."Transfer-from Code");
            TransferHeader.Validate("Transfer-from Name", Rec."Transfer-from Name");
            TransferHeader.Validate("Transfer-from Name 2", Rec."Transfer-from Name 2");
            TransferHeader.Validate("Transfer-from Address", Rec."Transfer-from Address");
            TransferHeader.Validate("Transfer-from Address 2", Rec."Transfer-from Address 2");
            TransferHeader.Validate("Transfer-from City", Rec."Transfer-from City");
            TransferHeader.Validate("Transfer-from Post Code", Rec."Transfer-from Post Code");
            TransferHeader.Validate("Trsf.-from Country/Region Code", Rec."Trsf.-from Country/Region Code");
            TransferHeader.Validate("Transfer-to Code", Rec."Transfer-to Code");
            Loc.Reset();
            Loc.SetRange("Use As In-Transit", true);
            IF Loc.FindFirst() then
                TransferHeader.Validate("In-Transit Code", Loc.Code);
            TransferHeader.Validate("Transfer-To Name", Rec."Transfer-To Name");
            TransferHeader.Validate("Transfer-To Name 2", Rec."Transfer-To Name 2");
            TransferHeader.Validate("Transfer-To Address", Rec."Transfer-To Address");
            TransferHeader.Validate("Transfer-To Address 2", Rec."Transfer-To Address 2");
            TransferHeader.Validate("Transfer-To City", Rec."Transfer-To City");
            TransferHeader.Validate("Transfer-To Post Code", Rec."Transfer-To Post Code");
            TransferHeader.Validate("Trsf.-To Country/Region Code", Rec."Trsf.-To Country/Region Code");
            IF Rec."CRM Document No." <> '' then begin
                InventorySetup.TestField("Posted Transfer Shpt. Nos.");
                InventorySetup.TestField("Posted Transfer Rcpt. Nos.");
                NoSeriesLine.Reset();
                NoSeriesLine.SetRange("Series Code", InventorySetup."Posted Transfer Shpt. Nos.");
                IF NoSeriesLine.FindFirst() then begin
                    NoSeriesLine."Starting No." := Rec."CRM Document No.";
                    NoSeriesLine.Modify();
                end;
                NoSeriesLine.Reset();
                NoSeriesLine.SetRange("Series Code", InventorySetup."Posted Transfer Rcpt. Nos.");
                IF NoSeriesLine.FindFirst() then begin
                    NoSeriesLine."Starting No." := Rec."CRM Document No.";
                    NoSeriesLine.Modify();
                end;
            end;
            IF TransferHeader.MODIFY() then
                Rec."NAV Transfer Order No." := TransferHeader."No.";
        end else begin
            TransferHeader2.RESET;
            TransferHeader2.SETRANGE("No.", Rec."NAV Transfer Order No.");
            IF TransferHeader2.FINDFIRST THEN BEGIN
                TransferHeader2.Validate("Posting Date", Rec."Posting Date");
                TransferHeader2.Validate("Shipment Date", Rec."Shipment Date");
                TransferHeader2.Validate("Receipt Date", Rec."Receipt Date");
                TransferHeader2.validate("Transfer-from Code", Rec."Transfer-from Code");
                //TransferHeader2.Validate("Transfer-from Name", Rec."Transfer-from Name");
                //TransferHeader2.Validate("Transfer-from Name 2", Rec."Transfer-from Name 2");
                //TransferHeader2.Validate("Transfer-from Address", Rec."Transfer-from Address");
                //TransferHeader2.Validate("Transfer-from Address 2", Rec."Transfer-from Address 2");
                // TransferHeader2.Validate("Transfer-from City", Rec."Transfer-from City");
                // TransferHeader2.Validate("Transfer-from Post Code", Rec."Transfer-from Post Code");
                //TransferHeader2.Validate("Trsf.-from Country/Region Code", Rec."Trsf.-from Country/Region Code");
                TransferHeader2.Validate("Transfer-to Code", Rec."Transfer-to Code");
                Loc.Reset();
                Loc.SetRange("Use As In-Transit", true);
                IF Loc.FindFirst() then
                    TransferHeader.Validate("In-Transit Code", Loc.Code);
                // TransferHeader2.Validate("Transfer-To Name", Rec."Transfer-To Name");
                // TransferHeader2.Validate("Transfer-To Name 2", Rec."Transfer-To Name 2");
                // TransferHeader2.Validate("Transfer-To Address", Rec."Transfer-To Address");
                // TransferHeader2.Validate("Transfer-To Address 2", Rec."Transfer-To Address 2");
                // TransferHeader2.Validate("Transfer-To City", Rec."Transfer-To City");
                // TransferHeader2.Validate("Transfer-To Post Code", Rec."Transfer-To Post Code");
                // TransferHeader2.Validate("Trsf.-To Country/Region Code", Rec."Trsf.-To Country/Region Code");
                IF Rec."CRM Document No." <> '' then begin
                    InventorySetup.TestField("Posted Transfer Shpt. Nos.");
                    InventorySetup.TestField("Posted Transfer Rcpt. Nos.");
                    NoSeriesLine.Reset();
                    NoSeriesLine.SetRange("Series Code", InventorySetup."Posted Transfer Shpt. Nos.");
                    IF NoSeriesLine.FindFirst() then begin
                        NoSeriesLine."Starting No." := Rec."CRM Document No.";
                        //NoSeriesLine."Last No. Used" := '';
                        NoSeriesLine.Modify();
                    end;
                    NoSeriesLine.Reset();
                    NoSeriesLine.SetRange("Series Code", InventorySetup."Posted Transfer Rcpt. Nos.");
                    IF NoSeriesLine.FindFirst() then begin
                        NoSeriesLine."Starting No." := Rec."CRM Document No.";
                        NoSeriesLine.Modify();
                    end;
                end;
                TransferHeader2.MODIFY();
            end;
        end;
        TransferLine1.RESET;
        TransferLine1.SETRANGE("Document No.", Rec."NAV Transfer Order No.");
        TransferLine1.SETRANGE("Line No.", Rec."Line No" * 10000);
        IF NOT TransferLine1.FINDFIRST THEN BEGIN
            TransferLine.INIT;
            TransferLine."Document No." := Rec."NAV Transfer Order No.";
            TransferLine."Line No." := Rec."Line No" * 10000;
            TransferLine.VALIDATE("Item No.", Rec."Item Code");
            TransferLine.INSERT();

            // TransferLine.Amount := Rec.Amount;
            //TransferLine.Validate(Amount);
            TransferLine.Validate("Transfer Price", Rec."Transfer Price");
            TransferLine.VALIDATE(Quantity, Rec."Qty");
            TransferLine.validate("Transfer-from Code", Rec."Transfer-to Code");
            TransferLine.validate("Transfer-to Code", Rec."Transfer-to Code");
            TransferLine.MODIFY();
        end else begin
            TransferLine2.RESET;
            TransferLine2.SETRANGE("Document No.", Rec."NAV Transfer Order No.");
            TransferLine2.SETRANGE("Line No.", Rec."Line No" * 10000);
            IF TransferLine2.FINDFIRST THEN BEGIN
                TransferLine2.VALIDATE("Item No.", Rec."Item Code");
                //TransferLine.Amount := Rec.Amount;
                //TransferLine.Validate(Amount);
                TransferLine2.Validate("Transfer Price", Rec."Transfer Price");
                TransferLine2.VALIDATE(Quantity, Rec.Qty);
                TransferLine2.validate("Transfer-from Code", Rec."Transfer-to Code");
                TransferLine2.validate("Transfer-to Code", Rec."Transfer-to Code");
                TransferLine2.MODIFY();
            END;
        end;

        IF Rec."Transfer Order Post" then begin
            TransferHeader2.RESET;
            TransferHeader2.SETRANGE("No.", Rec."NAV Transfer Order No.");
            TransferHeader2.SetRange("Direct Transfer", true);
            IF TransferHeader2.FINDFIRST THEN
                Codeunit.Run(Codeunit::"TransferOrder-Post (Yes/No)", TransferHeader2);
        end;
    end;


    procedure TransferAmount(Var Rec: Record "CRM Transfer Order Buffer")
    var
        LimsPurchaseInvoice: Record "CRM Transfer Order Buffer";
        TransferLine: Record "Transfer Line";
    begin
        LimsPurchaseInvoice.Reset();
        LimsPurchaseInvoice.SetCurrentKey("NAV Transfer Order No.", "Line No");
        LimsPurchaseInvoice.SetRange("NAV Transfer Order No.", Rec."NAV Transfer Order No.");
        If LimsPurchaseInvoice.FindSet() then begin
            repeat
                TransferLine.Reset();
                TransferLine.SetRange("Document No.", LimsPurchaseInvoice."NAV Transfer Order No.");
                TransferLine.SetRange("Line No.", LimsPurchaseInvoice."Line No" * 10000);
                If TransferLine.FindFirst() then begin
                    TransferLine.Validate(Amount, LimsPurchaseInvoice.Amount);
                    //TransferLine.Validate("Line Discount %", LimsPurchaseInvoice.discount_percentage);
                    TransferLine.Modify();
                end;
            until LimsPurchaseInvoice.Next() = 0;
        end;

    end;
}
