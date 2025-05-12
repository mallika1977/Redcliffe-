report 50005 "Purch. Invoice Imp. File"
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
        InvU: Record "Inv Update";
        PLLLL: Record "Purchase Line";
        RPLLLL: Record "Purchase Line";
        XPLLLL: Record "Purchase Line";
        CalculateTax: Codeunit "Calculate Tax";
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
        PH_I: Record "Gen. Journal Line";
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
        PH: Record "Purchase Header";
        PH_I: Record "Purchase Header";
        PL: Record "Purchase Line";
        PL_C: Record "Purchase Line";
        PL_LL: Record "Purchase Line";
        PL_L: Record "Purchase Line";
        DocD: Code[30];
        LineN: Integer;
        GstCre: Option "GST Credit";
        InvUP: Record "Inv Update";
        CalculateTax: Codeunit "Calculate Tax";
        Rec_VEND: Record Vendor;
    begin
        InvUP.DeleteAll();

        PH.Reset();
        PH.SetRange("Document Type", PH."Document Type"::Invoice);
        PH.SetRange("No.", GetValueAtCell(RowNo, 1));
        IF not PH.FindFirst() then begin
            PH_I.INIT;
            PH_I.validate("Document Type", PH."Document Type"::Invoice);
            PH_I.validate("No.", GetValueAtCell(RowNo, 1));
            PH_I.Insert(true);
            DocD := PH_I."No.";

            PH_I.validate("Buy-from Vendor No.", GetValueAtCell(RowNo, 2));
            EVALUATE(PH_I."Posting Date", GetValueAtCell(RowNo, 3));
            PH_I.validate("Posting Date");
            PH_I.validate("Order Address Code", GetValueAtCell(RowNo, 4));
            EVALUATE(PH_I."Invoice Type", GetValueAtCell(RowNo, 5));
            PH_I.validate("Invoice Type");
            PH_I.validate("Location Code", GetValueAtCell(RowNo, 10));
            PH_I.validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 6));
            PH_I.validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 7));
            // PH_I.validate("Shortcut Dimension 3 Code", GetValueAtCell(RowNo, 8));
            // PH_I.validate("Shortcut Dimension 4 Code", GetValueAtCell(RowNo, 9));
            EVALUATE(PH_I."Invoice Discount Amount", GetValueAtCell(RowNo, 11));
            PH_I.validate("Invoice Discount Amount");
            PH_I.validate("Vendor Invoice No.", GetValueAtCell(RowNo, 12));
            PH_I.validate(Narration, GetValueAtCell(RowNo, 17));
            PH_I.validate("Posting No. Series", GetValueAtCell(RowNo, 18));
            PH_I.Validate("GRN No", GetValueAtCell(RowNo, 20));
            EVALUATE(PH_I."GRN Date", GetValueAtCell(RowNo, 21));
            PH_I.validate("GRN Date");
            EVALUATE(PH_I."Vendor Invoice Date", GetValueAtCell(RowNo, 22));
            PH_I.validate("Vendor Invoice Date");
            EVALUATE(PH_I."Nature Type", GetValueAtCell(RowNo, 23));
            PH_I.validate("Nature Type");
            EVALUATE(PH_I."Document Date", GetValueAtCell(RowNo, 27));
            PH_I.validate("Document Date");
            EVALUATE(PH_I."PO Date", GetValueAtCell(RowNo, 28));
            PH_I.validate("PO Date");
            PH_I.Validate("Bill to-Location(POS)", GetValueAtCell(RowNo, 29));
            PH_I.Modify();

            PL.Init();
            PL.validate("Document Type", PH_I."Document Type");
            PL.validate("Document No.", PH_I."No.");
            PL.Validate("Line No.", 10000);
            PL.Insert(true);
            EVALUATE(PL.Type, GetValueAtCell(RowNo, 19));
            PL.Validate(Type);
            PL.Validate("No.", GetValueAtCell(RowNo, 13));
            EVALUATE(PL.Quantity, GetValueAtCell(RowNo, 14));
            PL.Validate(Quantity);
            EVALUATE(PL."Direct Unit Cost", GetValueAtCell(RowNo, 15));
            PL.Validate("Direct Unit Cost");
            EVALUATE(PL."Line Discount Amount", GetValueAtCell(RowNo, 16));
            PL.Validate("Line Discount Amount");
            EVALUATE(PL."GST Credit", GetValueAtCell(RowNo, 26));
            PL.validate("GST Credit");
            PL.Validate("GST Group Code", GetValueAtCell(RowNo, 24));
            PL.Validate("HSN/SAC Code", GetValueAtCell(RowNo, 25));
            PL.Validate("Depreciation Book Code", GetValueAtCell(RowNo, 30));
            CalculateTax.CallTaxEngineOnPurchaseLine(PL, PL_L);
            PL.Modify();
        end ELSE begin
            PL_LL.Reset();
            PL_LL.SetRange("Document Type", PL_LL."Document Type"::Invoice);
            PL_LL.SetRange("Document No.", GetValueAtCell(RowNo, 1));
            IF PL_LL.FindLast() then;
            PL.Init();
            PL.validate("Document Type", PL."Document Type"::Invoice);
            PL.validate("Document No.", GetValueAtCell(RowNo, 1));
            DocD := GetValueAtCell(RowNo, 1);
            PL.Validate("Line No.", PL_LL."Line No." + 10000);
            LineN := PL_LL."Line No." + 10000;
            PL.Insert();
            EVALUATE(PL.Type, GetValueAtCell(RowNo, 19));
            PL.Validate(Type);
            PL.Validate("No.", GetValueAtCell(RowNo, 13));
            EVALUATE(PL.Quantity, GetValueAtCell(RowNo, 14));
            PL.Validate(Quantity);
            EVALUATE(PL."Direct Unit Cost", GetValueAtCell(RowNo, 15));
            PL.Validate("Direct Unit Cost");
            EVALUATE(PL."Line Discount Amount", GetValueAtCell(RowNo, 16));
            PL.Validate("Line Discount Amount");
            EVALUATE(PL."GST Credit", GetValueAtCell(RowNo, 26));
            PL.Validate("GST Credit");
            PL.Validate("GST Group Code", GetValueAtCell(RowNo, 24));
            PL.Validate("HSN/SAC Code", GetValueAtCell(RowNo, 25));
            PL.Validate("Depreciation Book Code", GetValueAtCell(RowNo, 30));
            CalculateTax.CallTaxEngineOnPurchaseLine(PL, PL_L);
            PL.Modify();
        end;
    end;

    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        IF ExcelBuf1.GET(RowNo, ColNo) THEN
            EXIT(ExcelBuf1."Cell Value as Text");
    end;
}

