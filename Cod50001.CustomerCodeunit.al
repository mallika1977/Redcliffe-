codeunit 50001 "CustomerCodeunit"
{
    // procedure APILogHolisol(Code: Code[20]; ApiName: Text; TransactionType: Text; Requestjs: BigText; ResponseJs: DotNet "System.String")
    // var
    //     ApiLogsDetails: Record "APIs Error Log";
    //     OStream: OutStream;
    // begin
    //     ApiLogsDetails.INIT;
    //     ApiLogsDetails."Source No" := Code;
    //     ApiLogsDetails."Transaction Type" := TransactionType;
    //     ApiLogsDetails.RequestJson.CREATEOUTSTREAM(OStream);
    //     OStream.WRITETEXT(FORMAT(Requestjs));
    //     ApiLogsDetails.ResponseJson.CREATEOUTSTREAM(OStream);
    //     OStream.WRITETEXT(FORMAT(ResponseJs));
    //     ApiLogsDetails.APIName := ApiName;
    //     ApiLogsDetails."Created By" := USERID;
    //     ApiLogsDetails."Created On" := CURRENTDATETIME;

    //     ApiLogsDetails.INSERT;
    // end;

    trigger OnRun()
    begin
    end;

    var
        ven: Record "Item Unit of Measure";

}
