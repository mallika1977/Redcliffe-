page 50101 "API Car Model"
{
    PageType = API;

    APIVersion = 'v1.0';
    APIPublisher = 'bctech';
    APIGroup = 'demo';

    EntityCaption = 'CarModel';
    EntitySetCaption = 'CarModels';
    EntityName = 'carModel';
    EntitySetName = 'carModels';

    ODataKeyFields = SystemId;
    SourceTable = "Car Model";

    Extensible = false;
    DelayedInsert = true;

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
                field(brandId; Rec."Brand Id")
                {
                    Caption = 'Brand Id';
                    ApplicationArea = all;
                }
                field(power; Rec.Power)
                {
                    Caption = 'Power';
                    ApplicationArea = all;
                }
                field(fuelType; Rec."Fuel Type")
                {
                    Caption = 'Fuel Type';
                    ApplicationArea = all;
                }
            }
        }
    }
}