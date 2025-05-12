pageextension 50025 "PostedSalesCrMemo" extends "Posted Sales Credit Memo"
{
    layout
    {

    }
    actions
    {
        addafter(Print)
        {
            action("TCS Generate E-Invoice")
            {
                Caption = 'TCS Generate E-Invoice';
                Image = Indent;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;


                trigger OnAction()
                var
                    SalesPost: Codeunit "Sales-Post";
                    SalesInvHeader: Record "Sales Cr.Memo Header";
                begin
                    CLEAR(eInvoice);
                    CLEAR(eInvoice);
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.", Rec."No.");
                    SalesInvHeader.FINDFIRST;
                    SalesInvHeader.MARK(TRUE);
                    eInvoice.SetCrMemoHeader(SalesInvHeader);
                    eInvoice.GenrateInvoice;
                end;

            }
            // action("TCS Cancel E-Invoice")
            // {
            //     Caption = 'TCS Cancel E-Invoice';
            //     Image = CancelIndent;

            //     trigger OnAction()
            //     Var
            //         SalesInvHeader: Record 112;
            //         Var_SelectedValue: Integer;
            //         eInvoiceManagement: Codeunit "e-Invoice Management";
            //     Begin
            //         TESTFIELD("IRN Hash");
            //         TESTFIELD("Cancel Reason");

            //         if eInvoiceManagement.IsGSTApplicable(Rec."No.", Database::"Sales Invoice Header") then begin
            //             SalesInvHeader.RESET;
            //             SalesInvHeader.SETRANGE("No.", "No.");
            //             IF SalesInvHeader.FINDFIRST THEN BEGIN
            //                 CLEAR(eInvoice);
            //                 SalesInvHeader.MARK(TRUE);
            //                 eInvoice.SetSalesInvHeader(SalesInvHeader);
            //                 eInvoice.GenCanceleInvoice;
            //             END;
            //         END ELSE
            //             ERROR(eInvoiceErr);
            //     End;
            // }

            action("Export TCS E-Invoice")
            {
                ApplicationArea = Basic, Suite;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Specifies the function through which Json file will be generated.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Cr.Memo Header";
                    eInvoiceJsonHandler: Codeunit "TCS e-Invoice";
                    eInvoiceManagement: Codeunit "e-Invoice Management";
                    eInvoiceNonGSTTransactionErr: Label 'E-Invoicing is not applicable for Non-GST Transactions.';
                begin
                    if eInvoiceManagement.IsGSTApplicable(Rec."No.", Database::"Sales Invoice Header") then begin
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETRANGE("No.", "No.");
                        IF SalesInvHeader.FINDFIRST THEN BEGIN
                            CLEAR(eInvoice);
                            SalesInvHeader.MARK(TRUE);
                            eInvoice.SetCrMemoHeader(SalesInvHeader);
                            eInvoice.RUN;
                        END;
                    END ELSE
                        Error(eInvoiceNonGSTTransactionErr);
                end;
            }
            action("Get TCS Invoice by IRN")
            {
                ApplicationArea = Basic, Suite;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Specifies the function through which Json file will be generated.';

                trigger OnAction()
                var
                    TcsAuth: Codeunit "TCS Api Authentication";
                    SalesInvHeader: Record "Sales Cr.Memo Header";
                begin
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.", Rec."No.");
                    SalesInvHeader.FINDFIRST;
                    SalesInvHeader.MARK(TRUE);
                    TcsAuth.GetInvoiceByIRN(SalesInvHeader."No.", SalesInvHeader."Location GST Reg. No.", SalesInvHeader."IRN Hash");

                end;
            }
            // action("TCS Generate IRN")
            // {
            //     ApplicationArea = Basic, Suite;
            //     Image = ExportFile;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     PromotedIsBig = true;
            //     PromotedOnly = true;
            //     ToolTip = 'Specifies the function through which Json file will be generated.';
            //     trigger OnAction()
            //     var
            //         Code60001: Codeunit "RequisitionEvent";
            //         eInvoiceManagement: Codeunit "e-Invoice Management";
            //     begin
            //         if eInvoiceManagement.IsGSTApplicable(Rec."No.", Database::"Sales Cr.Memo Header") then begin
            //             IF "GST Customer Type" IN
            //                ["GST Customer Type"::Unregistered,
            //                 "GST Customer Type"::" "]
            //             THEN
            //                 ERROR(UnRegCustErr);

            //             CLEAR(Code60001);
            //             Code60001.GenerateIRN("No.", DATABASE::"Sales Cr.Memo Header");
            //             CurrPage.UPDATE;
            //         END ELSE
            //             ERROR(eInvoiceErr);

            //     end;
            // }
        }
    }
    var
        UnRegCustErr: Label 'ENU=E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.;ENN=E-Invoicing is not applicable for Unregistered, Export and Deemed Export Customers.';
        MakeFieldUneditable: Boolean;
        eInvoiceErr: Label 'ENU=E-Invoicing is not applicable for Non-GST Transactions.;ENN=E-Invoicing is not applicable for Non-GST Transactions.';
        eInvoice: Codeunit "TCS e-Invoice";
}
