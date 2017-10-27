package eTraveler.getResults;

import java.util.Map;
import java.util.HashMap;

import java.lang.Comparable;

public class ComparableNCR extends  HashMap<String, Object>
  implements Comparable<ComparableNCR> {

  public boolean verify() {
    if (containsKey("hardwareType") && containsKey("experimentSN") ) {
      try {
        Integer level = (Integer)get("level");
        Integer NCRnumber = (Integer)get("NCRnumber");
        return true;
      } catch (NumberFormatException ex) {
        return false;
      }
    }
    return false;
  }
  public int compareTo(ComparableNCR other) {
    int cmp =
      ((Integer)get("level")).compareTo((Integer)other.get("level"));
    if (cmp != 0) return cmp;
    cmp =
      ((String)get("hardwareType")).compareTo((String)other.get("hardwareType"));
    if (cmp != 0 ) return cmp;
    cmp =
      ((String)get("experimentSN")).compareTo((String)other.get("experimentSN"));
    if (cmp != 0 ) return cmp;
    return ((Integer)get("NCRnumber")).compareTo((Integer)other.get("NCRnumber"));

  }
}
