report 50004 "GL Change Report Batch"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "G/L Entry" = rmi;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Change Accounts")
                {
                    field("Old GL Acc"; Old_GL)
                    {
                        ApplicationArea = All;
                        TableRelation = "G/L Account";

                    }
                    field("New GL Acc"; New_GL)
                    {
                        ApplicationArea = ALL;
                        TableRelation = "G/L Account";

                    }
                }
            }
        }


    }
    trigger OnPreReport()
    begin
        if Confirm('Do you want to change GL Acc, Old GL Acc %1 & New GL Acc %2', False, Old_GL, New_GL) then begin
            recGLE.RESET;
            recGLE.SETRANGE("G/L Account No.", Old_GL);
            IF recGLE.FINDSET THEN BEGIN
                REPEAT
                    IF recGLE."G/L Account No." = Old_GL THEN
                        recGLE."G/L Account No." := New_GL;
                    recGLE.MODIFY;
                UNTIL recGLE.NEXT = 0;
            end;
        END;
    end;

    var
        Old_GL: Code[30];
        New_GL: Code[30];
        recGLE: record 17;
}