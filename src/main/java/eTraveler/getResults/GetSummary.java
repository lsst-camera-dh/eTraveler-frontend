package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Set;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
   Returns summary information about some object in the eTraveler db,
   e.g. a run
 */
public class GetSummary {
  private Connection m_connect=null;
  private HashMap<String, Object> m_summary=null;

  public GetSummary(Connection conn) {
    m_connect = conn;
  }

  /**
     Primarily or exclusively for use internal to package
   */
  HashMap<String, Object> getRunSummaryByRaid(int raid)
        throws GetResultsException, SQLException {
    String sql="select runInt from RunNumber where rootActivityId='" + raid + "'";
    PreparedStatement stmt =
      m_connect.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs=stmt.executeQuery();
    boolean gotRow = rs.first();
    if (!gotRow) {
      throw new GetResultsNoDataException("No information for root activity id " + raid);      
    }
    return getRunSummary(rs.getInt("runInt"));
  }

  HashMap<String, Object> getRunSummary(String run)
    throws GetResultsException, SQLException {

    // Only continue if argument is of acceptable form
    int runInt = GetResultsUtil.formRunInt(run);

    return getRunSummary(runInt);
  }

  HashMap<String, Object> getRunSummary(int runInt) 
    throws GetResultsException, SQLException {    
    m_summary = new HashMap<String, Object>();

    String sql="select runNumber,runInt,Process.name as travelerName,RunNumber.rootActivityId as raid,Process.version as travelerVersion,A.begin, A.end,Subsystem.name as subsystem, HardwareType.name as hardwareType,Hardware.lsstId as experimentSN,AFS.name as runStatus from RunNumber join Activity A on RunNumber.rootActivityId=A.id join Process on Process.id=A.processId join TravelerType on Process.id=TravelerType.rootProcessId join Subsystem on Subsystem.id=TravelerType.subsystemId join Hardware on Hardware.id =A.hardwareId  join HardwareType on HardwareType.id=Hardware.hardwareTypeId "
      + GetResultsUtil.getActivityStatusJoins()
      + " where RunNumber.runInt=" + runInt;

    PreparedStatement stmt =
      m_connect.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs = stmt.executeQuery();

    boolean gotRow=rs.first();
    if (!gotRow) {
      throw new GetResultsNoDataException("No information for run " + runInt);
    }
    m_summary.put("runNumber", rs.getString("runNumber"));
    m_summary.put("runInt", rs.getInt("runInt"));
    m_summary.put("rootActivityId", rs.getInt("raid"));
    m_summary.put("travelerName", rs.getString("travelerName"));
    m_summary.put("travelerVersion", rs.getString("travelerVersion"));
    m_summary.put("hardwareType", rs.getString("hardwareType"));
    m_summary.put("experimentSN", rs.getString("experimentSN"));
    m_summary.put("begin", GetResultsUtil.timeISO(rs.getString("begin")));
    String end = rs.getString("end");
    if (end == null) end="";
    m_summary.put("end", GetResultsUtil.timeISO(end));
    m_summary.put("subsystem", rs.getString("subsystem"));
    m_summary.put("runStatus", rs.getString("runStatus"));

    return m_summary;
  }

  public Map<Integer,Object>
    getRunsByLabel(Set<String> runLabels, ArrayList<String> runStatuses,
                   String travelerType)
    throws GetResultsException, SQLException {
    HashMap<Integer, String> labelHash =
      GetResultsUtil.expandLabels(m_connect, runLabels, "run");
    HashMap<Integer, Object> labeledRuns = new HashMap<Integer, Object>();
    //ArrayList<String> labelArray = new ArrayList<String>(runLabels);
    String q="select runNumber, runInt, RN.id as runId, ";
    q += "RN.rootActivityId as raid,begin,end, ";
    //q += "RN.rootActivityId as raid, L.name as labelName,begin,end, ";
    q += "concat(LG.name, ':', L.name) as fullname,";
    q += "AFS.name as runStatus, P.name as pname, version, H.id as hid,";
    q += "H.lsstId as expSN, HT.name as hname from LabelCurrent LC ";
    q += "join Label L on L.id= LC.labelId ";
    q += "join LabelGroup LG on LG.id=L.labelGroupId ";
    q += "join RunNumber RN on RN.id=LC.objectId ";
    q += "join Activity A on A.id=RN.rootActivityId ";
    q += "join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId ";
    q += "join Process P on A.processId=P.id ";
    q += "join Hardware H on H.id=A.hardwareId ";
    q += "join HardwareType HT on HT.id = H.hardwareTypeId ";
    q += "where adding = 1 and L.id in "
      + GetResultsUtil.setToSqlList(labelHash.keySet());

    if (travelerType != null) {
      q += " and P.name = '" + travelerType + "' ";
    }
    q += " and AFS.name in ";
    q += GetResultsUtil.arrayToSqlList(runStatuses);
    q += " order by runInt";

    PreparedStatement stmt =
      m_connect.prepareStatement(q, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs;
    try {
      rs = stmt.executeQuery();
    } catch (SQLException se) {
      throw new SQLException(se.getMessage() + " from query \n" + q);
    }
    boolean gotRow  = rs.first();

    boolean first = true;
    HashMap<Integer, Object> runMaps;
    if (gotRow) {
      runMaps = new HashMap<Integer, Object>();
    } else {
      stmt.close();
      throw new GetResultsNoDataException("No runs with specified labels with query: \n" + q);
    }
    int oldRunInt = 0;
    HashMap<String, Object> oldRunMap = null;
    while (gotRow)  {
      int runInt = rs.getInt("runInt");
      if (runInt != oldRunInt) {
        HashMap<String, Object> runMap = new HashMap<String, Object>();
        runMaps.put((Integer)rs.getInt("raid"), runMap);
        oldRunInt = runInt;
        oldRunMap = runMap;
        runMap.put("runNumber", rs.getString("runNumber"));
        runMap.put("runInt", rs.getInt("runInt"));
        runMap.put("rootActivityId", rs.getInt("raid"));
        runMap.put("travelerName", rs.getString("pname"));
        runMap.put("runStatus", rs.getString("runStatus"));
        // runMap.put("subsystem", rs.getString("subsystem"));
        runMap.put("runNumber", rs.getString("runNumber"));
        runMap.put("runId", rs.getInt("runId"));
        runMap.put("travelerVersion", rs.getInt("version"));
        runMap.put("hardwareType", rs.getString("hname"));
        runMap.put("experimentSN", rs.getString("expSN"));
        runMap.put("hardwareId", rs.getInt("hid"));
        runMap.put("begin", GetResultsUtil.timeISO(rs.getString("begin")));
        String end = rs.getString("end");
        if (end == null) end = "";
        runMap.put("end", GetResultsUtil.timeISO(end));
        ArrayList<String> labelList = new ArrayList<String>();
        labelList.add(rs.getString("fullname"));
        runMap.put("runLabels", labelList);
      }  else {  // Just add new label to list
        ArrayList<String> oldList =
          (ArrayList<String>) oldRunMap.get("runLabels");
        oldList.add(rs.getString("fullname"));
      }
      gotRow = rs.relative(1);
    }
    stmt.close();
    return runMaps;
  }
  public Map<Integer, Object>
    getComponentRuns(String hardwareType, String experimentSN,
                     String travelerName, ArrayList<String> runStatuses)
    throws SQLException, GetResultsException {

    Map<Integer, Object> results =
      GetResultsUtil.getRunMaps(m_connect, hardwareType,
                                experimentSN, null, travelerName, true,
                                runStatuses);
    if (results == null) {
      throw new GetResultsNoDataException("No data found");
    }
    return results;
  }
}
