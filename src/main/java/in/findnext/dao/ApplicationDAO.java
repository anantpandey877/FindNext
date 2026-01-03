package in.findnext.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import in.findnext.dbutils.DBConnection;
import in.findnext.models.ApplicationPojo;
public class ApplicationDAO {
	// Submits a new job application to the database
	public static boolean apply(ApplicationPojo app) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "INSERT INTO applications(user_id, job_id, resume_path, score) VALUES (?, ?, ?, ?)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, app.getUserId());
			ps.setInt(2, app.getJobId());
			ps.setString(3, app.getResumePath());
			ps.setDouble(4, app.getScore());
			int ans = ps.executeUpdate();
			return ans > 0;
		} finally {
			if (ps != null) {
				ps.close();
			}
		}
	}
	// Checks if a user has already applied to a specific job
	public static boolean hasAlreadyApplied(int userId, int jobId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "SELECT COUNT(*) FROM applications WHERE user_id = ? AND job_id = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);
			ps.setInt(2, jobId);
			rs = ps.executeQuery();
			boolean exists = false;
			if (rs.next()) {
				exists = rs.getInt(1) > 0;
			}
			return exists;
		} finally {
			if (ps != null)
				ps.close();
			if (rs != null)
				rs.close();
		}
	}
	// Gets all applications submitted by a particular user
	public static List<ApplicationPojo> getApplicationsByUser(int userId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			List<ApplicationPojo> list = new ArrayList<>();
			conn = DBConnection.getConnection();
			String sql = "SELECT * FROM applications WHERE user_id=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, userId);
			rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new ApplicationPojo(
						rs.getInt("id"),
						rs.getInt("user_id"),
						rs.getInt("job_id"),
						rs.getString("resume_path"),
						rs.getFloat("score"),
						rs.getString("status"),
						rs.getString("applied_at")
						));
			}
			return list;
		} finally {
			if (ps != null) {
				ps.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
	}
	// Retrieves all applications for a specific job, sorted by match score
	public static List<ApplicationPojo> getApplicationsByJob(int jobId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			List<ApplicationPojo> list = new ArrayList<>();
			conn = DBConnection.getConnection();
			String sql = "SELECT * FROM applications WHERE job_id = ? ORDER BY score DESC";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, jobId);
			rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new ApplicationPojo(
						rs.getInt("id"),
						rs.getInt("user_id"),
						rs.getInt("job_id"),
						rs.getString("resume_path"),
						rs.getFloat("score"),
						rs.getString("status"),
						rs.getString("applied_at")
						));
			}
			return list;
		} finally {
			if (ps != null) {
				ps.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
	}
	// Filters applications by job and status like applied, shortlisted, or rejected
	public static List<ApplicationPojo> getApplicationsByJobAndStatus(int jobId, String status) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			List<ApplicationPojo> list = new ArrayList<>();
			conn = DBConnection.getConnection();
			String sql = "SELECT * FROM applications WHERE job_id = ? AND status = ? ORDER BY score DESC";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, jobId);
			ps.setString(2, status);
			rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new ApplicationPojo(
						rs.getInt("id"),
						rs.getInt("user_id"),
						rs.getInt("job_id"),
						rs.getString("resume_path"),
						rs.getFloat("score"),
						rs.getString("status"),
						rs.getString("applied_at")
						));
			}
			return list;
		} finally {
			if (ps != null) {
				ps.close();
			}
			if (rs != null) {
				rs.close();
			}
		}
	}
	// Changes the status of an application when employer takes action
	public static boolean updateApplicationStatus(int appId, String status) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "UPDATE applications SET status = ? WHERE id = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, status);
			ps.setInt(2, appId);
			int rows = ps.executeUpdate();
			return rows > 0;
		} finally {
			if (ps != null) {
				ps.close();
			}
		}
	}
	// Updates resume path for all user's applications when they upload a new resume
	public static boolean updateResumePathForUser(int userId, String newResumePath) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "UPDATE applications SET resume_path = ? WHERE user_id = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, newResumePath);
			ps.setInt(2, userId);
			int rows = ps.executeUpdate();
			return rows >= 0;
		} finally {
			if (ps != null) {
				ps.close();
			}
		}
	}

	// Recalculates and updates the match score for an application
	public static boolean updateApplicationScore(int applicationId, int newScore) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "UPDATE applications SET score = ? WHERE id = ?";
			ps = conn.prepareStatement(sql);
			ps.setDouble(1, newScore);
			ps.setInt(2, applicationId);
			int rows = ps.executeUpdate();
			return rows > 0;
		} finally {
			if (ps != null) {
				ps.close();
			}
		}
	}

	// Finds which user submitted a particular application
	public static int getUserIdByApplicationId(int applicationId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "SELECT user_id FROM applications WHERE id = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, applicationId);
			rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt("user_id");
			}
			return 0;
		} finally {
			if (rs != null) rs.close();
			if (ps != null) ps.close();
		}
	}
}

