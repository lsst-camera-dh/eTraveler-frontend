package eTraveler.getResults;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.HashMap;
import java.util.Set;

public class GetResultsUtil {

  //  Assumes Activity has alias A
  private static final String s_activityStatusJoins="join ActivityStatusHistory ASH on A.id=ASH.activityId join ActivityFinalStatus AFS on AFS.id=ASH.activityStatusId";

  private static final String s_activityStatusCondition=
    "AFS.name='success' and ASH.id in (select max(id) from ActivityStatusHistory group by activityId)";

  public static String getActivityStatusJoins() {return s_activityStatusJoins;}
  public static String getActivityStatusCondition() {return s_activityStatusCondition;}
  
  /**
     Argument should be string representation of either a valid
     positive integer or valid positive integer followed by one
     non-numeric character, such as "1234D"
     Return integer equivalent, ignoring final non-numeric character
     if there is one.
   */
  public static int formRunInt(String st) throws GetResultsException {
    int theInt;
    try {
      theInt = Integer.parseInt(st);
      } catch (NumberFormatException e) {
      try {
        theInt = Integer.parseInt(st.substring(0, st.length() -1));
      }  catch (NumberFormatException e2) {
        throw new GetResultsException("Supplied run value " + st +
                                        " is not valid");
      }
      if (theInt < 1) {
        throw new GetResultsException("Supplied run value " + st +
                                        " is not valid");
      }
    }
    return theInt;
  }

  /* This subquery is used to find possibly interesting traveler root ids */
  public static String hidSubquery(String hardwareType, String expSN,
                                   String model) {
    String subq = "select H2.id as hid2 from Hardware H2 join HardwareType HT on H2.hardwareTypeId=HT.id where HT.name='" + hardwareType + "'";
    if (expSN != null) {
      subq += " and H2.lsstId='" + expSN + "'";
    } else if (model != null) {
      subq += " and H2.model='" + model + "'";
    }
    return subq;
  }

  public static HashMap<Integer, Object>
    getRunMaps(Connection conn, String hardwareType, String expSN,
               String model, String travelerName) throws SQLException {
    String hidSub=GetResultsUtil.hidSubquery(hardwareType, expSN, model);

    String raiQuery = "select A.id as raid, H.id as hid, H.lsstId as expSN, runNumber,runInt,P.version,A.begin,A.end from Hardware H join Activity A on H.id=A.hardwareId join Process P on A.processId=P.id join RunNumber on A.rootActivityId=RunNumber.rootActivityId where H.id in (" + hidSub + ") and A.id=A.rootActivityId and P.name='" + travelerName + "' order by H.id asc, A.id desc";

    PreparedStatement stmt =
      conn.prepareStatement(raiQuery, ResultSet.TYPE_SCROLL_INSENSITIVE);

    ResultSet rs = stmt.executeQuery();
    boolean gotRow  = rs.first();

    boolean first = true;
    HashMap<Integer, Object> runMaps;
    if (gotRow) {
      runMaps = new HashMap<Integer, Object>();
    } else {
      stmt.close();
      return null;
    }
    while (gotRow)  {
      HashMap<String, Object> runMap = new HashMap<String, Object>();
      runMaps.put((Integer)rs.getInt("raid"), runMap);
      runMap.put("runNumber", rs.getString("runNumber"));
      runMap.put("runInt", rs.getInt("runInt"));
      runMap.put("rootActivityId", rs.getInt("raid"));
      runMap.put("travelerName", travelerName);
      runMap.put("travelerVersion", rs.getString("version"));
      runMap.put("hardwareType", hardwareType);
      runMap.put("experimentSN", rs.getString("expSN"));
      runMap.put("begin", rs.getString("begin"));
      String end = rs.getString("end");
      if (end == null) end = "";
      runMap.put("end", end);
      gotRow = rs.relative(1);
    }
    stmt.close();
    return runMaps;
  }
  public static String setToSqlList(Set<Integer> elts) {
    if (elts.isEmpty()) return "()";
    String toReturn = "(";
    for (Integer elt : elts) {
      toReturn += "'" + elt.toString() +"',";
    }
    //  Change the final comma to close-paren
    toReturn = toReturn.replaceAll(",$", ")");
    return toReturn;
  }
  /**
     Given stepName, collection of root activity ids for runs which may 
     include step so named, for each component find most recent
     successful activity (if any) with correct step name in one of the
     runs on that component.  Return as string which is of form
        "(act1, act2, .. )"
  */
  public static String latestGoodActivities(Connection conn, String stepName,
                                            Set<Integer> raids)
  throws SQLException {
    String raidList = setToSqlList(raids);
    String sql="select A.id as aid, A.hardwareId as hid from Activity A "
      + "join Process on Process.id=A.processId " + getActivityStatusJoins()
      + " where A.rootActivityId in " + raidList + " and "
      + getActivityStatusCondition() 
      + " and Process.name='" + stepName
      + "' order by hid asc, A.id desc";

    PreparedStatement stmt =
      conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs = stmt.executeQuery();
    boolean gotRow = rs.first();
    if (!gotRow) return null;
    String hid = "";
    String ret = "(";
    while (gotRow) {
      String newHid=rs.getString("hid");
      if (!newHid.equals(hid)) {
        if (!hid.equals("")) {
          ret += ",";
        }
        ret += rs.getString("aid");
        hid = newHid;
      }
      gotRow = rs.relative(1);
    }
    stmt.close();
    ret += ")";
    return ret;
  }
}
