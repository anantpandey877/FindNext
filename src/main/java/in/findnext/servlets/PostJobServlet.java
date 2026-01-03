/** FindNext - PostJobServlet */
package in.findnext.servlets;

import java.io.IOException;

import in.findnext.dao.JobDAO;
import in.findnext.models.JobPojo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/post-job")
public class PostJobServlet extends HttpServlet {
	// Creates a new job posting from employer's dashboard
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession session = req.getSession(false);

		if (session == null || session.getAttribute("userId") == null
				|| !"employer".equals(session.getAttribute("userRole"))) {
			res.sendRedirect("signin");
			return;
		}

		try {
			int employerId = (int) session.getAttribute("userId");

			String title = req.getParameter("title");
			String description = req.getParameter("description");
			String skills = req.getParameter("skills");
			String company = req.getParameter("company");
			String location = req.getParameter("location");
			String experience = req.getParameter("experience");
			String packageLpa = req.getParameter("packageLpa");
			int vacancies = Integer.parseInt(req.getParameter("vacancies"));

			JobPojo job = new JobPojo();
			job.setTitle(title);
			job.setDescription(description);
			job.setSkills(skills);
			job.setCompany(company);
			job.setLocation(location);
			job.setExperience(experience);
			job.setPackageLpa(packageLpa);
			job.setVacancies(vacancies);
			job.setEmployerId(employerId);

			boolean ans = JobDAO.postJob(job);
			if (ans) {
				res.sendRedirect("employerDashboard?success=1");
			} else {
				res.sendRedirect("employerDashboard?error=1");
			}

		} catch (Exception e) {
			e.printStackTrace();
			res.sendRedirect("employerDashboard?error=1");
		}
	}
}

