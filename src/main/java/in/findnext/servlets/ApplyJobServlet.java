/** FindNext - ApplyJobServlet */
package in.findnext.servlets;

import java.io.IOException;
import java.util.List;

import in.findnext.dao.ApplicationDAO;
import in.findnext.dao.JobDAO;
import in.findnext.dao.ResumeAnalysisLogDAO;
import in.findnext.dao.UserDAO;
import in.findnext.models.ApplicationPojo;
import in.findnext.models.JobPojo;
import in.findnext.models.ResumeAnalysisLogPojo;
import in.findnext.models.UserPojo;
import in.findnext.utils.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/apply")
public class ApplyJobServlet extends HttpServlet {
    @Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null || !"user".equals(session.getAttribute("userRole"))) {
            res.sendRedirect("signin");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int jobId = Integer.parseInt(req.getParameter("jobId"));
        double score = Double.parseDouble(req.getParameter("score"));

        try {

            if (ApplicationDAO.hasAlreadyApplied(userId, jobId)) {
                res.sendRedirect("userDashboard?applied=1");
                return;
            }

            String resumePath = "N/A";
            List<ResumeAnalysisLogPojo> logs = ResumeAnalysisLogDAO.getLogsByUser(userId);
            if (!logs.isEmpty()) {
                String resultJson = logs.get(0).getResultJson();
                org.json.JSONObject obj = new org.json.JSONObject(resultJson);
                org.json.JSONObject data = obj.optJSONObject("data");
                if (data != null) {
                    resumePath = data.optString("resumePath", "N/A");
                } else {

                    resumePath = obj.optString("resumePath", "N/A");
                }
            }

            ApplicationPojo app = new ApplicationPojo(0, userId, jobId, resumePath, score, "applied", null);
            boolean applied = ApplicationDAO.apply(app);
            if (!applied) {

                res.sendRedirect("userDashboard?error=apply_failed");
                return;
            }
            UserPojo user = UserDAO.getUserById(userId);
            JobPojo job = JobDAO.getJobById(jobId);
            MailUtil.sendApplicationConfirmation(user.getName(), user.getEmail(), job.getTitle(), job.getCompany());
            UserPojo user2 = UserDAO.getUserById(job.getEmployerId());
            MailUtil.sendNewApplicationNotificationToEmployer(user2.getName(), user2.getEmail(),user.getName(),job.getTitle());

            res.sendRedirect("userDashboard?applied=1");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("userDashboard?error=apply_failed");
        }
    }
}

