/** FindNext - UpdateApplicationStatusServlet */
package in.findnext.servlets;

import java.io.IOException;

import in.findnext.dao.ApplicationDAO;
import in.findnext.dao.JobDAO;
import in.findnext.dao.UserDAO;
import in.findnext.models.JobPojo;
import in.findnext.models.UserPojo;
import in.findnext.utils.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/update-status")
public class UpdateApplicationStatusServlet extends HttpServlet {
	// Changes application status and notifies job seeker via email
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null ||
            !"employer".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("signin");
            return;
        }

        try {
            int appId = Integer.parseInt(req.getParameter("appId"));
            String newStatus = req.getParameter("status");
            int jobId = Integer.parseInt(req.getParameter("jobId"));

            if (!newStatus.equals("shortlisted") && !newStatus.equals("rejected")) {
                res.sendRedirect("view-applicants?jobId=" + jobId + "&error=invalid_status");
                return;
            }

            boolean updated = ApplicationDAO.updateApplicationStatus(appId, newStatus);
            if (updated) {
            	// Get job seeker details from application
            	int jobSeekerId = ApplicationDAO.getUserIdByApplicationId(appId);
            	UserPojo jobSeeker = UserDAO.getUserById(jobSeekerId);
            	JobPojo job = JobDAO.getJobById(jobId);
            	// Send email to job seeker about status change
            	MailUtil.sendApplicationStatusUpdate(jobSeeker.getName(), jobSeeker.getEmail(), job.getTitle(), job.getCompany(), newStatus);

                res.sendRedirect("view-applicants?jobId=" + jobId);
            } else {
                res.sendRedirect("view-applicants?jobId=" + jobId + "&error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("signin");
        }
    }
}

