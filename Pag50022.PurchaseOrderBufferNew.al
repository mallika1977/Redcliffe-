page 50022 "Purchase Order Buffer New"
{

    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v1.0';
    Caption = 'Purchase Order Buffer New';
    DelayedInsert = true;
    EntityName = 'tB3';
    EntitySetName = 'tB3';
    PageType = API;
    SourceTable = "Purchase Order Buffer New";
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
                field("NAV_PO_No"; Rec."NAV PO No.")
                {
                    ApplicationArea = All;
                }
                field("CRM_PO_No"; Rec."CRM P.O No.")
                {
                    ApplicationArea = All;
                }

                field("VendorNo"; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }

                field("PostingDate"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("OrderDate"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("VendorInvoiceDate"; Rec."Vendor Invoice Date")
                {
                    ApplicationArea = All;
                }
                field("ExternalDocumentNo"; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("ChallanNo"; Rec."Challan No.")
                {
                    ApplicationArea = All;
                }

                field("ChallanDate"; Rec."Challan Date")
                {
                    ApplicationArea = All;
                }
                field("GateEntryNo"; Rec."Gate Entry No.")
                {
                    ApplicationArea = All;
                }
                field("GateEntryDate"; Rec."Gate Entry Date")
                {
                    ApplicationArea = All;
                }
                field("PaymentTermsCode"; Rec."Payment Terms Code")
                {
                    ApplicationArea = All;
                }
                field("LocationCode"; Rec."Location Code")
                {
                    ApplicationArea = All;
                }
                field("LineNo"; Rec."Line No")
                {
                    ApplicationArea = All;
                }
                field("ItemType"; Rec."Item Type")
                {
                    ApplicationArea = All;
                }

                field("GL_ItemCode"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                // field(UOM; Rec.UOM)
                // {
                //     ApplicationArea = All;
                // }
                field("QtyToReceive"; Rec."Qty. To Receive")
                {
                    ApplicationArea = All;
                }

                field("DirectUnitCost"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("BatchNo"; Rec."Batch No.")
                {
                    ApplicationArea = All;
                }
                field("ExpiryDate"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("GRN_No"; Rec."GRN No")
                {
                    ApplicationArea = All;
                }
                field("DocumentPDF"; Rec."Document PDF")
                {
                    ApplicationArea = all;
                }
                field("GRN_Date"; Rec."GRN Date")
                {
                    ApplicationArea = all;
                }
                field("Dimension_2"; Rec."Dimension 2")
                {
                    ApplicationArea = all;
                }
                field("Nature_Type"; Rec."Nature Type")
                {
                    ApplicationArea = all;
                }


                // field("GstGroupCode"; Rec."Gst Group Code")
                // {
                //     ApplicationArea = All;
                // }

                // field("HSNCode"; Rec."HSN Code")
                // {
                //     ApplicationArea = All;
                // }

            }

        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    Var
        RecVend: Record Vendor;
        RecPH: Record "Purchase Header";
    begin
        RecPH.Reset();
        RecPH.SetRange("CRM P.O No.", Rec."CRM P.O No.");
        IF RecPH.FindFirst() then begin
            Error('CRM P.O. No. already exist');
        end;
        IF Not (Rec."CRM P.O No." <> '') then
            Error('CRM P.O No. required');
        IF Not (Rec."Posting Date" <> 0D) then
            Error('Posting Date required');
        IF Not (Rec."Order Date" <> 0D) then
            Error('Order Date required');
        IF Not (Rec."Qty. To Receive" <> 0) then
            Error('Qty. To Receive required');
        IF Not (Rec."Direct Unit Cost" <> 0) then
            Error('Direct Unit Cost required');
        IF Not (Rec."Location Code" <> '') then
            Error('Location Code required');
        IF RecVend.Get(Rec."Vendor No.") then
            IF RecVend.Status in [RecVend.Status::Open, RecVend.Status::"Pending Approval", RecVend.Status::"Pending Prepayment"] then
                Error('Vendor not approved');

        //Create PO
        CreatePurchaseOrder();
        LimsUnitCost(Rec);//validation

    end;


    procedure CreatePurchaseOrder()
    Var

        PurchaseHeader: Record "Purchase Header";
        PurchaseHeader1: Record "Purchase Header";
        PurchaseHeader2: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLine1: Record "Purchase Line";
        PurchaseLine2: Record "Purchase Line";
        CrmPOBuffer: Record "CRM Purchase Order Buffer";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PurchPaySetup: record "Purchases & Payables Setup";
        NoSeriesLine: Record "No. Series Line";
    Begin


        PurchPaySetup.Get();
        PurchPaySetup.TestField("NAV PO Nos.");
        IF Rec."NAV PO No." = '' then begin
            CrmPOBuffer.RESET;
            CrmPOBuffer.SETRANGE("CRM P.O No.", Rec."CRM P.O No.");
            CrmPOBuffer.SETRANGE("Line No", Rec."Line No");
            IF CrmPOBuffer.FINDFIRST THEN
                CrmPOBuffer.Delete();

            PurchaseHeader1.RESET;
            PurchaseHeader1.SETRANGE("Document Type", PurchaseHeader1."Document Type"::Order);
            PurchaseHeader1.SETRANGE("No.", Rec."NAV PO No.");
            IF NOT PurchaseHeader1.FINDFIRST THEN BEGIN
                PurchaseHeader.INIT;
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                PurchaseHeader."CRM P.O No." := Rec."CRM P.O No.";
                PurchaseHeader."No." := NoSeriesManagement.GetNextNo(PurchPaySetup."NAV PO Nos.", TODAY(), TRUE);
                PurchaseHeader.INSERT();
                PurchaseHeader.Validate("Buy-from Vendor No.", Rec."Vendor No.");
                PurchaseHeader.Validate("Posting Date", Rec."Posting Date");
                PurchaseHeader.Validate("Order Date", Rec."Order Date");
                PurchaseHeader.validate("Location Code", Rec."Location Code");
                PurchaseHeader."Challan No." := Rec."Challan No.";
                PurchaseHeader."Challan Date" := Rec."Challan Date";
                PurchaseHeader."Gate Entry No." := Rec."Gate Entry No.";
                PurchaseHeader."Gate Entry Date" := Rec."Gate Entry Date";
                PurchaseHeader."GRN No" := Rec."GRN No";
                PurchaseHeader."GRN Date" := Rec."GRN Date";
                Evaluate(PurchaseHeader."Nature Type", Rec."Nature Type");
                PurchaseHeader."Document PDF" := Rec."Document PDF";
                IF Rec."GRN No" <> '' then begin
                    PurchPaySetup.TestField("Posted Receipt Nos.");
                    NoSeriesLine.Reset();
                    NoSeriesLine.SetRange("Series Code", PurchPaySetup."Posted Receipt Nos.");
                    IF NoSeriesLine.FindFirst() then begin
                        NoSeriesLine."Starting No." := Rec."GRN No";

                        NoSeriesLine.Modify();
                    end;
                end;

                PurchaseHeader.Validate("Shortcut Dimension 1 Code", Rec."Location Code");
                PurchaseHeader.Validate("Shortcut Dimension 2 Code", Rec."Dimension 2");
                IF PurchaseHeader.MODIFY() then begin
                    Rec."NAV PO No." := PurchaseHeader."No.";
                end;

                PurchaseLine1.RESET;
                PurchaseLine1.SETRANGE("Document Type", PurchaseLine1."Document Type"::Order);
                PurchaseLine1.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLine1.SETRANGE("Line No.", Rec."Line No" * 10000);
                IF NOT PurchaseLine1.FINDFIRST THEN BEGIN
                    PurchaseLine.INIT;
                    PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                    PurchaseLine."Document No." := PurchaseHeader."No.";
                    PurchaseLine."Line No." := Rec."Line No" * 10000;
                    IF Rec."Item Type" = 0 THEN
                        PurchaseLine.Type := PurchaseLine.Type::Item
                    ELSE
                        IF Rec."Item Type" = 1 THEN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                    PurchaseLine.VALIDATE("No.", Rec."Item Code");
                    PurchaseLine.INSERT();
                    PurchaseLine.VALIDATE(Quantity, Rec."Qty. To Receive");
                    PurchaseLine.VALIDATE("Qty. To Receive", Rec."Qty. To Receive");
                    PurchaseLine."Direct Unit Cost" := Rec."Direct Unit Cost";
                    PurchaseLine.VALIDATE("Direct Unit Cost");
                    PurchaseLine.validate("Location Code", Rec."Location Code");
                    PurchaseLine."Batch No." := Rec."Batch No.";
                    PurchaseLine."Expiry Date" := Rec."Expiry Date";
                    PurchaseLine.VALIDATE("Shortcut Dimension 1 Code", Rec."Location Code");
                    PurchaseLine.VALIDATE("Shortcut Dimension 2 Code", Rec."Dimension 2");
                    PurchaseLine.MODIFY();

                end;
            end;
        end else begin

            CrmPOBuffer.RESET;
            CrmPOBuffer.SETRANGE("NAV PO No.", Rec."NAV PO No.");
            CrmPOBuffer.SETRANGE("Line No", Rec."Line No");
            IF CrmPOBuffer.FINDFIRST THEN
                CrmPOBuffer.Delete();

            PurchaseHeader2.RESET;
            PurchaseHeader2.SETRANGE("Document Type", PurchaseHeader2."Document Type"::Order);
            PurchaseHeader2.SETRANGE("No.", Rec."NAV PO No.");
            IF PurchaseHeader2.FINDFIRST THEN BEGIN
                PurchaseHeader2.Validate("Buy-from Vendor No.", Rec."Vendor No.");
                PurchaseHeader2.Validate("Posting Date", Rec."Posting Date");
                PurchaseHeader2.Validate("Order Date", Rec."Order Date");
                PurchaseHeader2.Validate("Location Code", Rec."Location Code");
                PurchaseHeader2."Challan No." := Rec."Challan No.";
                PurchaseHeader2."Challan Date" := Rec."Challan Date";
                PurchaseHeader2."Gate Entry No." := Rec."Gate Entry No.";
                PurchaseHeader2."Gate Entry Date" := Rec."Gate Entry Date";
                PurchaseHeader2.Validate("Shortcut Dimension 1 Code", Rec."Location Code");
                PurchaseHeader2.Validate("Shortcut Dimension 2 Code", Rec."Dimension 2");
                PurchaseHeader2."GRN No" := Rec."GRN No";
                PurchaseHeader2."GRN Date" := Rec."GRN Date";
                Evaluate(PurchaseHeader2."Nature Type", Rec."Nature Type");
                PurchaseHeader2."Document PDF" := Rec."Document PDF";
                IF Rec."GRN No" <> '' then begin
                    PurchPaySetup.TestField("Posted Receipt Nos.");
                    NoSeriesLine.Reset();
                    NoSeriesLine.SetRange("Series Code", PurchPaySetup."Posted Receipt Nos.");
                    IF NoSeriesLine.FindFirst() then begin
                        NoSeriesLine."Starting No." := Rec."GRN No";

                        NoSeriesLine.Modify();
                    end;
                end;
                PurchaseHeader2.MODIFY();
            end;
            PurchaseLine2.RESET;
            PurchaseLine2.SETRANGE("Document Type", PurchaseLine2."Document Type"::Order);
            PurchaseLine2.SETRANGE("Document No.", Rec."NAV PO No.");
            PurchaseLine2.SETRANGE("Line No.", Rec."Line No" * 10000);
            IF PurchaseLine2.FINDFIRST THEN BEGIN
                IF Rec."Item Type" = 0 THEN
                    PurchaseLine2.Type := PurchaseLine2.Type::Item
                ELSE
                    IF Rec."Item Type" = 1 THEN
                        PurchaseLine2.Type := PurchaseLine2.Type::"Fixed Asset";
                PurchaseLine2.VALIDATE("No.", Rec."Item Code");
                PurchaseLine2.VALIDATE(Quantity, Rec."Qty. To Receive");
                PurchaseLine2.VALIDATE("Qty. To Receive", Rec."Qty. To Receive");
                PurchaseLine2."Direct Unit Cost" := Rec."Direct Unit Cost";
                PurchaseLine2.VALIDATE("Direct Unit Cost");
                PurchaseLine2.validate("Location Code", Rec."Location Code");
                PurchaseLine2."Batch No." := Rec."Batch No.";
                PurchaseLine2."Expiry Date" := Rec."Expiry Date";
                PurchaseLine2.VALIDATE("Shortcut Dimension 1 Code", Rec."Location Code");
                PurchaseLine2.VALIDATE("Shortcut Dimension 2 Code", Rec."Dimension 2");
                PurchaseLine2.MODIFY();
            END;
        end;
    END;



    procedure LimsUnitCost(Var Rec: Record "Purchase Order Buffer New")
    var
        LimsPurchaseInvoice: Record "CRM Purchase Order Buffer";
        PurchaseLine: Record "Purchase Line";
    begin
        LimsPurchaseInvoice.Reset();
        LimsPurchaseInvoice.SetCurrentKey("NAV PO No.", "Line No");
        LimsPurchaseInvoice.SetRange("NAV PO No.", Rec."NAV PO No.");
        If LimsPurchaseInvoice.FindSet() then begin
            repeat
                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document No.", LimsPurchaseInvoice."NAV PO No.");
                PurchaseLine.SetRange("Line No.", LimsPurchaseInvoice."Line No" * 10000);
                If PurchaseLine.FindFirst() then begin
                    PurchaseLine.Validate("Direct Unit Cost", LimsPurchaseInvoice."Direct Unit Cost");

                    PurchaseLine.Modify();
                end;

            until LimsPurchaseInvoice.Next() = 0;
        end;

    end;




}
