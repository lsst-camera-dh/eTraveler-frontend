package eTraveler.getResults;

public class GetResultsUtil {

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
  
}
