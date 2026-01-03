/** FindNext - ViewApplicantsServlet */
package in.findnext.servlets;

import java.io.IOException;
import java.util.List;

import in.findnext.dao.ApplicationDAO;
import in.findnext.dao.JobDAO;
import in.findnext.models.ApplicationPojo;
import in.findnext.models.JobPojo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/view-applicants")
public class ViewApplicantsServlet extends HttpServlet {
	// Shows all applicants for a specific job posting with filtering options
    @Override
	protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"employer".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("signin");
            return;
        }

        try {
            String jobIdParam = req.getParameter("jobId");

            if (jobIdParam == null || jobIdParam.trim().isEmpty()) {
                req.setAttribute("errorMessage", "Job ID is missing");
                req.setAttribute("userRole", session.getAttribute("userRole"));
                req.getRequestDispatcher("error.jsp").forward(req, res);
                return;
            }

            int jobId;
            try {
                jobId = Integer.parseInt(jobIdParam);
            } catch (NumberFormatException e) {
                req.setAttribute("errorMessage", "Invalid Job ID format");
                req.setAttribute("userRole", session.getAttribute("userRole"));
                req.getRequestDispatcher("error.jsp").forward(req, res);
                return;
            }

            String status = req.getParameter("status");

            JobPojo job = JobDAO.getJobById(jobId);
            if (job == null) {
                req.setAttribute("errorMessage", "Job not found or you don't have permission to view it");
                req.setAttribute("userRole", session.getAttribute("userRole"));
                req.getRequestDispatcher("error.jsp").forward(req, res);
                return;
            }

            List<ApplicationPojo> applicants;
            if (status != null && !status.isEmpty()) {

                applicants = ApplicationDAO.getApplicationsByJobAndStatus(jobId, status);
            } else {

                applicants = ApplicationDAO.getApplicationsByJob(jobId);
            }

            req.setAttribute("job", job);
            req.setAttribute("applicants", applicants);
            req.setAttribute("selectedStatus", status);

            req.getRequestDispatcher("viewApplicants.jsp").forward(req, res);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "An error occurred while fetching applicants: " + e.getMessage());
            req.setAttribute("userRole", session.getAttribute("userRole"));
            req.getRequestDispatcher("error.jsp").forward(req, res);
        }
    }
}

