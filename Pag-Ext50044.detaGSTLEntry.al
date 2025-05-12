pageextension 50044 "Det. GST Led. Entry" extends "Detailed GST Ledger Entry"
{
    layout
    {
        addafter("Source No.")
        {
            field("Source Name"; "Source Name")
            {
                ApplicationArea = all;
            }
            field("Vendor Inv No."; "Vendor Inv No.")
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        GetSourceName();
    end;

    trigger OnAfterGetRecord()
    begin
        GetSourceName();
    end;

    procedure GetSourceName()
    begin
        if "Source Name" = '' then begin
            if "Source Type" = "Source Type"::Customer then begin
                Cust.Reset();
                if Cust.get("Source No.") then
                    "Source Name" := Cust.Name;
            end;
            if "Source Type" = "Source Type"::Vendor then begin
                Vend.Reset();
                if Vend.get("Source No.") then
                    "Source Name" := Vend.Name;
            end;
            Modify();
        end;
    end;

    var
        Cust: Record Customer;
        Vend: Record Vendor;

}
