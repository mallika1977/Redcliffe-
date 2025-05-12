pageextension 50024 "PostedSaleInvoice" extends "Posted Sales Invoice"
{
    layout
    {


    }
    actions
    {
        addafter(Print)
        {
            // action("Tax Invoice")
            // {
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Image = Report;
            //     trigger OnAction()
            //     var
            //         PSH: Record "Sales Invoice Header";
            //     begin
            //         PSH.Reset();
            //         PSH.SetRange("No.", Rec."No.");
            //         if PSH.FindFirst() then begin
            //             Report.RunModal(50100, true, true, PSH);
            //         end;
            //     end;
            // }
            action("Export Invoice")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category6;
                Image = Report;
                trigger OnAction()
                var
                    PSH: Record "Sales Invoice Header";
                begin
                    PSH.Reset();
                    PSH.SetRange("No.", Rec."No.");
                    if PSH.FindFirst() then begin
                        Report.RunModal(50016, true, true, PSH);
                    end;
                end;
            }
            action("Bill of Supply")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category6;
                Image = Report;
                trigger OnAction()
                var
                    PSH: Record "Sales Invoice Header";
                begin
                    PSH.Reset();
                    PSH.SetRange("No.", Rec."No.");
                    if PSH.FindFirst() then begin
                        Report.RunModal(50017, true, true, PSH);
                    end;
                end;
            }
            // action("Calculate Commission")s
            // {
            //     ApplicationArea = all;
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     Image = Process;
            //     trigger OnAction()
            //     begin
            //         Update_Commission(Rec."No.");
            //     end;
            // }

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
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    CLEAR(eInvoice);
                    CLEAR(eInvoice);
                    SalesInvHeader.RESET;
                    SalesInvHeader.SETRANGE("No.", Rec."No.");
                    SalesInvHeader.FINDFIRST;
                    SalesInvHeader.MARK(TRUE);
                    eInvoice.SetSalesInvHeader(SalesInvHeader);
                    eInvoice.GenrateInvoice;
                end;

            }
            action("TCS Cancel E-Invoice")
            {
                Caption = 'TCS Cancel E-Invoice';
                Image = CancelIndent;

                trigger OnAction()
                Var
                    SalesInvHeader: Record 112;
                    Var_SelectedValue: Integer;
                    eInvoiceManagement: Codeunit "e-Invoice Management";
                Begin
                    TESTFIELD("IRN Hash");
                    TESTFIELD("Cancel Reason");

                    if eInvoiceManagement.IsGSTApplicable(Rec."No.", Database::"Sales Invoice Header") then begin
                        SalesInvHeader.RESET;
                        SalesInvHeader.SETRANGE("No.", "No.");
                        IF SalesInvHeader.FINDFIRST THEN BEGIN
                            CLEAR(eInvoice);
                            SalesInvHeader.MARK(TRUE);
                            eInvoice.SetSalesInvHeader(SalesInvHeader);
                            eInvoice.GenCanceleInvoice;
                        END;
                    END ELSE
                        ERROR(eInvoiceErr);
                End;
            }

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
                    SalesInvHeader: Record "Sales Invoice Header";
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
                            eInvoice.SetSalesInvHeader(SalesInvHeader);
                            eInvoice.RUN;
                        END;
                    END ELSE
                        Error(eInvoiceNonGSTTransactionErr);
                end;
            }
            action("TCS Get Invoice by IRN")
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
            //         if eInvoiceManagement.IsGSTApplicable(Rec."No.", Database::"Sales Invoice Header") then begin
            //             IF "GST Customer Type" IN
            //                ["GST Customer Type"::Unregistered,
            //                 "GST Customer Type"::" "]
            //             THEN
            //                 ERROR(UnRegCustErr);

            //             CLEAR(Code60001);
            //             Code60001.GenerateIRN("No.", DATABASE::"Sales Invoice Header");
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
