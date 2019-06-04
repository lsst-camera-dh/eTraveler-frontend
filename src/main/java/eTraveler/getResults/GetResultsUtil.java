package eTraveler.getResults;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;
import java.util.ArrayList;

public class GetResultsUtil {

  //  Assumes Activity has alias A

  private static final String s_activityStatusJoins="join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId";

  private static final String s_activityStatusCondition=
    "AFS.name='success' "; 

  public static String getActivityStatusJoins() {return s_activityStatusJoins;}
  public static String getActivityStatusCondition() {return s_activityStatusCondition;}
  public static String getActivityStatusCondition(ArrayList<String> statuses) {
    if (statuses == null) return getActivityStatusCondition();
    String cond = " AFS.name in ";
    cond += arrayToSqlList(statuses);
    return cond;
  }
  
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

  /**
     getRunMaps is called from two types of routines:
      1. those wanting per run data, such as getResultsJH
      2. those (currently just one) wanting information about runs executed
        on a particular component (getComponentRuns)
      The argument byComponent is false in the first case, true in the second
     Returns: a dict where key is root activity id for the run. Value
     is a dict of quantities associated with the run.
        
   */
  public static HashMap<Integer, Object>
    getRunMaps(Connection conn, String hardwareType, String expSN,
               String model, String travelerName, boolean byComponent,
               ArrayList<String> runStatuses)
    throws SQLException, GetResultsException {
    String hidSub=GetResultsUtil.hidSubquery(hardwareType, expSN, model);

    String raiQuery;

    String runStatusCut = "";
    if (runStatuses != null) {
      runStatusCut = " and AFS.name in " +
        GetResultsUtil.arrayToSqlList(runStatuses);
    }
    
    if (!byComponent) {
      if (travelerName == null) {
        throw new GetResultsException("getRunMaps needs non-null traveler name");
      }
      raiQuery = "select A.id as raid, H.id as hid, H.lsstId as expSN, runNumber,runInt,RunNumber.id as runid,P.version,A.begin,A.end,AFS.name as runStatus from Hardware H join Activity A on H.id=A.hardwareId join Process P on A.processId=P.id join RunNumber on A.rootActivityId=RunNumber.rootActivityId join ActivityFinalStatus AFS on AFS.id=A.activityFinalStatusId where H.id in (" + hidSub + ") and A.id=A.rootActivityId and P.name='" + travelerName + "' ";
      raiQuery += runStatusCut + " order by H.id asc, A.id desc";
    } else {
      if (expSN == null) {
        throw new GetResultsException("getRunMaps needs non-null experimentSN when called by component");
      }
      raiQuery = "select A.id as raid, H.id as hid, H.lsstId as expSN, runNumber,runInt,RunNumber.id as runId,P.name as pname,P.version,A.begin,A.end,AFS.name as runStatus,Subsystem.name as subsystem from Hardware H join Activity A on H.id=A.hardwareId join Process P on A.processId=P.id join RunNumber on A.rootActivityId=RunNumber.rootActivityId join TravelerType on P.id=TravelerType.rootProcessId join Subsystem on Subsystem.id=TravelerType.subsystemId " + getActivityStatusJoins()
        + " where H.id in (" + hidSub + ") and A.id=A.rootActivityId ";
      if (travelerName != null) {
        raiQuery += " and P.name='" + travelerName + "' ";
      }
      raiQuery  += runStatusCut + " order by A.id asc";
    }
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
      if (!byComponent) {
        runMap.put("travelerName", travelerName);
        runMap.put("runStatus", rs.getString("runStatus"));
      } else {
        runMap.put("travelerName", rs.getString("pname"));
        runMap.put("subsystem", rs.getString("subsystem"));
        runMap.put("runStatus", rs.getString("runStatus"));
      }
      runMap.put("runId", rs.getInt("runId"));
      runMap.put("travelerVersion", rs.getInt("version"));
      runMap.put("hardwareType", hardwareType);
      runMap.put("experimentSN", rs.getString("expSN"));
      runMap.put("hardwareId", rs.getInt("hid"));
      runMap.put("begin", GetResultsUtil.timeISO(rs.getString("begin")));
      String end = rs.getString("end");
      if (end == null) end = "";
      runMap.put("end", GetResultsUtil.timeISO(end));
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
  public static String arrayToSqlList(ArrayList<String> elts) {
    if (elts.isEmpty()) return "()";
    String toReturn = "(";
    for (String elt : elts) {
      toReturn += "'" + elt + "',";
    }
    //  Change the final comma to close-paren
    toReturn = toReturn.replaceAll(",$", ")");
    return toReturn;
  }
  public static String stringSetToSqlList(Set<String> elts) {
    if (elts.isEmpty()) return "()";
    String toReturn = "(";
    for (String elt : elts) {
      toReturn += "'" + elt + "',";
    }
    //  Change the final comma to close-paren
    toReturn = toReturn.replaceAll(",$", ")");
    return toReturn;
  }

  /**
     Given stepName, collection of root activity ids for runs which may 
     include step so named, for each component find most recent
     acceptable activity (if any) with correct step name in one of the
     runs on that component.    If statuses arg. is null, "acceptable"
     means "success".  Otherwise any status in the supplied set is
     deemed acceptable.
     Return as string which is of form
        "(act1, act2, .. )"
  */
  public static String latestGoodActivities(Connection conn, String stepName,
                                            Set<Integer> raids,
                                            ArrayList<String> statuses)
  throws SQLException {
    String raidList = setToSqlList(raids);
    String sql="select A.id as aid, A.hardwareId as hid from Activity A "
      + "join Process on Process.id=A.processId " + getActivityStatusJoins()
      + " where A.rootActivityId in " + raidList + " and " 
      + getActivityStatusCondition(statuses) 
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

  /**
     Given run maps as created by GetResultsUtil.getRunMaps
     and set of labels of interest, for each hardware instance
     appearing in a run map, if it has any of the labels of
     interest add key "hardwareLabels" whose value is list
     of labels it has
     Returns set of hardware ids having at least one label
   */
  public static Set<Integer>
    addHardwareLabels(Connection conn, HashMap<Integer, Object> runMaps,
                      Set<String> labels) throws SQLException {
    Set<Integer> hids = new HashSet<Integer>();
    for (Integer raid : runMaps.keySet()) {
      HashMap<String, Object> runMap =
        (HashMap<String, Object>) runMaps.get(raid);
      hids.add((Integer) runMap.get("hardwareId"));
    }
    HashMap<Integer, Object> hidLabels =
      associateLabels(conn, labels, hids, "hardware");
    if (hidLabels == null) return null;

    for (Integer raid : runMaps.keySet()) {
      HashMap<String, Object> runMap =
        (HashMap<String, Object>) runMaps.get(raid);
      Integer hid = (Integer) runMap.get("hardwareId");
      if (hidLabels.keySet().contains(hid)) {
        runMap.put("hardwareLabels", hidLabels.get(hid));
      }
    }
    return hidLabels.keySet();
  }

  /**
     Given run maps as created by GetResultsUtil.getRunMaps
     and set of labels of interest, for each run
     appearing in a run map, if it has any of the labels of
     interest add key "runLabels" whose value is list
     of labels it has
     Returns set of runs (RunNumber.id) having at least one label
   */
  public static Set<Integer>
    addRunLabels(Connection conn, HashMap<Integer, Object> runMaps,
                 Set<String> labels) throws SQLException {
    Set<Integer> runIds = new HashSet<Integer>();
    for (Integer raid : runMaps.keySet()) {
      HashMap<String, Object> runMap =
        (HashMap<String, Object>) runMaps.get(raid);
      runIds.add((Integer) runMap.get("runId"));
    }
    HashMap<Integer, Object> runLabels =
      associateLabels(conn, labels, runIds, "run");
    if (runLabels == null) return null;

    for (Integer raid : runMaps.keySet()) {
      HashMap<String, Object> runMap =
        (HashMap<String, Object>) runMaps.get(raid);
      
      Integer runId = (Integer) runMap.get("runId");
      if (runLabels.keySet().contains(runId)) {
        runMap.put("runLabels", runLabels.get(runId));
      }
    }
    return runLabels.keySet();
  }
  
  // Maybe be more explicit with return type.  It's really going to
  // be a list or set of strings
  public static HashMap<Integer, Object>
    associateLabels(Connection conn, Set<String> labels,
                    Set<Integer> objectIds, String labelableType)
  throws SQLException {
    PreparedStatement stmt;
    ResultSet rs;
    boolean gotRow;
    
    HashMap<Integer, String> labelIds =
      expandLabels(conn, labels, labelableType);

    String assocQ = "select labelId,objectId from "
      +"LabelCurrent LC join Labelable on LC.labelableId=Labelable.id where "
      + "labelId in " + setToSqlList(labelIds.keySet())
      + " and objectId in " + setToSqlList(objectIds)
      + " and Labelable.name='" + labelableType + "'";

    stmt = conn.prepareStatement(assocQ, ResultSet.TYPE_SCROLL_INSENSITIVE);
    rs = stmt.executeQuery();
    gotRow=rs.first();
    if (!gotRow) {
      stmt.close();
      return null;
    }
    HashMap<Integer, Object> idToLabels = new HashMap<Integer, Object>();    
    while (gotRow) {
        ArrayList<String> labelList = null;
      Integer oid = rs.getInt("objectId");
      Integer lid = rs.getInt("labelId");
      if (!idToLabels.containsKey(oid)) {
        labelList = new ArrayList<String>();
        idToLabels.put(oid, labelList);
      } else {
        labelList = (ArrayList<String>) idToLabels.get(oid);
      }
      labelList.add(labelIds.get(lid));
      gotRow = rs.relative(1);
    }
    stmt.close();
    return idToLabels;
  }

  public static HashMap<Integer, String>
    expandLabels(Connection conn, Set<String> labels, String labelableType)
  throws SQLException {
    // If any of the label strings is of the form 'groupName:'
    //    expand into set of fullnames with that groupname 
    Set<String> expandedLabels = new HashSet<String>();
    Set<String> groups  = new HashSet<String>();
    PreparedStatement stmt;
    ResultSet rs;
    boolean gotRow;
    for (String lbl : labels) {
      String cmps[] = lbl.split(":");
      if (cmps.length == 2 ) {
        expandedLabels.add(lbl);
      } else {
        groups.add(cmps[0]);
      }
    }
    if (groups.size() > 0) {
      String expandQ =
        "select concat(LabelGroup.name,':',Label.name) as fullname from "
        + "LabelGroup join Label on LabelGroup.id=Label.labelGroupId "
        + "join Labelable on LabelGroup.labelableId=Labelable.id "
        + "where Labelable.name='" + labelableType +"' and LabelGroup.name"
        //+ "='" + g
        + " in " + GetResultsUtil.stringSetToSqlList(groups);
      stmt=conn.prepareStatement(expandQ,ResultSet.TYPE_SCROLL_INSENSITIVE);
      try {
        rs = stmt.executeQuery();
      } catch (SQLException se) {
        throw new SQLException(se.getMessage() + " from query \n" + expandQ);
      }
      gotRow = rs.first();
      while (gotRow) {
        expandedLabels.add(rs.getString("fullname"));
        gotRow = rs.relative(1);
      }
      stmt.close();
    }
    String labelCondition = " in " + stringSetToSqlList(expandedLabels);
    String labelIdQ =
      "select Label.id as lid,concat(LG.name,':',Label.name) as "
      + "fullname from Label join LabelGroup LG on LG.id=Label.labelGroupId "
      + "where concat(LG.name,':',Label.name) " + labelCondition;
    stmt =
      conn.prepareStatement(labelIdQ, ResultSet.TYPE_SCROLL_INSENSITIVE);
    try {
      rs = stmt.executeQuery();
    } catch (SQLException sel) {
      throw new SQLException(sel.getMessage() + " from query \n" + labelIdQ);
    }
    gotRow=rs.first();
    if (!gotRow) {
      stmt.close();
      return null;
    }
    HashMap<Integer, String> labelIds = new HashMap<Integer,String>();
    while (gotRow) {
      labelIds.put(rs.getInt("lid"), rs.getString("fullname"));
      gotRow = rs.relative(1);
    }
    stmt.close();
    return labelIds;
  }
  
  public static Object findOrAddStep(HashMap<String, Object> stepMap,
                                     String stepName) {
    if (stepMap.containsKey(stepName)) return stepMap.get(stepName);
    HashMap<String, Object> newStep = new HashMap<String, Object>();
    stepMap.put(stepName, newStep);
    return newStep;
  }

  
  /* Substitute T for the blank between date and time */
  static public String timeISO(String sqlDatetime)
  throws GetResultsException {
    if (sqlDatetime == null) {
      return "";
    }
    if (sqlDatetime.length() > 10) {
      if (sqlDatetime.charAt(10) == ' ') return sqlDatetime.replace(' ', 'T');
    }
    return sqlDatetime;
  }
}
