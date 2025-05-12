report 50003 "Import Batch File"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;

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
        GenJnlLine: Record "Gen. Journal Line";
        Batch_N: CODE[50];
        Temp_C: Code[50];

    procedure GetLastRowandColumn()
    begin
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    end;

    procedure Gen_Batch_Temp(Bat: Code[50]; Tem_: Code[50])
    begin
        Batch_N := Bat;
        Temp_C := Tem_;
    end;

    procedure InsertData(RowNo: Integer)
    var
    begin
        GenJnlLine.INIT;
        GenJnlLine.validate("Journal Template Name", GetValueAtCell(RowNo, 1));
        GenJnlLine.validate("Journal Batch Name", GetValueAtCell(RowNo, 2));
        GenJnlLine."Line No." := RowNo * 10000;
        GenJnlLine.Insert();
        EVALUATE(GenJnlLine."Posting Date", GetValueAtCell(RowNo, 3));
        GenJnlLine.validate("Posting Date");
        EVALUATE(GenJnlLine."Document Type", GetValueAtCell(RowNo, 4));
        GenJnlLine.validate("Document Type");
        GenJnlLine.validate("Document No.", GetValueAtCell(RowNo, 5));
        EVALUATE(GenJnlLine."Account Type", GetValueAtCell(RowNo, 6));
        GenJnlLine.validate("Account Type");
        GenJnlLine.Validate("Account No.", GetValueAtCell(RowNo, 7));
        IF GenJnlLine."Document Type" = GenJnlLine."Document Type"::Payment then
            GenJnlLine.Validate("TDS Section Code", '');
        if GetValueAtCell(RowNo, 8) = '' then
            GenJnlLine.validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account")
        else
            EVALUATE(GenJnlLine."Bal. Account Type", GetValueAtCell(RowNo, 8));
        GenJnlLine.validate("Bal. Account Type");
        GenJnlLine.Validate("Bal. Account No.", GetValueAtCell(RowNo, 9));
        EVALUATE(GenJnlLine.Amount, GetValueAtCell(RowNo, 10));
        GenJnlLine.validate(Amount);
        GenJnlLine.validate("Location Code", GetValueAtCell(RowNo, 11));
        GenJnlLine.validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
        GenJnlLine.validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
        GenJnlLine.validate("External Document No.", GetValueAtCell(RowNo, 14));
        if GetValueAtCell(RowNo, 15) <> '' then
            EVALUATE(GenJnlLine."Applies-to Doc. Type", GetValueAtCell(RowNo, 15));
        GenJnlLine.validate("Applies-to Doc. Type");
        GenJnlLine.Validate("Applies-to Doc. No.", GetValueAtCell(RowNo, 16));
        GenJnlLine.Validate(Narration, GetValueAtCell(RowNo, 17));
        if GenJnlLine."Document Type" <> GenJnlLine."Document Type"::Invoice then begin
            GenJnlLine.Validate("Gen. Bus. Posting Group", '');
            GenJnlLine.Validate("Gen. Posting Type", GenJnlLine."Gen. Posting Type"::" ");
            GenJnlLine.Validate("Gen. Prod. Posting Group", '');
            GenJnlLine.Validate("Bal. Gen. Bus. Posting Group");
            GenJnlLine.Validate("Bal. Gen. Posting Type", GenJnlLine."Bal. Gen. Posting Type"::" ");
            GenJnlLine.Validate("Bal. Gen. Prod. Posting Group", '');
        end;
        GenJnlLine.Modify();
    end;

    //    [Scope('Internal')]
    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        IF ExcelBuf1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuf1."Cell Value as Text");
    end;
}

