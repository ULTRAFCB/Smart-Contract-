// SPDX-License-Identifier: SimPL-2.0
pragma solidity <0.7.0;  //solidity version (backward compatible)

contract ReportScore {
    struct Report {	  //Define a report struct,which includes report name,developer adress,report score.
        string name;
        address owner;
        uint8[] stars;
        mapping(address => uint256) starOf; // Key to value mapping.
        uint totalStar;
    }

    Report[] public View_reports; //View the score of the submitted report.
    function Submit_Report(string memory name) public {  //<Memory>variable only take effect in current function.
        View_reports.push(
            Report(
                name,
                msg.sender,
                new uint8[](1),0));
    }

    function Star(uint reportId,uint8 num) public {  //Socred based on reportId.
        require(num>=1 && num <=100);   //The score range within 1-100.
        require(View_reports[reportId].starOf[msg.sender]==0); //
        Report storage report = View_reports[reportId]; //<Storage> Data can be shared across functions.
        report.stars.push(num);
        report.totalStar += num;
        report.starOf[msg.sender]=report.stars.length;
    }


    function Sort() public view returns (uint[] memory topIds)  //Sort report
    {
        topIds = new uint[](10);
        for(uint reportId=1;reportId<View_reports.length;reportId++){
          //
          uint topLast = reportId<topIds.length?reportId:topIds.length-1;
          if(reportId>=topIds.length && View_reports[reportId].totalStar<=View_reports[topIds[topLast]].totalStar){
              continue;
          }
          //
          topIds[topLast] = reportId;
          for(uint i=topLast;i>0;i--){
              if(View_reports[topIds[i]].totalStar>View_reports[topIds[i-1]].totalStar){
                  uint tempReportId = topIds[i];
                  topIds[i] = topIds[i-1];
                  topIds[i-1] = tempReportId;
              }else{
                  continue;
              }
          }
        }
    }
}
