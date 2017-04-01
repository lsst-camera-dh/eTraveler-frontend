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
  
  public void setInputs(Map arg) {m_inputs = arg;}
  public void setOutputVariable(String arg) {m_outputVariable = arg;}
  private static final int FUNC_getRunResults = 1;
  private static final int FUNC_getResultsJH = 2;
  private static final int FUNC_getRunFilepaths = 3;
  private static final int FUNC_getFilepathsJH = 4;

  public void doTag() throws JspException, IOException {
    JspContext jspContext = getJspContext();
    HttpServletRequest
      request = (HttpServletRequest)((PageContext)jspContext).getRequest();

    // Get a suitable connection
    String dataSource = ModeSwitcherFilter.getVariable(request.getSession(),
                                                       "etravelerDb");
    Connection conn = ConnectionManager.getConnection(dataSource);
    m_conn = conn;

    int func = 0;
    m_function = (String) m_inputs.get("function");
    if (m_function.equals("getRunResults")) func = FUNC_getRunResults;
    if (m_function.equals("getResultsJH")) func = FUNC_getResultsJH;
    if (m_function.equals("getRunFilepaths")) func = FUNC_getRunFilepaths;
    if (m_function.equals("getFilepathsJH")) func = FUNC_getFilepathsJH;
    try {
      conn.setAutoCommit(true);
    } catch (SQLException se) {
      jspContext.setAttribute("acknowledge", "SQL error" + se.getMessage());
      close();
      return;
    }

    // For now only class needed is GetHarnessedData. Someday might alsohave GetManualData class.
    // Make a new GetHarnessedData object
    GetHarnessedData getHD = new GetHarnessedData(conn);

    Map<String, Object> results = null;

    jspContext.removeAttribute("acknowledge"); // good status so far

    try {
      ImmutablePair<String, Object> filter=null;
      String run=null;
      
      switch(func) {
      case FUNC_getRunResults:
        run= (String) m_inputs.get("run");
        String schemaName= (String) m_inputs.get("schemaName");
        if (run == null) {
          jspContext.setAttribute("acknowledge", "Missing run argument");
          close();
          return;
        }
        if (m_inputs.get("filterKey") != null) {
          filter = new
            ImmutablePair<String, Object>(m_inputs.get("filterKey").toString(),
                                          m_inputs.get("filterValue"));
        }
        if (schemaName != null) {
          results = getHD.getRunResults(run, schemaName, filter);
        } else {
          results = getHD.getRunResults(run, filter);
        }
        break;
      case FUNC_getResultsJH:
        if (m_inputs.get("filterKey") != null) {
          filter = new
            ImmutablePair<String, Object>(m_inputs.get("filterKey").toString(),
                                 m_inputs.get("filterValue"));
        }
        results =
          getHD.getResultsJH((String) m_inputs.get("travelerName"),
                             (String) m_inputs.get("hardwareType"),
                             (String) m_inputs.get("schemaName"),
                             (String) m_inputs.get("model"),
                             (String) m_inputs.get("experimentSN"),
                             filter); 
        break;
      case FUNC_getRunFilepaths:
        run= (String) m_inputs.get("run");
        if (run == null) {
          jspContext.setAttribute("acknowledge", "Missing run argument");
          close();
          return;
        }
        results = getHD.getRunFilepaths(run, (String) m_inputs.get("stepName"));
        break;

      case FUNC_getFilepathsJH:
        results =
          getHD.getFilepathsJH((String) m_inputs.get("travelerName"),
                               (String) m_inputs.get("hardwareType"),
                               (String) m_inputs.get("stepName"),
                               (String) m_inputs.get("model"),
                               (String) m_inputs.get("experimentSN"));
        break;
      default:
        jspContext.setAttribute("acknowledge", "unknown function " + m_function);
        close();
        return;
      }
    } catch (SQLException sqlEx) {
      jspContext.setAttribute("acknowledge", "Failed with SQL exception "
                                + sqlEx.getMessage());
      close();
      return;
    } catch (GetResultsException ghEx) {
      jspContext.setAttribute("acknowledge", "Failed with exception "
                                + ghEx.getMessage());
      close();
      return;
    }
    if (results == null) {
      jspContext.setAttribute("acknowledge", "Error: no results found");
    } else {
      jspContext.setAttribute(m_outputVariable, results);
    }
    close();
    return;

  }

  void close() throws JspException {
    try {
      m_conn.setAutoCommit(true);
      m_conn.close();
    } catch (SQLException ex) {
      System.out.println("Failed to close SQL connection with error "
                         + ex.getMessage());
    }
  }
}

  
