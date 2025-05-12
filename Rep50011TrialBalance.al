report 50011 "Trial Balance Excel"
{
    DefaultLayout = RDLC;
    //RDLCLayout = './TrialBalance.rdlc';
    AdditionalSearchTerms = 'year closing,close accounting period,close fiscal year';
    ApplicationArea = Basic, Suite;
    Caption = 'Trial Balance Excel';
    // PreviewMode = PrintLayout;
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Account Type", "Date Filter", "Global Dimension 1 Filter", "Global Dimension 2 Filter";
            column(STRSUBSTNO_Text000_PeriodText_; StrSubstNo(Text000, PeriodText))
            {
            }
            column(COMPANYNAME; COMPANYPROPERTY.DisplayName)
            {
            }
            column(PeriodText; PeriodText)
            {
            }
            column(G_L_Account__TABLECAPTION__________GLFilter; TableCaption + ': ' + GLFilter)
            {
            }
            column(GLFilter; GLFilter)
            {
            }
            column(G_L_Account_No_; "No.")
            {
            }
            column(Trial_BalanceCaption; Trial_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Net_ChangeCaption; Net_ChangeCaptionLbl)
            {
            }
            column(BalanceCaption; BalanceCaptionLbl)
            {
            }
            column(G_L_Account___No__Caption; FieldCaption("No."))
            {
            }
            column(PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaption; PADSTR_____G_L_Account__Indentation___2___G_L_Account__NameCaptionLbl)
            {
            }
            column(G_L_Account___Net_Change_Caption; G_L_Account___Net_Change_CaptionLbl)
            {
            }
            column(G_L_Account___Net_Change__Control22Caption; G_L_Account___Net_Change__Control22CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date_Caption; G_L_Account___Balance_at_Date_CaptionLbl)
            {
            }
            column(G_L_Account___Balance_at_Date__Control24Caption; G_L_Account___Balance_at_Date__Control24CaptionLbl)
            {
            }
            column(PageGroupNo; PageGroupNo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change", "Balance at Date");

                if ChangeGroupNo then begin
                    PageGroupNo += 1;
                    ChangeGroupNo := false;
                end;

                ChangeGroupNo := "New Page";
                MakeExcelHeaderBody();

            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 0;
                ChangeGroupNo := false;

            end;

            trigger OnPostDataItem()
            begin
                CreateExcelSheet_DD('Trial Balance', True);
            end;

        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        "G/L Account".SecurityFiltering(SecurityFilter::Filtered);
        GLFilter := "G/L Account".GetFilters;
        PeriodText := "G/L Account".GetFilter("Date Filter");

        if PeriodText = '' then
            Error('Period must have a Date Range ');
        FirstDate := "G/L Account".GetRangeMin("Date Filter");
        TempExcelBuffer.DeleteAll();
        MakeExcelHeaderHeader();

    end;

    trigger OnPostReport()
    begin
        CreateExcelBook_DD('Trial Balance');
    end;


    local procedure MakeExcelHeaderHeader()
    begin
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Trial Balance', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(WorkDate(), false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Date);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(UserId, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Filters', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn("G/L Account".GetFilters, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('Company', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn(CompanyName, false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.NewRow();
        TempExcelBuffer.NewRow();
        TempExcelBuffer.AddColumn('No.', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Name', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Opening Debit', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Opening Credit', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Net Change Debit', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Net Change Credit', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Balance Debit', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
        TempExcelBuffer.AddColumn('Balance Credit', false, '', true, false, false, '', TempExcelBuffer."Cell Type"::Text);
    end;

    local procedure MakeExcelHeaderBody()
    begin
        ChartofAcc.Reset();
        ChartofAcc.SetRange("No.", "G/L Account"."No.");
        ChartofAcc.SetFilter("Date Filter", '..%1', FirstDate - 1);
        if ChartofAcc.FindFirst() then;
        ChartofAcc.CalcFields("Net Change");
        if "G/L Account"."Account Type" = "G/L Account"."Account Type"::Posting then begin
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn("G/L Account"."No.", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn("G/L Account".Name, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Text);
            // Message('%1\%2', "G/L Account"."Net Change", "G/L Account"."Balance at Date");
            if ChartofAcc."Net Change" > 0 then
                TempExcelBuffer.AddColumn(ChartofAcc."Net Change", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            if ChartofAcc."Net Change" < 0 then
                TempExcelBuffer.AddColumn(-ChartofAcc."Net Change", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);


            if "G/L Account"."Net Change" > 0 then
                TempExcelBuffer.AddColumn("G/L Account"."Net Change", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            if "G/L Account"."Net Change" < 0 then
                TempExcelBuffer.AddColumn(-"G/L Account"."Net Change", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);

            if "G/L Account"."Balance at Date" > 0 then
                TempExcelBuffer.AddColumn("G/L Account"."Balance at Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
            if "G/L Account"."Balance at Date" < 0 then
                TempExcelBuffer.AddColumn(-"G/L Account"."Balance at Date", false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', false, false, false, '', TempExcelBuffer."Cell Type"::Number);
        end else begin
            TempExcelBuffer.NewRow();
            TempExcelBuffer.AddColumn("G/L Account"."No.", false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Text);
            TempExcelBuffer.AddColumn("G/L Account".Name, false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Text);
            // Message('%1\%2', "G/L Account"."Net Change", "G/L Account"."Balance at Date");
            if ChartofAcc."Net Change" > 0 then
                TempExcelBuffer.AddColumn(ChartofAcc."Net Change", false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number);
            if ChartofAcc."Net Change" < 0 then
                TempExcelBuffer.AddColumn(-ChartofAcc."Net Change", false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number);


            if "G/L Account"."Net Change" > 0 then
                TempExcelBuffer.AddColumn("G/L Account"."Net Change", false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number);
            if "G/L Account"."Net Change" < 0 then
                TempExcelBuffer.AddColumn(-"G/L Account"."Net Change", false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number);

            if "G/L Account"."Balance at Date" > 0 then
                TempExcelBuffer.AddColumn("G/L Account"."Balance at Date", false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number);
            if "G/L Account"."Balance at Date" < 0 then
                TempExcelBuffer.AddColumn(-"G/L Account"."Balance at Date", false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number)
            else
                TempExcelBuffer.AddColumn(0, false, '', True, false, false, '', TempExcelBuffer."Cell Type"::Number);
        end;

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
        Text000: Label 'Period: %1';
        GLFilter: Text;
        PeriodText: Text[30];
        Trial_BalanceCaptionLbl: Label 'Trial Balance';
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
}

