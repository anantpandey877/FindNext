package in.findnext.dbutils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// FindNext - Database Connection Utility
// Manages MySQL database connection for the entire application
public class DBConnection {

	private static Connection conn;

	// Establishes a connection to the MySQL database
	public static void openConnection(String url, String username, String password) {
		try {
			conn = DriverManager.getConnection(url, username, password);
			System.out.println("Connection opened successfully");
		} catch (SQLException ex) {
			ex.printStackTrace();
		}

	}

	// Returns the active database connection
	public static Connection getConnection() throws SQLException {
		if (conn == null) {
			throw new SQLException("Connection is null");
		}
		return conn;
	}

	// Closes the database connection when application shuts down
	public static void closeConnection() {

		if (conn != null) {
			try {
				conn.close();
			} catch (SQLException ex) {
				ex.printStackTrace();
			}
		}

	}

}

