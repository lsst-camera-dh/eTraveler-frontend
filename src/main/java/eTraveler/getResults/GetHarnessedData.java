package eTraveler.getResults;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Set;
import org.apache.commons.lang3.tuple.ImmutablePair;
import org.apache.commons.lang3.tuple.Pair;
import org.apache.commons.lang3.StringUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ParameterMetaData;
import java.sql.SQLException;

/*
   For now client must get a db connection and pass in
 */
public class GetHarnessedData {
  private Connection m_connect=null;
  private String m_hardwareType=null;
  private String m_travelerName=null;
  private String m_schemaName=null;
  private String m_model=null;
  private String m_expSN=null;
  private int m_run=0;
  private int m_oneRai;
  private int m_oneHid;
  private String m_stepName=null;
  private ImmutablePair<String, Object> m_filter=null;

  private HashMap<Integer, Object> m_runMaps;
  // each Object value is itself a HashMap<String, Object>
  
  private HashMap<String, Object> m_results=null;

  //private HashMap<String, ArrayList<HashMap<String, Object> > >
  private HashMap<String, Object>     m_fileResults=null;

  private static final int DT_ABSENT = -2, DT_UNKNOWN = -1,
    DT_FLOAT = 0, DT_INT = 1, DT_STRING = 2;

  public GetHarnessedData(Connection conn) {
    m_connect=conn;
  }
  
  public void setConnection(Connection conn) {
    m_connect = conn;
  }
  /**
     travelerName must be non-null
     hardwareType must be non-null
     schemaName must be non-null to start; might loosen this requirements
     model, experimentSN are used for filtering if non-null
     Return data is map of maps (one for each component)
   */
  public Map<String, Object>
    getResultsJH(String travelerName, String hardwareType, String stepName,
                 String schemaName,
                 String model, String experimentSN,
                 Pair<String, Object> filter, Set<String> hardwareLabels)
    throws GetResultsException, SQLException {
    if (m_connect == null)
      throw new GetResultsException("Set connection before attempting to fetch data");
    checkNull(travelerName, "travelerName argument must be non-null");
    checkNull(hardwareType, "hardwareType argument must be non-null");
    checkNull(stepName, "stepName argument must be non-null");

    clearCache();
    m_travelerName = travelerName;
    m_hardwareType = hardwareType;
    m_schemaName=schemaName;
    m_stepName=stepName;
    m_model = model;
    m_expSN = experimentSN;
    if (filter != null) {
      m_filter = new
        ImmutablePair<String, Object> (filter.getLeft(), filter.getRight());
    }

    m_runMaps =
      GetResultsUtil.getRunMaps(m_connect, hardwareType, experimentSN,
                                model, travelerName, false);
    if (m_runMaps == null) {
      throw new GetResultsNoDataException("No data found");
    }

    Set<Integer> hidSet = null;
    if (hardwareLabels != null) {
      hidSet = GetResultsUtil.addHardwareLabels(m_connect, m_runMaps,
                                                hardwareLabels);
      if (hidSet == null) {
        throw new GetResultsNoDataException("No data found");
      }
    }
                                         
    // Find good activities in the runs of interest
    String goodActivities =
      GetResultsUtil.latestGoodActivities(m_connect, m_stepName,
                                          m_runMaps.keySet());

    // There are 6 replacements to be made.  All of them are results table
    // name (e.g. "FloatResultHarnessed")
    String sqlString=
      "select ?.schemaName as schname,?.name as resname,?.value as resvalue,?.schemaInstance as ressI,A.id as aid,A.rootActivityId as raid, A.hardwareId as hid,A.processId as pid,Process.name as pname"
      + " from  ? join Activity A on ?.activityId=A.id " 
      + " join Process on Process.id=A.processId "
      + " where A.id in " + goodActivities 
      + " and Process.name='" + m_stepName + "'";
    if (hidSet != null) {
      sqlString += " and A.hardwareId in " +GetResultsUtil.setToSqlList(hidSet);
    }
    if (m_schemaName != null) {
      sqlString += " and ?.schemaName='" + m_schemaName + "'";
    }
    sqlString +=  " order by A.hardwareId asc, A.rootActivityId desc, A.processId asc, schname,A.id desc, ressI asc, resname";

    m_results = new HashMap<String, Object>();
    executeGenQuery(sqlString, "FloatResultHarnessed", DT_FLOAT);
    executeGenQuery(sqlString, "IntResultHarnessed", DT_INT);
    executeGenQuery(sqlString, "StringResultHarnessed", DT_STRING);

    
    if (filter != null)  {
      for (Object expObject : m_results.values()) {
        HashMap<String, Object> expMap = (HashMap<String, Object>) expObject;
        HashMap<String, Object> steps =
          (HashMap<String, Object> ) expMap.get("steps");
        for (String pname : steps.keySet()) {
          HashMap<String, Object> step = (HashMap<String, Object>)
            steps.get(pname);
          pruneStep(step, filter);
        }
      }
    }
    return m_results;
  }

  public Map<String, Object>
    getRunResults(String run, String stepName,
                  String schemaName, Pair<String, Object> filter)
    throws GetResultsException, SQLException {

    int runInt = GetResultsUtil.formRunInt(run);
    return getRunResults(runInt, stepName, schemaName, filter);
  }


  public Map<String, Object>
    getRunResults(int runInt, String stepName, String schemaName,
                  Pair<String, Object> filter)
    throws GetResultsException, SQLException {
    if (m_connect == null)
      throw new GetResultsException("Set connection before attempting to fetch data");
        //checkNull(schemaName, "schemaName argument must be non-null");
    clearCache();

    m_schemaName = schemaName;
    m_stepName = stepName;
    m_run = runInt;

    return getRunResults(filter);
  }

  /**
     For the given run return lists of virtual paths for all files registered in 
     Data Catalog, sorted by process step
   */
  public Map<String, Object>     getRunFilepaths(String run, String stepName)
    throws GetResultsException, SQLException {
    int runInt = GetResultsUtil.formRunInt(run);
    return getRunFilepaths(runInt, stepName);
  }

  public Map<String, Object>
    getRunFilepaths(int run, String stepName)
    throws GetResultsException, SQLException {
    clearCache();
    m_run = run;
    m_stepName = stepName;
    // Really m_results will be
    //    HashMap<String, ArrayList< HashMap<String, Object> > >();
    m_fileResults = new HashMap<String, Object>();


    String sql =
      "select F.virtualPath as vp,basename,catalogKey,schemaInstance,A.id as aid,P.name as pname,P.id as pid,A.id as aid from FilepathResultHarnessed F join Activity A on F.activityId=A.id "
      + GetResultsUtil.getActivityStatusJoins() +
      " join Process P on P.id=A.processId join RunNumber on A.rootActivityId=RunNumber.rootActivityId where RunNumber.runInt='"
      + m_run + "' and " + GetResultsUtil.getActivityStatusCondition(); 
    if (m_stepName != null) {
      sql += " and P.name='" + m_stepName  + "' ";
    }
    sql += " order by P.id,A.id desc,basename,F.virtualPath";
    PreparedStatement stmt = m_connect.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs = stmt.executeQuery();
    boolean gotRow=rs.first();
    if (!gotRow) {
      throw new GetResultsNoDataException("No files generated by run " + m_run);
    }
    //storePaths(rs);
    storeRunPaths(m_fileResults, rs, 0);
    return m_fileResults;
  }

  public Map<String, Object>
    getFilepathsJH(String travelerName, String hardwareType, String stepName,
                   String model, String experimentSN,Set<String> hardwareLabels)
    throws GetResultsException, SQLException {
    if (m_connect == null)
      throw new GetResultsException("Set connection before attempting to fetch data");
    checkNull(travelerName, "travelerName argument must be non-null");
    checkNull(hardwareType, "hardwareType argument must be non-null");
    checkNull(stepName, "stepName argument must be non-null");

    clearCache();
    m_travelerName = travelerName;
    m_hardwareType = hardwareType;
    m_model = model;
    m_expSN = experimentSN;
    m_stepName = stepName;
    HashMap<String, Object> steps = null;

    m_runMaps =
      GetResultsUtil.getRunMaps(m_connect, hardwareType, experimentSN,
                                model, travelerName, false);
                                         
    if (m_runMaps == null) {
      throw new GetResultsNoDataException("No data found");
    }
    Set<Integer> hidSet = null;

    if (hardwareLabels != null) {
      hidSet = GetResultsUtil.addHardwareLabels(m_connect, m_runMaps,
                                                hardwareLabels);
      if (hidSet == null) {
        throw new GetResultsNoDataException("No data found");
      }
    }
    
    // Find good activities in the runs of interest
    String goodActivities =
      GetResultsUtil.latestGoodActivities(m_connect, m_stepName,
                                          m_runMaps.keySet());

    String sql =
      "select F.virtualPath as vp,basename,catalogKey,schemaInstance,A.id as aid,A.rootActivityId as raid, A.hardwareId as hid,P.name as pname,P.id as pid from FilepathResultHarnessed F join Activity A on F.activityId=A.id "
      + " join Process P on P.id=A.processId where A.id in " + goodActivities;
      sql += " and P.name='" + m_stepName  + "' ";
    if (hidSet != null) {
      sql += " and A.hardwareId in " +GetResultsUtil.setToSqlList(hidSet);
    }

    sql += " order by A.hardwareId asc,P.id asc ,A.id desc, F.basename, F.virtualPath";
    m_fileResults = new HashMap<String, Object>();

    PreparedStatement stmt = m_connect.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs = stmt.executeQuery();
    boolean gotRow=rs.first();
    HashMap<String, Object> expMap = null;

    if (!gotRow) {
      stmt.close();
      throw new
        GetResultsNoDataException("No data found");
    }
    while (gotRow) {
      HashMap<String, Object> ourRunMap =
        (HashMap<String, Object>) m_runMaps.get(rs.getInt("raid"));
      String expSN = (String) ourRunMap.get("experimentSN");
      if (m_fileResults.containsKey(expSN) ) {
        expMap = (HashMap<String, Object>) m_fileResults.get(expSN);
        steps = (HashMap<String, Object>) expMap.get("steps");
      } else  {
        expMap = new HashMap<String, Object>(ourRunMap);
        m_fileResults.put(expSN, expMap);

        steps = new HashMap<String, Object>();
        expMap.put("steps", steps);
      }
      gotRow = storeRunPaths(steps, rs, rs.getInt("hid"));
    }
    stmt.close();
    return m_fileResults;
  }    
  
  /**
     Does most of the work after public routines handle other arguments
     and appropriately set m_schemaName, m_stepName and m_run
   */
  private Map<String, Object>
    getRunResults(Pair<String, Object> filter)
    throws GetResultsException, SQLException {

    if (filter != null) {
      m_filter = new
        ImmutablePair<String, Object> (filter.getLeft(), filter.getRight());
    }

    getRunParameters();
    m_results = new HashMap<String, Object>();
    m_results.put("run", m_run);
    m_results.put("experimentSN", m_expSN);
    m_results.put("hid", m_oneHid);
    HashMap<String, Object> stepMap = new HashMap<String, Object>();
    m_results.put("steps", stepMap);

    String sql =
     "select ?.schemaName as schname,?.name as resname,?.value as resvalue,?.schemaInstance as ressI,A.id as aid,A.processId as pid,Process.name as pname,ASH.activityStatusId as actStatus from ? join Activity A on ?.activityId=A.id "
      + GetResultsUtil.getActivityStatusJoins() +
      " join Process on Process.id=A.processId where ";
    if (m_schemaName != null) {
      sql += "?.schemaName='" + m_schemaName +"' and ";
    }
    if (m_stepName != null) {
      sql += "Process.name='" + m_stepName +"' and ";
    }
    sql += " A.rootActivityId='" + m_oneRai + "' and " +
      GetResultsUtil.getActivityStatusCondition() +
      " order by A.processId asc,schname, A.id desc, ressI asc, resname";

    executeGenRunQuery(sql, "FloatResultHarnessed", DT_FLOAT);
    executeGenRunQuery(sql, "IntResultHarnessed", DT_INT);
    executeGenRunQuery(sql, "StringResultHarnessed", DT_STRING);

    if (filter != null) {
      for (String pname : stepMap.keySet()) {
        HashMap<String, Object> step = (HashMap<String, Object>)
          stepMap.get(pname);
        pruneStep(step, filter);
      }
    }
    return m_results;
  }    
  
  /* This subquery is used to find possibly interesting traveler root ids */
  /*              Use utility in GetResultsUtil instead.
  private String hidSubquery() {
    String subq = "select H2.id as hid2 from Hardware H2 join HardwareType HT on H2.hardwareTypeId=HT.id where HT.name='" + m_hardwareType + "'";
    if (m_expSN != null) {
      subq += " and H2.lsstId='" + m_expSN + "'";
    } else if (m_model != null) {
      subq += " and H2.model='" + m_model + "'";
    }
    return subq;
  }
  */

  /**
     Find per-run parameters when we already have a run
  */
  private void getRunParameters() throws SQLException,GetResultsException {
    String sql= "select RunNumber.rootActivityId as rai, Activity.hardwareId as hid, Hardware.lsstId as expSN, HardwareType.name as hname,Process.name as pname from RunNumber join Activity on RunNumber.rootActivityId=Activity.id join Hardware on Activity.hardwareId=Hardware.id join HardwareType on HardwareType.id=Hardware.hardwareTypeId join Process on Process.id=Activity.processId where runInt='" + m_run + "'";
    ResultSet rs = m_connect.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE).executeQuery();
    if (!rs.first()) {
      throw new GetResultsNoDataException("No data found for run " + m_run);
    }
    m_oneRai = rs.getInt("rai");
    m_expSN = rs.getString("expSN");
    m_oneHid = rs.getInt("hid");
    m_hardwareType = rs.getString("hname");
    m_travelerName = rs.getString("pname");

    return;
  }
  
  private void executeGenQuery(String sql, String tableName, int datatype)
    throws SQLException, GetResultsException {
    String sqlString = sql.replace("?", tableName);

    PreparedStatement genQuery =
      m_connect.prepareStatement(sqlString, ResultSet.TYPE_SCROLL_INSENSITIVE);

    ResultSet rs = genQuery.executeQuery();

    boolean gotRow = rs.first();
    if (!gotRow) {
      genQuery.close();
      return;
    }
    HashMap<String, Object> expMap = null;
    HashMap<String, Object> steps;
    while (gotRow) {
      HashMap<String, Object> ourRun =
        (HashMap<String, Object>) m_runMaps.get(rs.getInt("raid"));
      String expSN = (String) ourRun.get("experimentSN");
      
      if (m_results.containsKey(expSN) ) {
        expMap = (HashMap<String, Object>) m_results.get(expSN);
        
        steps = (HashMap<String, Object>) expMap.get("steps");
      } else  {
        expMap = new HashMap<String, Object>(ourRun);
        m_results.put(expSN, expMap);
        
        steps = new HashMap<String, Object>();
        expMap.put("steps", steps);
      }
      gotRow = storeRunAll(steps, rs, datatype, rs.getInt("hid"));
    }

    genQuery.close();
    
  }

  private void executeGenRunQuery(String sql, String tableName, int datatype)
    throws SQLException, GetResultsException {
    String sqlString = sql.replace("?", tableName);

    PreparedStatement genQuery =
      m_connect.prepareStatement(sqlString, ResultSet.TYPE_SCROLL_INSENSITIVE);

    ResultSet rs = genQuery.executeQuery();

    boolean gotRow = rs.first();
    if (!gotRow) {
      genQuery.close();
      return;
    }
    storeRunAll(m_results.get("steps"), rs, datatype, 0);
    genQuery.close();
  }

  /**  
       Store everything for a run from one of the *ResultHarnessed tables 
       Upon entry the result set is pointing at the first row, known not to be null
       Return false if no more data; true if there is another run 
  */
  private boolean storeRunAll(Object stepMapsObject, ResultSet rs, int datatype,
                           int hid) throws SQLException, GetResultsException {
    HashMap<String, Object> stepMaps =
      (HashMap<String, Object>) stepMapsObject;

    boolean gotRow = true;
    String pname = ""; 
    String schname = "";
    HashMap<String, Object> ourStepMap = null;

    ArrayList<HashMap <String, Object> > ourInstanceList = null;

    int raid = 0;
    if (hid > 0) { // could be more than one run
      raid = rs.getInt("raid");
    }
    while (gotRow) {
      if (raid > 0) {
        if (rs.getInt("raid") != raid) {
          while (rs.getInt("hid") == hid) {
            gotRow = rs.relative(1);
            if (!gotRow) return gotRow;
          }
          return gotRow;
        }
      }
      if (!(pname.equals(rs.getString("pname")))) {
        pname = rs.getString("pname");
        ourStepMap = (HashMap<String, Object>) findOrAddStep(stepMaps, pname);
        schname = "";
      }
      if (!schname.equals(rs.getString("schname"))) {
        schname = rs.getString("schname");
        ourInstanceList = (ArrayList<HashMap<String, Object> >)
          findOrAddSchema(ourStepMap, schname);
      }
      gotRow = storeOne(rs, ourInstanceList, datatype);
      if (hid > 0) {
        if (!gotRow) return gotRow;
        // If hid has changed, we're done with this component
        if (rs.getInt("hid") != hid) return gotRow; 
      }
    }
    return gotRow;
  }

  /* Store a row and advance cursor.  If schema name and pid match but aid does not, skip over rows
     until we've exhausted rows with that aid */
  private boolean storeOne(ResultSet rs, ArrayList<HashMap <String, Object> > instances, int datatype) 
    throws SQLException, GetResultsException {
    int schemaInstance = rs.getInt("ressI");
    HashMap<String, Object> myInstance=null;
    boolean gotRow = true;
    for (HashMap<String, Object> iMap : instances ) {
      if ((int) iMap.get("schemaInstance") == schemaInstance) {
        myInstance = iMap;
        if ((Integer) myInstance.get("activityId") != rs.getInt("aid")) {
          int thisAid = rs.getInt("aid");
          while (thisAid == rs.getInt("aid")) {
            gotRow = rs.relative(1);
            if (!gotRow) return gotRow;
          }
          return gotRow;
        }
        break;
      }
    }
    if (myInstance == null) {
      myInstance = new HashMap<String, Object>();
      myInstance.put("schemaInstance", schemaInstance);
      myInstance.put("activityId", rs.getInt("aid"));
      instances.add(myInstance);
    }
    HashMap<String, Object> instance0 =
      (HashMap<String, Object>) instances.get(0);
    switch (datatype) {
    case DT_FLOAT:
      myInstance.put(rs.getString("resname"), rs.getDouble("resvalue"));
      instance0.put(rs.getString("resname"), "float");
      break;
    case DT_INT:
      myInstance.put(rs.getString("resname"), rs.getInt("resvalue"));
      instance0.put(rs.getString("resname"), "int");
      break;
    case DT_STRING:
      myInstance.put(rs.getString("resname"), rs.getString("resvalue"));
      instance0.put(rs.getString("resname"), "string");
      break;
    default:
      throw new GetResultsException("Unkown datatype");
    }
    return rs.relative(1);
  }

  /**
     Do the work of storing returned data for one run.  We start with cursor 
     pointing to a good row. 
     For each process step, save data for most recent successful activity assoc. 
     with that step.
     If hid is 0, all data are known to come from a single run.
   */
  private boolean storeRunPaths(HashMap<String, Object> steps, ResultSet rs, int hid)
    throws SQLException {
    boolean gotRow=true;
    int  pid = 0;
    int  aid = 0;
    int raid = 0;
    ArrayList<HashMap<String, Object> > dictList=null;

    if (hid > 0) {
      raid = rs.getInt("raid");
    }
    while (gotRow) {
      if (raid > 0) {
        if (rs.getInt("raid") != raid) {
          while (rs.getInt("hid") == hid) {
            gotRow = rs.relative(1);
            if (!gotRow) return gotRow;
          }
          return gotRow;
        }
      }
      
      if (pid != rs.getInt("pid")) { // make a new one
        pid = rs.getInt("pid");
        dictList = addPathList(rs.getString("pname"), steps);

        aid = rs.getInt("aid");
      }
      while ((aid != rs.getInt("aid")) && (pid == rs.getInt("pid")))  {   // skip past
        gotRow = rs.relative(1);
        if (!gotRow) return gotRow;
      }
      if (pid == rs.getInt("pid")) {
        gotRow = storePathEntry(dictList, rs);
        if (hid > 0) {
          if (!gotRow) return gotRow;
          // if hid has changed, we're done with this component
          if (rs.getInt("hid") != hid) return gotRow;
        }
      }   // otherwise this file belongs to a new step
    } 
    return gotRow;
  }

  /* Add filepath entry to list for current step*/
  private static boolean
    storePathEntry(ArrayList<HashMap <String, Object> > entryArray,
                   ResultSet rs) throws SQLException {

    HashMap<String, Object> newDict = new HashMap<String, Object>();
    newDict.put("virtualPath", rs.getString("vp"));
    newDict.put("basename", rs.getString("basename"));
    newDict.put("catalogKey", rs.getInt("catalogKey"));
    newDict.put("schemaInstance", rs.getInt("schemaInstance"));
    newDict.put("activityId", rs.getInt("aid"));
    entryArray.add(newDict);
    return rs.relative(1);
  }

  private static ArrayList<HashMap<String, Object> >
    addPathList(String name, HashMap<String, Object> steps) {
    ArrayList<HashMap<String, Object> > dictList =
      new ArrayList<HashMap<String,Object> >();
    // Add entry 0 with type information
    HashMap<String, Object> entry0 = new HashMap<String, Object>();
    entry0.put("virtualPath", "string");
    entry0.put("basename", "string");
    entry0.put("catalogKey", "int");
    entry0.put("schemaInstance", 0);
    dictList.add(entry0);
    steps.put(name, dictList);
    return dictList;
  }
      
  private static void checkNull(String val, String msg) throws GetResultsException {
    if (val == null) throw new GetResultsException(msg);
  }

  /* Clear all local data except for connection */
  private void clearCache() {
    m_hardwareType=null;
    m_travelerName=null;
    m_stepName=null;
    m_schemaName=null;
    m_model=null;
    m_expSN=null;
    m_filter=null;
    m_results=null;
    m_fileResults=null;
    m_run=0;
    m_oneRai=0;
    m_oneHid=0;
  }

  private static Object findOrAddStep(HashMap<String, Object> stepMap,
                                      String stepName) {
    if (stepMap.containsKey(stepName)) return stepMap.get(stepName);
    HashMap<String, Object> newStep = new HashMap<String, Object>();
    stepMap.put(stepName, newStep);
    return newStep;
  }

  private static Object findOrAddSchema(HashMap<String, Object> step,
                                        String schemaName) {
    if (step.containsKey(schemaName)) return step.get(schemaName);

    ArrayList<HashMap<String, Object> > newSchema =
      new ArrayList<HashMap<String, Object>>();
    HashMap <String, Object> instance0 = new HashMap<String, Object>();
    instance0.put("schemaInstance", (Integer) 0);
    newSchema.add(instance0);
    step.put(schemaName, newSchema);
    return newSchema;
  }

  
  private void pruneInstances(ArrayList<HashMap <String, Object> > mapList,
                              Pair<String, Object> filter)
  throws GetResultsException {
    String key = filter.getLeft();
    Object val = filter.getRight();

    int valType = DT_UNKNOWN;
    HashMap<String, Object> instance0 = mapList.get(0);
    if (!(instance0.containsKey(key))) return;
    String t=(String) instance0.get(key);
    if (t.equals("float") ) {
      valType=DT_FLOAT;
    } else {
      if (t.equals("int")) {
        valType=DT_INT;
      } else {
        if (t.equals("string")) {
          valType=DT_STRING;
        }  else {
          throw new GetResultsException("pruneInstances: Unrecognized data type");
        }
      }
    }

    for (int i=(mapList.size() - 1); i > 0; i--) {
      if (!(mapList.get(i).get(key).equals(val)) ) {
        mapList.remove(i);
      }
    }
  }

  private void pruneStep(HashMap<String, Object> step,
                         Pair<String, Object> filter)
    throws GetResultsException {
    for (String schema : step.keySet()) {
      ArrayList<HashMap<String, Object> > instanceList =
        (ArrayList<HashMap<String, Object> > ) step.get(schema);
      pruneInstances(instanceList, filter);
    }
  }
}
