report 50017 BillOfSupply
{
    Caption = 'Bill Of Supply';
    DefaultLayout = RDLC;
    RDLCLayout = './src/ReportLayout/50017_BillofSupply.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            column(Report_Copy; Report_Copy) { }
            column(BankAcc_No; BankAcc_No) { }
            column(Bankname; Bankname) { }
            column(bankifscCode; bankifscCode) { }
            column(bankSwfcode; bankSwfcode) { }
            column(Pic; CompanyInformation.Picture) { }
            column(ComName; CompanyInformation.Name) { }
            column(ComAdd; CompanyInformation.Address) { }
            column(ComAdd2; CompanyInformation."Address 2") { }
            column(ComCity; CompanyInformation.City) { }
            column(ComPin; CompanyInformation."Post Code") { }
            column(CompC; CompanyInformation."Country/Region Code") { }
            column(ComGST; CompanyInformation."GST Registration No.") { }
            column(ComCIN; CompanyInformation."Circle No.") { }
            column(CompPan; CompanyInformation."P.A.N. No.") { }
            column(PlaceofSupply; '') { }
            column(Revers_Chage; '') { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(Bill_to_Name; "Bill-to Name") { }
            column(No_H; "No.") { }
            column(Bill_to_Address; "Bill-to Address") { }
            column(Bill_to_Address_2; "Bill-to Address 2") { }
            column(Bill_to_City; "Bill-to City") { }
            column(Bill_to_Post_Code; "Bill-to Post Code") { }
            column(Customer_GST_Reg__No_; "Customer GST Reg. No.") { }
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Address_2; "Ship-to Address 2") { }
            column(Ship_to_City; "Ship-to City") { }
            column(Ship_to_Post_Code; "Ship-to Post Code") { }
            column(Ship_to_GST_Reg__No_; "Ship-to GST Reg. No.") { }
            column(Due_Date; FORMAT("Due Date")) { }
            column(Currency_Code; "Currency Code") { }
            column(Posting_Date; FORMAT("Posting Date")) { }
            column(Amount; Amount) { }
            column(Amt_Cust; 0) { }
            column(Round_Off; 0) { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No.");

                column(S_No; S_No) { }
                column(No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(Unit_Price; "Unit Price") { }
                column(GST_Base; GST_Base) { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(GST_Per; GST_Per) { }
                column(IGST_RATE; IGST_RATE) { }
                column(IGST_AMT; IGST_AMT) { }
                column(CGST_RATE; CGST_RATE) { }
                column(CGST_AMT; CGST_AMT) { }
                column(SGST_RATE; SGST_RATE) { }
                column(SGST_AMT; SGST_AMT) { }
                column(GST_Group_Code; "GST Group Code") { }
                column(Total_Amt; Total_Amt) { }
                column(Amount_Words; Amount_Words) { }
                trigger OnAfterGetRecord()
                begin
                    S_No += 1;
                    GST_Base := 0;
                    Clear(SGST_AMT);
                    Clear(CGST_AMT);
                    Clear(IGST_AMT);
                    Clear(IGST_RATE);
                    Clear(SGST_RATE);
                    Clear(CGST_RATE);
                    Rec_DGST.Reset();
                    Rec_DGST.SetRange("Transaction Type", Rec_DGST."Transaction Type"::Sales);
                    Rec_DGST.SetRange("Document No.", "Sales Invoice Line"."Document No.");
                    Rec_DGST.SetRange("No.", "Sales Invoice Line"."No.");
                    Rec_DGST.SetRange("Document Line No.", "Sales Invoice Line"."Line No.");
                    if Rec_DGST.FindSet() then begin
                        repeat
                            if Rec_DGST."GST Component Code" = 'IGST' then begin
                                IGST_AMT += ABS(Rec_DGST."GST Amount");
                                IGST_RATE := Rec_DGST."GST %";
                            end;
                            if Rec_DGST."GST Component Code" = 'CGST' then begin
                                CGST_AMT += ABS(Rec_DGST."GST Amount");
                                CGST_RATE := Rec_DGST."GST %";
                            end;
                            if Rec_DGST."GST Component Code" = 'SGST' then begin
                                SGST_AMT += ABS(Rec_DGST."GST Amount");
                                SGST_RATE := Rec_DGST."GST %";
                            end;
                        until Rec_DGST.Next() = 0;
                    end;
                    Total_Amt += IGST_AMT + SGST_AMT + CGST_AMT + "Sales Invoice Line"."Line Amount";
                    GST_Base := IGST_AMT + SGST_AMT + CGST_AMT;
                    Rep_Cehck.InitTextVariable;
                    Rep_Cehck.FormatNoText(NoText_Check, Total_Amt, "Sales Invoice Header"."Currency Code");
                    Amount_Words := NoText_Check[1] + ' ' + NoText_Check[2];
                end;

                trigger OnPreDataItem()
                begin
                    S_No := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Customer_Rec.Reset();
                IF not Customer_Rec.GET("Bill-to Customer No.") then
                    Clear(Customer_Rec);
                CalcFields(Amount, "Amount Including VAT");
                if "Currency Code" = '' then
                    "Currency Code" := 'INR';

                Clear(Bankname);
                Clear(BankAcc_No);
                Clear(bankSwfcode);
                Clear(bankifscCode);
                Customer_Rec.Reset();
                Customer_Rec.SetRange("No.", "Sales Invoice Header"."Bill-to Customer No.");
                if Customer_Rec.FindFirst() then begin
                    RecBankAccount.Reset();
                    RecBankAccount.SetRange(Code, Customer_Rec."Preferred Bank Account Code");
                    if RecBankAccount.FindSet() then begin
                        Bankname := RecBankAccount.Name;
                        BankAcc_No := RecBankAccount."Bank Account No.";
                        bankSwfcode := RecBankAccount."SWIFT Code";
                        bankifscCode := RecBankAccount.IFSC;
                    end;
                end;
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
                    field(Report_Copy; Report_Copy)
                    {
                        Caption = 'Print';
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Reset();
        CompanyInformation.Get;
        CompanyInformation.CalcFields(Picture);
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer_Rec: Record Customer;
        S_No: Integer;
        GST_Base: Decimal;
        Rec_DGST: Record "Detailed GST Ledger Entry";
        IGST_AMT: Decimal;
        CGST_AMT: Decimal;
        SGST_AMT: Decimal;
        IGST_RATE: Decimal;
        SGST_RATE: Decimal;
        CGST_RATE: Decimal;
        GST_Per: Code[10];
        Report_Copy: Option Original,Duplicate,Triplicate;
        Rep_Cehck: Report "Check Customize";
        Total_Amt: Decimal;
        NoText_Check: array[2] OF TEXT[1024];
        NoText_CheckTax: array[2] of Text[1024];
        Amount_Words: Text;
        Bankname: Text;
        BankAcc_No: Text;
        bankSwfcode: Text;
        bankifscCode: Text;
        RecBankAccount: Record "Customer Bank Account";


}
