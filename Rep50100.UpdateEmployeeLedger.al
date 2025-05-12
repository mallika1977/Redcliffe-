report 50100 "Update Employee Ledger"
{
    ApplicationArea = All;
    Caption = 'Update Employee Ledger';
    UsageCategory = Administration;
    ProcessingOnly = true;
    Permissions = tabledata "Employee Ledger Entry" = rim;
    dataset

    {
        dataitem(EmployeeLedgerEntry; "Employee Ledger Entry")
        {

            RequestFilterFields = "Entry No.", "Document No.";
            CalcFields = "Credit Amount", "Debit Amount";
            trigger OnPreDataItem()
            begin
                EmployeeLedgerEntry.SetRange("Running Balance", 0);

            end;

            trigger OnAfterGetRecord()
            begin
                //  EmployeeLedgerEntry."Running Balance" := EmployeeLedgerEntry."Credit Amount" - "Debit Amount";
                //  EmployeeLedgerEntry.Modify();
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
}
