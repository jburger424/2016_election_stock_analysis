/**
 * Created by Jon on 12/5/16.
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Arrays;

//http://www.sqlitetutorial.net/sqlite-java/insert/
public class Insert {
    /**
     *
     * @return the Connection object
     */

    private Connection connect() {
        // SQLite connection string
        try{
            Class.forName("org.sqlite.JDBC");
        }
        catch (Exception e){
            e.printStackTrace();
        }

//needed to include https://github.com/xerial/sqlite-jdbc
        String url = "jdbc:sqlite:/Users/Jon/Google_Drive/comp321/stock-election-db/data.sqlite";
        Connection conn = null;

        try {
            conn = DriverManager.getConnection(url);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conn;
    }

    /**
     * Insert a new row into the warehouses table
     *
     * @param dbName
     * @param headers
     * @param data
     */
    public void insert(String dbName, String[] headers, String[][] data, int numRows, int numCols) {
        String headersString = String.join(",", headers);
        String[] qArray = new String[numCols];
        Arrays.fill(qArray, "?");
        String sql = "INSERT INTO "+dbName+"("+String.join(",", headersString)+") VALUES("+String.join(",",qArray)+")";

        System.out.println(sql);

        try (Connection conn = this.connect();
             PreparedStatement statement = conn.prepareStatement(sql)) {
            int i = 0;

            for (int row = 0; row < numRows; row++) {
                for (int col = 0; col < numCols; col++) {
                    //System.out.println("numCols: "+numCols+" numRows: "+numRows+" col: "+col+" row: "+row);
                    statement.setString(col+1, data[row][col]);
                }
                statement.addBatch();

                i++;

                if (i % 1000 == 0 || i == numRows) {
                    statement.executeBatch(); // Execute every 1000 items.
                }
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
