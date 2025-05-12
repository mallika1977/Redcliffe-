/// <summary>
/// Report Purhase Register (ID 50007).
/// </summary>
report 50006 "Purhase Register"
{
    ApplicationArea = All;
    Caption = 'Purchase Register';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            RequestFilterFields = "No.", "Location Code";
            trigger OnPreDataItem()
            begin
                if ("Posting Date" <> 0D) or (EndDate <> 0D) then
                    "Purch. Inv. Header".SetRange("Posting Date", StartDate, EndDate);
                if Region <> '' then
                    "Purch. Inv. Header".SetRange("Shortcut Dimension 1 Code", Region);

                PrintHeader();
            end;

            trigger OnAfterGetRecord()
            begin

                // if "Purch. Inv. Header"."Applies-to Doc. No." <> '' then begin
                /*
                  PCMHeaderRec.Reset();
                  PCMHeaderRec.SetCurrentKey("Applies-to Doc. No.");
                  PCMHeaderRec.SetRange("Applies-to Doc. No.", "Purch. Inv. Header"."No.");
                  PCMHeaderRec.SetRange("Return Type", PCMHeaderRec."Return Type"::Mistake);
                  if PCMHeaderRec.FindFirst() then
                      CurrReport.Skip();

  */

                //  PCMHeaderRec."Return Type"::Actual
                if PurchaseIvoiceBool then begin
                    if REC_VED.Get("Purch. Inv. Header"."Buy-from Vendor No.") then;
                    PILineRec.Reset();
                    PILineRec.SetRange("Document No.", "Purch. Inv. Header"."No.");
                    PILineRec.SetFilter("No.", '<>%1', '');
                    VendorRec.Reset();
                    VendorRec.SetRange("No.", "Purch. Inv. Header"."Buy-from Vendor No.");
                    if VenPosGroup <> '' then
                        VendorRec.SetRange("Vendor Posting Group", VenPosGroup);
                    if (VendorRec.FindFirst()) and (PILineRec.FindFirst()) then
                        repeat
                            PrintPurchaseInvoiceLine();
                        until PILineRec.Next() = 0;
                end;
            end;





            trigger OnPostDataItem()
            begin
            end;
        }

        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            RequestFilterFields = "No.", "Location Code";
            trigger OnPreDataItem()
            begin
                if ("Posting Date" <> 0D) or (EndDate <> 0D) then
                    "Purch. Cr. Memo Hdr.".SetRange("Posting Date", StartDate, EndDate);
                if Region <> '' then
                    "Purch. Cr. Memo Hdr.".SetRange("Shortcut Dimension 1 Code", Region);
                //  "Purch. Cr. Memo Hdr.".SetFilter("Return Type", '<>%1', "Purch. Cr. Memo Hdr."."Return Type"::Mistake);
                PrintHeader();
            end;

            trigger OnAfterGetRecord()
            begin
                if PurchaseCrMemoBool then begin
                    if REC_VED.Get("Purch. Inv. Header"."Buy-from Vendor No.") then;
                    PCMLineRec.Reset();
                    PCMLineRec.SetRange("Document No.", "Purch. Cr. Memo Hdr."."No.");
                    PCMLineRec.SetFilter("No.", '<>%1', '');


                    VendorRec.Reset();
                    VendorRec.SetRange("No.", "Purch. Cr. Memo Hdr."."Buy-from Vendor No.");
                    if VenPosGroup <> '' then
                        VendorRec.SetRange("Vendor Posting Group", VenPosGroup);
                    if (VendorRec.FindFirst()) and (PCMLineRec.FindFirst()) then
                        repeat
                            PrintPurchaseCrMemoLine();
                        until PCMLineRec.Next() = 0;
                end;
            end;

            trigger OnPostDataItem()
            begin
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
                    Caption = 'Filters';
                    field(StartDate; StartDate)
                    {
                        Caption = 'Start Date';
                        ToolTip = 'filter for posting date';
                        ApplicationArea = all;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'End Date';
                        ToolTip = 'filter for posting date';
                        ApplicationArea = all;
                    }
                    field(Region; Region)
                    {
                        Caption = 'LOC COST CENTRE';
                        TableRelation = Dimension;
                        ToolTip = 'filter for Global Dimension 1';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            REC_DIMVALUE: Record "Dimension Value";
                            GL_SETUP: Record "General Ledger Setup";
                            Dimension_Values: Page "Dimension Values";
                        begin
                            Clear("Region");
                            GL_SETUP.Get();
                            REC_DIMVALUE.Reset();
                            REC_DIMVALUE.SetRange("Dimension Code", GL_SETUP."Global Dimension 1 Code");
                            if REC_DIMVALUE.FindFirst() then begin

                                Dimension_Values.SetTableView(REC_DIMVALUE);
                                Dimension_Values.LookupMode(true);
                                if Dimension_Values.RunModal() = Action::LookupOK then
                                    Dimension_Values.GetRecord(REC_DIMVALUE);
                                Region := REC_DIMVALUE.Code;
                            end;
                        end;
                    }
                    field(VenPosGroup; VenPosGroup)
                    {
                        Caption = 'Vendor Posting Group';
                        TableRelation = "Vendor Posting Group";
                        ToolTip = 'filter for Vendor Posting Group';
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            VPGroupRec: Record "Vendor Posting Group";
                            VPGroupsPge: Page "Vendor Posting Groups";
                        begin
                            Clear(VenPosGroup);
                            VPGroupRec.Reset();
                            VPGroupsPge.SetTableView(VPGroupRec);
                            VPGroupsPge.LookupMode(true);
                            if VPGroupsPge.RunModal() = Action::LookupOK then
                                VPGroupsPge.GetRecord(VPGroupRec);
                            VenPosGroup := VPGroupRec.Code;
                        end;
                    }
                    field(PurchaseIvoiceBool; PurchaseIvoiceBool)
                    {
                        Caption = 'Posted Purchase Invoice';
                        ToolTip = 'Print from Posted Purchase Invoice Y/N ';
                        ApplicationArea = all;
                    }
                    field(PurchaseCrMemoBool; PurchaseCrMemoBool)
                    {
                        Caption = 'Posted Purchase Cr. Memo';
                        ToolTip = 'Print from Posted Purchase Cr. Memo Y/N ';
                        ApplicationArea = all;
                    }

                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnInitReport()
    begin
        xlBuff.DeleteAll();
        CompanyInformationRec.Get();
        HeaderPrinted := true;
    end;

    trigger OnPostReport()
    begin
        xlBuff.CreateNewBook('Purchase Register');
        xlBuff.WriteSheet('Purchase Register', CompanyName, UserId);
        xlBuff.CloseBook();
        xlBuff.SetFriendlyFilename('Export Purchase Register');
        xlBuff.OpenExcel();
    end;

    local procedure PrintHeader()
    begin
        if HeaderPrinted then begin
            HeaderPrinted := false;
            // xlBuff.NewRow();
            // xlBuff.AddColumn(CompanyInformationRec.Name, false, '', true, false, false, '', xlBuff."Cell Type"::Text);

            xlBuff.NewRow();
            xlBuff.AddColumn('Purchase Register Detail', false, '', true, false, false, '', xlBuff."Cell Type"::Text);

            xlBuff.NewRow();
            xlBuff.AddColumn('Date & time of Generation', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn(Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year> <Hour>:<Minute> <AM/PM>'), false, '', false, false, false, '', xlBuff."Cell Type"::Text);

            xlBuff.NewRow();
            xlBuff.AddColumn('Period', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn(StrSubstNo('%1 - %2', Format(StartDate, 0, '<Day,2>/<Month,2>/<Year>'), Format(EndDate, 0, '<Day,2>/<Month,2>/<Year>')), false, '', false, false, false, '', xlBuff."Cell Type"::Text);

            xlBuff.NewRow();
            xlBuff.AddColumn('Region', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn(Region, false, '', false, false, false, '', xlBuff."Cell Type"::Text);

            // xlBuff.NewRow();
            // xlBuff.AddColumn('Location', false, '', true, false, false, '', xlBuff."Cell Type"::Text);

            xlBuff.NewRow();
            xlBuff.AddColumn('Fiscal Year', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Month', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //  xlBuff.AddColumn('Month Dimension', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //  xlBuff.AddColumn('Brand Code ', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Location Code', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('LOC Dim', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('PO Date', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('PO No.', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('GRN Date', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('GRN NO.', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Doc Type', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Purchase Invoice Date', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Purchase  Invoice No.', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Document Date', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Document Number', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Refernce Invoice for CN', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Vendor Group Code', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            // xlBuff.AddColumn('Vendor Group Desc', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            // xlBuff.AddColumn('SAGE Code', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Vendor Code', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Vendor name', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('GST Registration No.', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //  xlBuff.AddColumn('Vat Registration no', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            // xlBuff.AddColumn('Item -Parent Account', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            // xlBuff.AddColumn('Item -Category', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Item Number / GL name', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Item  / GL Description', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('HSN/ SAC Code', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //   xlBuff.AddColumn('Item Brand ( variant)', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Quantity', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Base UOM', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //  xlBuff.AddColumn('Brand UOM', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Unit Cost', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Amount Excluding Tax', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Discount %', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Discount Amount', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Amount After Discount', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('GST Credit', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('GST Group Code', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('EXEMPT', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('SGST', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('CGST', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('IGST', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //  xlBuff.AddColumn('Cess', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //  xlBuff.AddColumn('Vat', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Total Tax Amount', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            xlBuff.AddColumn('Total Including Tax', false, '', true, false, false, '', xlBuff."Cell Type"::Text);
            //  xlBuff.AddColumn('MSME/UOM NO. ', false, '', true, false, false, '', xlBuff."Cell Type"::Text);


        end;
    end;

    local procedure PrintPurchaseInvoiceLine()
    begin
        SGSTAmt := 0;
        IGSTAmt := 0;
        CGSTAmt := 0;
        VATAmt := 0;
        CessAmt := 0;
        VARIANT_UOM := '';
        GRN_NO := '';
        Clear(GRN_Date);
        Clear(Order_Date);
        Clear(Order_NO);
        Clear(Parent_Acc);

        DGSTLEntryRec.RESET;
        DGSTLEntryRec.SETRANGE("Document No.", PILineRec."Document No.");
        DGSTLEntryRec.SETRANGE("Transaction Type", DGSTLEntryRec."Transaction Type"::Purchase);
        DGSTLEntryRec.SETRANGE("Document Line No.", PILineRec."Line No.");
        IF DGSTLEntryRec.FINDFIRST THEN BEGIN
            repeat
                case DGSTLEntryRec."GST Component Code" of
                    'CGST':
                        CGSTAmt := Abs(DGSTLEntryRec."GST Amount");
                    'SGST':
                        SGSTAmt := Abs(DGSTLEntryRec."GST Amount");
                    'IGST':
                        IGSTAmt := Abs(DGSTLEntryRec."GST Amount");
                    'CESS':
                        CessAmt := Abs(DGSTLEntryRec."GST Amount");
                end;
            until DGSTLEntryRec.Next() = 0;
        END;
        VATAmt := PILineRec."Line Amount" * PILineRec."VAT %" div 100;
        TotalTax := SGSTAmt + IGSTAmt + CGSTAmt + VATAmt + CessAmt;
        ItemCategoryrec.Reset();
        if ItemCategoryrec.Get(PILineRec."Item Category Code") then
            Parent_Acc := ItemCategoryrec."Parent Category";

        REC_VARIANT.Reset();
        REC_VARIANT.SetRange("Item No.", PILineRec."No.");
        REC_VARIANT.SetRange(Code, PILineRec."Variant Code");
        if REC_VARIANT.FindFirst() then;
        //    VARIANT_UOM := REC_VARIANT.UOM;

        PRcptHeaderRec.Reset();
        PRcptHeaderRec.SetRange("No.", "Purch. Inv. Header"."GRN No");
        if PRcptHeaderRec.FindFirst() then begin
            GRN_NO := PRcptHeaderRec."No.";
            GRN_Date := PRcptHeaderRec."Posting Date";
            Order_Date := PRcptHeaderRec."Order Date";
            Order_NO := PRcptHeaderRec."Order No.";
        end else begin
            Order_Date := "Purch. Inv. Header"."Order Date";
            Order_NO := "Purch. Inv. Header"."Order No.";
        end;
        VPGroupRec.Reset();
        if VPGroupRec.Get(VendorRec."Vendor Posting Group") then;

        if PILineRec."Location Code" <> '' then
            if LocationRec.Get(PILineRec."Location Code") then;

        xlBuff.NewRow();
        //Fiscal Year
        xlBuff.AddColumn(Date2DMY(PILineRec."Posting Date", 3), false, '', false, false, false, '', xlBuff."Cell Type"::Number);
        //Month
        xlBuff.AddColumn(Format(PILineRec."Posting Date", 0, '<Month Text,3>-<Year,2>'), false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Month Dimension
        // xlBuff.AddColumn(PILineRec."Shortcut Dimension 3 Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Brand Code        RED
        // xlBuff.AddColumn(LocationRec."Brand Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Location Code
        xlBuff.AddColumn(PILineRec."Location Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //LOC Dim
        xlBuff.AddColumn(PILineRec."Shortcut Dimension 2 Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //PO Date
        //if "Purch. Inv. Header"."Order No." <> '' then
        // xlBuff.AddColumn("Purch. Inv. Header"."Order Date", false, '', false, false, false, '', xlBuff."Cell Type"::Date)
        //else
        xlBuff.AddColumn(Order_Date, false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //PO No.
        xlBuff.AddColumn(Order_NO, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //GRN Date
        xlBuff.AddColumn(GRN_Date, false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //GRN NO.
        xlBuff.AddColumn(GRN_NO, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Doc Type
        if "Purch. Inv. Header"."Invoice Type" = "Purch. Inv. Header"."Invoice Type"::"Debit Note" then
            xlBuff.AddColumn('Debit Note', false, '', false, false, false, '', xlBuff."Cell Type"::Text)
        else
            xlBuff.AddColumn('Invoice', false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Purchase Invoice Date
        xlBuff.AddColumn("Purch. Inv. Header"."Posting Date", false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //Purchase  Invoice No.
        xlBuff.AddColumn("Purch. Inv. Header"."No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Document Date
        xlBuff.AddColumn("Purch. Inv. Header"."Document Date", false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //Document Number
        xlBuff.AddColumn("Purch. Inv. Header"."Vendor Invoice No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Refernce Invoice for CN
        xlBuff.AddColumn("Purch. Cr. Memo Hdr."."Applies-to Doc. No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor Group Code
        xlBuff.AddColumn(VendorRec."Vendor Posting Group", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor Group Desc
        // xlBuff.AddColumn(VPGroupRec.Description, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //SAGE Code
        //  xlBuff.AddColumn(VendorRec."Sage Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor Code
        xlBuff.AddColumn(VendorRec."No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor name
        xlBuff.AddColumn(VendorRec.Name, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //GST Registration No.
        if "Purch. Inv. Header"."Vendor GST Reg. No." <> '' then
            xlBuff.AddColumn("Purch. Inv. Header"."Vendor GST Reg. No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text)
        else
            xlBuff.AddColumn(VendorRec."GST Registration No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vat Registration no
        //  xlBuff.AddColumn(VendorRec."VAT Registration No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item -Parent Account
        // xlBuff.AddColumn(Parent_Acc, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item -Category
        // xlBuff.AddColumn(PILineRec."Item Category Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item Number / GL name
        xlBuff.AddColumn(PILineRec."No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item  / GL Description
        xlBuff.AddColumn(PILineRec.Description, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //HSN/ SAC Code
        xlBuff.AddColumn(PILineRec."HSN/SAC Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item Brand ( varient)
        //  xlBuff.AddColumn(PILineRec."Variant Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Quantity
        xlBuff.AddColumn(PILineRec.Quantity, false, '', false, false, false, '', xlBuff."Cell Type"::Number);
        // Item Base UOM
        xlBuff.AddColumn(PILineRec."Unit of Measure Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //VARIANT_UOM
        //  xlBuff.AddColumn(VARIANT_UOM, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Unit Cost
        xlBuff.AddColumn(PILineRec."Direct Unit Cost", false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Amount Excluding Tax
        xlBuff.AddColumn(PILineRec.Quantity * PILineRec."Direct Unit Cost", false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Discount %
        xlBuff.AddColumn(PILineRec."Line Discount %", false, '', false, false, false, '', xlBuff."Cell Type"::Number);
        //Discount Amount
        xlBuff.AddColumn(PILineRec."Line Discount Amount", false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Amount After Discount
        xlBuff.AddColumn(PILineRec."Line Amount", false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //GST Credit
        xlBuff.AddColumn(PILineRec."GST Credit", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //GST Group Code
        xlBuff.AddColumn(PILineRec."GST Group Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //EXEMPT
        if PILineRec.Exempted then
            xlBuff.AddColumn('Yes', false, '', false, false, false, '', xlBuff."Cell Type"::Text)
        else
            xlBuff.AddColumn('No', false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //TAX bock
        //SGST
        xlBuff.AddColumn(SGSTAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //CGST
        xlBuff.AddColumn(CGSTAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //IGST
        xlBuff.AddColumn(IGSTAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Cess
        //  xlBuff.AddColumn(CessAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Vat
        //   xlBuff.AddColumn(VATAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Total Tax Amount
        xlBuff.AddColumn(TotalTax, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Total Including Tax
        xlBuff.AddColumn(PILineRec."Line Amount" + TotalTax, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //MSME
        // xlBuff.AddColumn(REC_VED."MSME No." + '/' + REC_VED."UAM No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);


    end;

    local procedure PrintPurchaseCrMemoLine()
    begin
        SGSTAmt := 0;
        IGSTAmt := 0;
        CGSTAmt := 0;
        VATAmt := 0;
        CessAmt := 0;
        VARIANT_UOM := '';
        Clear(Parent_Acc);

        DGSTLEntryRec.RESET;
        DGSTLEntryRec.SETRANGE("Document No.", PCMLineRec."Document No.");
        DGSTLEntryRec.SETRANGE("Transaction Type", DGSTLEntryRec."Transaction Type"::Purchase);
        DGSTLEntryRec.SETRANGE("Document Line No.", PCMLineRec."Line No.");
        IF DGSTLEntryRec.FINDFIRST THEN BEGIN
            repeat
                case DGSTLEntryRec."GST Component Code" of
                    'CGST':
                        CGSTAmt := Abs(DGSTLEntryRec."GST Amount");
                    'SGST':
                        SGSTAmt := Abs(DGSTLEntryRec."GST Amount");
                    'IGST':
                        IGSTAmt := Abs(DGSTLEntryRec."GST Amount");
                    'CESS':
                        CessAmt := Abs(DGSTLEntryRec."GST Amount");
                end;
            until DGSTLEntryRec.Next() = 0;
        END;
        VATAmt := 0 - (PCMLineRec."Line Amount" * PCMLineRec."VAT %" div 100);
        TotalTax := SGSTAmt + IGSTAmt + CGSTAmt + VATAmt + CessAmt;
        ItemCategoryrec.Reset();
        if ItemCategoryrec.Get(PCMLineRec."Item Category Code") then
            Parent_Acc := ItemCategoryrec."Parent Category";
        REC_VARIANT.Reset();
        REC_VARIANT.SetRange("Item No.", PCMLineRec."No.");
        REC_VARIANT.SetRange(Code, PCMLineRec."Variant Code");
        if REC_VARIANT.FindFirst() then;
        //  VARIANT_UOM := REC_VARIANT.UOM;

        PRcptHeaderRec.Reset();
        PRcptHeaderRec.SetRange("Order No.", "Purch. Cr. Memo Hdr."."Return Order No.");
        if PRcptHeaderRec.FindFirst() then;
        VPGroupRec.Reset();
        if VPGroupRec.Get(VendorRec."Vendor Posting Group") then;

        if PILineRec."Location Code" <> '' then
            if LocationRec.Get(PILineRec."Location Code") then;


        xlBuff.NewRow();
        //Fiscal Year
        xlBuff.AddColumn(Date2DMY(PCMLineRec."Posting Date", 3), false, '', false, false, false, '', xlBuff."Cell Type"::Number);
        //Month
        xlBuff.AddColumn(Format(PCMLineRec."Posting Date", 0, '<Month Text,3>-<Year,2>'), false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Month Dimension
        // xlBuff.AddColumn(PCMLineRec."Shortcut Dimension 3 Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Brand Code
        //  xlBuff.AddColumn(LocationRec."Brand Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Location Code
        xlBuff.AddColumn(PCMLineRec."Location Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //LOC Dim
        xlBuff.AddColumn(PCMLineRec."Shortcut Dimension 2 Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //PO Date
        xlBuff.AddColumn(PRcptHeaderRec."Posting Date", false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //PO No.
        xlBuff.AddColumn("Purch. Cr. Memo Hdr."."Return Order No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //GRN Date          RED
        xlBuff.AddColumn('', false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //GRN NO.           RED
        xlBuff.AddColumn('', false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Doc Type
        xlBuff.AddColumn('Credit Note', false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Purchase Invoice Date
        xlBuff.AddColumn("Purch. Cr. Memo Hdr."."Posting Date", false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //Purchase  Invoice No.
        xlBuff.AddColumn("Purch. Cr. Memo Hdr."."No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Document Date
        xlBuff.AddColumn("Purch. Cr. Memo Hdr."."Document Date", false, '', false, false, false, '', xlBuff."Cell Type"::Date);
        //Document Number
        xlBuff.AddColumn("Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Refernce Invoice for CN
        xlBuff.AddColumn("Purch. Cr. Memo Hdr."."Applies-to Doc. No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor Group Code
        xlBuff.AddColumn(VendorRec."Vendor Posting Group", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor Group Desc
        //   xlBuff.AddColumn(VPGroupRec.Description, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //SAGE Code
        //  xlBuff.AddColumn(VendorRec."Sage Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor Code
        xlBuff.AddColumn(VendorRec."No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vendor name
        xlBuff.AddColumn(VendorRec.Name, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //GST Registration No.
        if "Purch. Cr. Memo Hdr."."Vendor GST Reg. No." <> '' then
            xlBuff.AddColumn("Purch. Cr. Memo Hdr."."Vendor GST Reg. No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text)
        else
            xlBuff.AddColumn(VendorRec."GST Registration No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Vat Registration no
        // xlBuff.AddColumn(VendorRec."VAT Registration No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item -Parent Account
        //  xlBuff.AddColumn(Parent_Acc, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item -Category
        //   xlBuff.AddColumn(PCMLineRec."Item Category Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item Number / GL name
        xlBuff.AddColumn(PCMLineRec."No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item  / GL Description
        xlBuff.AddColumn(PCMLineRec.Description, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //HSN/ SAC Code
        xlBuff.AddColumn(PCMLineRec."HSN/SAC Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Item Brand ( varient)
        //  xlBuff.AddColumn(PCMLineRec."Variant Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Quantity
        xlBuff.AddColumn(-PCMLineRec.Quantity, false, '', false, false, false, '', xlBuff."Cell Type"::Number);
        // Item Base UOM
        xlBuff.AddColumn(PCMLineRec."Unit of Measure Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        // xlBuff.AddColumn(VARIANT_UOM, false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //Unit Cost
        xlBuff.AddColumn(-PCMLineRec."Direct Unit Cost", false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Amount Excluding Tax
        xlBuff.AddColumn(-(PCMLineRec.Quantity * PCMLineRec."Direct Unit Cost"), false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Discount %
        xlBuff.AddColumn(PCMLineRec."Line Discount %", false, '', false, false, false, '', xlBuff."Cell Type"::Number);
        //Discount Amount
        xlBuff.AddColumn(-PCMLineRec."Line Discount Amount", false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Amount After Discount
        xlBuff.AddColumn(-PCMLineRec."Line Amount", false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //GST Credit
        xlBuff.AddColumn(PCMLineRec."GST Credit", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //GST Group Code
        xlBuff.AddColumn(PCMLineRec."GST Group Code", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //EXEMPT
        if PCMLineRec.Exempted then
            xlBuff.AddColumn('Yes', false, '', false, false, false, '', xlBuff."Cell Type"::Text)
        else
            xlBuff.AddColumn('No', false, '', false, false, false, '', xlBuff."Cell Type"::Text);
        //TAX bock
        //SGST
        xlBuff.AddColumn(-SGSTAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //CGST
        xlBuff.AddColumn(-CGSTAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //IGST
        xlBuff.AddColumn(-IGSTAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Cess
        //  xlBuff.AddColumn(-CessAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Vat
        //  xlBuff.AddColumn(-VATAmt, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Total Tax Amount
        xlBuff.AddColumn(-TotalTax, false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //Total Including Tax
        xlBuff.AddColumn(-(PCMLineRec."Line Amount" + TotalTax), false, '', false, false, false, '#0.00', xlBuff."Cell Type"::Number);
        //  xlBuff.AddColumn(REC_VED."MSME No." + '/' + REC_VED."UAM No.", false, '', false, false, false, '', xlBuff."Cell Type"::Text);
    end;

    var
        StartDate: Date;
        EndDate: date;
        SGSTAmt: Decimal;
        CGSTAmt: Decimal;
        IGSTAmt: Decimal;
        VATAmt: Decimal;
        CessAmt: Decimal;
        TotalTax: Decimal;
        xlBuff: Record "Excel Buffer" temporary;
        VendorRec: Record Vendor;
        LocationRec: Record Location;
        CompanyInformationRec: Record "Company Information";
        "PILineRec": Record "Purch. Inv. Line";
        PIHeaderRec: Record "Purch. Inv. Header";
        PRHeaderRec: Record "Purch. Rcpt. Header";
        "PCMLineRec": Record "Purch. Cr. Memo Line";
        PCMHeaderRec: Record "Purch. Cr. Memo Hdr.";
        GLSetuprec: Record "General Ledger Setup";
        DGSTLEntryRec: Record "Detailed GST Ledger Entry";
        PRcptHeaderRec: Record "Purch. Rcpt. Header";
        VPGroupRec: Record "Vendor Posting Group";
        Region: Code[20];
        VenPosGroup: Code[20];
        PurchaseIvoiceBool: Boolean;
        PurchaseCrMemoBool: Boolean;
        DimensionRec: Record Dimension;
        ItemCategoryrec: Record "Item Category";
        HeaderPrinted: Boolean;
        REC_VED: Record Vendor;
        REC_VARIANT: Record "Item Variant";
        VARIANT_UOM: text[100];
        GRN_NO: code[20];
        GRN_Date: Date;
        Item_Catg: Code[20];
        Order_NO: Code[20];
        Order_Date: Date;
        Parent_Acc: Text;

}
