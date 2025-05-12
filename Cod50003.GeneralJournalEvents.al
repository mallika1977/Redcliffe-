/// <summary>
/// Codeunit General Journal Events (ID 50003).
/// </summary>
codeunit 50003 "General Journal Events"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitVendLedgEntry', '', false, false)]
    local procedure OnBeforeInitVendLedgEntrytbl(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        vendLedger: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry.Narration := GenJournalLine.Narration;
    end;



    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitBankAccLedgEntry', '', false, false)]
    local procedure OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        BankAccountLedgerEntry.Narration := GenJournalLine.Narration;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitCustLedgEntry', '', false, false)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry.Narration := GenJournalLine.Narration;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal)
    begin
        GLEntry.Narration := GenJournalLine.Narration;
    end;


    [EventSubscriber(ObjectType::Page, page::"Apply Customer Entries", 'OnBeforeEarlierPostingDateError', '', false, false)]

    local procedure OnBeforeEarlierPostingDateError(ApplyingCustLedgerEntry: Record "Cust. Ledger Entry"; CustLedgerEntry: Record "Cust. Ledger Entry"; var RaiseError: Boolean; CalcType: Option; var OK: Boolean)

    begin
        if RaiseError then begin
            RaiseError := false;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeCheckIfPostingDateIsEarlier', '', false, false)]

    local procedure OnBeforeCheckIfPostingDateIsEarlier(GenJournalLine: Record "Gen. Journal Line"; ApplyPostingDate: Date; ApplyDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; ApplyDocNo: Code[20]; var IsHandled: Boolean; RecordVariant: Variant; CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        IsHandled := true;
    end;

    /// <summary>
    /// OnPostVendOnAfterInitVendLedgEntry.
    /// </summary>
    /// <param name="GenJnlLine">VAR Record "Gen. Journal Line".</param>
    /// <param name="VendLedgEntry">VAR Record "Vendor Ledger Entry".</param>
    /// <param name="Vendor">Record Vendor.</param>
    // [EventSubscriber(ObjectType::Codeunit, 12, 'OnPostVendOnAfterInitVendLedgEntry', '', false, false)]
    // procedure OnPostVendOnAfterInitVendLedgEntry(var GenJnlLine: Record "Gen. Journal Line"; var VendLedgEntry: Record "Vendor Ledger Entry"; Vendor: Record Vendor)
    // begin
    //     VendLedgEntry."Vend. Name" := Vendor.Name;
    // end;

    // [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterGLFinishPosting', '', false, false)]
    // local procedure OnAfterGLFinishPosting(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    // var
    //     VendorLedgerEntry: Record "Vendor Ledger Entry";
    //     GstLedger: Record "GST Ledger Entry";
    //     GstAmount: Decimal;


    // begin
    //     Clear(GstAmount);
    //     VendorLedgerEntry.Reset();
    //     VendorLedgerEntry.SetRange("Document No.", GenJnlLine."Document No.");
    //     if VendorLedgerEntry.FindFirst() then begin
    //         GstLedger.Reset();
    //         GstLedger.SetRange("Document No.", GenJnlLine."Document No.");
    //         if GstLedger.FindSet() then begin
    //             repeat
    //                 GstAmount += GstLedger."GST Amount";
    //             until GstLedger.Next() = 0;
    //         end;
    //         VendorLedgerEntry."GST Amount" := GstAmount;
    //         VendorLedgerEntry.Modify()
    //     end;
    // end;

    // /// <summary>
    // /// OnAfterPostPurchaseDoc.
    // /// </summary>
    // /// <param name="PurchaseHeader">VAR Record "Purchase Header".</param>
    // /// <param name="GenJnlPostLine">VAR Codeunit "Gen. Jnl.-Post Line".</param>
    // /// <param name="PurchRcpHdrNo">Code[20].</param>
    // /// <param name="RetShptHdrNo">Code[20].</param>
    // /// <param name="PurchInvHdrNo">Code[20].</param>
    // /// <param name="PurchCrMemoHdrNo">Code[20].</param>
    // /// <param name="CommitIsSupressed">Boolean.</param>
    // [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterPostPurchaseDoc', '', false, false)]
    // procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    // var
    //     VendorLedger: Record "Vendor Ledger Entry";
    //     PurchInvLine: Record "Purch. Inv. Line";
    //     PurchInvHeader: Record "Purch. Inv. Header";
    //     BaseAmount: Decimal;
    // begin
    //     Clear(BaseAmount);
    //     PurchInvHeader.Reset();
    //     PurchInvHeader.SetRange("No.", PurchInvHdrNo);
    //     if PurchInvHeader.FindFirst() then begin
    //         PurchInvLine.Reset();
    //         PurchInvLine.SetRange("Document No.", PurchInvHdrNo);
    //         if PurchInvLine.FindFirst() then begin
    //             repeat
    //                 BaseAmount += PurchInvLine."Line Amount";
    //             until PurchInvLine.Next() = 0;
    //         end;
    //         VendorLedger.Reset();
    //         VendorLedger.SetRange("Document No.", PurchInvHdrNo);
    //         if VendorLedger.FindFirst() then begin
    //             VendorLedger."GRN No." := PurchInvHeader."GRN No";
    //             VendorLedger."GRN Date" := PurchInvHeader."GRN Date";
    //             VendorLedger."Vendor Inv No." := PurchInvHeader."Vendor Invoice No.";
    //             VendorLedger."Vendor Inv Date" := PurchInvHeader."Vendor Invoice Date";
    //             VendorLedger."Base Amount" := BaseAmount;
    //             VendorLedger.Modify();
    //         end;
    //     end;

    // end;

}
