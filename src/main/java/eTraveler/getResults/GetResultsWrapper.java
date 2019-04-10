package eTraveler.getResults;

import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import javax.servlet.http.HttpServletRequest;

import java.sql.SQLException;
import java.sql.Connection;
import java.io.IOException;
import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Set;
import java.util.HashSet;
import org.apache.commons.lang3.tuple.ImmutablePair;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.srs.web.base.db.ConnectionManager;
import org.srs.web.base.filters.modeswitcher.ModeSwitcherFilter;

/**
   The following inputs are needed
       Experiment name (not actually used yet)
       Db name
       Whether or not we want to talk to prod eT server
       Command to be executed
 */
public class GetResultsWrapper extends SimpleTagSupport {
  private Map    m_inputs;
  private String m_outputVariable;
  private String m_function;
  private Connection m_conn=null;
  private JspContext m_jspContext=null;
  private Object m_results = null;
  
  public void setInputs(Map arg) {m_inputs = arg;}
  public void setOutputVariable(String arg) {m_outputVariable = arg;}
  public static final int RQSTDATA_primitives = 1;  // string, int, float
  public static final int RQSTDATA_filepaths = 2;
  public static final int RQSTDATA_signatures = 3;
  public static final int RQSTDATA_none = -1;
  private static final int FUNC_getRunResults = 1;
  private static final int FUNC_getResultsJH = 2;
  private static final int FUNC_getRunFilepaths = 3;
  private static final int FUNC_getFilepathsJH = 4;
  private static final int FUNC_lastHarnessed = FUNC_getFilepathsJH;

  // Reserve for getManual
  private static final int FUNC_getManualRunResults = 5;
  private static final int FUNC_getManualRunSignatures = 6;
  private static final int FUNC_getManualRunFilepaths = 7;
  private static final int FUNC_getManualResultsStep = 8;
  private static final int FUNC_getManualSignaturesStep = 9;
  private static final int FUNC_getManualFilepathsStep = 10;
  private static final int FUNC_getMissingSignatures = 11;
  //private static final int FUNC_lastManual = 

  // Activity info
  private static final int FUNC_getActivity = 12;
  private static final int FUNC_getRunActivities = 13;

  // Hardware, run summaries  
  private static final int FUNC_getRunSummary = 14;
  private static final int FUNC_getRunsByLabel = 15;

  private static final int FUNC_getComponentRuns = 16;
  private static final int FUNC_getHardwareInstances = 17;
  private static final int FUNC_getHardwareNCRs = 18;

  public void doTag() throws JspException, IOException {
    m_jspContext = getJspContext();

    HttpServletRequest
      request = (HttpServletRequest)((PageContext)m_jspContext).getRequest();

    // Get a suitable connection
    String dataSource = ModeSwitcherFilter.getVariable(request.getSession(),
                                                       "etravelerDb");
    try  (Connection conn = ConnectionManager.getConnection(dataSource) ) {
      m_conn = conn;
      int func = 0;
      m_function = (String) m_inputs.get("function");
      if (m_function.equals("getRunResults")) func = FUNC_getRunResults;
      if (m_function.equals("getResultsJH")) func = FUNC_getResultsJH;
      if (m_function.equals("getRunFilepaths")) func = FUNC_getRunFilepaths;
      if (m_function.equals("getFilepathsJH")) func = FUNC_getFilepathsJH;
      if (m_function.equals("getManualRunResults")) func = FUNC_getManualRunResults;
      if (m_function.equals("getManualResultsStep")) func = FUNC_getManualResultsStep;
      if (m_function.equals("getManualRunFilepaths")) func = FUNC_getManualRunFilepaths;
      if (m_function.equals("getManualFilepathsStep")) func = FUNC_getManualFilepathsStep;
      
      if (m_function.equals("getManualRunSignatures")) func = FUNC_getManualRunSignatures;
      if (m_function.equals("getManualSignaturesStep")) func = FUNC_getManualSignaturesStep;
      if (m_function.equals("getMissingSignatures")) func = FUNC_getMissingSignatures;
      if (m_function.equals("getActivity")) func = FUNC_getActivity;
      if (m_function.equals("getRunActivities")) func = FUNC_getRunActivities;
      if (m_function.equals("getRunSummary")) func = FUNC_getRunSummary;
      if (m_function.equals("getRunsByLabel")) func = FUNC_getRunsByLabel;
      if (m_function.equals("getComponentRuns")) func = FUNC_getComponentRuns;
      if (m_function.equals("getHardwareInstances")) func = FUNC_getHardwareInstances;
      if (m_function.equals("getHardwareNCRs")) func = FUNC_getHardwareNCRs;
      if (func == 0) {
        m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
        return;
      }
    
      try {
        m_conn.setAutoCommit(true);
      } catch (SQLException se) {
        m_jspContext.setAttribute("acknowledge", "SQL error" + se.getMessage());
        return;
      }    
      m_jspContext.removeAttribute("acknowledge"); // good status so far

      //try {
      switch(func) {
      case FUNC_getRunResults:
      case FUNC_getResultsJH:
      case FUNC_getRunFilepaths:
      case FUNC_getFilepathsJH:
        getHarnessed(func);
        break;
      case FUNC_getActivity:
      case FUNC_getRunActivities:
        getActivities(func);
        break;
      case FUNC_getRunSummary:
      case FUNC_getRunsByLabel:
      case FUNC_getComponentRuns:
        getSummary(func);
        break;
      case FUNC_getHardwareInstances:
      case FUNC_getHardwareNCRs:
        getHardware(func);
        break;
      case FUNC_getManualRunResults:
      case FUNC_getManualResultsStep:
      case FUNC_getManualRunFilepaths:
      case FUNC_getManualFilepathsStep:
      case FUNC_getManualRunSignatures:
      case FUNC_getManualSignaturesStep:
      case FUNC_getMissingSignatures:
        getManual(func);
        break;
      default:
        m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
        return;
      }
        
    } catch (SQLException sqlEx) {
      m_jspContext.setAttribute("acknowledge", "Failed with SQL exception "
                                + sqlEx.getMessage());
      return;
    } catch (GetResultsNoDataException ndEx) {
      m_jspContext.setAttribute("acknowledge", "Failed with GetResultsNoDataException: "
                                + ndEx.getMessage());
    } catch (GetResultsException ghEx) {
      m_jspContext.setAttribute("acknowledge", "Failed with exception "
                                + ghEx.getMessage());
      return;
    } catch (JspException jspEx) {
      throw jspEx;
    }

    if (m_results == null) {
      if (m_jspContext.getAttribute("acknowledge") == null) {
          m_jspContext.setAttribute("acknowledge", "Error: no results found");
      }
    } else {
      ObjectMapper mapper = new ObjectMapper();
      String outputString = mapper.writeValueAsString(m_results);
      m_jspContext.setAttribute(m_outputVariable, outputString);
    }
    return;
  }

  private void getHarnessed(int func)
    throws SQLException,GetResultsException,JspException {
    GetHarnessedData getHD = new GetHarnessedData(m_conn);
    ImmutablePair<String, Object> filter=null;
    Set<String> hardwareLabels=null;
    Set<String> runLabels=null;
    String run=null;
    ArrayList<String> runStatuses =
      (ArrayList<String>) m_inputs.get("runStatus");
      
    switch(func) {
    case FUNC_getRunResults:
      run= (String) m_inputs.get("run");
      String schemaName= (String) m_inputs.get("schemaName");
      String stepName= (String) m_inputs.get("stepName");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        return;
      }
      if (m_inputs.get("filterKey") != null) {
        filter = new
          ImmutablePair<String, Object>(m_inputs.get("filterKey").toString(),
                                        m_inputs.get("filterValue"));
      }
      m_results = getHD.getRunResults(run, stepName, schemaName, filter);
      break;
    case FUNC_getResultsJH:
      if (m_inputs.get("filterKey") != null) {
        filter = new
          ImmutablePair<String, Object>(m_inputs.get("filterKey").toString(),
                                        m_inputs.get("filterValue"));
      }
      if (m_inputs.get("hardwareLabels") != null)  {
        ArrayList<String> hlabelList =
          (ArrayList<String>) m_inputs.get("hardwareLabels");
        hardwareLabels = new HashSet<String>();
        hardwareLabels.addAll(hlabelList);
      }
      if (m_inputs.get("runLabels") != null)  {
        ArrayList<String> rlabelList =
          (ArrayList<String>) m_inputs.get("runLabels");
        runLabels = new HashSet<String>();
        runLabels.addAll(rlabelList);
      }
      m_results =
        getHD.getResultsJH((String) m_inputs.get("travelerName"),
                           (String) m_inputs.get("hardwareType"),
                           (String) m_inputs.get("stepName"),
                           (String) m_inputs.get("schemaName"),
                           (String) m_inputs.get("model"),
                           (String) m_inputs.get("experimentSN"),
                           filter, hardwareLabels, runStatuses,
                           runLabels); 
      break;
    case FUNC_getRunFilepaths:
      run= (String) m_inputs.get("run");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        return;
      }
      m_results = getHD.getRunFilepaths(run, (String) m_inputs.get("stepName"));
      break;
      
    case FUNC_getFilepathsJH:
      if (m_inputs.get("hardwareLabels") != null)  {
        ArrayList<String> labelList =
          (ArrayList<String>) m_inputs.get("hardwareLabels");
        hardwareLabels = new HashSet<String>();
        hardwareLabels.addAll(labelList);
      }
      if (m_inputs.get("runLabels") != null)  {
        ArrayList<String> rlabelList =
          (ArrayList<String>) m_inputs.get("runLabels");
        runLabels = new HashSet<String>();
        runLabels.addAll(rlabelList);
      }
      m_results =
        getHD.getFilepathsJH((String) m_inputs.get("travelerName"),
                             (String) m_inputs.get("hardwareType"),
                             (String) m_inputs.get("stepName"),
                             (String) m_inputs.get("model"),
                             (String) m_inputs.get("experimentSN"),
                             hardwareLabels, runStatuses, runLabels);
      break;
    default:
      m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
    }
    return;
  }
  private void getManual(int func) 
    throws SQLException,GetResultsException,JspException {
    GetManualData getMD = new GetManualData(m_conn);
    Set<String> hardwareLabels=null;
    
    ArrayList<String> statuses =
      (ArrayList<String>) m_inputs.get("activityStatus");
    ArrayList<String> runStatuses =
      (ArrayList<String>) m_inputs.get("runStatus");
    int rqstdata = RQSTDATA_none;
    
    String run=null;
    switch(func) {
    case FUNC_getManualRunResults:
      if (rqstdata == RQSTDATA_none) rqstdata = RQSTDATA_primitives;
      // intentional fall-through
    case FUNC_getManualRunFilepaths:
      if (rqstdata == RQSTDATA_none) rqstdata = RQSTDATA_filepaths;
      // intentional fall-through
    case FUNC_getManualRunSignatures:
      if (rqstdata == RQSTDATA_none) rqstdata = RQSTDATA_signatures;
      run = (String) m_inputs.get("run");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        return;
      }
      String stepName= (String) m_inputs.get("stepName");
      // String nameFilter = (String) m_inputs.get("nameFilter");

      m_results=getMD.getManualRun(rqstdata, run, stepName, statuses);
      break;
    case FUNC_getManualResultsStep:
      if (rqstdata == RQSTDATA_none) rqstdata = RQSTDATA_primitives;
      // intentional fall-through
    case FUNC_getManualFilepathsStep:
      if (rqstdata == RQSTDATA_none) rqstdata = RQSTDATA_filepaths;
      //intentional fall-through
    case FUNC_getManualSignaturesStep:
      if (rqstdata == RQSTDATA_none) rqstdata = RQSTDATA_signatures;
      
      if (m_inputs.get("hardwareLabels") != null)  {
        ArrayList<String> labelList =
          (ArrayList<String>) m_inputs.get("hardwareLabels");
        hardwareLabels = new HashSet<String>();
        hardwareLabels.addAll(labelList);
      }
      m_results =
        getMD.getManualStep(rqstdata,
                            (String) m_inputs.get("travelerName"),
                            (String) m_inputs.get("hardwareType"),
                            (String) m_inputs.get("stepName"),
                            (String) m_inputs.get("model"),
                            (String) m_inputs.get("experimentSN"),
                            hardwareLabels, statuses, runStatuses);
      break;
    case FUNC_getMissingSignatures:
      if (statuses == null) {
        statuses = new ArrayList<String>(3);
        statuses.add("success");
        statuses.add("inProgress");
        statuses.add("paused");
      }
      
      m_results =
        getMD.getMissingSignatures(statuses,
                                         (String) m_inputs.get("travelerName"),
                                         (String) m_inputs.get("stepName"),
                                         (String) m_inputs.get("hardwareType"),
                                         (String) m_inputs.get("model"),
                                         (String) m_inputs.get("experimentSN"),
                                         null);
      break;
    default:
      m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
    }
    return;
  }
  private void getActivities(int func)
    throws SQLException,GetResultsException,JspException {
    GetActivityInfo getA = new GetActivityInfo(m_conn);
    switch(func) {
    case FUNC_getActivity:
      String aid= (String) m_inputs.get("activityId");
      if (aid == null) {
        m_jspContext.setAttribute("acknowledge", "Missing activityId argument");
        return;
      }
      m_results = getA.getActivity(aid);
      break;
    case FUNC_getRunActivities:
      String run= (String) m_inputs.get("run");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        return;
      }
      m_results = getA.getRunActivities(run);
      break;
    default:
      m_jspContext.setAttribute("acknowledge","Unknown function " + m_function);
    }    
    return;
  }
  private void getHardware(int func)
    throws SQLException,GetResultsException,JspException {
    GetHardware getH = new GetHardware(m_conn);
    Set<String> hardwareLabels=null;

    switch(func) {
    case FUNC_getHardwareInstances:
      String htype = (String) m_inputs.get("hardwareType");
      if (htype == null) {
        m_jspContext.setAttribute("acknowledge", "Missing hardware type arg");
        return;
      }
      if (m_inputs.get("hardwareLabels") != null)  {
        ArrayList<String> labelList =
          (ArrayList<String>) m_inputs.get("hardwareLabels");
        hardwareLabels = new HashSet<String>();
        hardwareLabels.addAll(labelList);
      }
      
      m_results =
        getH.getHardwareInstances(htype,(String) m_inputs.get("experimentSN"),
                                  (String) m_inputs.get("model"),
                                  hardwareLabels);
      break;
    case FUNC_getHardwareNCRs:
      Set<String> ncrLabels=null;
      if (m_inputs.get("ncrLabels") != null)  {
        ArrayList<String> labelList =
          (ArrayList<String>) m_inputs.get("ncrLabels");
        ncrLabels = new HashSet<String>();
        ncrLabels.addAll(labelList);
      }

      htype = (String) m_inputs.get("hardwareType");
      if (htype == null) {
        m_jspContext.setAttribute("acknowledge", "Missing hardware type arg");
        return;
      }
      String expSN = (String) m_inputs.get("experimentSN");
      if (expSN == null) {
        m_jspContext.setAttribute("acknowledge", "Missing component SN arg");
        return;
      }
      m_results = getH.getNCRs(htype, expSN, (String) m_inputs.get("items"),
                               ncrLabels);
      break;
    default:
      m_jspContext.setAttribute("acknowledge","Unknown function " + m_function);
    }
    return;
  }
  
  private void getSummary(int func)
    throws SQLException,GetResultsException,JspException {
    GetSummary getS = new GetSummary(m_conn);
    ArrayList<String> runStatuses =
      (ArrayList<String>) m_inputs.get("runStatus");

    switch(func) {
    case FUNC_getRunSummary:
      String run =(String) m_inputs.get("run");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        return;
      }
      m_results = getS.getRunSummary(run);
      break;
    case FUNC_getRunsByLabel:
      if (m_inputs.get("runLabels") == null) {
        m_jspContext.setAttribute("acknowledge", "Missing argument runLabels");
        return;
      }
      ArrayList<String> labelList =
        (ArrayList<String>) m_inputs.get("runLabels");
      if (labelList.size() == 0) {
        m_jspContext.setAttribute("acknowledge", "0-length argument runLabels");
        return;
      }
      HashSet<String> runLabels = new HashSet<String>();
      runLabels.addAll(labelList);
      m_results = getS.getRunsByLabel(runLabels, runStatuses,
                                      (String) m_inputs.get("travelerName"));
      break;
      
      
    case FUNC_getComponentRuns:
      String htype = (String) m_inputs.get("hardwareType");
      String expSN = (String) m_inputs.get("experimentSN");
      if ((htype == null) || (expSN == null)) {
        m_jspContext.setAttribute("acknowledge", "Missing argument");
        return;
      }
      String travelerName = (String) m_inputs.get("travelerName");
      m_results = getS.getComponentRuns(htype, expSN, travelerName,
                                        runStatuses);
      break;
    default:
      m_jspContext.setAttribute("acknowledge",
                                "Unknown function " + m_function);
      return;
    }      
  }
}
