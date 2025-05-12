report 50010 "TDS Change Report Batch"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Permissions = tabledata "Vendor Ledger Entry" = rmi,
    tabledata "TDS Entry" = rmi;
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
                        Caption = 'Old TDS Section';
                        ApplicationArea = All;
                        //TableRelation = "TDS Section";

                    }
                    field("New GL Acc"; New_GL)
                    {
                        Caption = 'New TDS Section';
                        ApplicationArea = All;
                        TableRelation = "TDS Section";

                    }
                }
            }
        }


    }
    trigger OnPreReport()
    begin
        if Confirm('Do you want to change TDS, Old TDS %1 & New TDS %2', False, Old_GL, New_GL) then begin
            recGLE.RESET;
            recGLE.SETRANGE("TDS Section Code", Old_GL);
            IF recGLE.FINDSET THEN BEGIN
                REPEAT
                    IF recGLE."TDS Section Code" = Old_GL THEN
                        recGLE."TDS Section Code" := New_GL;
                    recGLE.MODIFY;
                UNTIL recGLE.NEXT = 0;
            end;
            RecTDS.RESET;
            RecTDS.SETRANGE(Section, Old_GL);
            IF RecTDS.FINDSET THEN BEGIN
                REPEAT
                    IF RecTDS.Section = Old_GL THEN
                        RecTDS.Section := New_GL;
                    RecTDS.MODIFY;
                UNTIL RecTDS.NEXT = 0;
            end;
        END;
    end;

    var
        Old_GL: Code[30];
        New_GL: Code[30];
        recGLE: record "Vendor Ledger Entry";
        RecTDS: Record "TDS Entry";

}