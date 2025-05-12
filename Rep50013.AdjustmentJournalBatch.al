/// <summary>
/// Report Adjustment Journal Batch (ID 50013).
/// </summary>
report 50013 "Adjustment Journal Batch"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;


    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));

        }
    }

    requestpage
    {


        trigger OnQueryClosePage(CloseAction: Action): Boolean
        var
            PageTds: Page "TDS Adjustment Journal";
        begin

            IF CloseAction = ACTION::OK THEN BEGIN

                ServerFileName := FileMgt.UploadFile(Text006, ExcelExtensionTok);
                IF ServerFileName = '' THEN
                    EXIT(FALSE);

                SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                IF SheetName = '' THEN
                    EXIT(FALSE);

            END;
        end;


    }


    trigger OnPreReport()
    var
        X: Integer;
    begin

        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBook(ServerFileName, SheetName);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn;

        FOR X := 2 TO TotalRows DO
            InsertData(X);
        ExcelBuf.DELETEALL;
    end;

    trigger OnPostReport()
    begin
        MESSAGE('Import Completed.');
    end;

    var
        Text005: Label 'Imported from Excel ';
        ServerFileName: Text;
        SheetName: Text[250];
        FileMgt: Codeunit "File Management";
        Text006: Label 'Import Excel File';
        ExcelExtensionTok: Label '.xlsx', Locked = true;
        ExcelBuf: Record "Excel Buffer";
        Text010: Label 'Add entries,Replace entries';
        Window: Dialog;
        Text001: Label 'Do you want to create %1 %2.';
        Text003: Label 'Are you sure you want to %1 for %2 %3.';
        TotalColumns: Integer;
        TotalRows: Integer;


    /// <summary>
    /// GetLastRowandColumn.
    /// </summary>
    procedure GetLastRowandColumn()
    begin
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    end;



    /// <summary>
    /// InsertData.
    /// </summary>
    /// <param name="RowNo">Integer.</param>
    procedure InsertData(RowNo: Integer)
    var
        TdsEntry: Record "TDS Entry";
    begin
        TdsEntry.Reset();
        TdsEntry.SetRange("Document No.", GetValueAtCell(RowNo, 1));
        if TdsEntry.FindFirst() then begin
            InsertTDSJnlLine(TdsEntry."Entry No.");
        end;
    end;


    /// <summary>
    /// GetValueAtCell.
    /// </summary>
    /// <param name="RowNo">Integer.</param>
    /// <param name="ColNo">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        IF ExcelBuf1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuf1."Cell Value as Text");
    end;

    local procedure InsertTDSJnlLine(TransactionNo: Integer)
    var
        GetTDSEntry: Record "TDS Entry";
        TDSJournalLine: Record "TDS Journal Line";
        TDSJournalBatch: Record "TDS Journal Batch";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentNo: Code[20];
        LineNo: Integer;
    begin
        TDSJournalBatch.Get('TDS JNL', 'DEFAULT');
        if TDSJournalBatch."No. Series" <> '' then begin
            Clear(NoSeriesManagement);
            Commit();
            DocumentNo := NoSeriesManagement.TryGetNextNo(TDSJournalBatch."No. Series", Today);
        end;
        TDSJournalLine.LockTable();
        TDSJournalLine.SetRange("Journal Template Name", 'TDS JNL');
        TDSJournalLine.SetRange("Journal Batch Name", 'DEFAULT');
        if TDSJournalLine.FindLast() then
            LineNo := TDSJournalLine."Line No." + 10000
        else
            LineNo := 10000;

        GetTDSEntry.Get(TransactionNo);
        if GetTDSEntry."TDS Base Amount" <> 0 then
            InsertTDSJnlLineWithTDSAmt(TDSJournalLine, GetTDSEntry, DocumentNo, LineNo);
    end;

    local procedure InsertTDSJnlLineWithTDSAmt(
        TDSJournalLine: Record "TDS Journal Line";
        TDSEntry: Record "TDS Entry";
        DocumentNo: Code[20];
        LineNo: Integer)
    var
        SourceCodeSetup: Record "Source Code Setup";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        SourceCodeSetup.Get();
        SourceCodeSetup.TestField("TDS Adjustment Journal");
        TDSJournalLine.Init();
        TDSJournalLine."Document No." := DocumentNo;
        TDSJournalLine."Journal Template Name" := 'TDS JNL';
        TDSJournalLine."Journal Batch Name" := 'DEFAULT';
        TDSJournalLine."Line No." := LineNo;
        TDSJournalLine.Adjustment := true;
        TDSJournalLine."Posting Date" := WorkDate();
        TDSJournalLine."Account Type" := TDSJournalLine."Account Type"::Vendor;
        TDSJournalLine."Account No." := TDSEntry."Vendor No.";
        TDSJournalLine."TDS Section Code" := TDSEntry.Section;
        TDSJournalLine."Document Type" := TDSEntry."Document Type";
        TDSJournalLine."Concessional Code" := TDSEntry."Concessional Code";
        TDSJournalLine."Per Contract" := TDSEntry."Per Contract";
        TDSJournalLine."Assessee Code" := TDSEntry."Assessee Code";
        TDSJournalLine."TDS Base Amount" := Abs(TDSEntry."TDS Base Amount");
        TDSJournalLine."Surcharge Base Amount" := Abs(TDSEntry."Surcharge Base Amount");
        TDSJournalLine."eCESS Base Amount" := Abs(TDSEntry."TDS Amount Including Surcharge");
        TDSJournalLine."SHE Cess Base Amount" := Abs(TDSEntry."TDS Amount Including Surcharge");
        if TDSEntry.Adjusted then begin
            TDSJournalLine."TDS %" := TDSEntry."Adjusted TDS %";
            TDSJournalLine."Surcharge %" := TDSEntry."Adjusted Surcharge %";
            TDSJournalLine."eCESS %" := TDSEntry."Adjusted eCESS %";
            TDSJournalLine."SHE Cess %" := TDSEntry."Adjusted SHE CESS %"
        end else begin
            TDSJournalLine."TDS %" := TDSEntry."TDS %";
            TDSJournalLine."Surcharge %" := TDSEntry."Surcharge %";
            TDSJournalLine."eCESS %" := TDSEntry."eCESS %";
            TDSJournalLine."SHE Cess %" := TDSEntry."SHE Cess %";
        end;
        TDSJournalLine."Debit Amount" := TDSEntry."Total TDS Including SHE CESS";
        TDSJournalLine."TDS Amount" := TDSEntry."TDS Amount";
        TDSJournalLine."Surcharge Amount" := TDSEntry."Surcharge Amount";
        TDSJournalLine."eCESS on TDS Amount" := TDSEntry."eCESS Amount";
        TDSJournalLine."SHE Cess on TDS Amount" := TDSEntry."SHE Cess Amount";
        TDSJournalLine."Bal. Account No." := TDSEntry."Account No.";
        TDSJournalLine."TDS Invoice No." := TDSEntry."Document No.";
        TDSJournalLine."TDS Transaction No." := TDSEntry."Entry No.";
        TDSJournalLine."T.A.N. No." := TDSEntry."T.A.N. No.";
        TDSJournalLine."Document Type" := TDSJournalLine."Document Type"::" ";
        TDSJournalLine."Bal. TDS Including SHE CESS" := TDSEntry."Bal. TDS Including SHE CESS";
        TDSJournalLine."Source Code" := SourceCodeSetup."TDS Adjustment Journal";
        TDSJournalLine."TDS Transaction No." := TDSEntry."Entry No.";
        TDSJournalLine.Insert();

        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("No.", TDSEntry."Document No.");
        if PurchInvHeader.FindFirst() then begin
            TDSJournalLine.validate("Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 1 Code");
            TDSJournalLine.validate("Shortcut Dimension 2 Code", PurchInvHeader."Shortcut Dimension 2 Code");
        end;
        TDSJournalLine.Modify();

    end;
}