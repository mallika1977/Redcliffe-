report 63059 "Bank Payment excel Import"
{
    // NAV#ExcelImport
    //   # Report to Simulate Excel Import

    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = all;
    Caption = 'Auto Create Sale Invoice';
    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    Visible = false;
                    field(ImportOption; ImportOption)
                    {
                        Caption = 'Option';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            // IF CloseAction = ACTION::OK THEN BEGIN
            //     ServerFileName := FileMgt.UploadFile(Text006, ExcelExtensionTok);
            //     IF ServerFileName = '' THEN
            //         EXIT(FALSE);
            //     SheetName := ExcelBuf.SelectSheetsName(ServerFileName);

            //     IF SheetName = '' THEN
            //         EXIT(FALSE);
            // END;

            //SAC
            Rec_SI.DeleteAll();
            Rec_ExcelBuffer.DeleteAll();
            Rows := 0;
            Columns := 0;
            FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

            if Filename <> '' then
                Sheetname := Rec_ExcelBuffer.SelectSheetsNameStream(Instr)
            else
                exit;


            Rec_ExcelBuffer.Reset;
            Rec_ExcelBuffer.OpenBookStream(Instr, Sheetname);
            Rec_ExcelBuffer.ReadSheet();

            Commit();
            Rec_ExcelBuffer.Reset();
            Rec_ExcelBuffer.SetRange("Column No.", 1);
            if Rec_ExcelBuffer.FindFirst() then
                repeat
                    Rows := Rows + 1;
                until Rec_ExcelBuffer.Next() = 0;
            //Message(Format(Rows));

            Rec_ExcelBuffer.Reset();
            Rec_ExcelBuffer.SetRange("Row No.", 1);
            if Rec_ExcelBuffer.FindFirst() then
                repeat
                    Columns := Columns + 1;
                until Rec_ExcelBuffer.Next() = 0;
            //Message(Format(Columns))
            //Modify or Insert
            for RowNo := 2 to Rows do begin
                GetLastRowandColumn;
                InsertData(RowNo);

                //SAC
            end;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if Sale_OrderNo <> '' then begin
            MESSAGE('Sales Invoice Created %1-', Sale_OrderNo);
            IF CONFIRM('Do you want to open sale invoice') THEN BEGIN
                SH.RESET;
                SH.SETFILTER("No.", Sale_OrderNo);
                IF SH.FINDSET THEN BEGIN
                    Sale_Order.SETTABLEVIEW(SH);
                    Sale_Order.RUN;
                END;
            END;
        end;
    end;

    trigger OnPreReport()
    var
        X: Integer;
    begin

        // ExcelBuf.LOCKTABLE;
        // ExcelBuf.OpenBook(ServerFileName, SheetName);
        // ExcelBuf.ReadSheet;

        // FOR X := 2 TO TotalRows DO
        //     InsertData(X);


        // ExcelBuf.DELETEALL;

        // MESSAGE('Import Completed.');
        CreatOrder;
    end;

    var
        ImportOption: Option "Add entries","Replace entries";
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
        Colno2: Integer;
        Int: Integer;
        RepleSystem: Text;
        CostMethod: Text;
        Line: Integer;
        ExcelUploadSaleOrder: Record "Excel Upload Sale Order";
        OLD_DOCNO: Code[20];
        Line_No: Integer;
        REC_SH: Record "Sales Header";
        REC_SL: Record "Sales Line";
        Sale_OrderNo: Text;
        SH: Record "Sales Header";
        Sale_Order: Page "Sales Invoice";
        TempDocNo: Code[20];
        //sac auto pay
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        Filename: Text;
        FileMgmt: Codeunit "File Management";
        ExcelFile: File;
        Instr: InStream;

        FileUploaded: Boolean;
        RowNo: Integer;
        ColNo: Integer;

        Order_No: Text;
        // ANIKET

        PrepmtTotalAmount: Decimal;
        PrepmtVATAmount: Decimal;
        PrepmtTotalAmount2: Decimal;
        VATAmountText: array[3] of Text[30];
        PrepmtVATAmountText: Text[30];
        ProfitLCY: array[3] of Decimal;
        ProfitPct: array[3] of Decimal;
        AdjProfitLCY: array[3] of Decimal;
        AdjProfitPct: array[3] of Decimal;
        TotalAdjCostLCY: array[3] of Decimal;
        CreditLimitLCYExpendedPct: Decimal;
        PrepmtInvPct: Decimal;
        PrepmtDeductedPct: Decimal;
        i: Integer;
        PrevNo: Code[20];
        Rec_SI: Record "Excel Upload Sale Order";





    //[Scope('Internal')]
    procedure GetLastRowandColumn()
    begin
        ExcelBuf.SETRANGE("Row No.", 1);
        TotalColumns := ExcelBuf.COUNT;

        ExcelBuf.RESET;
        IF ExcelBuf.FINDLAST THEN
            TotalRows := ExcelBuf."Row No.";
    end;

    // [Scope('Internal')]
    procedure InsertData(RowNo: Integer)
    var
        ItemNo: Code[20];
        LMonth: Integer;
    begin
        ExcelUploadSaleOrder.INIT;
        ExcelUploadSaleOrder."Doc No." := GetValueAtCell(RowNo, 1);
        ExcelUploadSaleOrder."Customer Code" := GetValueAtCell(RowNo, 2);
        EVALUATE(ExcelUploadSaleOrder."Posting Date", GetValueAtCell(RowNo, 3));
        ExcelUploadSaleOrder."Posting No. Series" := GetValueAtCell(RowNo, 4);
        if GetValueAtCell(RowNo, 5) = '' then
            ExcelUploadSaleOrder."Invoice Type" := ExcelUploadSaleOrder."Invoice Type"::" "
        else
            if GetValueAtCell(RowNo, 5) = 'Bill of Supply' then
                ExcelUploadSaleOrder."Invoice Type" := ExcelUploadSaleOrder."Invoice Type"::"Bill of Supply"
            else
                if GetValueAtCell(RowNo, 5) = 'Debit Note' then
                    ExcelUploadSaleOrder."Invoice Type" := ExcelUploadSaleOrder."Invoice Type"::"Debit Note"
                else
                    if GetValueAtCell(RowNo, 5) = 'Export' then
                        ExcelUploadSaleOrder."Invoice Type" := ExcelUploadSaleOrder."Invoice Type"::Export
                    else
                        if GetValueAtCell(RowNo, 5) = 'Non-GST' then
                            ExcelUploadSaleOrder."Invoice Type" := ExcelUploadSaleOrder."Invoice Type"::"Non-GST"
                        else
                            if GetValueAtCell(RowNo, 5) = 'Supplementary' then
                                ExcelUploadSaleOrder."Invoice Type" := ExcelUploadSaleOrder."Invoice Type"::Supplementary
                            else
                                if GetValueAtCell(RowNo, 5) = 'Taxable' then
                                    ExcelUploadSaleOrder."Invoice Type" := ExcelUploadSaleOrder."Invoice Type"::Taxable;
        ExcelUploadSaleOrder."Dimension 1" := GetValueAtCell(RowNo, 6);
        ExcelUploadSaleOrder."Dimesnion 2" := GetValueAtCell(RowNo, 7);
        ExcelUploadSaleOrder."Dimesnion 3" := GetValueAtCell(RowNo, 8);
        ExcelUploadSaleOrder."Dimesion 4" := GetValueAtCell(RowNo, 9);
        ExcelUploadSaleOrder."Location Code" := GetValueAtCell(RowNo, 10);
        EVALUATE(ExcelUploadSaleOrder."Invoice Discount", GetValueAtCell(RowNo, 11));
        ExcelUploadSaleOrder."External Doc No" := GetValueAtCell(RowNo, 12);
        ExcelUploadSaleOrder."Item No." := GetValueAtCell(RowNo, 13);
        EVALUATE(ExcelUploadSaleOrder.Quanity, GetValueAtCell(RowNo, 14));
        EVALUATE(ExcelUploadSaleOrder."Unit Price", GetValueAtCell(RowNo, 15));
        EVALUATE(ExcelUploadSaleOrder."Line Discount", GetValueAtCell(RowNo, 16));
        Evaluate(ExcelUploadSaleOrder."Applies-to Doc. Type", GetValueAtCell(RowNo, 17));
        Evaluate(ExcelUploadSaleOrder."Applies-to Doc. No.", GetValueAtCell(RowNo, 18));
        ExcelUploadSaleOrder.INSERT(TRUE);
    end;

    //[Scope('Internal')]
    procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        //ExcelBuf1.GET(RowNo,ColNo);
        ExcelBuf1.RESET;
        ExcelBuf1.SETRANGE(ExcelBuf1."Row No.", RowNo);
        ExcelBuf1.SETRANGE(ExcelBuf1."Column No.", ColNo);
        IF ExcelBuf1.FINDFIRST THEN;
        EXIT(ExcelBuf1."Cell Value as Text");
    end;

    local procedure CreatOrder()
    var
        RE_USO: Record "Excel Upload Sale Order";
    begin

        RE_USO.RESET;
        RE_USO.SETCURRENTKEY("Entry No.");
        RE_USO.SETRANGE("Order Created", FALSE);
        IF RE_USO.FINDSET THEN BEGIN
            REPEAT
                IF OLD_DOCNO <> RE_USO."Doc No." THEN BEGIN
                    CLEAR(Line_No);
                    REC_SH.INIT;
                    REC_SH."Document Type" := REC_SH."Document Type"::Invoice;
                    REC_SH."No." := RE_USO."Doc No.";
                    if RE_USO."Invoice Type" = RE_USO."Invoice Type"::"Bill of Supply" then
                        REC_SH."Invoice Type" := REC_SH."Invoice Type"::"Bill of Supply"
                    else
                        if RE_USO."Invoice Type" = RE_USO."Invoice Type"::"Debit Note" then
                            REC_SH."Invoice Type" := REC_SH."Invoice Type"::"Debit Note"
                        else
                            if RE_USO."Invoice Type" = RE_USO."Invoice Type"::Export then
                                REC_SH."Invoice Type" := REC_SH."Invoice Type"::Export
                            else
                                if RE_USO."Invoice Type" = RE_USO."Invoice Type"::"Non-GST" then
                                    REC_SH."Invoice Type" := REC_SH."Invoice Type"::"Non-GST"
                                else
                                    if RE_USO."Invoice Type" = RE_USO."Invoice Type"::Supplementary then
                                        REC_SH."Invoice Type" := REC_SH."Invoice Type"::Supplementary
                                    else
                                        if RE_USO."Invoice Type" = RE_USO."Invoice Type"::Taxable then
                                            REC_SH."Invoice Type" := REC_SH."Invoice Type"::Taxable;

                    REC_SH.VALIDATE("Invoice Type");
                    REC_SH.INSERT(TRUE);
                    REC_SH.VALIDATE("Sell-to Customer No.", RE_USO."Customer Code");
                    REC_SH.VALIDATE("Posting Date", RE_USO."Posting Date");

                    if RE_USO."Location Code" <> '' then
                        REC_SH.VALIDATE("Location Code", RE_USO."Location Code");
                    if RE_USO."Dimension 1" <> '' then
                        REC_SH.VALIDATE("Shortcut Dimension 1 Code", RE_USO."Dimension 1");
                    if RE_USO."Dimesnion 2" <> '' then
                        REC_SH.VALIDATE("Shortcut Dimension 2 Code", RE_USO."Dimesnion 2");
                    // REC_SH.VALIDATE("Invoice Type", RE_USO."Invoice Type");
                    if RE_USO."Posting No. Series" <> '' then
                        REC_SH.VALIDATE("Posting No. Series", RE_USO."Posting No. Series");
                    REC_SH."External Document No." := RE_USO."External Doc No";
                    if RE_USO."Invoice Type" = RE_USO."Invoice Type"::"Bill of Supply" then
                        REC_SH."Invoice Type" := REC_SH."Invoice Type"::"Bill of Supply"
                    else
                        if RE_USO."Invoice Type" = RE_USO."Invoice Type"::"Debit Note" then
                            REC_SH."Invoice Type" := REC_SH."Invoice Type"::"Debit Note"
                        else
                            if RE_USO."Invoice Type" = RE_USO."Invoice Type"::Export then
                                REC_SH."Invoice Type" := REC_SH."Invoice Type"::Export
                            else
                                if RE_USO."Invoice Type" = RE_USO."Invoice Type"::"Non-GST" then
                                    REC_SH."Invoice Type" := REC_SH."Invoice Type"::"Non-GST"
                                else
                                    if RE_USO."Invoice Type" = RE_USO."Invoice Type"::Supplementary then
                                        REC_SH."Invoice Type" := REC_SH."Invoice Type"::Supplementary
                                    else
                                        if RE_USO."Invoice Type" = RE_USO."Invoice Type"::Taxable then
                                            REC_SH."Invoice Type" := REC_SH."Invoice Type"::Taxable;

                    REC_SH.VALIDATE("Invoice Type");
                    REC_SH.MODIFY;
                    IF Sale_OrderNo = '' THEN
                        Sale_OrderNo := REC_SH."No."
                    ELSE
                        Sale_OrderNo := Sale_OrderNo + '|' + REC_SH."No.";
                END;
                Line_No := Line_No + 10000;
                REC_SL.INIT;
                REC_SL."Document Type" := REC_SL."Document Type"::Invoice;
                REC_SL."Document No." := REC_SH."No.";
                REC_SL."Line No." := Line_No;
                REC_SL.Type := REC_SL.Type::Item;
                REC_SL.VALIDATE("No.", RE_USO."Item No.");
                REC_SL.VALIDATE(Quantity, RE_USO.Quanity);
                REC_SL.VALIDATE("Line Amount", RE_USO."Unit Price");
                REC_SL.VALIDATE("Line Discount %", RE_USO."Line Discount");
                REC_SL.INSERT(TRUE);
                OLD_DOCNO := RE_USO."Doc No.";
                RE_USO."Order Created" := TRUE;
                RE_USO.MODIFY;
            UNTIL RE_USO.NEXT = 0;
        END;
    end;
}

