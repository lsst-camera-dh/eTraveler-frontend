package eTraveler.getResults;
import java.util.HashMap;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *  Knows how to store a row from a result set in destination data structure
 *  dest
 */
public interface RowStorer {
  public boolean storeRow(ResultSet rs, HashMap<String, Object> dest)
    throws SQLException, GetResultsException;
}
