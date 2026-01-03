/** FindNext - UserDashboardServlet */
package in.findnext.servlets;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.json.JSONObject;

import in.findnext.dao.ApplicationDAO;
import in.findnext.dao.JobDAO;
import in.findnext.dao.ResumeAnalysisLogDAO;
import in.findnext.models.ApplicationPojo;
import in.findnext.models.JobPojo;
import in.findnext.models.ResumeAnalysisLogPojo;
import in.findnext.utils.AffindaAPI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/userDashboard")
public class UserDashboardServlet extends HttpServlet {
	// Displays job seeker's dashboard with available jobs and application status
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("signin");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        String location = request.getParameter("location");
        String experience = request.getParameter("experience");
        String packageLpa = request.getParameter("packageLpa");

        try {

            List<ResumeAnalysisLogPojo> logs = ResumeAnalysisLogDAO.getLogsByUser(userId);
            boolean resumeUploaded = !logs.isEmpty();
            List<String> userSkills = null;

            if (resumeUploaded) {
                JSONObject obj = new JSONObject(logs.get(0).getResultJson());
                userSkills = AffindaAPI.extractSkills(obj.toString());
            }

            List<JobPojo> jobs = JobDAO.getAllJobsForUserDashboard(search, sort, location, experience, packageLpa);

            if (resumeUploaded && userSkills != null) {
                for (JobPojo job : jobs) {
                    int score = AffindaAPI.calculateMatchScore(job.getSkills(), userSkills);
                    job.setScore(score);
                }
            }

            List<ApplicationPojo> appliedList = ApplicationDAO.getApplicationsByUser(userId);
            Set<Integer> appliedJobIds = new HashSet<>();
            java.util.Map<Integer, String> jobStatusMap = new java.util.HashMap<>();

            for (ApplicationPojo app : appliedList) {
                appliedJobIds.add(app.getJobId());
                jobStatusMap.put(app.getJobId(), app.getStatus());
            }

            request.setAttribute("jobs", jobs);
            request.setAttribute("appliedJobIds", appliedJobIds);
            request.setAttribute("jobStatusMap", jobStatusMap);
            request.setAttribute("applicationsList", appliedList);
            request.setAttribute("search", search);
            request.setAttribute("sort", sort);
            request.setAttribute("location", location);
            request.setAttribute("experience", experience);
            request.setAttribute("packageLpa", packageLpa);
            request.setAttribute("resumeUploaded", resumeUploaded);

            request.getRequestDispatcher("userDashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("signin");
        }
    }
}

