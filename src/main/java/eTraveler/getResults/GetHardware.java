package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.concurrent.ConcurrentSkipListSet;
import java.util.Set;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
    getHardwareInstances(String htype, String expSN, Set<String> hardwareLabels)
    throws SQLException, GetResultsException {

    // If hardwareLabels not null
    //   Get set of all hardware id's under consideration
    //   Invoke GetResultsUtil.associateLabels 
    String findHistoryRows =
      "(select max(HSH2.id) from HardwareStatusHistory HSH2 " +
      "join Hardware H2 on HSH2.hardwareId=H2.id " +
      "join HardwareType HT on HT.id=H2.hardwareTypeId " +
      "join HardwareStatus HS2 on HS2.id=HSH2.hardwareStatusId " +
      "where HS2.isStatusValue=1 and HT.name='" + htype + "' ";
    if (expSN != null) {
      findHistoryRows += "and H2.lsstId+'" + expSN + "' ";
    }
    findHistoryRows += " group by HSH2.hardwareId) ";
    
    String sql="select H.id as hid,lsstId,  "
      + "remarks, model, manufacturer,manufacturerId, "
      + "HS.name as status from Hardware H "
      + "join HardwareStatusHistory HSH " 
      + "on H.id=HSH.hardwareId join HardwareStatus HS on "
      + "HS.id=HSH.hardwareStatusId where HSH.id in "
      + findHistoryRows + " order by hid";

    PreparedStatement stmt =
      m_connect.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE);
    ResultSet rs=stmt.executeQuery();
    boolean gotRow = rs.first();
    if (!gotRow) {
      String msg="No information for hardware type " + htype;
      if (expSN != null) {
        msg += " and experimentSN=" + expSN;
      }
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
      m_hlist.add(instance);
      gotRow = rs.relative(1);
    }
    return m_hlist;

  }
}
