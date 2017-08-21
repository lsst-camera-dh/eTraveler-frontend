package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import org.apache.commons.lang3.StringUtils;

//import org.lsst.camera.etraveler.backend.db.DbConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class GetActivityInfo {
  private Connection m_connect=null;
  private ArrayList<HashMap<String, Object>> m_info=null;
  private static String s_queryInitial =
    "select A.id,A.begin,A.end, P.name,AFS.name from Activity A join Process P on A.processId=P.id join ActivityStatusHistory ASH on ASH.activityId=A.id join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId where A.id";
  
  public GetActivityInfo(Connection conn) {
    m_connect=conn;
  }

  HashMap<String, Object>  getActivity(String activityId) 
    throws GetResultsException, SQLException  {
    HashMap<String, Object> info = new HashMap<String, Object>();

    String q=s_queryInitial + "=" + activityId +
      " order by ASH.id desc limit 1";

    PreparedStatement stmt =
      m_connect.prepareStatement(q, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs = stmt.executeQuery();
    boolean gotRow=rs.first();
    if (!gotRow) {
      throw new GetResultsNoDataException("No data found for activity " +
                                          activityId);
    }
    storeActivityRow(info, rs);
             
    return info;
  }
  ArrayList<HashMap<String, Object>> getRunActivities(String runNumber)
      throws GetResultsException, SQLException {
    ArrayList<HashMap<String, Object>> infoList =
      new ArrayList<HashMap<String, Object>>();
    int runInt = GetResultsUtil.formRunInt(runNumber);

    String subquery="(select A2.id from Activity A2 join RunNumber RN on A2.rootActivityId=RN.rootActivityId where '";
    subquery += runInt + "'=RN.runInt)";
    String q=s_queryInitial+" in "+subquery+ " order by A.id asc, ASH.id desc";

    PreparedStatement stmt =
      m_connect.prepareStatement(q, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs = stmt.executeQuery();
    boolean gotRow=rs.first();
    if (!gotRow) {
      throw new GetResultsNoDataException("No data found for run " + runNumber);
    }
    int oldActivity;
    while (gotRow) {
      HashMap<String, Object> info = new HashMap<String, Object>();
      oldActivity = rs.getInt("A.id");
      
      storeActivityRow(info, rs);
      infoList.add(info);
      gotRow = rs.relative(1);
      if (!gotRow) return infoList;
      // Ignore all but first row with a certain activity id
      while (oldActivity == rs.getInt("A.id")) {
        gotRow = rs.relative(1);
        if (!gotRow) return infoList;
      }
    }
    return infoList; // Keep compiler happy. We never actually get here
  }
  static private void storeActivityRow(HashMap<String, Object> info,
                                       ResultSet rs)
    throws SQLException, GetResultsException { 
    info.put("activityId", rs.getInt("A.id"));
    info.put("stepName", rs.getString("P.name"));
    info.put("status", rs.getString("AFS.name"));
    info.put("begin", GetResultsUtil.timeISO(rs.getString("A.begin")));
    info.put("end", GetResultsUtil.timeISO(rs.getString("A.end")));
  }
  /* Process good results row */
}
