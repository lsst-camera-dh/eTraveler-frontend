package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Set;
import java.util.concurrent.ConcurrentSkipListSet;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ParameterMetaData;
import java.sql.SQLException;

public class GetManualData {
  private Connection m_connect=null;
  private int m_run=0;
  private String m_stepName;
  // private String m_nameFilter;
  private String m_travelerName;
  private String m_hardwareType;
  private String m_model=null;
  private String m_expSN=null;
  private HashMap<Integer, Object> m_runMaps=null;
  private HashMap<String, Object> m_results = null;

  private static final int DT_ABSENT = -2, DT_UNKNOWN = -1,
    DT_FLOAT = 0, DT_INT = 1, DT_STRING = 2, DT_TEXT = 3;

  public GetManualData(Connection conn) {
    m_connect=conn;
  }

  public void setConnection(Connection conn) {
    m_connect=conn;
  }

  /**
     Return map, indexed by experimentSN, of manual data for step stepName
     belonging to components as specified by arguments hardwareType, model 
     and experimentSN for which traveler with name travelerName was run and
     step stepName had good status.
   */
  public Map<String, Object>
    getManualResultsStep(String travelerName, String hardwareType,
                         String stepName, String model, String experimentSN,
                         Set<String> hardwareLabels)
    throws GetResultsException, SQLException {

    if (m_connect == null)
      throw new GetResultsException("Set connection before attempting to fetch data");
    checkNull(travelerName, "travelerName argument must be non-null");
    checkNull(hardwareType, "hardwareType argument must be non-null");
    checkNull(stepName, "stepName argument must be non-null");

    m_travelerName = travelerName;
    m_hardwareType = hardwareType;
    m_stepName=stepName;
    m_model = model;
    m_expSN = experimentSN;

    /*  Get information about all runs on components of interest with
        the right travelerName.  In general they won't all make the
        final cut.  We use data only from the most recent good one (if
        any) for each component.
     */
    m_runMaps = GetResultsUtil.getRunMaps(m_connect, m_hardwareType,
                                          m_expSN, m_model, m_travelerName);
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

    /* Form data-fetching query. It will be run once for each of the 4 tables
       which might have data we're looking for: FloatResultManual, etc.
       Substitute table name for the ?
     */
    String sql =
      "select ?.value as resvalue,IP.units as resunits,IP.name as patname, IP.isOptional, Process.name as procname, A.id as aid,A.hardwareId as hid,A.rootActivityId as raid,A.processId as pid from ? join Activity A on ?.activityId=A.id join InputPattern IP on ?.inputPatternId=IP.id join Process on Process.id=A.processId";
    sql +=   " where A.id in " + goodActivities;
    if (hidSet != null) {
      sql += " and A.hardwareId in " +GetResultsUtil.setToSqlList(hidSet);
    }
    sql += " order by A.hardwareId asc, A.rootActivityId desc,A.id desc, patname";
    
    m_results = new HashMap<String, Object>();
    executeGenQuery(sql, "FloatResultManual", DT_FLOAT);
    executeGenQuery(sql, "IntResultManual", DT_INT);
    executeGenQuery(sql, "StringResultManual", DT_STRING);
    executeGenQuery(sql, "TextResultManual", DT_TEXT);

    /* No additional filtering for now */
    return m_results;
    
  }

  public Map<String, Object>
    getManualRunResults(String run, String stepName)
    throws GetResultsException, SQLException {
    int runInt = GetResultsUtil.formRunInt(run);
    return getManualRunResults(runInt, stepName);
  }

  public Map<String, Object>
    getManualRunResults(int runInt, String stepName)
    throws GetResultsException, SQLException {
    if (m_connect == null)
      throw new GetResultsException("Set connection before attempting to fetch data");
    
    m_run = runInt;
    m_stepName = stepName;

    GetSummary getSummary = new GetSummary(m_connect);
    m_results = getSummary.getRunSummary(runInt);

    HashMap<String, Object> stepMap = new HashMap<String, Object>();
    m_results.put("steps", stepMap);

    String sql =
      "select ?.value as resvalue,IP.units as resunits,IP.name as patname, IP.isOptional, Process.name as procname, A.id as aid,A.processId as pid,ASH.activityStatusId as actStatus from ? join Activity A on ?.activityId=A.id join InputPattern IP on ?.inputPatternId=IP.id "
      + GetResultsUtil.getActivityStatusJoins()
      + " join Process on Process.id=A.processId where ";
    if (m_stepName != null) {
      sql += "Process.name='" + m_stepName +"' and ";
    }
    sql += " A.rootActivityId='" + m_results.get("rootActivityId") + "' and " +
      GetResultsUtil.getActivityStatusCondition() +
      " order by A.processId asc,A.id desc, patname";

    // Perform the same query on 4 tables; merge results by step as we go
    executeGenRunQuery(sql, "StringResultManual", DT_STRING);
    executeGenRunQuery(sql, "IntResultManual", DT_INT);
    executeGenRunQuery(sql, "FloatResultManual", DT_FLOAT);
    executeGenRunQuery(sql, "TextResultManual", DT_TEXT);

    // No filtering for now
    return m_results;
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
        steps =  (HashMap<String, Object>) expMap.get("steps");
      } else {
        expMap = new HashMap<String, Object>(ourRun);
        m_results.put(expSN, expMap);
        steps = new HashMap<String, Object>();
        expMap.put("steps", steps);
      }
      gotRow = storeRunAll(steps, rs, datatype, rs.getInt("hid"));
    }
    
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
       Store everything for a run from one of the *ResultManual tables,
       not including FilepathResultManual or SignatureResultManual
       because they have extra information.
       Upon entry the result set is pointing at the first row, known not to be null
       Return false if no more data; true if there is another run 
  */
  private boolean storeRunAll(Object stepMapsObject, ResultSet rs, int datatype,
                           int hid) throws SQLException, GetResultsException {
    HashMap<String, Object> stepMaps =
      (HashMap<String, Object>) stepMapsObject;

    boolean gotRow = true;
    String pname = ""; 
    HashMap<String, Object> ourStepMap = null;

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
      if (!(pname.equals(rs.getString("procname")))) {
        pname = rs.getString("procname");
        ourStepMap = (HashMap<String, Object>) findOrAddStep(stepMaps, pname);
      }
      gotRow = storeOne(rs, ourStepMap, datatype);
      if (hid > 0) {
        if (!gotRow) return gotRow;
        // If hid has changed, we're done with this component
        if (rs.getInt("hid") != hid) return gotRow; 
      }
    }
    return gotRow;
  }

  /**
     rs          result set from query made in executeGenRunQuery
     stepMap     keyed by Process.name.  Matches our step name. 
                 Contains of each entry is a map, keyed by
                 InputPattern.name.   We repeat activityId in each
                 such entry, even though they will all be the same
                 for all entries in a stepMap
     datatype    Depends on which results table query was made on

     Store a row and advance cursor.  If stepname matches but aid of
     pre-existing entries does not,
     skip over rows until we've exhausted rows with that aid */
  private boolean storeOne(ResultSet rs, HashMap <String, Object> stepMap,
                           int datatype) 
    throws SQLException, GetResultsException {

    boolean gotRow = true;
    HashMap <String, Object> ourEntry = null;
    String    patname = rs.getString("patname");
    if (stepMap.containsKey(patname)) {
      ourEntry = (HashMap <String, Object>) stepMap.get(patname);
      if ((Integer) ourEntry.get("activityId") != rs.getInt("aid")) {
        // Skip past all other rows with this bad aid
        int thisAid = rs.getInt("aid");
        while (thisAid == rs.getInt("aid")) {
          gotRow = rs.relative(1);
          if (!gotRow) return gotRow;
        }
        return gotRow;
      }  else { // shouldn't happen
        throw new GetResultsException("Duplicate input pattern name in step");
      }
    }
    
    // Make a new hash map for our entry and store in step map
    ourEntry = new HashMap<String, Object>();
    stepMap.put(patname, ourEntry);

    // Store parts which are independent of datatype
    ourEntry.put("activityId", rs.getInt("aid"));
    ourEntry.put("units", rs.getString("resunits"));
    ourEntry.put("isOptional", rs.getInt("isOptional"));

    switch (datatype) {
    case DT_FLOAT:
      ourEntry.put("value", rs.getDouble("resvalue"));
      ourEntry.put("datatype", "float");
      break;
    case DT_INT:
      ourEntry.put("value", rs.getInt("resvalue"));
      ourEntry.put("datatype", "int");
      break;
    case DT_STRING:
    case DT_TEXT:
      ourEntry.put("value", rs.getString("resvalue"));
      ourEntry.put("datatype", "string");
      break;
    default:
      throw new GetResultsException("Unkown datatype");
    }
    return rs.relative(1);
  }

  private static Object findOrAddStep(HashMap<String, Object> stepMap,
                                      String stepName) {
    if (stepMap.containsKey(stepName)) return stepMap.get(stepName);
    HashMap<String, Object> newStep = new HashMap<String, Object>();
    stepMap.put(stepName, newStep);
    return newStep;
  }
  private static void checkNull(String val, String msg) throws GetResultsException {
    if (val == null) throw new GetResultsException(msg);
  }
  
}
