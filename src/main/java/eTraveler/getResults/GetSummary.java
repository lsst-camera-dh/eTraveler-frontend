package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;

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

    String sql="select runNumber,runInt,Process.name as travelerName,RunNumber.rootActivityId as raid,Process.version as travelerVersion,Activity.begin, Activity.end,Subsystem.name as subsystem, HardwareType.name as hardwareType,Hardware.lsstId as experimentSN,AFS.name as runStatus from RunNumber join Activity on RunNumber.rootActivityId=Activity.id join Process on Process.id=Activity.processId join TravelerType on Process.id=TravelerType.rootProcessId join Subsystem on Subsystem.id=TravelerType.subsystemId join Hardware on Hardware.id =Activity.hardwareId  join HardwareType on HardwareType.id=Hardware.hardwareTypeId join ActivityStatusHistory  ASH on ASH.activityId=Activity.id  join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId where RunNumber.runInt=" + runInt + " order by ASH.id desc limit 1";

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
    m_summary.put("begin", rs.getString("begin"));
    String end = rs.getString("end");
    if (end == null) end="";
    m_summary.put("end", end);
    m_summary.put("subsystem", rs.getString("subsystem"));
    m_summary.put("runStatus", rs.getString("runStatus"));

    return m_summary;
  }
  
}
