report 50139 "Customer\Vendor\Item Delete"
{
    // version V.001-CS

    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Administration;
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

            trigger OnPreDataItem()
            begin
                if not Customer_V then
                    CurrReport.Break();
                IF Source_No <> '' then
                    SetFilter("No.", Source_No)
                else
                    if not Confirm('Do you want to Delete All Customer ?') then
                        CurrReport.Break();
            end;
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = sorting("No.");
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

            trigger OnPreDataItem()
            begin
                if not Vendor_V then
                    CurrReport.Break();
                IF Source_No <> '' then
                    SetFilter("No.", Source_No)
                else
                    if not Confirm('Do you want to Delete All Vendor ?') then
                        CurrReport.Break();
            end;
        }
        dataitem(Item; Item)
        {
            DataItemTableView = sorting("No.");
            trigger OnAfterGetRecord()
            begin
                Delete();
            end;

            trigger OnPreDataItem()
            begin
                if not Item_V then
                    CurrReport.Break();
                IF Source_No <> '' then
                    SetFilter("No.", Source_No)
                else
                    if not Confirm('Do you want to Delete All Item ?') then
                        CurrReport.Break();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    field(Customer_V; Customer_V)
                    {
                        Caption = 'Customer';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            Vendor_V := false;
                            Item_V := false;
                        end;
                    }
                    field(Vendor_V; Vendor_V)
                    {
                        Caption = 'Vendor';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            Customer_V := false;
                            Item_V := false;
                        end;
                    }
                    field(Item_V; Item_V)
                    {
                        Caption = 'Item';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            Customer_V := false;
                            Vendor_V := false;
                        end;
                    }
                    field(Source_No; Source_No)
                    {

                        Caption = 'Source No.';
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Customer_V then begin
                                Clear(Customer_P);
                                Customer_.Reset();
                                Customer_.FindSet();
                                Customer_P.SETTABLEVIEW(Customer_);
                                Customer_P.LOOKUPMODE(TRUE);
                                IF Customer_P.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    Customer_P.GETRECORD(Customer_);
                                    Source_No := Customer_."No.";
                                end;
                            end;
                            if Vendor_V then begin
                                Clear(Vendor_P);
                                Vendor_.Reset();
                                Vendor_.FindSet();
                                Vendor_P.SETTABLEVIEW(Vendor_);
                                Vendor_P.LOOKUPMODE(TRUE);
                                IF Vendor_P.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    Vendor_P.GETRECORD(Vendor_);
                                    Source_No := Vendor_."No.";
                                end;
                            end;
                            if Item_V then begin
                                Clear(Item_P);
                                Item_.Reset();
                                Item_.FindSet();
                                Item_P.SETTABLEVIEW(Item_);
                                Item_P.LOOKUPMODE(TRUE);
                                IF Item_P.RUNMODAL = ACTION::LookupOK THEN BEGIN
                                    Item_P.GETRECORD(Item_);
                                    Source_No := Item_."No.";
                                end;
                            end;
                        end;

                    }
                }
            }
        }
    }


    labels
    {
    }

    trigger OnPostReport()
    begin
        MESSAGE('Done');
    end;

    var
        Counter: Integer;
        TotalCount: Integer;
        PROGRESS: Dialog;
        Text_10001Lbl: Label 'PROCESSING #1  Out Of  @2 .', Comment = '#1 = No. of Counts';
        Customer_V: Boolean;
        Vendor_V: Boolean;
        Source_No: Code[30];
        Customer_: Record customer;
        Vendor_: Record Vendor;
        Customer_P: PAGE "Customer Lookup";
        Vendor_P: PAGE "Vendor Lookup";
        Item_V: Boolean;
        Item_: Record Item;
        Item_P: PAGE "Item Lookup";
}