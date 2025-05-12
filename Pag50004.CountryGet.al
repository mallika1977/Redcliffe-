page 50004 "CountryGet"
{
    PageType = API;
    APIVersion = 'v1.0';
    APIPublisher = 'ANI';
    APIGroup = 'CountryGet';
    SourceTable = "Country/Region";
    Caption = 'Country Get';
    ApplicationArea = All;
    UsageCategory = Administration;
    EntityName = 'tB1';
    EntitySetName = 'tB1';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = true;
    layout
    {
        area(content)
        {
            repeater(GroupName)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic, Suite, Invoicing;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite, Invoicing;
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field("ISOCode"; Rec."ISO Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a two-letter country code defined in ISO 3166-1.';
                }
                field("ISONumericCode"; Rec."ISO Numeric Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a three-digit code number defined in ISO 3166-1.';
                }

                field("EUCountryRegionCode"; Rec."EU Country/Region Code")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies the EU code for the country/region you are doing business with.';
                }
                field("IntrastatCode"; Rec."Intrastat Code")
                {
                    ApplicationArea = BasicEU;
                    ToolTip = 'Specifies an INTRASTAT code for the country/region you are trading with.';
                }

            }
        }
    }

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecCust: Record Customer;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin


    end;

    procedure InsertCust(): Text
    begin


    end;


}
