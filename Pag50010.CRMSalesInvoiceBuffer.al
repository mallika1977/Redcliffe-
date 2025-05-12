page 50010 "CRM Sales Invoice Buffer"
{

    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v1.0';
    Caption = 'CRM Sales Invoice Buffer';
    DelayedInsert = true;
    EntityName = 'tB1';
    EntitySetName = 'tB1';
    PageType = API;
    SourceTable = "CRM Sales Invoice Buffer";
    // ApplicationArea = All;
    // UsageCategory = Administration;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(GroupName)
            {
                field("NAV_Invoice_No"; Rec."NAV Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("CRM_Invoice_No"; Rec."CRM Invoice No.")
                {
                    ApplicationArea = All;
                }

                field("CustomerNo"; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }

                field("PostingDate"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }

                field("ExternalDocumentNo"; Rec."External Document No.")
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

                field("ItemCode"; Rec."Item Code")
                {
                    ApplicationArea = All;
                }
                // field(UOM; Rec.UOM)
                // {
                //     ApplicationArea = All;
                // }
                field(Qty; Rec."Qty")
                {
                    ApplicationArea = All;
                }

                field("UnitPrice"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("PatientID"; Rec."Patient ID")
                {
                    ApplicationArea = All;
                }
                field("PatientName"; Rec."Patient name")
                {
                    ApplicationArea = All;
                }
                field("ChildID"; Rec."Child ID")
                {
                    ApplicationArea = all;
                }
                field("ChildName"; Rec."Child Name")
                {
                    ApplicationArea = All;
                }
                field("CouponID"; Rec."Coupon ID")
                {
                    ApplicationArea = all;
                }
                field("BankAccountCode"; Rec."Bank Account Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("NAV_Payment_No"; Rec."NAV Payment No.")
                {
                    ApplicationArea = All;
                }
                field("TypeofTest"; Rec."Type of Test")
                {
                    ApplicationArea = All;
                }
                field("No_Of_Test"; Rec."No. of Test")
                {
                    ApplicationArea = All;
                }
                field(Gender; Rec.Gender)
                {
                    ApplicationArea = All;
                }
                field(Age; Rec.Age)
                {
                    ApplicationArea = All;
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
    var
        RecCust: Record Customer;
    begin
        IF Not (Rec."CRM Invoice No." <> '') then
            Error('CRM Invoice No. required');
        IF Not (Rec."Posting Date" <> 0D) then
            Error('Posting Date required');

        IF Not (Rec."Qty" <> 0) then
            Error('Qty required');
        IF Not (Rec."Unit Price" <> 0) then
            Error('Unit Price required');
        IF Not (Rec."Location Code" <> '') then
            Error('Location Code required');
        IF Not (Rec."Bank Account Code" <> '') then
            Error('Bank Account Code required');
        IF Not (Rec."Customer No." <> '') then
            Error('Customer No. required');
        IF RecCust.Get(Rec."Customer No.") then
            IF RecCust.Status in [RecCust.Status::Open, RecCust.Status::"Pending Approval", RecCust.Status::"Pending Prepayment"] then
                Error('Customer not approved');
        //Auto Payment
        CreatePaymentEntry(Rec);
        //Auto Payment
        CreateSalesInvoice();
        SalesUnitPrice(Rec);//Validation
    end;

    procedure CreateSalesInvoice()
    Var
        SalesHeader: Record "Sales Header";
        SalesHeader1: Record "Sales Header";
        SalesHeader2: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine1: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        CrmSalesInvBuffer: Record "CRM Sales Invoice Buffer";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        SalesPaySetup: record "Sales & Receivables Setup";
        NoSeriesLine: Record "No. Series Line";
        BLE: Record "Bank Account Ledger Entry";
    Begin
        SalesPaySetup.Get();
        SalesPaySetup.TestField("NAV Invoice Nos.");
        //IF Rec."NAV Invoice No." = '' then begin
        CrmSalesInvBuffer.RESET;
        CrmSalesInvBuffer.SETRANGE("CRM Invoice No.", Rec."CRM Invoice No.");
        CrmSalesInvBuffer.SETRANGE("Line No", Rec."Line No");
        IF CrmSalesInvBuffer.FINDFIRST THEN
            CrmSalesInvBuffer.Delete();

        SalesHeader1.RESET;
        SalesHeader1.SETRANGE("Document Type", SalesHeader1."Document Type"::Invoice);
        SalesHeader1.SETRANGE("No.", Rec."NAV Invoice No.");
        IF NOT SalesHeader1.FINDFIRST THEN BEGIN
            SalesHeader.INIT;
            SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
            SalesHeader."CRM Invoice No." := Rec."CRM Invoice No.";
            SalesHeader."No." := NoSeriesManagement.GetNextNo(SalesPaySetup."NAV Invoice Nos.", TODAY(), TRUE);
            SalesHeader.INSERT();
            SalesHeader.Validate("Sell-to Customer No.", Rec."Customer No.");
            SalesHeader.Validate("Posting Date", Rec."Posting Date");
            SalesHeader.validate("Location Code", Rec."Location Code");
            IF Rec."CRM Invoice No." <> '' then begin
                SalesPaySetup.TestField("Posted Invoice Nos.");
                NoSeriesLine.Reset();
                NoSeriesLine.SetRange("Series Code", SalesPaySetup."Posted Invoice Nos.");
                IF NoSeriesLine.FindFirst() then begin
                    NoSeriesLine."Starting No." := Rec."CRM Invoice No.";
                    NoSeriesLine.Modify();
                end;
            end;
            if TempDocNo <> '' then begin
                BLE.Reset();
                BLE.SetRange("Document Type", BLE."Document Type"::Payment);
                BLE.SetRange("Document No.", TempDocNo);
                if BLE.FindFirst() then begin
                    SalesHeader."Applies-to Doc. Type" := SalesHeader."Applies-to Doc. Type"::Payment;
                    SalesHeader.Validate("Applies-to Doc. No.", TempDocNo);
                end;
            end;
            IF SalesHeader.MODIFY() then begin
                Rec."NAV Invoice No." := SalesHeader."No.";
                Rec."NAV Payment No." := TempDocNo;
            end;
        end else begin
            SalesHeader2.RESET;
            SalesHeader2.SETRANGE("Document Type", SalesHeader2."Document Type"::Invoice);
            SalesHeader2.SETRANGE("No.", Rec."NAV Invoice No.");
            IF SalesHeader2.FINDFIRST THEN BEGIN
                SalesHeader2.Validate("Sell-to Customer No.", Rec."Customer No.");
                SalesHeader2.Validate("Posting Date", Rec."Posting Date");
                SalesHeader2.Validate("Location Code", Rec."Location Code");
                // SalesHeader2.Validate("Shortcut Dimension 1 Code", Rec.GD1);
                // SalesHeader2.Validate("Shortcut Dimension 2 Code", Rec.GD2);
                SalesHeader2."CRM Invoice No." := Rec."CRM Invoice No.";
                IF Rec."CRM Invoice No." <> '' then begin
                    SalesPaySetup.TestField("Posted Invoice Nos.");
                    NoSeriesLine.Reset();
                    NoSeriesLine.SetRange("Series Code", SalesPaySetup."Posted Invoice Nos.");
                    IF NoSeriesLine.FindFirst() then begin
                        NoSeriesLine."Starting No." := Rec."CRM Invoice No.";
                        //NoSeriesLine."Last No. Used" := '';
                        NoSeriesLine.Modify();
                    end;
                end;
                SalesHeader2.MODIFY();
            end;

        end;
        //end else begin
        // CrmSalesInvBuffer.RESET;
        // CrmSalesInvBuffer.SETRANGE("NAV Invoice No.", Rec."NAV Invoice No.");
        // CrmSalesInvBuffer.SETRANGE("Line No", Rec."Line No");
        // IF CrmSalesInvBuffer.FINDFIRST THEN
        //     CrmSalesInvBuffer.Delete();
        SalesLine1.RESET;
        SalesLine1.SETRANGE("Document Type", SalesLine1."Document Type"::Invoice);
        SalesLine1.SETRANGE("Document No.", Rec."NAV Invoice No.");
        SalesLine1.SETRANGE("Line No.", Rec."Line No" * 10000);
        IF NOT SalesLine1.FINDFIRST THEN BEGIN
            SalesLine.INIT;
            SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
            SalesLine."Document No." := Rec."NAV Invoice No.";
            SalesLine."Line No." := Rec."Line No" * 10000;
            IF Rec."Item Type" = 0 THEN
                SalesLine.Type := SalesLine.Type::Item
            ELSE
                IF Rec."Item Type" = 1 THEN
                    SalesLine.Type := SalesLine.Type::"Fixed Asset";
            SalesLine.VALIDATE("No.", Rec."Item Code");
            SalesLine.INSERT();
            SalesLine.VALIDATE(Quantity, Rec."Qty");
            SalesLine."Unit Price" := Rec."Unit Price";
            SalesLine.VALIDATE("Unit Price");
            SalesLine.validate("Location Code", Rec."Location Code");
            SalesLine."Patient ID" := Rec."Patient ID";
            SalesLine."Patient name" := Rec."Patient name";
            SalesLine."Child ID" := Rec."Child ID";
            SalesLine."Child Name" := Rec."Child Name";
            SalesLine."Coupon ID" := Rec."Coupon ID";
            SalesLine."Type of Test" := Rec."Type of Test";
            SalesLine."No. of Test" := Rec."No. of Test";
            SalesLine.Gender := Rec.Gender;
            SalesLine.Age := Rec.Age;
            //SalesLine.VALIDATE("Shortcut Dimension 1 Code", Rec.GD1);
            //SalesLine.VALIDATE("Shortcut Dimension 2 Code", Rec.GD2);
            SalesLine.MODIFY();

        end else begin
            SalesLine2.RESET;
            SalesLine2.SETRANGE("Document Type", SalesLine2."Document Type"::Invoice);
            SalesLine2.SETRANGE("Document No.", Rec."NAV Invoice No.");
            SalesLine2.SETRANGE("Line No.", Rec."Line No" * 10000);
            IF SalesLine2.FINDFIRST THEN BEGIN
                IF Rec."Item Type" = 0 THEN
                    SalesLine2.Type := SalesLine2.Type::Item
                ELSE
                    IF Rec."Item Type" = 1 THEN
                        SalesLine2.Type := SalesLine2.Type::"Fixed Asset";
                SalesLine2.VALIDATE("No.", Rec."Item Code");
                SalesLine2.VALIDATE(Quantity, Rec.Qty);
                SalesLine2."Unit Price" := Rec."Unit Price";
                SalesLine2.VALIDATE("Unit Price");
                SalesLine2.validate("Location Code", Rec."Location Code");
                SalesLine2."Patient ID" := Rec."Patient ID";
                SalesLine2."Patient name" := Rec."Patient name";
                SalesLine2."Child ID" := Rec."Child ID";
                SalesLine2."Child Name" := Rec."Child Name";
                SalesLine2."Coupon ID" := Rec."Coupon ID";
                SalesLine2."Type of Test" := Rec."Type of Test";
                SalesLine2."No. of Test" := Rec."No. of Test";
                SalesLine2.Gender := Rec.Gender;
                SalesLine2.Age := Rec.Age;
                // SalesLine2.VALIDATE("Shortcut Dimension 1 Code", Rec.GD1);
                // SalesLine2.VALIDATE("Shortcut Dimension 2 Code", Rec.GD2);
                SalesLine2.MODIFY();
            end;
        END;
    end;
    //END;



    procedure SalesUnitPrice(Var Rec: Record "CRM Sales Invoice Buffer")
    var
        LimsPurchaseInvoice: Record "CRM Sales Invoice Buffer";
        SalesLine: Record "Sales Line";
    begin
        LimsPurchaseInvoice.Reset();
        LimsPurchaseInvoice.SetCurrentKey("NAV Invoice No.", "Line No");
        LimsPurchaseInvoice.SetRange("NAV Invoice No.", Rec."NAV Invoice No.");
        If LimsPurchaseInvoice.FindSet() then begin
            repeat
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", LimsPurchaseInvoice."NAV Invoice No.");
                SalesLine.SetRange("Line No.", LimsPurchaseInvoice."Line No" * 10000);
                If SalesLine.FindFirst() then begin
                    SalesLine.Validate("Unit Price", LimsPurchaseInvoice."Unit Price");
                    //SalesLine.Validate("Line Discount %", LimsPurchaseInvoice.discount_percentage);
                    SalesLine.Modify();
                end;
            until LimsPurchaseInvoice.Next() = 0;
        end;

    end;

    procedure CreatePaymentEntry(CRMSales: Record "CRM Sales Invoice Buffer")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        Customer: Record "Customer";
        NoSeries: Codeunit "NoSeriesManagement";
        DueDate: Date;
        GenJournalLine: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        Loc_Rec: Record Location;
        CusLedger: Record "Cust. Ledger Entry";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        REC_SH: Record "Sales Header";

    begin
        //POST PAYMENT APPLY
        GLSetup.Get();
        GLSetup.TestField("Auto Payment Template Name");
        GLSetup.TestField("Auto Payment Jnl Batch Name");
        GenJournalLine.RESET();
        GenJournalLine.SETRANGE("Journal Template Name", GLSetup."Auto Payment Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name", GLSetup."Auto Payment Jnl Batch Name");
        IF GenJournalLine.FINDFIRST() THEN
            GenJournalLine.DELETEALL();


        Clear(TempDocNo);
        GenJournalBatch.RESET();
        GenJournalBatch.SETRANGE("Journal Template Name", GLSetup."Auto Payment Template Name");
        GenJournalBatch.SETRANGE(Name, GLSetup."Auto Payment Jnl Batch Name");
        IF GenJournalBatch.FINDFIRST() THEN
            TempDocNo := NoSeries.GetNextNo(GLSetup."Auto Payment Nos", 0D, TRUE);

        CLEAR(NoSeries);

        GenJournalLine.RESET();
        GenJournalLine.SETRANGE("Journal Template Name", GLSetup."Auto Payment Template Name");
        GenJournalLine.SETRANGE("Journal Batch Name", GLSetup."Auto Payment Jnl Batch Name");
        IF GenJournalLine.FINDLAST() THEN
            GenJournalLine."Line No." := GenJournalLine."Line No." + 10000
        ELSE
            GenJournalLine."Line No." := 10000;

        GenJournalLine.INIT();
        GenJournalLine.VALIDATE("Journal Template Name", GLSetup."Auto Payment Template Name");
        GenJournalLine.VALIDATE("Journal Batch Name", GLSetup."Auto Payment Jnl Batch Name");
        GenJournalLine.VALIDATE("Document Type", GenJournalLine."Document Type"::Payment);
        GenJournalLine.VALIDATE("Document No.", TempDocNo);
        GenJournalLine.VALIDATE("Account Type", GenJournalLine."Account Type"::Customer);
        GenJournalLine.VALIDATE("Account No.", CRMSales."Customer No.");
        GenJournalLine."External Document No." := CRMSales."External Document No.";
        // GenJournalLine.Comment := POSInv."POS Invoice No.";
        GenJournalLine.VALIDATE("Bal. Account Type", GenJournalLine."Bal. Account Type"::"Bank Account");
        GenJournalLine.VALIDATE("Posting Date", CRMSales."Posting Date");
        GenJournalLine.Validate("Bal. Account No.", CRMSales."Bank Account Code");
        GenJournalLine.Validate("Credit Amount", CRMSales.Amount);

        GenJournalLine.VALIDATE("Location Code", CRMSales."Location Code");
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code", CRMSales.GD1);
        GenJournalLine.Validate("Shortcut Dimension 2 Code", CRMSales.GD2);
        if GenJournalLine.INSERT(TRUE) then begin
            PostGenJournal(GenJournalLine);
        end;
    end;

    procedure PostGenJournal(GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        GLSetup_POST: Record "General Ledger Setup";
    begin

        GLSetup_POST.get();
        GLSetup_POST.TestField("Auto Payment Template Name");
        GLSetup_POST.TestField("Auto Payment Jnl Batch Name");
        GenJournalBatch.RESET();
        GenJournalBatch.SETRANGE("Journal Template Name", GLSetup_POST."Auto Payment Template Name");
        GenJournalBatch.SETRANGE(Name, GLSetup_POST."Auto Payment Jnl Batch Name");
        IF GenJournalBatch.FINDFIRST() THEN
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJournalLine);
    end;

    var
        TempDocNo: Code[20];
}
