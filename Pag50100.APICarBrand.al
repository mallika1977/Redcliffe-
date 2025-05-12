page 50100 "API Car Brand"
{
    PageType = API;
    APIGroup = 'demo';
    APIVersion = 'v1.0';
    APIPublisher = 'bctech';

    EntityCaption = 'CarBrand';
    EntitySetCaption = 'CarBrands';
    EntityName = 'carBrand';
    EntitySetName = 'carBrands';

    ODataKeyFields = SystemId;
    SourceTable = "Car Brand";

    Extensible = false;
    DelayedInsert = true;
    // ApplicationArea = all;
    // UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                    ApplicationArea = all;

                }

                field(name; Rec.Name)
                {
                    Caption = 'Name';
                    ApplicationArea = all;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = all;
                }
                field(country; Rec.Country)
                {
                    Caption = 'Country';
                    ApplicationArea = all;
                }
            }

            part(carModels; "API Car Model")
            {
                ApplicationArea = all;
                Caption = 'Car Models';
                EntityName = 'carModel';
                EntitySetName = 'carModels';
                SubPageLink = "Brand Id" = Field(SystemId);
            }
        }
    }
}