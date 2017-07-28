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
import org.apache.commons.lang3.tuple.ImmutablePair;

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
  private Connection m_conn;
  private JspContext m_jspContext=null;
  private Object m_results = null;
  
  public void setInputs(Map arg) {m_inputs = arg;}
  public void setOutputVariable(String arg) {m_outputVariable = arg;}
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
  private static final int FUNC_getManualResultsSignaturesStep = 9;
  private static final int FUNC_getManualFilepathsStep = 10;
  private static final int FUNC_lastManual = FUNC_getManualFilepathsStep;
  
  // Activity info
  private static final int FUNC_getActivity = 11;
  private static final int FUNC_getRunActivities = 12;

  private static final int FUNC_getRunSummary = 13;

  // Hardware
  private static final int FUNC_getHardwareInstances = 14;


  public void doTag() throws JspException, IOException {
    m_jspContext = getJspContext();

    HttpServletRequest
      request = (HttpServletRequest)((PageContext)m_jspContext).getRequest();

    // Get a suitable connection
    String dataSource = ModeSwitcherFilter.getVariable(request.getSession(),
                                                       "etravelerDb");
    m_conn = ConnectionManager.getConnection(dataSource);

    int func = 0;
    m_function = (String) m_inputs.get("function");
    if (m_function.equals("getRunResults")) func = FUNC_getRunResults;
    if (m_function.equals("getResultsJH")) func = FUNC_getResultsJH;
    if (m_function.equals("getRunFilepaths")) func = FUNC_getRunFilepaths;
    if (m_function.equals("getFilepathsJH")) func = FUNC_getFilepathsJH;
    if (m_function.equals("getManualRunResults")) func = FUNC_getManualRunResults;
    if (m_function.equals("getManualResultsStep")) func = FUNC_getManualResultsStep;
    /*
    if (m_function.equals("getManualRunFilepaths")) func = FUNC_getManualRunFilepaths;
    if (m_function.equals("getManualRunSignatures")) func = FUNC_getManualRunSignatures;
    if (m_function.equals("getManualFilepathsStep")) func = FUNC_getManualFilepathsStep;
    */
    if (m_function.equals("getActivity")) func = FUNC_getActivity;
    if (m_function.equals("getRunActivities")) func = FUNC_getRunActivities;
    if (m_function.equals("getRunSummary")) func = FUNC_getRunSummary;
    if (m_function.equals("getHardwareInstances")) func = FUNC_getHardwareInstances;
    if (func == 0) {
      m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
      close();
      return;
    }
    
    try {
      m_conn.setAutoCommit(true);
    } catch (SQLException se) {
      m_jspContext.setAttribute("acknowledge", "SQL error" + se.getMessage());
      close();
      return;
    }
    
    m_jspContext.removeAttribute("acknowledge"); // good status so far

    try {
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
        getSummary(func);
        break;
      case FUNC_getHardwareInstances:
        getHardware(func);
        break;
      case FUNC_getManualRunResults:
      case FUNC_getManualResultsStep:
        // call a new thing here
        getManual(func);
        break;
      default:
        m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
        close();
        return;
      }
    } catch (SQLException sqlEx) {
      m_jspContext.setAttribute("acknowledge", "Failed with SQL exception "
                                + sqlEx.getMessage());
      close();
      return;
    } catch (GetResultsException ghEx) {
      m_jspContext.setAttribute("acknowledge", "Failed with exception "
                                + ghEx.getMessage());
      close();
      return;
    }

    if (m_results == null) {
      if (m_jspContext.getAttribute("acknowledge") == null) {
          m_jspContext.setAttribute("acknowledge", "Error: no results found");
      }
    } else {
      m_jspContext.setAttribute(m_outputVariable, m_results);
    }
    close();
    return;

  }

  private void getHarnessed(int func)
    throws SQLException,GetResultsException,JspException {
    GetHarnessedData getHD = new GetHarnessedData(m_conn);
    ImmutablePair<String, Object> filter=null;
    ArrayList<String> hardwareLabels=null;
    String run=null;
      
    switch(func) {
    case FUNC_getRunResults:
      run= (String) m_inputs.get("run");
      String schemaName= (String) m_inputs.get("schemaName");
      String stepName= (String) m_inputs.get("stepName");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        close();
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
        hardwareLabels = (ArrayList<String>) m_inputs.get("hardwareLabels");
      }
      m_results =
        getHD.getResultsJH((String) m_inputs.get("travelerName"),
                           (String) m_inputs.get("hardwareType"),
                           (String) m_inputs.get("stepName"),
                           (String) m_inputs.get("schemaName"),
                           (String) m_inputs.get("model"),
                           (String) m_inputs.get("experimentSN"),
                           filter, hardwareLabels); 
      break;
    case FUNC_getRunFilepaths:
      run= (String) m_inputs.get("run");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        close();
        return;
      }
      m_results = getHD.getRunFilepaths(run, (String) m_inputs.get("stepName"));
      break;
      
    case FUNC_getFilepathsJH:
      m_results =
        getHD.getFilepathsJH((String) m_inputs.get("travelerName"),
                             (String) m_inputs.get("hardwareType"),
                             (String) m_inputs.get("stepName"),
                             (String) m_inputs.get("model"),
                             (String) m_inputs.get("experimentSN"));
      break;
    default:
      m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
      close();
      return;
    }
  }
  private void getManual(int func) 
    throws SQLException,GetResultsException,JspException {
    GetManualData getMD = new GetManualData(m_conn);
    String run=null;
    switch(func) {
    case FUNC_getManualRunResults:
      run = (String) m_inputs.get("run");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        close();
        return;
      }
      String stepName= (String) m_inputs.get("stepName");
      // String nameFilter = (String) m_inputs.get("nameFilter");
      m_results = getMD.getManualRunResults(run, stepName);
      break;
    case FUNC_getManualResultsStep:
      m_results =
        getMD.getManualResultsStep((String) m_inputs.get("travelerName"),
                                   (String) m_inputs.get("hardwareType"),
                                   (String) m_inputs.get("stepName"),
                                   (String) m_inputs.get("model"),
                                   (String) m_inputs.get("experimentSN"));
      break;
      
    default:
      m_jspContext.setAttribute("acknowledge", "Unknown function " + m_function);
      close();
      return;
    }
  }
  private void getActivities(int func)
    throws SQLException,GetResultsException,JspException {
    GetActivityInfo getA = new GetActivityInfo(m_conn);
    switch(func) {
    case FUNC_getActivity:
      String aid= (String) m_inputs.get("activityId");
      if (aid == null) {
        m_jspContext.setAttribute("acknowledge", "Missing activityId argument");
        close();
        return;
      }
      m_results = getA.getActivity(aid);
      break;
    case FUNC_getRunActivities:
      String run= (String) m_inputs.get("run");
      if (run == null) {
        m_jspContext.setAttribute("acknowledge", "Missing run argument");
        close();
        return;
      }
      m_results = getA.getRunActivities(run);
      break;
    default:
      m_jspContext.setAttribute("acknowledge","Unknown function " + m_function);
      close();
      return;
    }    
  }
  private void getHardware(int func)
    throws SQLException,GetResultsException,JspException {
    GetHardware getH = new GetHardware(m_conn);
    switch(func) {
    case FUNC_getHardwareInstances:
      String htype = (String) m_inputs.get("hardwareTypeName");
      if (htype == null) {
        m_jspContext.setAttribute("acknowledge", "Missing hardware type arg");
        close();
        return;
      }
      m_results =
        getH.getHardwareInstances(htype,(String) m_inputs.get("experimentSN")); 
    }
  }
  
  private void getSummary(int func)
    throws SQLException,GetResultsException,JspException {
    String run =(String) m_inputs.get("run");
    if (run == null) {
      m_jspContext.setAttribute("acknowledge", "Missing run argument");
      close();
      return;
    }
    GetSummary getS = new GetSummary(m_conn);
    m_results = getS.getRunSummary(run);
  }
  private void close() throws JspException {
    try {
      m_conn.setAutoCommit(true);
      m_conn.close();
    } catch (SQLException ex) {
      System.out.println("Failed to close SQL connection with error "
                         + ex.getMessage());
    }
  }
}

  
