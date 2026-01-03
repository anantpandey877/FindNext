/** FindNext - DownloadResumeServlet */
package in.findnext.servlets;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/download-resume")
public class DownloadResumeServlet extends HttpServlet {
	// Handles resume file downloads for employers viewing applicants
    @Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String resumePath = request.getParameter("path");

        System.out.println("Download request for resume path: " + resumePath);

        if (resumePath == null || resumePath.trim().isEmpty()) {
            System.err.println("Resume path is null or empty");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Resume path not provided");
            return;
        }

        File file = new File(resumePath);

        if (!file.exists()) {
            System.out.println("File not found at original path, checking new location...");

            String fileName = new File(resumePath).getName();

            File newLocationFile = new File("D:/HireSense_Resumes/" + fileName);

            if (newLocationFile.exists()) {
                System.out.println("✅ Found file in new permanent location: " + newLocationFile.getAbsolutePath());
                file = newLocationFile;
            } else {

                System.err.println("❌ Resume file not found in either location:");
                System.err.println("   Original path: " + resumePath);
                System.err.println("   New location: " + newLocationFile.getAbsolutePath());
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Resume file not found. The file may have been deleted. Please ask the applicant to re-upload their resume.");
                return;
            }
        }

        if (!file.canRead()) {
            System.err.println("Cannot read file: " + file.getAbsolutePath());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Cannot read resume file");
            return;
        }

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + file.getName() + "\"");
        response.setContentLengthLong(file.length());

        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            out.flush();
            System.out.println("✅ Successfully downloaded resume: " + file.getName());
        } catch (IOException e) {
            System.err.println("❌ Error while downloading resume: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}

