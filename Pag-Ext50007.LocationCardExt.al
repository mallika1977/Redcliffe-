pageextension 50007 "LocationCard_Ext" extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field("CRM Location Code"; Rec."CRM Location Code")
            {

                ApplicationArea = all;
            }
        }

        addafter("Tax Information")
        {
            group(Customized)
            {

                field("CRM Reference Id"; Rec."CRM Reference Id")
                {
                    ApplicationArea = All;

                }
                field(Create; Rec."Created On")
                {
                    ApplicationArea = All;

                }

                field(Update; Rec."Updatet On")
                {
                    ApplicationArea = All;

                }
                field("Lab Code"; Rec."Lab Code")
                {
                    ApplicationArea = all;
                }
                field("Location Type"; Rec."Location Type")
                {
                    ApplicationArea = all;
                }
            }
        }


    }
    actions
    {
        addafter("&Bins")
        {
            action("Customer % List")
            {
                ApplicationArea = Warehouse;
                Caption = 'Customer % List';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Customer Percentage List";
                RunPageLink = "Location Code" = FIELD(Code);
                ToolTip = 'View or edit information about Customer Percentage that you use at this location.';
            }
        }
    }
}