package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.HashSet;
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
      + " where H.id in " GetResultsUtil.seqToSqlList(hidSet)
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
}
