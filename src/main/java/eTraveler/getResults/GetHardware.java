package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;
import java.util.Collections;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.Comparator;

import eTraveler.getResults.ComparableNCR;

/**
   Returns information about hardware instances of specified type
 */
public class GetHardware {
  private Connection m_connect=null;


  private ArrayList<HashMap<String, Object>> m_hlist=null;
  
  public GetHardware(Connection conn) {
    m_connect = conn;
  }
  
  /**
     Primarily or exclusively for use internal to package
   */
  ArrayList< HashMap<String, Object>>
    getHardwareInstances(String htype, String expSN, String model,
                         Set<String> hardwareLabels)
    throws SQLException, GetResultsException {

    // If hardwareLabels not null
    //   Get set of all hardware id's under consideration
    //   Invoke GetResultsUtil.associateLabels
    String getHidsQ = "select H.id as hid from Hardware H "
      + "join HardwareType HT on H.hardwareTypeId = HT.id "
      + "where HT.name='" + htype + "' ";
    if (expSN != null) {
      getHidsQ += "and H.lsstId='" + expSN + "' ";
    } else {
      if (model != null) {
        getHidsQ += "and H.model='" + model + "' ";
      }
    }
    PreparedStatement stmt =
      m_connect.prepareStatement(getHidsQ, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs=stmt.executeQuery();
    boolean gotRow = rs.first();
    if (!gotRow) {
      String msg="No information for hardware type " + htype;
      if (expSN != null) {
        msg += " and experimentSN=" + expSN;
      } else if (model != null) {
        msg += " and model=" + model;
      }
      throw new GetResultsNoDataException(msg);
    }
    Set<Integer> hidSet = new HashSet<Integer>();    
    while (gotRow) {
      hidSet.add(rs.getInt("hid"));
      gotRow = rs.relative(1);
    }
    stmt.close();
    HashMap<Integer, Object> hidToLabels=null;
    if (hardwareLabels !=null) {
      hidToLabels =
        GetResultsUtil.associateLabels(m_connect, hardwareLabels,
                                       hidSet, "hardware");
      if (hidToLabels == null) {
        String msg="No relevant components with specified labels";
        throw new GetResultsNoDataException(msg);
      }
      hidSet = hidToLabels.keySet();
    }
    String sql="select H.id as hid,lsstId,  "
      + "remarks, model, manufacturer,manufacturerId, "
      + "HS.name as status, concat(Site.name,':', Location.name) as loc "
      + "from Hardware H "
      + "join HardwareStatus HS on HS.id=H.hardwareStatusId "
      + "join Location on H.locationId = Location.id "
      + "join Site on Site.id=Location.siteId "
      + " where H.id in " + GetResultsUtil.setToSqlList(hidSet) 
      + " order by hid";

    stmt =
      m_connect.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
    rs=stmt.executeQuery();
    gotRow = rs.first();
    if (!gotRow) {
      String msg="No information for hardware type " + htype;
      if (expSN != null) {
        msg += " and experimentSN=" + expSN;
      }
      stmt.close();
      throw new GetResultsNoDataException(msg);
    }
    m_hlist=new ArrayList<HashMap<String, Object> >();
    while (gotRow) {
      HashMap<String, Object> instance = new HashMap<String, Object>();
      instance.put("experimentSN", rs.getString("lsstId"));
      instance.put("model",rs.getString("model"));
      instance.put("manufacturer",rs.getString("manufacturer"));
      instance.put("manufacturerId",rs.getString("manufacturerId"));
      instance.put("remarks",rs.getString("remarks"));
      instance.put("status", rs.getString("status"));
      instance.put("location", rs.getString("loc"));
      if (hardwareLabels != null) {
        instance.put("hardwareLabels", hidToLabels.get(rs.getInt("hid")));
      }
      m_hlist.add(instance);
      gotRow = rs.relative(1);
    }
    stmt.close();
    return m_hlist;

  }
  /**
     Return quantities pertaining to NCRs associated with one or more
     components.  Exactly which components are determined by value of
     items arg.
        "this"   - specified component only
        "containedIn" - this and all assemblies it's contained in
        "children" - this and all subcomponents (if this is an assembly)
   */
  public ArrayList<ComparableNCR>
    getNCRs(String htype, String expSN, String items, Set<String> ncrLabels)
    throws SQLException, GetResultsException {
    // Check that items has a recognized value
    if (items == null) items = "this";
    if (!items.equals("this") && !items.equals("ancestors")) {
      String msg="getNCRs: unrecognized items argument: " + items;
      throw new GetResultsException(msg);
    }
    String qId="select H.id as hid from Hardware H join HardwareType HT on ";
    qId += "H.hardwareTypeId=HT.id where HT.name='" + htype;
    qId +=  "' and H.lsstId='" + expSN + "'";
    String thisId=null;
    try (PreparedStatement stmt =
         m_connect.prepareStatement(qId, ResultSet.TYPE_SCROLL_INSENSITIVE) ) {
      ResultSet rs=stmt.executeQuery();
      if (!rs.first()) {
        String msg="getNCRs: no such component";
        throw new GetResultsNoDataException(msg);
      }
      thisId=rs.getString("hid");
    }
    // Get collection of hardware of interest, in particular hids.
    Map<String, Integer> hidsMap = new HashMap<>();

    hidsMap.put(thisId, 0);
    if  (items.equals("ancestors") ) {
      String next=thisId;
      int level=0;
      while (next != null) {
        level++;
        next = getParent(next, level, hidsMap);
      }
    }
    // Find all NCRs belonging to these hids
    return getNCRs(hidsMap, ncrLabels);
  }

  private String getParent(String childHid, int parentLevel,
                           Map<String, Integer> hidsMap)
    throws SQLException, GetResultsException {
    String q="select MRS.hardwareId as pId, MRA.name as action from ";
    q += "MultiRelationshipHistory MRH ";
    q+= "join MultiRelationshipSlot MRS on MRH.multirelationshipSlotId=MRS.id ";
    q += "join MultiRelationshipAction MRA on MRH.multiRelationshipActionId=MRA.id ";
    q += " where MRH.minorId='" + childHid + "' order by MRH.id desc limit 1";
    try (PreparedStatement stmt =
         m_connect.prepareStatement(q, ResultSet.TYPE_SCROLL_INSENSITIVE) ) {
      ResultSet rs=stmt.executeQuery();
      boolean gotRow = rs.first();
      if (!gotRow) return null;
      String action=rs.getString("action");
      String pId = rs.getString("pId");
      if (!action.equals("install")) return null;
      hidsMap.put(pId, parentLevel);
      return pId;
    }
  }

  private ArrayList<ComparableNCR>
    getNCRs(Map<String, Integer> hidsMap, Set<String> ncrLabels)
    throws SQLException, GetResultsException {
    ArrayList<ComparableNCR> ncrInfo = new ArrayList<ComparableNCR>();

    Set<String> hidsSet = hidsMap.keySet();
    // Generic Prepared statement.  Substitute in hid 
    String ncrQ = "select E.NCRActivityId as NCRnumber,";
    ncrQ +="H.lsstId as experimentSN,HT.name as hardwareType,";
    ncrQ+="RN.runNumber as runNumber,P.name as NCRname,AFS.name as NCRstatus,AFS.isFinal as done,E.id as exceptionId from Exception E ";
    ncrQ += "join Activity A on E.exitActivityId=A.id ";
    ncrQ +="join RunNumber RN on A.rootActivityId=RN.rootActivityId ";
    ncrQ +="join Hardware H on H.id=A.hardwareId ";
    ncrQ +="join HardwareType HT on HT.id=H.hardwareTypeId ";
    ncrQ +="join Activity A2 on A2.id=E.NCRActivityId ";
    ncrQ +="join Process P on P.id=A2.processId ";
    ncrQ +="join ActivityFinalStatus AFS on A2.activityFinalStatusId=AFS.id ";
    ncrQ +="where H.id=?";
    try (PreparedStatement stmt=
         m_connect.prepareStatement(ncrQ,ResultSet.TYPE_SCROLL_INSENSITIVE)) {
      for (String hid : hidsSet) {
        stmt.setString(1, hid);
        ResultSet rs=stmt.executeQuery();
        boolean gotRow=rs.first();
        while (gotRow) {
          //HashMap<String, Object> ncrMap = new HashMap<>();
          ComparableNCR ncrMap = new ComparableNCR();
          // store stuff, including level in hierarchy = hidsMap.get(hid)
          ncrMap.put("level", (Integer) hidsMap.get(hid));
          ncrMap.put("experimentSN", rs.getString("experimentSN"));
          ncrMap.put("hardwareType", rs.getString("hardwareType"));
          ncrMap.put("hardwareId", hid);
          ncrMap.put("NCRnumber", (Integer) rs.getInt("NCRnumber"));
          ncrMap.put("runNumber", rs.getString("runNumber"));
          ncrMap.put("NCRname", rs.getString("NCRname")); 
          ncrMap.put("NCRstatus", rs.getString("NCRstatus"));
          ncrMap.put("done", (Integer) rs.getInt("done"));
          ncrMap.put("exceptionId", (Integer) rs.getInt("exceptionId"));
          ncrInfo.add(ncrMap);
          gotRow=rs.relative(1);
        }
      }
    }
    if (ncrInfo.isEmpty()) {
      throw new GetResultsNoDataException("No NCRs found");
    }
    // Sort by comparing in order level, hardware type, experimentSN, NCRnumber

    for (ComparableNCR c : ncrInfo) {
      if (!c.verify()) {
        throw new GetResultsException("Incomplete ncr info");
      }
    }
    Collections.sort(ncrInfo);
    for (ComparableNCR c : ncrInfo)  {
      getNCRcurrentStep(c);
      if (ncrLabels != null) getNCRlabels(c, ncrLabels);
    }
    return ncrInfo;
  }
  private void getNCRcurrentStep(ComparableNCR c)
    throws SQLException, GetResultsException  {
    if ((Integer) c.get("done") == 1) {
      c.put("currentStep", "N/A");
      return;
    }
    String qCur="select A.id as aid,P.name as pname,AFS.name as status,AFS.isFinal as done from Activity A join ActivityFinalStatus AFS on A.activityFinalStatusId=AFS.id join Process P on P.id=A.processId where rootActivityId='";
    qCur += c.get("NCRnumber");
    qCur += "' order by A.id desc";

    // We're in most recently-started step which is not done
    try (PreparedStatement stmt=
         m_connect.prepareStatement(qCur,ResultSet.TYPE_SCROLL_INSENSITIVE)) {
      ResultSet rs=stmt.executeQuery();
      boolean gotRow=rs.first();
      while (gotRow) {
        int done=rs.getInt("done");
        if (done==0) {
          c.put("currentStep", rs.getString("pname"));
          return;
        }
        gotRow=rs.relative(1);
      }
    }
  }
  private void getNCRlabels(ComparableNCR c, Set<String> ncrLabels)
    throws SQLException, GetResultsException  {

    String qLbl="select LH.objectId,concat(LG.name, ':',L.name) as fullname from LabelGroup LG join Label L on LG.id=L.labelGroupId join LabelHistory LH on LH.labelId=L.id join Labelable on Labelable.id=LG.labelableId where ";
    qLbl += "(objectId='" + c.get("exceptionId").toString() + "') and ";
    qLbl += "(Labelable.name='NCR') and LG.name in ";
    qLbl += GetResultsUtil.stringSetToSqlList(ncrLabels);
    qLbl += " and LH.id in (select max(LH2.id) from Labelable LBL join LabelHistory LH2 on LBL.id=LH2.labelableId where LBL.name='NCR' group by LH2.objectId,LH2.labelId) and adding=1";
    // If we do this for all NCRs at once probably add
    //  " order by LH.objectId "  at the end
    try (PreparedStatement stmt=
         m_connect.prepareStatement(qLbl,ResultSet.TYPE_SCROLL_INSENSITIVE)) {
      ResultSet rs=stmt.executeQuery();
      boolean gotRow=rs.first();
      ArrayList<String> labels = new ArrayList<String> ();
      while (gotRow) {
        labels.add(rs.getString("fullname"));
        gotRow=rs.relative(1);
      }
      c.put("ncrLabels", labels);
    }
  }
}
