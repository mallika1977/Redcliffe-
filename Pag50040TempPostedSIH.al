page 50040 "TEMP Posted Invoice"
{

    ApplicationArea = All;
    Caption = 'Update Wrong Inv by Credit Memo';
    PageType = List;
    SourceTable = "TEMP POSTED SALE INVOICE";
    UsageCategory = Administration;
    Permissions = tabledata "Purch. Inv. Header" = rmi, tabledata "Purch. Inv. Line" = rmi, tabledata "Sales Shipment Line" = rmi, tabledata "Sales Shipment Header" = rmi, tabledata "Detailed GST Ledger Entry" = rmi, tabledata "GST Ledger Entry" = rmi,
  tabledata "Value Entry" = rmi, tabledata "Item Ledger Entry" = rmi, tabledata "Cust. Ledger Entry" = rmi, tabledata "Detailed Cust. Ledg. Entry" = rmi, tabledata "G/L Entry" = rmi,
  tabledata "VAT Entry" = rmi;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("INVOICE NO."; Rec."INVOICE NO.")
                {
                    ToolTip = 'Specifies the value of the INVOICE NO. field.';
                    ApplicationArea = All;
                }
                field(Updated; Updated)
                {
                    ApplicationArea = All;
                }
                field("Credit Memo"; "Credit Memo")
                {
                    ApplicationArea = All;
                }
                field("Posted Credit Memo"; "Posted Credit Memo")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import POS Data")
            {
                ApplicationArea = All;
                Caption = 'Import Excel';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    Rec_ExcelBuffer: Record "Excel Buffer";
                    Rows: Integer;
                    Columns: Integer;
                    Filename: Text;
                    FileMgmt: Codeunit "File Management";
                    ExcelFile: File;
                    Instr: InStream;
                    Sheetname: Text;
                    FileUploaded: Boolean;
                    RowNo: Integer;
                    ColNo: Integer;
                begin
                    Rec_ExcelBuffer.DeleteAll();
                    Rows := 0;
                    Columns := 0;
                    FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

                    if Filename <> '' then
                        Sheetname := Rec_ExcelBuffer.SelectSheetsNameStream(Instr)
                    else
                        exit;


                    Rec_ExcelBuffer.Reset;
                    Rec_ExcelBuffer.OpenBookStream(Instr, Sheetname);
                    Rec_ExcelBuffer.ReadSheet();

                    Commit();
                    Rec_ExcelBuffer.Reset();
                    Rec_ExcelBuffer.SetRange("Column No.", 1);
                    if Rec_ExcelBuffer.FindFirst() then
                        repeat
                            Rows := Rows + 1;
                        until Rec_ExcelBuffer.Next() = 0;

                    Rec_ExcelBuffer.Reset();
                    Rec_ExcelBuffer.SetRange("Row No.", 1);
                    if Rec_ExcelBuffer.FindFirst() then
                        repeat
                            Columns := Columns + 1;
                        until Rec_ExcelBuffer.Next() = 0;
                    for RowNo := 1 to Rows do begin
                        Init();
                        Evaluate("Entry No.", GetValueAtIndex(RowNo, 1));
                        Evaluate("INVOICE NO.", GetValueAtIndex(RowNo, 2));
                        Insert();
                    end;
                end;
            }

            action("Auto Credit Memo")
            {
                ApplicationArea = all;
                RunObject = report 50015;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin

                end;
            }

        }
    }
    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
        Rec_ExcelBuffer: Record "Excel Buffer";
    begin
        Rec_ExcelBuffer.Reset();
        IF Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");
    end;

}
