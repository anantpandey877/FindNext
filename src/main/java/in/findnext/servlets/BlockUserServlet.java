/** FindNext - BlockUserServlet */
package in.findnext.servlets;

import java.io.IOException;

import in.findnext.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/block-user")
public class BlockUserServlet extends HttpServlet {
	// Blocks a user account when admin takes action
    @Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int userId = Integer.parseInt(req.getParameter("userId"));
        try {
            UserDAO.updateStatus(userId, "blocked");

            res.sendRedirect("adminPanel");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("error.jsp");
        }
    }
}

