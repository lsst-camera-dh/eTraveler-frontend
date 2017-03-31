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

  public void doTag() throws JspException, IOException {
    JspContext jspContext = getJspContext();
    HttpServletRequest
      request = (HttpServletRequest)((PageContext)jspContext).getRequest();

    // Get a suitable connection
    String dataSource = ModeSwitcherFilter.getVariable(request.getSession(),
                                                       "etravelerDb");
    Connection conn = ConnectionManager.getConnection(dataSource);
    m_conn = conn;

    m_function = (String) m_inputs.get("function");
    try {
      conn.setAutoCommit(true);
    } catch (SQLException se) {
      jspContext.setAttribute("acknowledge", "SQL error" + se.getMessage());
      close();
      return;
    }

    // For now the only class we need is GetHarnessedData. Could
    // change if some day there is also a GetManualData class.
    // Make a new GetHarnessedData object
    GetHarnessedData getHD = new GetHarnessedData(conn);

    Map<String, Object> results = null;

    jspContext.removeAttribute("acknowledge"); // good status so far
    
    if (m_function.equals("getRunResults")) {
      // If run is null, complain.  It's ok for schemaName to be null

      String run= (String) m_inputs.get("run");
      String schemaName= (String) m_inputs.get("schemaName");
      if (run == null) {
        jspContext.setAttribute("acknowledge", "Missing run argument");
        close();
        return;
      }
      ImmutablePair<String, Object> filter=null;
      if (m_inputs.get("filterKey") != null) {
        filter = new
          ImmutablePair<String, Object>(m_inputs.get("filterKey").toString(),
                               m_inputs.get("filterValue"));
      }
      try {
        if (schemaName != null) {
          results = getHD.getRunResults(run, schemaName, filter);
        } else {
          results = getHD.getRunResults(run, filter);
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
    if (m_function.equals("getResultsJH")) {
      try {
        ImmutablePair<String, Object> filter=null;
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
                             filter); // no filter for now
      }     catch (SQLException sqlEx) {
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
    if (m_function.equals("getRunFilepaths")) {
      String run= (String) m_inputs.get("run");
      String stepName= null;
      if (m_inputs.containsKey("stepName")) {
        stepName = (String) m_inputs.get("stepName");
      }
      if (run == null) {
        jspContext.setAttribute("acknowledge", "Missing run argument");
        close();
        return;
      }
      try {
        results = getHD.getRunFilepaths(run, stepName);
      }     catch (SQLException sqlEx) {
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
    // unrecognized or NYI function
    jspContext.setAttribute("acknowledge", "unknown function " + m_function);
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

  
