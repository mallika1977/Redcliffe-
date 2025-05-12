page 50911 "Reverse Transaction - Batch"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Reverse Transaction - Batch";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = all;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field(Update; Rec.Update)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ReverseTransaction)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reverse Transaction';
                Ellipsis = true;
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Reverse a posted general ledger entry.';

                trigger OnAction()
                var
                    ReversalEntry: Record "Reversal Entry";
                    GLEntry: Record "G/L Entry";
                    ReveEn: Record 50911;
                begin

                    ReveEn.Reset();
                    if ReveEn.FindFirst() then
                        repeat
                            Clear(ReversalEntry);
                            GLEntry.Reset();
                            GLEntry.SetRange("Document No.", ReveEn."Document No.");
                            if GLEntry.FindFirst() then begin
                                if GLEntry.Reversed then
                                    ReversalEntry.AlreadyReversedEntry(GLEntry.TableCaption, GLEntry."Entry No.");
                                if GLEntry."Journal Batch Name" = '' then
                                    Error('You can only reverse entries that were posted from a journal.');
                                GLEntry.TestField("Transaction No.");
                                ReverseEntries(GLEntry."Transaction No.", RevType1::Transaction);
                            END;
                            ReveEn.Update := true;
                            ReveEn.Modify();
                            Commit();
                        until ReveEn.Next() = 0;
                end;
            }


        }
    }

    local procedure ReverseEntries(Number: Integer; RevType: Option Transaction,Register)
    var
        ReversalPost: Codeunit "Reversal-Post";
        IsHandled: Boolean;
    begin
        TempReversalEntry.DeleteAll();
        InsertReversalEntry(Number, RevType);
        TempReversalEntry.SetCurrentKey("Document No.", "Posting Date", "Entry Type", "Entry No.");
        if TempReversalEntry.FindFirst() then
            repeat
                // Message('%1\%2\%3', TempReversalEntry."Document No.", TempReversalEntry."Account No.", TempReversalEntry.Amount);
                //  ReversalPost.SetPrint(false);
                ReversalPost.Run(TempReversalEntry);
            // CurrPage.Update(false);
            until TempReversalEntry.Next() = 0;
        //        TempReversalEntry.DeleteAll();

    end;



    local procedure InsertReversalEntry(Number: Integer; RevType: Option Transaction,Register)
    var
        TempRevertTransactionNo: Record "Integer" temporary;
        NextLineNo: Integer;
        IsHandled: Boolean;
        GLSetup: Record "General Ledger Setup";
        TempReversalEntry: Record "Reversal Entry" temporary;
        ReversalEntry: Record "Reversal Entry";
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        GLSetup.Get();
        TempReversalEntry.DeleteAll();
        NextLineNo := 1;
        TempRevertTransactionNo.Number := Number;
        TempRevertTransactionNo.Insert();
        SetReverseFilter(Number, RevType);

        InsertFromCustLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromVendLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromEmplLedgerEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromBankAccLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromFALedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromMaintenanceLedgEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromVATEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        InsertFromGLEntry(TempRevertTransactionNo, Number, RevType, NextLineNo);
        if TempReversalEntry.Find('-') then;


    end;


    procedure SetReverseFilter(Number: Integer; RevType: Option Transaction,Register)
    begin
        if RevType = RevType::Transaction then begin
            GLEntry.SetCurrentKey("Transaction No.");
            CustLedgEntry.SetCurrentKey("Transaction No.");
            VendLedgEntry.SetCurrentKey("Transaction No.");
            EmployeeLedgerEntry.SetCurrentKey("Transaction No.");
            BankAccLedgEntry.SetCurrentKey("Transaction No.");
            FALedgEntry.SetCurrentKey("Transaction No.");
            MaintenanceLedgEntry.SetCurrentKey("Transaction No.");
            VATEntry.SetCurrentKey("Transaction No.");
            GLEntry.SetRange("Transaction No.", Number);
            CustLedgEntry.SetRange("Transaction No.", Number);
            VendLedgEntry.SetRange("Transaction No.", Number);
            EmployeeLedgerEntry.SetRange("Transaction No.", Number);
            BankAccLedgEntry.SetRange("Transaction No.", Number);
            FALedgEntry.SetRange("Transaction No.", Number);
            FALedgEntry.SetFilter("G/L Entry No.", '<>%1', 0);
            MaintenanceLedgEntry.SetRange("Transaction No.", Number);
            VATEntry.SetRange("Transaction No.", Number);
        end else begin
            GLReg.Get(Number);
            GLEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            CustLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            VendLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            EmployeeLedgerEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            BankAccLedgEntry.SetRange("Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            FALedgEntry.SetCurrentKey("G/L Entry No.");
            FALedgEntry.SetRange("G/L Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            MaintenanceLedgEntry.SetCurrentKey("G/L Entry No.");
            MaintenanceLedgEntry.SetRange("G/L Entry No.", GLReg."From Entry No.", GLReg."To Entry No.");
            VATEntry.SetRange("Entry No.", GLReg."From VAT Entry No.", GLReg."To VAT Entry No.");
        end;

    end;


    protected procedure InsertFromCustLedgEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        Cust: Record Customer;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.SetCurrentKey("Transaction No.", "Customer No.", "Entry Type");
        DtldCustLedgEntry.SetFilter(
          "Entry Type", '<>%1', DtldCustLedgEntry."Entry Type"::"Initial Entry");
        if CustLedgEntry.FindSet() then
            repeat
                DtldCustLedgEntry.SetRange("Transaction No.", CustLedgEntry."Transaction No.");
                DtldCustLedgEntry.SetRange("Customer No.", CustLedgEntry."Customer No.");
                if (not DtldCustLedgEntry.IsEmpty) and (RevType = RevType::Register) then
                    Error(PostedAndAppliedSameTransactionErr, Number);

                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Customer;
                Cust.Get(CustLedgEntry."Customer No.");
                TempReversalEntry."Account No." := Cust."No.";
                TempReversalEntry."Account Name" := Cust.Name;
                TempReversalEntry.CopyFromCustLedgEntry(CustLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.Insert();

                DtldCustLedgEntry.SetRange(Unapplied, true);
                if DtldCustLedgEntry.FindSet() then
                    repeat
                        InsertCustTempRevertTransNo(TempRevertTransactionNo, DtldCustLedgEntry."Unapplied by Entry No.");
                    until DtldCustLedgEntry.Next() = 0;
                DtldCustLedgEntry.SetRange(Unapplied);
            until CustLedgEntry.Next() = 0;

    end;

    procedure InsertCustTempRevertTransNo(var TempRevertTransactionNo: Record "Integer" temporary; CustLedgEntryNo: Integer)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.Get(CustLedgEntryNo);
        if DtldCustLedgEntry."Transaction No." <> 0 then begin
            TempRevertTransactionNo.Number := DtldCustLedgEntry."Transaction No.";
            if TempRevertTransactionNo.Insert() then;
        end;
    end;

    protected procedure InsertFromVendLedgEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        Vend: Record Vendor;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
        DtldVendLedgEntry.SetFilter(
          "Entry Type", '<>%1', DtldVendLedgEntry."Entry Type"::"Initial Entry");
        if VendLedgEntry.FindSet() then
            repeat
                DtldVendLedgEntry.SetRange("Transaction No.", VendLedgEntry."Transaction No.");
                DtldVendLedgEntry.SetRange("Vendor No.", VendLedgEntry."Vendor No.");
                if (not DtldVendLedgEntry.IsEmpty) and (RevType = RevType::Register) then
                    Error(PostedAndAppliedSameTransactionErr, Number);

                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Vendor;
                Vend.Get(VendLedgEntry."Vendor No.");
                TempReversalEntry."Account No." := Vend."No.";
                TempReversalEntry."Account Name" := Vend.Name;
                TempReversalEntry.CopyFromVendLedgEntry(VendLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.Insert();

                DtldVendLedgEntry.SetRange(Unapplied, true);
                if DtldVendLedgEntry.FindSet() then
                    repeat
                        InsertVendTempRevertTransNo(TempRevertTransactionNo, DtldVendLedgEntry."Unapplied by Entry No.");
                    until DtldVendLedgEntry.Next() = 0;
                DtldVendLedgEntry.SetRange(Unapplied);
            until VendLedgEntry.Next() = 0;

    end;

    procedure InsertVendTempRevertTransNo(var TempRevertTransactionNo: Record "Integer" temporary; VendLedgEntryNo: Integer)
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry.Get(VendLedgEntryNo);
        if DtldVendLedgEntry."Transaction No." <> 0 then begin
            TempRevertTransactionNo.Number := DtldVendLedgEntry."Transaction No.";
            if TempRevertTransactionNo.Insert() then;
        end;
    end;

    protected procedure InsertFromEmplLedgerEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
    begin
        DetailedEmployeeLedgerEntry.SetCurrentKey("Transaction No.", "Employee No.", "Entry Type");
        DetailedEmployeeLedgerEntry.SetFilter(
          "Entry Type", '<>%1', DetailedEmployeeLedgerEntry."Entry Type"::"Initial Entry");

        if EmployeeLedgerEntry.FindSet() then
            repeat
                DetailedEmployeeLedgerEntry.SetRange("Transaction No.", EmployeeLedgerEntry."Transaction No.");
                DetailedEmployeeLedgerEntry.SetRange("Employee No.", EmployeeLedgerEntry."Employee No.");
                if (not DetailedEmployeeLedgerEntry.IsEmpty) and (RevType = RevType::Register) then
                    Error(PostedAndAppliedSameTransactionErr, Number);

                NextLineNo += 1;


            until EmployeeLedgerEntry.Next() = 0;

    end;

    protected procedure InsertFromBankAccLedgEntry(TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        BankAcc: Record "Bank Account";
    begin
        if BankAccLedgEntry.FindSet() then
            repeat
                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"Bank Account";
                BankAcc.Get(BankAccLedgEntry."Bank Account No.");
                TempReversalEntry."Account No." := BankAcc."No.";
                TempReversalEntry."Account Name" := BankAcc.Name;
                TempReversalEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.Insert();
            until BankAccLedgEntry.Next() = 0;

    end;

    protected procedure InsertFromFALedgEntry(TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        FA: Record "Fixed Asset";
    begin
        if FALedgEntry.FindSet() then
            repeat
                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"Fixed Asset";
                FA.Get(FALedgEntry."FA No.");
                TempReversalEntry."Account No." := FA."No.";
                TempReversalEntry."Account Name" := FA.Description;
                TempReversalEntry.CopyFromFALedgEntry(FALedgEntry);
                if FALedgEntry."FA Posting Type" <> FALedgEntry."FA Posting Type"::"Salvage Value" then begin
                    TempReversalEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    TempReversalEntry.Insert();
                end;
            until FALedgEntry.Next() = 0;

    end;

    protected procedure InsertFromMaintenanceLedgEntry(TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        FA: Record "Fixed Asset";
    begin
        if MaintenanceLedgEntry.FindSet() then
            repeat
                Clear(TempReversalEntry);
                if RevType = RevType::Register then
                    TempReversalEntry."G/L Register No." := Number;
                TempReversalEntry."Reversal Type" := RevType;
                TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::Maintenance;
                FA.Get(MaintenanceLedgEntry."FA No.");
                TempReversalEntry."Account No." := FA."No.";
                TempReversalEntry."Account Name" := FA.Description;
                TempReversalEntry.CopyFromMaintenanceEntry(MaintenanceLedgEntry);
                TempReversalEntry."Line No." := NextLineNo;
                NextLineNo := NextLineNo + 1;
                TempReversalEntry.Insert();
            until MaintenanceLedgEntry.Next() = 0;

    end;

    protected procedure InsertFromVATEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    begin
        TempRevertTransactionNo.FindSet();
        repeat
            if RevType = RevType::Transaction then
                VATEntry.SetRange("Transaction No.", TempRevertTransactionNo.Number);
            if VATEntry.FindSet() then
                repeat
                    Clear(TempReversalEntry);
                    if RevType = RevType::Register then
                        TempReversalEntry."G/L Register No." := Number;
                    TempReversalEntry."Reversal Type" := RevType;
                    TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::VAT;
                    TempReversalEntry.CopyFromVATEntry(VATEntry);
                    TempReversalEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    TempReversalEntry.Insert();
                until VATEntry.Next() = 0;
        until TempRevertTransactionNo.Next() = 0;

    end;

    protected procedure InsertFromGLEntry(var TempRevertTransactionNo: Record "Integer" temporary; Number: Integer; RevType: Option Transaction,Register; var NextLineNo: Integer)
    var
        GLAcc: Record "G/L Account";
    begin
        TempRevertTransactionNo.FindSet();
        repeat
            if RevType = RevType::Transaction then
                GLEntry.SetRange("Transaction No.", TempRevertTransactionNo.Number);
            if GLEntry.FindSet() then
                repeat
                    Clear(TempReversalEntry);
                    if RevType = RevType::Register then
                        TempReversalEntry."G/L Register No." := Number;
                    TempReversalEntry."Reversal Type" := RevType;
                    TempReversalEntry."Entry Type" := TempReversalEntry."Entry Type"::"G/L Account";
                    if not GLAcc.Get(GLEntry."G/L Account No.") then
                        Error(CannotReverseDeletedErr, GLEntry.TableCaption(), GLAcc.TableCaption);
                    TempReversalEntry."Account No." := GLAcc."No.";
                    TempReversalEntry."Account Name" := GLAcc.Name;
                    TempReversalEntry.CopyFromGLEntry(GLEntry);
                    TempReversalEntry."Line No." := NextLineNo;
                    NextLineNo := NextLineNo + 1;
                    TempReversalEntry.Insert();
                until GLEntry.Next() = 0;
        until TempRevertTransactionNo.Next() = 0;

    end;

    var
        RevType1: Option Transaction,Register;
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        VATEntry: Record "VAT Entry";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        GLReg: Record "G/L Register";
        Text000: Label 'You cannot reverse %1 No. %2 because the entry is either applied to an entry or has been changed by a batch job.';
        FAReg: Record "FA Register";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Text001: Label 'You cannot reverse %1 No. %2 because the posting date is not within the allowed posting period.';
        Text002: Label 'You cannot reverse the transaction because it is out of balance.';
        Text003: Label 'You cannot reverse %1 No. %2 because the entry has a related check ledger entry.';
        Text004: Label 'You can only reverse entries that were posted from a journal.';
        Text005: Label 'You cannot reverse %1 No. %2 because the %3 is not within the allowed posting period.';
        Text006: Label 'You cannot reverse %1 No. %2 because the entry is closed.';
        Text007: Label 'You cannot reverse %1 No. %2 because the entry is included in a bank account reconciliation line. The bank reconciliation has not yet been posted.';
        Text008: Label 'You cannot reverse the transaction because the %1 has been sold.';
        CannotReverseDeletedErr: Label 'The transaction cannot be reversed, because the %1 has been compressed or a %2 has been deleted.', Comment = '%1 and %2 = table captions';
        Text010: Label 'You cannot reverse %1 No. %2 because the register has already been involved in a reversal.';
        Text011: Label 'You cannot reverse %1 No. %2 because the entry has already been involved in a reversal.';
        PostedAndAppliedSameTransactionErr: Label 'You cannot reverse register number %1 because it contains customer or vendor or employee ledger entries that have been posted and applied in the same transaction.\\You must reverse each transaction in register number %1 separately.', Comment = '%1="G/L Register No."';
        Text013: Label 'You cannot reverse %1 No. %2 because the entry has an associated Realized Gain/Loss entry.';
        UnrealizedVATReverseErr: Label 'You cannot reverse %1 No. %2 because the entry has an associated Unrealized VAT Entry.';

        GLSetup: Record "General Ledger Setup";
        TempReversalEntry: Record "Reversal Entry" temporary;
        AllowPostingFrom: Date;
        AllowPostingto: Date;
        HideDialog: Boolean;
        HideWarningDialogs: Boolean;
        MaxPostingDate: Date;

}