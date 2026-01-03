/** FindNext - UserDAO */
package in.findnext.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import in.findnext.dbutils.DBConnection;
import in.findnext.models.UserPojo;

public class UserDAO {

    // Saves a new user to the database during registration
    public static int registerUser(UserPojo user) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            return ps.executeUpdate();
        } finally {
            if (ps != null) {
				ps.close();
			}
        }
    }

    // Finds and returns a user by their email address
    public static UserPojo getUserByEmail(String email) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE email=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new UserPojo(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("status"),
                    rs.getDate("created_at")
                );
            }
            return null;
        } finally {
            if (rs != null) {
				rs.close();
			}
            if (ps != null) {
				ps.close();
			}
        }
    }

    // Fetches user details using their unique user ID
    public static UserPojo getUserById(int userId) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                return new UserPojo(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("status"),
                    rs.getDate("created_at")
                );
            }
            return null;
        } finally {
            if (rs != null) {
				rs.close();
			}
            if (ps != null) {
				ps.close();
			}
        }
    }

    // Checks if an email is already registered in the system
    public static boolean isEmailExists(String email) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM users WHERE email=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
        }
    }

    // Updates the password for a user when they reset it
    public static boolean updatePassword(String email, String newPassword) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET password=? WHERE email=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } finally {
            if (ps != null) ps.close();
        }
    }

    // Retrieves all users from the database for admin panel
    public static List<UserPojo> getAllUsers() throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<UserPojo> list = new ArrayList<>();

        try {
            conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users ORDER BY id DESC";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new UserPojo(
                    rs.getInt("id"),
                    rs.getString("name"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("role"),
                    rs.getString("status"),
                    rs.getDate("created_at")
                ));
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

    // Changes a user's account status to active or blocked
    public static int updateStatus(int userId, String status) throws Exception {
        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBConnection.getConnection();
            String sql = "UPDATE users SET status=? WHERE id=?";
            ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        } finally {
            if (ps != null) {
				ps.close();
			}
        }
    }

    // Searches and filters users based on name, role, and status criteria
    public static List<UserPojo> getFilteredUsers(String search, String role, String status) {
        List<UserPojo> users = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            StringBuilder query = new StringBuilder("SELECT * FROM users WHERE role != 'admin'");
            if (search != null && !search.trim().isEmpty()) {
                query.append(" AND (name LIKE ? OR email LIKE ?)");
            }
            if (role != null && !role.trim().isEmpty() && !role.equalsIgnoreCase("all")) {
                query.append(" AND role = ?");
            }
            if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("all")) {
                query.append(" AND status = ?");
            }

            query.append(" ORDER BY created_at DESC");

            ps = conn.prepareStatement(query.toString());
            int index = 1;
            if (search != null && !search.trim().isEmpty()) {
                ps.setString(index++, "%" + search.trim() + "%");
                ps.setString(index++, "%" + search.trim() + "%");
            }
            if (role != null && !role.trim().isEmpty() && !role.equalsIgnoreCase("all")) {
                ps.setString(index++, role);
            }
            if (status != null && !status.trim().isEmpty() && !status.equalsIgnoreCase("all")) {
                ps.setString(index++, status);
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                UserPojo user = new UserPojo();
                user.setId(rs.getInt("id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                users.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return users;
    }

}
