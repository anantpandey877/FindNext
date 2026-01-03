package in.findnext.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import in.findnext.dbutils.DBConnection;
import in.findnext.models.JobPojo;
public class JobDAO {
	// Creates a new job posting in the database
	public static boolean postJob(JobPojo job) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "INSERT INTO jobs (title, description, skills, company, location, experience, package_lpa, vacancies, employer_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			ps = conn.prepareStatement(sql);
			ps.setString(1, job.getTitle());
			ps.setString(2, job.getDescription());
			ps.setString(3, job.getSkills());
			ps.setString(4, job.getCompany());
			ps.setString(5, job.getLocation());
			ps.setString(6, job.getExperience());
			ps.setString(7, job.getPackageLpa());
			ps.setInt(8, job.getVacancies());
			ps.setInt(9, job.getEmployerId());
			int ans = ps.executeUpdate();
			return ans > 0;
		} finally {
			ps.close();
		}
	}
	// Gets all jobs posted by a specific employer with filtering and sorting options
	public static List<JobPojo> getJobsByEmployer(int employerId, String search, String status, String sort)
			throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			List<JobPojo> list = new ArrayList<>();
			conn = DBConnection.getConnection();
			StringBuilder sql = new StringBuilder(
					"SELECT j.*, (SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) AS applicant_count "
							+ "FROM jobs j WHERE j.employer_id = ?");
			List<Object> params = new ArrayList<>();
			params.add(employerId);
			if (search != null && !search.trim().isEmpty()) {
				sql.append(" AND j.title LIKE ?");
				params.add("%" + search + "%");
			}
			if (status != null && !status.trim().isEmpty()) {
				sql.append(" AND j.status = ?");
				params.add(status);
			}
			if ("asc".equalsIgnoreCase(sort)) {
				sql.append(" ORDER BY applicant_count ASC");
			} else if ("desc".equalsIgnoreCase(sort)) {
				sql.append(" ORDER BY applicant_count DESC");
			} else {
				sql.append(" ORDER BY j.created_at DESC");
			}
			ps = conn.prepareStatement(sql.toString());
			for (int i = 0; i < params.size(); i++) {
				ps.setObject(i + 1, params.get(i));
			}
			rs = ps.executeQuery();
			while (rs.next()) {
				JobPojo job = new JobPojo();
				job.setId(rs.getInt("id"));
				job.setTitle(rs.getString("title"));
				job.setDescription(rs.getString("description"));
				job.setSkills(rs.getString("skills"));
				job.setCompany(rs.getString("company"));
				job.setLocation(rs.getString("location"));
				job.setExperience(rs.getString("experience"));
				job.setPackageLpa(rs.getString("package_lpa"));
				job.setVacancies(rs.getInt("vacancies"));
				job.setEmployerId(rs.getInt("employer_id"));
				job.setCreatedAt(rs.getTimestamp("created_at"));
				job.setStatus(rs.getString("status"));
				job.setApplicantCount(rs.getInt("applicant_count"));
				list.add(job);
			}
			return list;
		} finally {
			if (rs != null) {
				rs.close();
			}
			if (ps != null) {
				ps.close();
			}
		}
	}
	// Switches job status between active and inactive
	public static void toggleJobStatus(int jobId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			conn = DBConnection.getConnection();
			// Toggle: active <-> inactive
			String sql = "UPDATE jobs SET status = CASE WHEN status = 'active' THEN 'inactive' ELSE 'active' END WHERE id = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, jobId);
			ps.executeUpdate();
		} finally {
			if (ps != null) {
				ps.close();
			}
		}
	}
	// Fetches all jobs with their applicant count for admin panel
	public static List<JobPojo> getAllJobsWithEmployerAndApplicantCount() throws Exception {
	    Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    try {
	        conn = DBConnection.getConnection();
	        String sql = "SELECT j.*, " +
	                     "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) AS applicant_count " +
	                     "FROM jobs j";
	        ps = conn.prepareStatement(sql);
	        rs = ps.executeQuery();
	        List<JobPojo> jobs = new ArrayList<>();
	        while (rs.next()) {
	            JobPojo job = new JobPojo();
	            job.setId(rs.getInt("id"));
	            job.setTitle(rs.getString("title"));
	            job.setCompany(rs.getString("company"));
	            job.setLocation(rs.getString("location"));
	            job.setExperience(rs.getString("experience"));
	            job.setPackageLpa(rs.getString("package_lpa"));
	            job.setEmployerId(rs.getInt("employer_id"));
	            job.setApplicantCount(rs.getInt("applicant_count"));
	            job.setCreatedAt(rs.getTimestamp("created_at"));
	            job.setStatus(rs.getString("status"));
	            jobs.add(job);
	        }
	        return jobs;
	    } finally {
	        if (ps != null) {
				ps.close();
			}
	        if (rs != null) {
				rs.close();
			}
	    }
	}
	// Removes a job and all its applications from the database
	public static boolean deleteJob(int jobId) throws Exception {
		Connection conn = null;
		PreparedStatement ps1 = null;
		PreparedStatement ps2 = null;
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			String deleteAppsSql = "DELETE FROM applications WHERE job_id = ?";
			ps1 = conn.prepareStatement(deleteAppsSql);
			ps1.setInt(1, jobId);
			ps1.executeUpdate();
			String deleteJobSql = "DELETE FROM jobs WHERE id = ?";
			ps2 = conn.prepareStatement(deleteJobSql);
			ps2.setInt(1, jobId);
			int affectedRows = ps2.executeUpdate();
			conn.commit();
			return affectedRows > 0;
		} catch (Exception e) {
			if (conn != null) {
				conn.rollback();
			}
			throw e;
		} finally {
			if (ps1 != null) {
				ps1.close();
			}
			if (ps2 != null) {
				ps2.close();
			}
		}
	}
	// Gets active jobs for job seekers with search and filter options
	public static List<JobPojo> getAllJobsForUserDashboard(String search, String sort, String location,
			String experience, String packageLpa) throws Exception {
		List<JobPojo> jobs = new ArrayList<>();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			Connection conn = DBConnection.getConnection();
			StringBuilder sql = new StringBuilder(
					"SELECT j.*, " + "(SELECT COUNT(*) FROM applications a WHERE a.job_id = j.id) AS applicant_count "
							+ "FROM jobs j WHERE j.status = 'active'");
			List<Object> params = new ArrayList<>();
			if (search != null && !search.trim().isEmpty()) {
				sql.append(" AND (j.title LIKE ? OR j.company LIKE ?)");
				String keyword = "%" + search.trim() + "%";
				params.add(keyword);
				params.add(keyword);
			}
			if (location != null && !location.trim().isEmpty()) {
				sql.append(" AND j.location LIKE ?");
				params.add("%" + location.trim() + "%");
			}
			if (experience != null && !experience.trim().isEmpty()) {
				sql.append(" AND j.experience = ?");
				params.add(experience.trim());
			}
			if (packageLpa != null && !packageLpa.trim().isEmpty()) {
				sql.append(" AND j.package_lpa = ?");
				params.add(packageLpa.trim());
			}
			if ("asc".equalsIgnoreCase(sort)) {
				sql.append(" ORDER BY j.vacancies ASC");
			} else if ("desc".equalsIgnoreCase(sort)) {
				sql.append(" ORDER BY j.vacancies DESC");
			} else {
				sql.append(" ORDER BY j.created_at DESC");
			}
			ps = conn.prepareStatement(sql.toString());
			for (int i = 0; i < params.size(); i++) {
				ps.setObject(i + 1, params.get(i));
			}
			rs = ps.executeQuery();
			while (rs.next()) {
				JobPojo job = new JobPojo();
				job.setId(rs.getInt("id"));
				job.setTitle(rs.getString("title"));
				job.setDescription(rs.getString("description"));
				job.setSkills(rs.getString("skills"));
				job.setCompany(rs.getString("company"));
				job.setVacancies(rs.getInt("vacancies"));
				job.setEmployerId(rs.getInt("employer_id"));
				job.setCreatedAt(rs.getTimestamp("created_at"));
				job.setStatus(rs.getString("status"));
				job.setLocation(rs.getString("location"));
				job.setExperience(rs.getString("experience"));
				job.setPackageLpa(rs.getString("package_lpa"));
				job.setApplicantCount(rs.getInt("applicant_count"));
				jobs.add(job);
			}
			return jobs;
		} finally {
			if (rs != null) {
				rs.close();
			}
			if (ps != null) {
				ps.close();
			}
		}
	}
	// Retrieves detailed information about a specific job
	public static JobPojo getJobById(int jobId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			conn = DBConnection.getConnection();
			String sql = "SELECT * FROM jobs WHERE id = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, jobId);
			rs = ps.executeQuery();
			JobPojo job = null;
			if (rs.next()) {
				job = new JobPojo();
				job.setId(rs.getInt("id"));
				job.setTitle(rs.getString("title"));
				job.setDescription(rs.getString("description"));
				job.setSkills(rs.getString("skills"));
				job.setCompany(rs.getString("company"));
				job.setLocation(rs.getString("location"));
				job.setExperience(rs.getString("experience"));
				job.setPackageLpa(rs.getString("package_lpa"));
				job.setVacancies(rs.getInt("vacancies"));
				job.setEmployerId(rs.getInt("employer_id"));
				job.setCreatedAt(rs.getTimestamp("created_at"));
				job.setStatus(rs.getString("status"));
			}
			return job;
		} finally {
			rs.close();
			ps.close();
		}
	}
}

