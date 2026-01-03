/** FindNext - RemoveJobServlet */
package in.findnext.servlets;

import java.io.IOException;

import in.findnext.dao.JobDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/remove-job")
public class RemoveJobServlet extends HttpServlet {
	// Deletes a job posting from the system permanently
    @Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        int jobId = Integer.parseInt(req.getParameter("jobId"));
        try {
            JobDAO.deleteJob(jobId);
            res.sendRedirect("adminPanel");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("error.jsp");
        }
    }
}

