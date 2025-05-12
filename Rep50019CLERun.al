report 50019 "Customer Running Amount"
{
    DefaultLayout = RDLC;
    //RDLCLayout = './TrialBalance.rdlc';
    ApplicationArea = Basic, Suite;
    Caption = 'Customer Running Amount';
    // PreviewMode = PrintLayout;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Customer No.", "Posting Date");
            RequestFilterFields = "Customer No.";

            trigger OnAfterGetRecord()
            begin
                CalcFields(Amount);
                if X_Vend <> "Customer No." then
                    Running_Amount := 0;
                X_Vend := "Customer No.";
                MakeExcelHeaderBody();
            end;

            trigger OnPostDataItem()
            begin
                CreateExcelSheet_DD('Customer Running Amount', True);
            end;

            trigger OnPreDataItem()
            begin
                SetCurrentKey("Customer No.", "Posting Date")
            end;

        }
    }


    trigger OnPreReport()
    begin
        GLFilter := "Cust. Ledger Entry".GetFilters;

        TempExcelBuffer.DeleteAll();
        MakeExcelHeaderHeader();

    end;

    trigger OnPostReport()
    begin
        CreateExcelBook_DD('Customer Running Amount');
    end;


    local procedure MakeExcelHeaderHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Document NO ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Posting Date', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Document Type', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer Code', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Customer Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Amount LCY', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Base Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('GST Amount', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('TDS Amount ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Remaining Amount ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Running Amount ', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
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
        "Cust. Ledger Entry".CalcFields(Amount, "Amount (LCY)");
        Cust.Reset();
        if Cust.get("Cust. Ledger Entry"."Customer No.") then;

        Running_Amount := Running_Amount + ("Cust. Ledger Entry"."Amount (LCY)");
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Document No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Posting Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Document Type", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Customer No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(Cust.Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Amount (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        BaseA := 0;
        TdsA := 0;
        GSTAmt := 0;
        GSTL.Reset();
        GSTL.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
        GSTL.CalcSums("GST Amount");
        GSTAmt := GSTL."GST Amount";
        GSTL.Reset();
        GSTL.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
        GSTL.CalcSums("GST Base Amount");
        BaseA := GSTL."GST Base Amount";
        TDSEntry.Reset();
        TDSEntry.SetRange("Document No.", "Cust. Ledger Entry"."Document No.");
        TDSEntry.SetRange("Document Type", "Cust. Ledger Entry"."Document Type");
        TDSEntry.CalcSums("TDS Amount");
        TdsA := TDSEntry."TDS Amount";
        TempExcelBuffer.AddColumn(BaseA, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(GSTAmt, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(TdsA, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Remaining Amt. (LCY)", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn(Running_Amount, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        TempExcelBuffer.AddColumn("Cust. Ledger Entry"."Global Dimension 2 Code", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
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
        Trial_BalanceCaptionLbl: Label 'Customer Running Amount';
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
        X_Vend: Code[30];
        Month: Text;
        TotalInvAmt: Decimal;
        GstBase: Decimal;
        GSTAmt: Decimal;
        CGST_A: Decimal;
        SGST_A: Decimal;
        IGST_A: Decimal;
        GSTL: Record "GST Ledger Entry";
        TDSEntry: Record "TDS Entry";
        BaseA: Decimal;
        TdsA: Decimal;
        Cust: record Customer;
        Running_Amount: Decimal;
}

