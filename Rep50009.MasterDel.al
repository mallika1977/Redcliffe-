report 50009 "Masters Delete"
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
        layout
        {
            area(content)
            {
                group("Select Master")
                {
                    Caption = 'Options';
                    field(ItemD; ItemD)
                    {
                        Caption = 'Item';
                        ApplicationArea = Suite;
                    }
                    field(CustD; CustD)
                    {
                        Caption = 'Customer';
                        ApplicationArea = Suite;
                    }
                    field(VenD; VenD)
                    {
                        Caption = 'Vendor';
                        ApplicationArea = Suite;
                    }
                }
            }
        }

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if (ItemD = false) and (CustD = false) and (VenD = false) then
                Error('Please select Option for Delete Item,Customer or Vendor ?');
            if (ItemD = true) and (CustD = true) and (VenD = true) then
                Error('Please select Only one Option for  Item,Customer or Vendor ?');
            if (ItemD = true) and (CustD = true) then
                Error('Please select Only one Option for Item or Customer?');
            if (ItemD = true) and (VenD = true) then
                Error('Please select Only one Option for Item or Vendor ?');
            if (CustD = true) and (VenD = true) then
                Error('Please select Only one Option for Customer or Vendor ?');

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
        ItemD: Boolean;
        CustD: Boolean;
        VenD: Boolean;


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
        ItemR: Record Item;
        CustR: Record Customer;
        VendR: Record Vendor;
    begin
        if ItemD then begin
            ItemR.Reset();
            ItemR.SetRange("No.", GetValueAtCell(RowNo, 2));
            IF ItemR.FindFirst() then begin
                ItemR.Delete(true);
            end;
        end;
        if CustD then begin
            CustR.Reset();
            CustR.SetRange("No.", GetValueAtCell(RowNo, 2));
            IF CustR.FindFirst() then begin
                CustR.Delete(true);
            end;
        end;
        if VenD then begin
            VendR.Reset();
            VendR.SetRange("No.", GetValueAtCell(RowNo, 2));
            IF VendR.FindFirst() then begin
                VendR.Delete(true);
            end;
        end;
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

