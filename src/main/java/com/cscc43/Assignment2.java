// REMOVE PACKAGE AND SUBMIT IN THE END
package com.cscc43;
import org.postgresql.util.PSQLException;

import java.sql.*;

public class Assignment2 {
    
    // A connection to the database  
    Connection connection;
  
    // Statement to run queries
    Statement sql = null;
  
    // Prepared Statement
    PreparedStatement ps = null;
  
    // ResultSet for the query
    ResultSet rs;

    // insert player query
    private static final String INSERT_PLAYER = "INSERT INTO player VALUES (?, ?, ?, ?)";
    //CONSTRUCTOR
    Assignment2() throws ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
    }
  
    /*
     * Using the input parameters, establish a connection to be used for this session.
     * Returns true if connection is successful
     */
    public boolean connectDB(String URL, String username, String password) {
        boolean result = false;
        try {
            connection = DriverManager.getConnection(URL, username, password);
            sql = connection.createStatement();
            sql.execute("SET search_path TO A2");
            result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
  
    // Closes the connection. Returns true if closure was successful
    public boolean disconnectDB() {
        boolean result = false;
        try {
            sql.close();
            connection.close();
            result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public boolean insertPlayer(int pid, String pname, int globalRank, int cid) {
        boolean result = false;
        try {
            ps = connection.prepareStatement("INSERT INTO player VALUES (?, ?, ?, ?)");
            ps.setInt(1, pid);
            ps.setString(2, pname);
            ps.setInt(3, globalRank);
            ps.setInt(4, cid);
            ps.executeUpdate();
            result = true;
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
  
    public int getChampions(int pid) {
        int result = 0;
        try {
            ps = connection.prepareStatement("SELECT count(*) FROM champion WHERE pid = ?");
            ps.setInt(1, pid);
            rs = ps.executeQuery();
            if (rs.next()) {
                result = rs.getInt("count");
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
   
    public String getCourtInfo(int courtid) {
        String result = "";
        try {
            ps = connection.prepareStatement("SELECT * FROM court WHERE courtid = ?");
            ps.setInt(1, courtid);
            rs = ps.executeQuery();
            if (rs.next()) {
                result += courtid + ":" + rs.getString(2) + ":"
                        + rs.getString(3) + ":" + rs.getString(4);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean chgRecord(int pid, int year, int wins, int losses) {
        boolean result = false;
        try {
            ps = connection.prepareStatement("UPDATE record SET wins = ?, losses = ? " +
                    "WHERE pid = ? AND year = ?");
            ps.setInt(1, wins);
            ps.setInt(2, losses);
            ps.setInt(3, pid);
            ps.setInt(4, year);
            if (ps.executeUpdate() != 0) { // not sure if this check is supposed to be here
                result = true;
            }
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean deleteMatchBetween(int p1id, int p2id) {
        boolean result = false;
        try {
            ps = connection.prepareStatement("DELETE FROM event WHERE winid = ? AND lossid = ?" +
                    "OR winid = ? AND lossid = ?");
            ps.setInt(1, p1id);
            ps.setInt(2, p2id);
            ps.setInt(3, p2id);
            ps.setInt(4, p1id);
            if (ps.executeUpdate() != 0) { // also not sure if this needs to be included
                result = true;
            }
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public String listPlayerRanking() {
        String result = "";
        try {
            rs = sql.executeQuery("SELECT pname, globalrank FROM player ORDER BY globalrank DESC");
            while (rs.next()) {
                if (!result.equals("")) {
                    result += "\n";
                }
                result += rs.getString(1) + ":" + rs.getString(2);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
  
    public int findTriCircle() {
        int result = 0;
        try {
            String allTriCicleQueryWithOrder = "SELECT DISTINCT e1.winid, e2.winid, e3.winid " +
                    "FROM event e1, event e2, event e3 " +
                    "WHERE e1.winid = e3.lossid AND e1.lossid = e2.winid AND e2.lossid = e3.winid";
            rs = sql.executeQuery("SELECT count(*)/3 FROM (" + allTriCicleQueryWithOrder + ") tri");
            if (rs.next()) {
                result = rs.getInt(1);
            }
            rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public boolean updateDB() {
        boolean result = false;
        try {
            sql.executeUpdate("DROP TABLE IF EXISTS championPlayers");
            sql.executeUpdate("CREATE TABLE championPlayers" +
                    "(pid INTEGER, pname VARCHAR, nchampions INTEGER)");
            sql.executeUpdate("INSERT INTO championPlayers " +
                    "(SELECT p.pid, pname, count(tid)" +
                    "FROM player p LEFT JOIN champion c " +
                    "ON p.pid = c.pid " +
                    "GROUP BY p.pid, pname " +
                    "ORDER BY p.pid)");
            result = true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

}
