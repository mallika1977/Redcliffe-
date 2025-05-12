report 50008 "Purch. Invoice Delete"
{
    Caption = 'Purch \Sales Inv Delete';
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
        layout
        {
            area(content)
            {
                group("Select for Delete")
                {
                    Caption = 'Select for Delete';
                    field(PurchD; PurchD)
                    {
                        Caption = 'Purchase';
                        ApplicationArea = Suite;
                    }
                    field(SalesD; SalesD)
                    {
                        Caption = 'Sales';
                        ApplicationArea = Suite;
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if (SalesD = false) and (PurchD = false) then
                Error('Please select Option for Delete Sales or Purchase ?');
            if (SalesD = true) and (PurchD = true) then
                Error('Please select Only one Option for Delete Sales or Purchase ?');


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
        MESSAGE('Delete Completed.');
    end;

    var
        Text005: Label 'Imported from Excel ';
        ServerFileName: Text;
        SheetName: Text[250];
        FileMgt: Codeunit "File Management";
        Text006: Label 'Import Excel File for Delete';
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
        SalesD: Boolean;
        PurchD: Boolean;

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
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        PH_I: Record "Purchase Header";
        PL: Record "Purchase Line";
        PL_C: Record "Purchase Line";
        PL_LL: Record "Purchase Line";

    begin
        IF PurchD THEN begin
            PH.Reset();
            PH.SetRange("Document Type", PH."Document Type"::Invoice);
            PH.SetRange("No.", GetValueAtCell(RowNo, 1));
            IF PH.FindFirst() then begin
                PH.Delete(true);
                PL.Reset();
                PL.SetRange("Document Type", PL."Document Type"::Invoice);
                PL.SetRange("Document No.", GetValueAtCell(RowNo, 1));
                if PL.FindFirst() then
                    repeat
                        pl.Delete(true);
                    until PL.Next() = 0;
            end;
        END;
        IF SalesD THEN begin
            SH.Reset();
            SH.SetRange("Document Type", SH."Document Type"::Invoice);
            SH.SetRange("No.", GetValueAtCell(RowNo, 1));
            IF SH.FindFirst() then begin
                SH.Delete(true);
                SL.Reset();
                SL.SetRange("Document Type", SL."Document Type"::Invoice);
                SL.SetRange("Document No.", GetValueAtCell(RowNo, 1));
                if SL.FindFirst() then
                    repeat
                        SL.Delete(true);
                    until SL.Next() = 0;
            end;
        END;

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

