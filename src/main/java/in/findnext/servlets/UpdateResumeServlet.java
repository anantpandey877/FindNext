package in.findnext.servlets;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.util.List;

import org.json.JSONObject;

import in.findnext.dao.ApplicationDAO;
import in.findnext.dao.JobDAO;
import in.findnext.dao.ResumeAnalysisLogDAO;
import in.findnext.models.ApplicationPojo;
import in.findnext.models.JobPojo;
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

@WebServlet("/update-resume")
@MultipartConfig
public class UpdateResumeServlet extends HttpServlet {

    private static final String RESUME_DIRECTORY = "D:/HireSense_Resumes";

	// Allows users to upload a new version of their resume
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("signin");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        System.out.println("=== Resume Update Started for User: " + userId + " ===");

        try {

            Part filePart = request.getPart("resume");
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("error", "Please select a resume file");
                request.getRequestDispatcher("userDashboard.jsp").forward(request, response);
                return;
            }

            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            System.out.println("Uploaded file: " + fileName);

            File resumeDir = new File(RESUME_DIRECTORY);
            if (!resumeDir.exists()) {
                resumeDir.mkdirs();
                System.out.println("Created resume directory: " + RESUME_DIRECTORY);
            }

            String uniqueFileName = "user_" + userId + "_" + System.currentTimeMillis() + "_" + fileName;
            File newResumeFile = new File(resumeDir, uniqueFileName);
            String newResumePath = newResumeFile.getAbsolutePath();

            System.out.println("New resume path: " + newResumePath);

            deleteOldResume(userId);

            saveResumeFile(filePart, newResumeFile);
            System.out.println("Resume file saved successfully");

            JSONObject analysisResult = analyzeResumeWithFallback(newResumeFile, userId);

            analysisResult.put("resumePath", newResumePath);
            ResumeAnalysisLogDAO.saveLog(userId, analysisResult.toString());
            System.out.println("Analysis log saved to database");

            ApplicationDAO.updateResumePathForUser(userId, newResumePath);
            System.out.println("Resume path updated in applications");

            recalculateMatchScores(userId, analysisResult);

            System.out.println("=== Resume Update Completed Successfully ===");

            response.sendRedirect("userDashboard?resumeUpdated=true");

        } catch (Exception e) {
            System.err.println("Error updating resume: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to update resume: " + e.getClass().getSimpleName() + ": " + e.getMessage());
            request.setAttribute("userRole", "user");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    /**
     * Delete old resume file from disk
     */
    private void deleteOldResume(int userId) {
        try {
            List<ResumeAnalysisLogPojo> logs = ResumeAnalysisLogDAO.getLogsByUser(userId);
            if (!logs.isEmpty()) {
                String oldJson = logs.get(0).getResultJson();
                JSONObject oldResult = new JSONObject(oldJson);
                String oldPath = oldResult.optString("resumePath", null);

                if (oldPath != null && !oldPath.isEmpty()) {
                    File oldFile = new File(oldPath);
                    if (oldFile.exists()) {
                        boolean deleted = oldFile.delete();
                        System.out.println("Old resume deleted: " + deleted + " - " + oldPath);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Warning: Could not delete old resume: " + e.getMessage());

        }
    }

    /**
     * Save resume file to disk
     */
    private void saveResumeFile(Part filePart, File targetFile) throws IOException {
        try (InputStream input = filePart.getInputStream();
             FileOutputStream output = new FileOutputStream(targetFile)) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }
        }
        System.out.println("Resume file saved: " + targetFile.getAbsolutePath());
    }

    /**
     * Analyze resume with fallback mechanism
     * If API fails, create a basic analysis with empty skills
     */
    private JSONObject analyzeResumeWithFallback(File resumeFile, int userId) {
        JSONObject result = new JSONObject();

        try {
            System.out.println("Attempting to analyze resume with Affinda API...");
            String apiResponse = AffindaAPI.analyzeResume(resumeFile);

            if (apiResponse != null && !apiResponse.isEmpty()) {
                result = new JSONObject(apiResponse);

                if (!result.has("data")) {
                    result.put("data", new JSONObject());
                }

                System.out.println("✓ API analysis successful");
            } else {
                throw new Exception("Empty API response");
            }

        } catch (Exception e) {
            System.err.println("⚠ API analysis failed: " + e.getMessage());
            System.out.println("Creating fallback analysis data...");

            JSONObject data = new JSONObject();
            data.put("skills", new org.json.JSONArray());
            data.put("name", "Unknown");
            data.put("email", "");
            data.put("phone", "");
            data.put("totalYearsExperience", 0);

            result.put("data", data);
            result.put("fallback", true);
            result.put("error", e.getMessage());

            System.out.println("✓ Fallback data created");
        }

        return result;
    }

    /**
     * Recalculate match scores for all user's applications
     */
    private void recalculateMatchScores(int userId, JSONObject analysisResult) {
        try {

            List<String> userSkills = AffindaAPI.extractSkills(analysisResult.toString());

            if (userSkills.isEmpty()) {
                System.out.println("No skills extracted, skipping score recalculation");
                return;
            }

            List<ApplicationPojo> applications = ApplicationDAO.getApplicationsByUser(userId);
            System.out.println("Recalculating scores for " + applications.size() + " applications");

            int updated = 0;
            for (ApplicationPojo app : applications) {
                JobPojo job = JobDAO.getJobById(app.getJobId());
                if (job != null) {
                    int newScore = AffindaAPI.calculateMatchScore(job.getSkills(), userSkills);
                    boolean success = ApplicationDAO.updateApplicationScore(app.getId(), newScore);
                    if (success) {
                        updated++;
                    }
                }
            }

            System.out.println("✓ Updated " + updated + " application scores");

        } catch (Exception e) {
            System.err.println("Warning: Could not recalculate scores: " + e.getMessage());

        }
    }
}

