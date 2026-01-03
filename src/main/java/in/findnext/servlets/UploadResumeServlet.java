/** FindNext - UploadResumeServlet */

package in.findnext.servlets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.List;

import org.json.JSONObject;

import in.findnext.dao.ResumeAnalysisLogDAO;
import in.findnext.dao.ApplicationDAO;
import in.findnext.dao.JobDAO;
import in.findnext.dao.UserDAO;
import in.findnext.models.ApplicationPojo;
import in.findnext.models.JobPojo;
import in.findnext.models.UserPojo;
import in.findnext.models.ResumeAnalysisLogPojo;
import in.findnext.utils.AffindaAPI;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/upload-resume")
@MultipartConfig
public class UploadResumeServlet extends HttpServlet {
	// Handles resume upload and job application submission
    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("signin");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        Part filePart = request.getPart("resume");
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

        String uploadDir = "D:/HireSense_Resumes";
        File dir = new File(uploadDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        String uniqueFileName = "user_" + userId + "_" + fileName;
        File resumeFile = new File(dir, uniqueFileName);

        try {
            List<ResumeAnalysisLogPojo> logs = ResumeAnalysisLogDAO.getLogsByUser(userId);
            if (!logs.isEmpty()) {
                String prevJson = logs.get(0).getResultJson();
                JSONObject obj = new JSONObject(prevJson);
                JSONObject dataObj = obj.optJSONObject("data");
                String prevPath = null;
                if (dataObj != null) {
                    prevPath = dataObj.optString("resumePath", null);
                } else {
                    prevPath = obj.optString("resumePath", null);
                }
                if (prevPath != null) {
                    File oldFile = new File(prevPath);
                    if (oldFile.exists()) {
						oldFile.delete();
					}
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        try (InputStream input = filePart.getInputStream(); FileOutputStream out = new FileOutputStream(resumeFile)) {
            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }

        // --- Resume analysis (Affinda) with safe fallback ---
        JSONObject result;
        try {
            String resultJson = AffindaAPI.analyzeResume(resumeFile);
            result = new JSONObject(resultJson);
        } catch (Exception e) {
            // Typical case: java.net.UnknownHostException when DNS/network is blocked.
            e.printStackTrace();

            result = new JSONObject();
            JSONObject data = new JSONObject();
            data.put("skills", new org.json.JSONArray());
            data.put("name", "Unknown");
            data.put("email", "");
            data.put("phone", "");
            data.put("totalYearsExperience", 0);
            result.put("data", data);
            result.put("fallback", true);
            result.put("error", e.getClass().getSimpleName() + ": " + e.getMessage());

            session.setAttribute("resume_analysis_error",
                    "Resume uploaded, but external analysis is currently unavailable (" + e.getClass().getSimpleName() + "). Match score will be 0 until analysis is available.");
        }

        try {
            JSONObject data = result.optJSONObject("data");
            boolean fallbackDataCreated = false;
            if (data == null) {
                fallbackDataCreated = true;
                data = new JSONObject();
                data.put("skills", new org.json.JSONArray());
                result.put("data", data);
            }
            data.put("resumePath", resumeFile.getAbsolutePath());
            result.put("data", data);
            ResumeAnalysisLogDAO.saveLog(userId, result.toString());

            if (fallbackDataCreated) {
                System.err.println("Affinda analyzeResume returned no 'data' for userId=" + userId + ". Response: " + result);
                session.setAttribute("resume_analysis_error", "Resume uploaded but external analysis returned no data. Saved minimal record.");
            }

            String jobIdStr = request.getParameter("jobId");
            if (jobIdStr != null && !jobIdStr.isEmpty()) {
                try {
                    int jobId = Integer.parseInt(jobIdStr);

                    if (!ApplicationDAO.hasAlreadyApplied(userId, jobId)) {

                        String savedResultJson = result.toString();
                        List<String> userSkills = AffindaAPI.extractSkills(savedResultJson);
                        JobPojo job = JobDAO.getJobById(jobId);
                        int score = AffindaAPI.calculateMatchScore(job.getSkills(), userSkills);

                        String resumePath = resumeFile.getAbsolutePath();
                        ApplicationPojo app = new ApplicationPojo(0, userId, jobId, resumePath, score, "applied", null);
                        boolean applied = ApplicationDAO.apply(app);
                        if (applied) {

                            try {
                                UserPojo user = UserDAO.getUserById(userId);
                                UserPojo employer = UserDAO.getUserById(job.getEmployerId());
                                in.findnext.utils.MailUtil.sendApplicationConfirmation(user.getName(), user.getEmail(), job.getTitle(), job.getCompany());
                                in.findnext.utils.MailUtil.sendNewApplicationNotificationToEmployer(employer.getName(), employer.getEmail(), user.getName(), job.getTitle());
                            } catch (Exception me) {
                                me.printStackTrace();
                            }

                            response.sendRedirect("userDashboard?applied=1");
                            return;
                        }
                    } else {

                        response.sendRedirect("userDashboard?applied=1");
                        return;
                    }
                } catch (NumberFormatException nfe) {
                    nfe.printStackTrace();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("resume_analysis_error", "Resume processing failed: " + e.getMessage());
        }

        response.sendRedirect("userDashboard");
    }
}

