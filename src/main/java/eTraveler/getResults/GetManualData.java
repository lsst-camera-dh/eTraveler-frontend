package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;

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
  private String m_nameFilter;
  private HashMap<String, Object> m_results = null;

  private static final int DT_ABSENT = -2, DT_UNKNOWN = -1,
    DT_FLOAT = 0, DT_INT = 1, DT_STRING = 2, DT_TEXT = 3;

  public GetManualData(Connection conn) {
    m_connect=conn;
  }

  public void setConnection(Connection conn) {
    m_connect=conn;
  }

  public Map<String, Object>
    getManualRunResults(String run, String stepName, String nameFilter)
    throws GetResultsException, SQLException {
    int runInt = GetResultsUtil.formRunInt(run);
    return getManualRunResults(runInt, stepName, nameFilter);
  }

  public Map<String, Object>
    getManualRunResults(int runInt, String stepName, String nameFilter)
    throws GetResultsException, SQLException {
    if (m_connect == null)
      throw new GetResultsException("Set connection before attempting to fetch data");
    
    m_run = runInt;
    m_stepName = stepName;
    m_nameFilter = nameFilter;

    GetSummary getSummary = new GetSummary(m_connect);
    m_results = getSummary.getRunSummary(runInt);

    HashMap<String, Object> stepMap = new HashMap<String, Object>();
    m_results.put("steps", stepMap);

    String sql =
      "select ?.value as resvalue,IP.units as resunits,IP.name as patname, Process.name as procname, A.id as aid,A.processId as pid,ASH.activityStatusId as actStatus from ? join Activity A on ?.activityId=A.id join InputPattern IP on ?.inputPatternId=IP.id "
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
}
