pageextension 50019 "SalesInvoiceCardExt" extends "Sales Invoice"
{
    layout
    {
        addlast(General)
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = ALL;
            }
        }
        //  addafter(Warehouse)
        // {
        //     group(Customized)
        //     {
        //         field("CRM Reference Id"; Rec."CRM Reference Id")
        //         {
        //             ApplicationArea = all;
        //         }
        //         field("Type of Test"; Rec."Type of Test")
        //         {
        //             ApplicationArea = all;
        //         }
        //     }
        // }
        modify("Sell-to Customer No.")
        {
            trigger OnBeforeValidate()
            var
                cust: Record Customer;
            begin
                if cust.Get(Rec."Sell-to Customer No.") then begin
                    if cust.Status = cust.Status::Open then
                        Error('Customer should be Released %1', Cust."No.");
                end;
            end;
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                US: Record "User Setup";
            begin
                US.Reset();
                IF US.Get(UserId) THEN;
                US.TestField("Allow SI");
            end;
        }
        modify(PostAndNew)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Get(UserId);
                UserSetup.TestField("Allow SI");

            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            var
                UserSetup: Record "User Setup";
            begin
                UserSetup.Get(UserId);
                UserSetup.TestField("Allow PI");

            end;
        }

    }
}
pageextension 50076 "SalesInvoicelistExt" extends "Sales Invoice List"
{
    layout
    {
        addafter(Amount)
        {
            field("IGST Amount"; Rec."IGST Amount") { ApplicationArea = all; }
            field("CGST Amount"; Rec."CGST Amount") { ApplicationArea = all; }
            field("SGST Amount"; Rec."SGST Amount") { ApplicationArea = all; }

            field("GST Amount"; Rec."GST Amount")
            {
                ApplicationArea = All;
            }
            field("TDS Amount"; Rec."TDS Amount")
            {
                ApplicationArea = All;
            }
            field("Net Amount"; Rec."Net Amount")

            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addafter(Post)
        {
            action("Delete Selected Sales Invoices")
            {
                ApplicationArea = All;
                Image = DeleteRow;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    RecH: Record "Sales Header";
                    RecL: Record "Sales Line";
                begin
                    CurrPage.SetSelectionFilter(RecH);
                    if RecH.FindFirst() then
                        repeat
                            RecH.Delete(true);
                            RecL.Reset();
                            RecL.Reset();
                            RecL.SetRange("Document Type", RecL."Document Type"::Invoice);
                            RecL.SetRange("Document No.", RecH."No.");
                            if RecL.FindFirst() then
                                repeat
                                    RecL.Delete(true);
                                until RecL.Next() = 0;
                        until RecH.Next() = 0;
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        UpdateGSTAmnt();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateGSTAmnt();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateGSTAmnt();
    end;

    procedure UpdateGSTAmnt()
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GST_A: Decimal;
        TDS_A: Decimal;
        PurchaseL: Record 37;
        IGST_: Decimal;
        CGST_: Decimal;
        SGST_: Decimal;
    begin
        //>>
        CLEAR(GST_A);
        Clear(TDS_A);
        IGST_ := 0;
        CGST_ := 0;
        SGST_ := 0;
        PurchaseL.Reset();
        PurchaseL.SetRange("Document Type", "Document Type");
        PurchaseL.SetRange("Document No.", "No.");
        IF PurchaseL.FindFirst() then
            repeat
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', PurchaseL.RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                TaxTransactionValue.SetRange("Visible on Interface", true);
                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                TaxTransactionValue.SetRange("Tax Type", 'GST');
                if TaxTransactionValue.FindSet() then
                    repeat
                        //Message('%1', TaxTransactionValue.Amount);
                        GST_A += (TaxTransactionValue.Amount);
                        if (TaxTransactionValue.GetAttributeColumName = 'CGST') then
                            CGST_ += (TaxTransactionValue.Amount);
                        IF (TaxTransactionValue.GetAttributeColumName = 'IGST') then
                            IGST_ += (TaxTransactionValue.Amount);
                        IF (TaxTransactionValue.GetAttributeColumName = 'SGST') then
                            SGST_ += (TaxTransactionValue.Amount);

                    until TaxTransactionValue.Next() = 0;
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', PurchaseL.RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                TaxTransactionValue.SetRange("Visible on Interface", true);
                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                TaxTransactionValue.SetRange("Tax Type", 'TDS');
                if TaxTransactionValue.FindSet() then
                    repeat
                        //Message('%1', TaxTransactionValue.Amount);
                        TDS_A += (TaxTransactionValue.Amount);
                    until TaxTransactionValue.Next() = 0;
            UNTIL PurchaseL.Next() = 0;
        Rec.CalcFields(Amount);
        if Rec.Amount <> 0 then begin
            Rec."GST Amount" := GST_A;
            Rec."IGST Amount" := Igst_;
            Rec."CGST Amount" := CGST_;
            Rec."SGST Amount" := SGST_;
            Rec."Net Amount" := Rec.Amount + GST_A - TDS_A;
            Rec."TDS Amount" := TDS_A;
            Rec.Modify();
        end;
    end;
}


pageextension 50077 "PurchaseInvoicelistExt" extends "Purchase Invoices"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Vendor GST Reg. No."; "Vendor GST Reg. No.")
            {
                ApplicationArea = all;
            }
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = all;
            }
            field("GST Vendor Type"; "GST Vendor Type")
            {
                ApplicationArea = all;
            }
        }
        addafter(Amount)
        {

            field("IGST Amount"; Rec."IGST Amount") { ApplicationArea = all; }
            field("CGST Amount"; Rec."CGST Amount") { ApplicationArea = all; }
            field("SGST Amount"; Rec."SGST Amount") { ApplicationArea = all; }
            field("GST Amount"; "GST Amount")
            {
                ApplicationArea = All;
            }
            field("TDS Amount"; "TDS Amount")
            {
                ApplicationArea = All;
            }
            field("Net Amount"; "Net Amount")
            {
                ApplicationArea = All;
            }
        }

    }
    actions
    {


        addafter(Statistics)
        {
            action("Import Purchase Invoices")
            {
                ApplicationArea = All;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = report "Purch. Invoice Imp. File";
            }
            action("Delete Selected Purchase Invoices")
            {
                ApplicationArea = All;
                Image = DeleteRow;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    RecH: Record "Purchase Header";
                    RecL: Record "Purchase Line";
                begin
                    CurrPage.SetSelectionFilter(RecH);
                    if RecH.FindFirst() then
                        repeat
                            RecH.Delete(true);
                            RecL.Reset();
                            RecL.Reset();
                            RecL.SetRange("Document Type", RecL."Document Type"::Invoice);
                            RecL.SetRange("Document No.", RecH."No.");
                            if RecL.FindFirst() then
                                repeat
                                    RecL.Delete(true);
                                until RecL.Next() = 0;
                        until RecH.Next() = 0;
                end;
            }

        }
    }
    trigger OnOpenPage()
    begin
        UpdateGSTAmnt();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateGSTAmnt();
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateGSTAmnt();
    end;

    procedure UpdateGSTAmnt()
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GST_A: Decimal;
        TDS_A: Decimal;
        PurchaseL: Record 39;
        IGST_: Decimal;
        CGST_: Decimal;
        SGST_: Decimal;
    begin
        //>>
        IGST_ := 0;
        CGST_ := 0;
        SGST_ := 0;
        CLEAR(GST_A);
        Clear(TDS_A);
        PurchaseL.Reset();
        PurchaseL.SetRange("Document Type", "Document Type");
        PurchaseL.SetRange("Document No.", "No.");
        IF PurchaseL.FindFirst() then
            repeat
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', PurchaseL.RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                TaxTransactionValue.SetRange("Visible on Interface", true);
                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                TaxTransactionValue.SetRange("Tax Type", 'GST');
                if TaxTransactionValue.FindSet() then
                    repeat
                        //Message('%1', TaxTransactionValue.Amount);
                        GST_A += (TaxTransactionValue.Amount);
                        if (TaxTransactionValue.GetAttributeColumName = 'CGST') then
                            CGST_ += (TaxTransactionValue.Amount);
                        IF (TaxTransactionValue.GetAttributeColumName = 'IGST') then
                            IGST_ += (TaxTransactionValue.Amount);
                        IF (TaxTransactionValue.GetAttributeColumName = 'SGST') then
                            SGST_ += (TaxTransactionValue.Amount);
                    until TaxTransactionValue.Next() = 0;
                TaxTransactionValue.Reset();
                TaxTransactionValue.SetFilter("Tax Record ID", '%1', PurchaseL.RecordId);
                TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
                TaxTransactionValue.SetRange("Visible on Interface", true);
                TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                TaxTransactionValue.SetRange("Tax Type", 'TDS');
                if TaxTransactionValue.FindSet() then
                    repeat
                        //Message('%1', TaxTransactionValue.Amount);
                        TDS_A += (TaxTransactionValue.Amount);
                    until TaxTransactionValue.Next() = 0;
            UNTIL PurchaseL.Next() = 0;
        Rec.CalcFields(Amount);
        if Rec.Amount <> 0 then begin
            Rec."GST Amount" := GST_A;
            Rec."IGST Amount" := Igst_;
            Rec."CGST Amount" := CGST_;
            Rec."SGST Amount" := SGST_;
            Rec."Net Amount" := Rec.Amount + GST_A - TDS_A;
            Rec."TDS Amount" := TDS_A;
            Rec.Modify();
        end;
    end;
}
