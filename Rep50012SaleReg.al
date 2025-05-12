report 50012 "Sales Register"
{
    DefaultLayout = RDLC;
    //RDLCLayout = './TrialBalance.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Sales Register';
    // PreviewMode = PrintLayout;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.") where("Document Type" = filter('Invoice|Credit Memo'));
            RequestFilterFields = "Customer No.", "Date Filter", "Global Dimension 1 Code", "Global Dimension 2 Code";

            trigger OnAfterGetRecord()
            begin
                CalcFields(Amount);
                MakeExcelHeaderBody();
            end;



            trigger OnPostDataItem()
            begin
                CreateExcelSheet_DD('Sales Register', True);
            end;

        }
    }


    trigger OnPreReport()
    begin
        "Cust. Ledger Entry".SecurityFiltering(SecurityFilter::Filtered);
        GLFilter := "Cust. Ledger Entry".GetFilters;
        PeriodText := "Cust. Ledger Entry".GetFilter("Date Filter");

        if PeriodText = '' then
            Error('Period must have a Date Range ');
        FirstDate := "Cust. Ledger Entry".GetRangeMin("Date Filter");
        TempExcelBuffer.DeleteAll();
        MakeExcelHeaderHeader();

    end;

    trigger OnPostReport()
    begin
        CreateExcelBook_DD('Sales Register');
    end;


    local procedure MakeExcelHeaderHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Serial No', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document NO ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Nature', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location Code GSt No', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Location State Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Month', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer GST No', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Total Invoice', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Invocie Total Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GST Base Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GST Group Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GST Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('IGST Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('SGST Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('CGST Amount ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Extrenal Document No ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Vertical/Sub ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelHeaderBody()
    begin
        Serial_No += 1;
        Clear(Month);
        Clear(TotalInvAmt);
        Clear(GstBase);
        Clear(GSTAmt);
        Clear(CGST_A);
        Clear(SGST_A);
        Clear(IGST_A);
        DGSTL.Reset();
        DGSTL.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
        DGSTL.SetFilter("GST Component Code", '<>%1', 'CGST');
        IF DGSTL.FindFirst() THEN
            repeat
                IF DGSTL."GST Component Code" = 'SGST' then
                    SGST_A += ABS(DGSTL."GST Amount");
                IF DGSTL."GST Component Code" = 'IGST' then
                    IGST_A += ABS(DGSTL."GST Amount");
                GstBase += Abs((DGSTL."GST Base Amount"));
            UNTIL DGSTL.Next() = 0;
        "Cust. Ledger Entry".CalcFields(Amount);
        TotalInvAmt := GstBase + SGST_A * 2 + IGST_A;
        Cust.Reset();
        if Cust.get("Cust. Ledger Entry"."Customer No.") then;

        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn(Serial_No, false, '', False, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Document No.", false, '', False, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Document Type", false, '', False, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Location GST Reg. No.", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Location Code", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Posting Date", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn(Month, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Customer No.", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Cust.Name, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Cust."GST Registration No.", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry".Amount, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TotalInvAmt, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(GstBase, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."GST Group Code", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(GSTAmt, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(IGST_A, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SGST_A, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(SGST_A, false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."External Document No.", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Global Dimension 2 Code", false, '', False, False, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    procedure CreateExcelBook_DD(File_Name: Text[250])
    begin
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.SetFriendlyFilename(File_Name);
        TempExcelBuffer.OpenExcel();
    end;

    procedure CreateExcelSheet_DD(SheetName: Text[250]; NewBook: Boolean)
    begin
        if NewBook then
            TempExcelBuffer.CreateNewBook(SheetName)
        else
            TempExcelBuffer.SelectOrAddSheet(SheetName);
        TempExcelBuffer.WriteSheet(SheetName, CompanyName, UserId);
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.ClearNewRow();
    end;

    var
        Serial_No: Integer;
        Text000: Label 'Period: %1';
        GLFilter: Text;
        PeriodText: Text[30];
        Trial_BalanceCaptionLbl: Label 'Sales Register';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Net_ChangeCaptionLbl: Label 'Net Change';
        BalanceCaptionLbl: Label 'Balance';
        PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl: Label 'Name';
        G_L_Account___Net_Change_CaptionLbl: Label 'Debit';
        G_L_Account___Net_Change__Control22CaptionLbl: Label 'Credit';
        G_L_Account___Balance_at_Date_CaptionLbl: Label 'Debit';
        G_L_Account___Balance_at_Date__Control24CaptionLbl: Label 'Credit';
        PageGroupNo: Integer;
        ChangeGroupNo: Boolean;
        BlankLineNo: Integer;
        TempExcelBuffer: Record "Excel Buffer" temporary;
        ChartofAcc: Record "G/L Account";
        FirstDate: Date;
        Month: Text;
        TotalInvAmt: Decimal;
        GstBase: Decimal;
        GSTAmt: Decimal;
        CGST_A: Decimal;
        SGST_A: Decimal;
        IGST_A: Decimal;
        DGSTL: Record "Detailed GST Ledger Entry";
        Cust: record customer;
}

