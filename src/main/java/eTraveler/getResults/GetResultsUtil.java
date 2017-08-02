package eTraveler.getResults;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.HashMap;
import java.util.Set;
import java.util.concurrent.ConcurrentSkipListSet;
import java.util.ArrayList;

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
      runMap.put("hardwareId", rs.getInt("hid"));
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
    Set<Integer> hids = new ConcurrentSkipListSet<Integer>();
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

  // Maybe be more explicit with return type.  It's really going to
  // be a list or set of strings
  public static HashMap<Integer, Object>
    associateLabels(Connection conn, Set<String> labels,
                    Set<Integer> objectIds, String labelableType)
  throws SQLException {
    String labelCondition = " in " + stringSetToSqlList(labels);

    // If any of the label strings is of the form 'groupName:', could
    // either
    //    expand into set of fullnames with that groupname or
    //    change the way we do the query to remove condition on label name
    String labelIdQ =
      "select Label.id as lid,concat(LG.name,':',Label.name) as "
      + "fullname from Label join LabelGroup LG on LG.id=Label.labelGroupId "
      + "where concat(LG.name,':',Label.name) " + labelCondition;
    PreparedStatement stmt =
      conn.prepareStatement(labelIdQ, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs = stmt.executeQuery();
    boolean gotRow=rs.first();
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
    String assocQ = "select labelId,objectId from "
      +"LabelHistory LH join Labelable on LH.labelableId=Labelable.id where "
      + "labelId in " + setToSqlList(labelIds.keySet())
      + " and objectId in " + setToSqlList(objectIds)
      + " and Labelable.name='" + labelableType
      + "' and LH.id in "
      + "(select max(id) from LabelHistory LH2 group by LH2.objectId, "
      + "LH2.labelId) and adding=1";
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
  /*
select id, labelId,objectId,adding from LabelHistory where labelId in(select Label.id from Label join LabelGroup LG on LG.id=Label.labelGroupId where concat(LG.name,":",Label.name) in ("SnarkRandom:green","SnarkRandom:fuzzy") ) and objectId in (5,24,66) and id in (select max(id) from LabelHistory  LH2 group by LH2.objectId,LH2.labelId) and adding=1;

Maybe better to find label id's associated with names in a separate query:

mysql> select Label.id,concat(LabelGroup.name,":",Label.name) as fullname from Label join LabelGroup on LabelGroup.id=Label.labelGroupId where concat(LabelGroup.name,":",Label.name)  in ("SnarkRandom:green", "SnarkRandom:fuzzy");
+----+-------------------+
| id | fullname          |
+----+-------------------+
| 16 | SnarkRandom:fuzzy |
| 15 | SnarkRandom:green |
+----+-------------------+

Then

mysql> select labelId,objectId from LabelHistory where labelId in (15,16) and objectId in (5,24,66) and id in (select max(id) from LabelHistory LH2 group by LH2.objectId,LH2.labelId) and adding=1;
+---------+----------+
| labelId | objectId |
+---------+----------+
|      15 |        5 |
|      16 |        5 |
|      15 |       24 |
+---------+----------+

Then only use runs in runmap on one of the hardware components with id=objectId
in table above.  And, for those runs, add list of label names to summary info
for the run.

     */
  
}