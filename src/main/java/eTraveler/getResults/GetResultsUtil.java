package eTraveler.getResults;

public class GetResultsUtil {
  /**
   *  Assumes Activity has alias A
   */
  private static final String s_activityStatusJoins="join ActivityStatusHistory ASH on A.id=ASH.activityId join ActivityFinalStatus on ActivityFinalStatus.id=ASH.activityStatusId";
  private static final String s_activityStatusCondition="ActivityFinalStatus.name='success'";

  public static String getActivityStatusJoins() {return s_activityStatusJoins;}
  public static String getActivityStatusCondition() {return s_activityStatusCondition;}
  
  /**
     Argument should be string representation of either a valid
     positive integer or valid positive integer followed by one
     non-numeric character, such as "1234D"
     Return integer equivalent, ignoring final non-numeric character
     if there is one.
   */
  public static int formRunInt(String st) throws GetResultsException {
    int theInt;
    try {
      theInt = Integer.parseInt(st);
      } catch (NumberFormatException e) {
      try {
        theInt = Integer.parseInt(st.substring(0, st.length() -1));
      }  catch (NumberFormatException e2) {
        throw new GetResultsException("Supplied run value " + st +
                                        " is not valid");
      }
      if (theInt < 1) {
        throw new GetResultsException("Supplied run value " + st +
                                        " is not valid");
      }
    }
    return theInt;
  }

  /* This subquery is used to find possibly interesting traveler root ids */
  public static String hidSubquery(String hardwareType, String expSN,
                                   String model) {
    String subq = "select H2.id as hid2 from Hardware H2 join HardwareType HT on H2.hardwareTypeId=HT.id where HT.name='" + hardwareType + "'";
    if (expSN != null) {
      subq += " and H2.lsstId='" + expSN + "'";
    } else if (model != null) {
      subq += " and H2.model='" + model + "'";
    }
    return subq;
  }
  
  
}
