report 50007 "Purchase Order 1"
{
    Caption = 'Purchase Order';
    DefaultLayout = RDLC;
    RDLCLayout = './src/ReportLayout/50007_Purchase_Order.rdl';
    PreviewMode = PrintLayout;
    ApplicationArea = all;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(Report_Copy; Report_Copy) { }
            column(Pic; CompanyInformation.Picture) { }
            column(ComName; CompanyInformation.Name) { }
            column(ComAdd; CompanyInformation.Address) { }
            column(ComAdd2; CompanyInformation."Address 2") { }
            column(ComCity; CompanyInformation.City) { }
            column(ComPin; CompanyInformation."Post Code") { }
            column(CompC; CompanyInformation."Country/Region Code") { }
            column(ComGST; CompanyInformation."GST Registration No.") { }
            column(ComCIN; CompanyInformation."Circle No.") { }
            column(PlaceofSupply; "Payment Terms Code") { }

            column(Bill_to_Customer_No_; "Buy-from Vendor No.") { }
            column(AMC_CMC_; "AMC/CMC ") { }
            column(Warranty; Warranty) { }
            column(Vendor_Quotation_Reference; "Vendor Quotation/Reference") { }
            column(Bill_to_Name; "Buy-from Vendor Name") { }
            column(No_H; "No.") { }
            column(Bill_to_Address; "Buy-from Address") { }
            column(Bill_to_Address_2; "Buy-from Address 2") { }
            column(Bill_to_City; "Buy-from City" + ' ' + "GST Order Address State") { }
            column(Bill_to_Post_Code; "Buy-from Post Code") { }
            column(BuyGst; Customer_Rec."GST Registration No.") { }
            column(Customer_GST_Reg__No_; Customer_GST_Reg__No_) { }
            column(Ship_to_Name; BShip_to_Name) { }
            column(Ship_to_Address; BShip_to_Address) { }
            column(Ship_to_Address_2; BShip_to_Address_2) { }
            column(Ship_to_City; BShip_to_City) { }
            column(Ship_to_Post_Code; BShip_to_Post_Code) { }
            column(Ship_to_GST_Reg__No_; Customer_GST_Reg__No_) { }
            column(XShip_to_Name; XShip_to_Name) { }
            column(XShip_to_Address; XShip_to_Address) { }
            column(XShip_to_Address_2; XShip_to_Address_2) { }
            column(XShip_to_City; XShip_to_City) { }
            column(XShip_to_Post_Code; XShip_to_Post_Code) { }
            column(Due_Date; FORMAT("Due Date")) { }
            column(Currency_Code; Currency_Code) { }
            column(Posting_Date; FORMAT("Posting Date")) { }
            column(Amount; Amount) { }
            column(Amt_Cust; 0) { }
            column(Round_Off; 0) { }
            column(BStateN; BState."State Code (GST Reg. No.)" + ' - ' + BState.Description) { }
            column(SStateN; SState."State Code (GST Reg. No.)" + ' - ' + SState.Description) { }
            column(OStateN; OState."State Code (GST Reg. No.)" + ' - ' + OState.Description) { }

            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Revers_Chage; "Expected Receipt Date") { }
                column(S_No; S_No) { }
                column(No_; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure Code") { }
                column(Line_Amount; "Line Amount") { }
                column(Unit_Price; "Direct Unit Cost") { }
                column(Line_Discount__; "Line Discount %") { }
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
                column(Delivery_Challan_Date; Format("Expected Receipt Date")) { }
                trigger OnAfterGetRecord()
                begin
                    S_No += 1;
                    GST_Base := 0;
                    GST_Per := 0;
                    Clear(SGST_AMT);
                    Clear(CGST_AMT);
                    Clear(IGST_AMT);
                    Clear(IGST_RATE);
                    Clear(SGST_RATE);
                    Clear(CGST_RATE);
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetFilter("Tax Record ID", '%1', "Purchase Line".RecordId);
                    TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                    TaxTransactionValue.SetRange("Visible on Interface", true);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    TaxTransactionValue.SetRange("Tax Type", 'GST');
                    if TaxTransactionValue.FindSet() then begin
                        repeat
                            GST_Per += TaxTransactionValue.Percent;
                            if TaxTransactionValue.GetAttributeColumName = 'IGST' then begin
                                IGST_AMT += ABS(TaxTransactionValue.Amount);
                                IGST_RATE := TaxTransactionValue.Percent;
                            end;
                            if TaxTransactionValue.GetAttributeColumName = 'CGST' then begin
                                CGST_AMT += ABS(TaxTransactionValue.Amount);
                                CGST_RATE := TaxTransactionValue.Percent;
                            end;
                            if TaxTransactionValue.GetAttributeColumName = 'SGST' then begin
                                SGST_AMT += ABS(TaxTransactionValue.Amount);
                                SGST_RATE := TaxTransactionValue.Percent;
                            end;
                        until TaxTransactionValue.Next() = 0;
                    end;
                    Total_Amt += IGST_AMT + SGST_AMT + CGST_AMT + "Purchase Line"."Line Amount";
                    GST_Base := IGST_AMT + SGST_AMT + CGST_AMT;
                    Rep_Cehck.InitTextVariable;
                    Rep_Cehck.FormatNoText(NoText_Check, Round(Total_Amt), "Purchase Header"."Currency Code");
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
                IF not Customer_Rec.GET("Buy-from Vendor No.") then
                    Clear(Customer_Rec);
                CalcFields(Amount, "Amount Including VAT");
                if "Currency Code" = '' then
                    Currency_Code := 'INR'
                else
                    Currency_Code := "Currency Code";

                Loca.Reset();
                IF Loca.Get("Location Code") THEN;
                BState.Reset();
                OState.Reset();
                SState.Reset();
                XShiP_to_Name := Loca.Name;
                XShiP_to_Address := Loca.Address;
                XShiP_to_Address_2 := Loca."Address 2";
                XShiP_to_City := Loca.City + ' ' + Loca."State Code";
                XShiP_to_Post_Code := Loca."Post Code";
                Customer_GST_Reg__No_ := Loca."GST Registration No.";
                if BState.Get(Loca."State Code") then;
                if SState.Get(Loca."State Code") then;
                if SState.Get("GST Order Address State") then;

                if "Bill to-Location(POS)" <> '' then begin
                    Loca.Reset();
                    IF Loca.Get("Bill to-Location(POS)") THEN;
                    BShiP_to_Name := Loca.Name;
                    BShiP_to_Address := Loca.Address;
                    BShiP_to_Address_2 := Loca."Address 2";
                    BShiP_to_City := Loca.City + ' ' + Loca."State Code";
                    BShiP_to_Post_Code := Loca."Post Code";
                    if SState.Get(Loca."State Code") then;
                end ELSE begin
                    BShiP_to_Name := Loca.Name;
                    BShiP_to_Address := Loca.Address;
                    BShiP_to_Address_2 := Loca."Address 2";
                    BShiP_to_City := Loca.City + ' ' + Loca."State Code";
                    BShiP_to_Post_Code := Loca."Post Code";
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
        Customer_Rec: Record Vendor;
        S_No: Integer;
        GST_Base: Decimal;
        TaxTransactionValue: Record "Tax Transaction Value";
        IGST_AMT: Decimal;
        CGST_AMT: Decimal;
        SGST_AMT: Decimal;
        IGST_RATE: Decimal;
        SGST_RATE: Decimal;
        CGST_RATE: Decimal;
        GST_Per: Decimal;
        Report_Copy: Option Original,Duplicate,Triplicate;
        Rep_Cehck: Report "Check Customize";
        Total_Amt: Decimal;
        NoText_Check: array[2] OF TEXT[1024];
        NoText_CheckTax: array[2] of Text[1024];
        Amount_Words: Text;
        Currency_Code: Code[10];
        XShip_to_Name: Text;
        XShip_to_Address: Text;
        XShip_to_Address_2: Text;
        XShip_to_City: Text;
        XShip_to_Post_Code: Text;
        BShip_to_Name: Text;
        BShip_to_Address: Text;
        BShip_to_Address_2: Text;
        BShip_to_City: Text;
        BShip_to_Post_Code: Text;
        Customer_GST_Reg__No_: Text;

        Loca: Record Location;
        OState: Record State;
        BState: Record State;
        SState: Record State;
        BuyGst: Code[15];


}