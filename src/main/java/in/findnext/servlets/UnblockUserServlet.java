/** FindNext - UnblockUserServlet */
package in.findnext.servlets;

import java.io.IOException;

import in.findnext.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/unblock-user")
public class UnblockUserServlet extends HttpServlet {
	// Reactivates a blocked user account when admin approves
    @Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        try {
            UserDAO.updateStatus(userId, "active");
            res.sendRedirect("adminPanel");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("error.jsp");
        }
    }
}

