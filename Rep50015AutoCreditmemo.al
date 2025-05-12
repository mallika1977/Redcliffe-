report 50015 "Auto Credit Memo"
{
    //  ApplicationArea = All;
    Caption = 'Auto Credit Memo';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions = tabledata "Purchase Header" = rmi,
    tabledata "Purchase Line" = rmi,

    tabledata "Purch. Inv. Header" = rmi,
     tabledata "Purch. Inv. Line" = rmi,
     tabledata "Purch. Rcpt. Line" = rmi,
     tabledata "Purch. Rcpt. Header" = rmi,
     tabledata "Detailed GST Ledger Entry" = rmi,
     tabledata "GST Ledger Entry" = rmi,
  tabledata "Value Entry" = rmi,
  tabledata "Item Ledger Entry" = rmi,
   tabledata "Cust. Ledger Entry" = rmi,
   tabledata "Detailed Cust. Ledg. Entry" = rmi,
   tabledata "G/L Entry" = rmi,
  tabledata "VAT Entry" = rmi;
    dataset
    {
        dataitem("TEMP POSTED SALE INVOICE"; "TEMP POSTED SALE INVOICE")
        {
            DataItemTableView = where(Updated = filter(false));
            RequestFilterFields = "INVOICE NO.";

            trigger OnPreDataItem()
            begin
                REC_PURPAYS_SETUP.Get();
            end;

            trigger OnAfterGetRecord()
            begin
                //    ChangeDocNo("TEMP POSTED SALE INVOICE"."INVOICE NO.", "TEMP POSTED SALE INVOICE"."INVOICE NO." + '.');
                //   Commit();
                PurchInvoiceHeader.Reset();
                PurchInvoiceHeader.SetRange("No.", "TEMP POSTED SALE INVOICE"."INVOICE NO.");
                if PurchInvoiceHeader.FindFirst() then begin
                    Doc_No := NoSerMgt.GetNextNo(REC_PURPAYS_SETUP."Credit Memo Nos.", Today, true);
                    REC_SHDR.Init();
                    REC_SHDR."Document Type" := REC_SHDR."Document Type"::"Credit Memo";
                    REC_SHDR."No." := Doc_No;
                    REC_SHDR.Insert(TRUE);
                    REC_SHDR.Validate("Buy-from Vendor No.", PurchInvoiceHeader."Buy-from Vendor No.");
                    REC_SHDR.Validate("Location Code", PurchInvoiceHeader."Location Code");
                    if PurchInvoiceHeader."Shortcut Dimension 1 Code" <> '' then
                        REC_SHDR.Validate("Shortcut Dimension 1 Code", PurchInvoiceHeader."Shortcut Dimension 1 Code");
                    if PurchInvoiceHeader."Shortcut Dimension 2 Code" <> '' then
                        REC_SHDR.Validate("Shortcut Dimension 2 Code", PurchInvoiceHeader."Shortcut Dimension 2 Code");
                    REC_SHDR.Validate("Document Date", PurchInvoiceHeader."Document Date");
                    REC_SHDR."Posting Date" := PurchInvoiceHeader."Posting Date";
                    REC_SHDR.Validate("Applies-to Doc. Type", REC_SHDR."Applies-to Doc. Type"::Invoice);
                    REC_SHDR.Validate("Applies-to Doc. No.", PurchInvoiceHeader."No.");
                    REC_SHDR.Validate("Reference Invoice No.", PurchInvoiceHeader."No.");
                    //REC_SHDR."Posting No." := 'REV' + PurchInvoiceHeader."No.";
                    REC_SHDR."Posting No." := PurchInvoiceHeader."No.";//Comment
                    REC_SHDR."Vendor Cr. Memo No." := PurchInvoiceHeader."Vendor Invoice No.";
                    REC_SHDR.VALIDATE("Bill to-Location(POS)", PurchInvoiceHeader."Bill to-Location(POS)");
                    REC_SHDR.Modify();
                    REC_SIL.Reset();
                    REC_SIL.SetRange("Document No.", PurchInvoiceHeader."No.");
                    if REC_SIL.FindSet() then begin
                        repeat
                            REC_SL.Init();
                            REC_SL."Document Type" := REC_SL."Document Type"::"Credit Memo";
                            REC_SL."Document No." := REC_SHDR."No.";
                            REC_SL."Line No." := REC_SIL."Line No.";
                            REC_SL.Validate("Buy-from Vendor No.", recSIL."Buy-from Vendor No.");
                            REC_SL.Insert(true);
                            REC_SL.Type := REC_SIL.Type;
                            REC_SL.Validate("No.", REC_SIL."No.");
                            REC_SL.Validate("Location Code", REC_SIL."Location Code");
                            if REC_SIL."Shortcut Dimension 1 Code" <> '' then
                                REC_SL.Validate("Shortcut Dimension 1 Code", REC_SIL."Shortcut Dimension 1 Code");
                            if REC_SIL."Shortcut Dimension 2 Code" <> '' then
                                REC_SL.Validate("Shortcut Dimension 2 Code", REC_SIL."Shortcut Dimension 2 Code");

                            REC_SL.validate(Quantity, REC_SIL.Quantity);
                            REC_SL.validate("Direct Unit Cost", REC_SIL."Direct Unit Cost");
                            REC_SL.validate("Line Discount %", REC_SIL."Line Discount %");
                            //REC_SL."Line Discount Amount" := REC_SIL."Line Discount Amount";
                            //REC_SL."Line Amount" := REC_SIL."Line Amount";
                            // REC_SL := REC_SIL."GST Place of Supply";
                            REC_SL.validate("GST Credit", REC_SL."GST Credit");
                            REC_SL.validate("GST Group Code", REC_SIL."GST Group Code");
                            REC_SL.validate("HSN/SAC Code", REC_SIL."HSN/SAC Code");
                            REC_SL."VAT Prod. Posting Group" := REC_SIL."VAT Prod. Posting Group";
                            REC_SL.Modify();
                        until REC_SIL.Next() = 0;
                        Commit();
                        SL_Rec.Reset();
                        SL_Rec.SetRange("Document No.", REC_SHDR."No.");
                        SL_Rec.SetRange("Document Type", SL_Rec."Document Type"::"Credit Memo");
                        if SL_Rec.FindFirst() then
                            repeat
                                SL_Rec.validate("GST Credit", SL_Rec."GST Credit"::Availment);
                                SL_Rec.Modify();
                            until SL_Rec.Next() = 0;
                        OpenSalesOrderStatistics(REC_SHDR);
                        Reference_Inv.Reset();
                        Reference_Inv.SetRange("Document Type", Reference_Inv."Document Type"::"Credit Memo");
                        Reference_Inv.SetRange("Document No.", REC_SHDR."No.");
                        Reference_Inv.SetRange("Source No.", REC_SHDR."Buy-from Vendor No.");
                        Reference_Inv.SetRange("Source Type", Reference_Inv."Source Type"::Vendor);
                        Reference_Inv.SetFilter("Reference Invoice Nos.", '<>%1', '');
                        if Not Reference_Inv.FindFirst() then begin
                            Reference_Inv.Init();
                            Reference_Inv.Validate("Document Type", Reference_Inv."Document Type"::"Credit Memo");
                            Reference_Inv.Validate("Document No.", REC_SHDR."No.");
                            Reference_Inv.Validate("Source Type", Reference_Inv."Source Type"::Vendor);
                            Reference_Inv.Validate("Source No.", REC_SHDR."Buy-from Vendor No.");
                            Reference_Inv.Validate("Reference Invoice Nos.", PurchInvoiceHeader."No.");
                            Reference_Inv.Validate(Verified, true);
                            Reference_Inv.Insert();
                        end;
                        Commit();
                    end;
                    CODEUNIT.RUN(CODEUNIT::"Purch.-Post", REC_SHDR);
                end;

                Updated := true;
                "Credit Memo" := Doc_No;
                // "Posted Credit Memo" := 'REV' + PurchInvoiceHeader."No.";
                "Posted Credit Memo" := PurchInvoiceHeader."No.";//Comment
                Modify();
                Commit();

            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    procedure ChangeDocNo(OldDocNo: Code[30]; NewDocNo: Code[30])
    begin
        recSIH.GET(OldDocNo);
        recSIH.RENAME(NewDocNo);
        recSIL.Reset();
        recSIL.SETRANGE("Document No.", OldDocNo);
        IF recSIL.FINDSET THEN BEGIN
            REPEAT
                IF recSIL."Document No." = OldDocNo THEN
                    recSIL.Rename(NewDocNo, recSIL."Line No.");
            UNTIL recSIL.NEXT = 0;
        END;
        recDGLE.RESET;
        recDGLE.SETRANGE("Document No.", OldDocNo);
        recDGLE.SETRANGE("Document Type", recDGLE."Document Type"::Invoice);
        IF recDGLE.FINDSET THEN BEGIN
            REPEAT
                IF recDGLE."Document No." = OldDocNo THEN
                    recDGLE."Document No." := NewDocNo;
                recDGLE.MODIFY;
            UNTIL recDGLE.NEXT = 0;
        END;
        recCLE.RESET;
        recCLE.SETRANGE("Document No.", OldDocNo);
        recCLE.SETRANGE("Document Type", recCLE."Document Type"::Invoice);
        IF recCLE.FINDSET THEN BEGIN
            REPEAT
                IF recCLE."Document No." = OldDocNo THEN
                    recCLE."Document No." := NewDocNo;
                recCLE.MODIFY;
            UNTIL recCLE.NEXT = 0;
        END;
        recDCLE.RESET;
        recDCLE.SETRANGE("Document No.", OldDocNo);
        recDCLE.SETRANGE("Document Type", recDCLE."Document Type"::Invoice);
        IF recDCLE.FINDSET THEN BEGIN
            REPEAT
                IF recDCLE."Document No." = OldDocNo THEN
                    recDCLE."Document No." := NewDocNo;
                recDCLE.MODIFY;
            UNTIL recDCLE.NEXT = 0;
        END;
        recGLE.RESET;
        recGLE.SETRANGE("Document No.", OldDocNo);
        recGLE.SETRANGE("Document Type", recGLE."Document Type"::Invoice);
        IF recGLE.FINDSET THEN BEGIN
            REPEAT
                IF recGLE."Document No." = OldDocNo THEN
                    recGLE."Document No." := NewDocNo;
                recGLE.MODIFY;
            UNTIL recGLE.NEXT = 0;
        END;
        recGL.RESET;
        recGL.SETRANGE("Document No.", OldDocNo);
        recGL.SETRANGE("Document Type", recGL."Document Type"::Invoice);
        IF recGL.FINDSET THEN BEGIN
            REPEAT
                IF recGL."Document No." = OldDocNo THEN
                    recGL."Document No." := NewDocNo;
                recGL.MODIFY;
            UNTIL recGL.NEXT = 0;
        END;

        recVE.Reset();
        recVE.SetRange("Document No.", OldDocNo);
        if recVE.FindSet() then begin
            repeat
                if recVE."Document No." = OldDocNo then
                    recVE."Document No." := NewDocNo;
                recVE.Modify();
            until recVE.Next() = 0;
        end;

        REC_VAT.Reset();
        REC_VAT.SetRange("Document No.", OldDocNo);
        if REC_VAT.FindSet() then begin
            repeat
                if REC_VAT."Document No." = OldDocNo then
                    REC_VAT."Document No." := NewDocNo;
                REC_VAT.Modify();
            until REC_VAT.Next() = 0;
        end;

        recILE.Reset();
        recILE.SetRange("Document No.", OldDocNo);
        if recILE.FindSet() then begin
            repeat
                if recILE."Document No." = OldDocNo then
                    recILE."Document No." := NewDocNo;
                recILE.Modify();
            until recILE.Next() = 0;
        end;
    end;


    procedure OpenSalesOrderStatistics(SH: Record "Purchase Header")
    var
        IsHandled: Boolean;
    begin
        OpenDocumentStatisticsInternal(SH);

    end;

    local procedure OpenDocumentStatisticsInternal(SH: Record "Purchase Header")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;
        ShowDocumentStatisticsPage(SH);
    end;

    procedure ShowDocumentStatisticsPage(SH: Record "Purchase Header")
    var
        SalesCalcDiscountByType: Codeunit "Purch - Calc Disc. By Type";
        StatisticsPageId: Integer;
        sales_Order_Statistics: page "Sales Order Statistics";
    begin
        SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(SH);
    end;


    var
        VAT_ENTRY: Record "VAT Entry";
        REC_SIL: Record "Purch. Inv. Line";
        REC_SHDR: Record "Purchase Header";
        REC_SL: Record "Purchase Line";
        NoSerMgt: Codeunit NoSeriesManagement;
        REC_PURPAYS_SETUP: Record "Purchases & Payables Setup";
        Doc_No: Code[20];
        PurchInvoiceHeader: Record "Purch. Inv. Header";
        STRLN: Integer;
        POS_NO: text[20];
        Reference_Inv: Record "Reference Invoice No.";
        recSIH: Record "Purch. Inv. Header";
        recSIL: Record "Purch. Inv. Line";
        recDGLE: Record "Detailed GST Ledger Entry";
        recCLE: Record "Cust. Ledger Entry";
        recDCLE: Record "Detailed Cust. Ledg. Entry";
        recGLE: Record "GST Ledger Entry";
        // recPSOD: Record "13760";
        // recPSOLD: Record "13798";
        recSSH: Record "Purch. Rcpt. Header";
        recSSL: Record "Purch. Rcpt. Line";
        recGL: Record "G/L Entry";
        recILE: Record "Item Ledger Entry";
        recVE: Record "Value Entry";
        REC_VAT: Record "VAT Entry";

        REC_PSIL: Record "Purch. Inv. Line";
        DGST: Record "Detailed GST Ledger Entry";
        SL_Rec: Record "Purchase Line";


}
