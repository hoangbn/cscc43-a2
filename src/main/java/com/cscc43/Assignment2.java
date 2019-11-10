// REMOVE PACKAGE IN THE END
package com.cscc43;
import java.sql.*;

public class Assignment2 {
    
    // A connection to the database  
    Connection connection;
  
    // Statement to run queries
    Statement sql;
  
    // Prepared Statement
    PreparedStatement ps;
  
    // ResultSet for the query
    ResultSet rs;
  
    //CONSTRUCTOR
    Assignment2() {
        try {
            Class.forName("org.postgresql.Driver");
        }
        catch (ClassNotFoundException e) {
            System.out.println("Failed to find the JDBC driver");
        }
    }
  
    /*
     * Using the input parameters, establish a connection to be used for this session.
     * Returns true if connection is successful
     */
    public boolean connectDB(String URL, String username, String password) {
        boolean result = true;
        try {
            connection = DriverManager.getConnection(URL, username, password);
        } catch (SQLException e) {
            e.printStackTrace();
            result = false;
        }
        return result;
    }
  
    // Closes the connection. Returns true if closure was successful
    public boolean disconnectDB() {
        boolean result = true;
        try {
            connection.close();
        } catch (SQLException e) {
            result = false;
        }
        return result;
    }
    
    public boolean insertPlayer(int pid, String pname, int globalRank, int cid) {
        boolean result = false;
        
        return result;
    }
  
    public int getChampions(int pid) {
	      return 0;  
    }
   
    public String getCourtInfo(int courtid) {
        return "";
    }

    public boolean chgRecord(int pid, int year, int wins, int losses) {
        return false;
    }

    public boolean deleteMatcBetween(int p1id, int p2id) {
        return false;        
    }
  
    public String listPlayerRanking() {
	      return "";
    }
  
    public int findTriCircle() {
        return 0;
    }
    
    public boolean updateDB(){
	      return false;    
    }
    
    public static void main(String[] args) {
      System.out.println("Started");
  }
}
