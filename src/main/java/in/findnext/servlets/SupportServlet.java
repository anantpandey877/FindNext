/** FindNext - SupportServlet */
package in.findnext.servlets;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/support")
@MultipartConfig(maxFileSize = 5242880)
public class SupportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String getSupportEmail() {
        Object v = getServletContext().getAttribute("mail.from");
        return (v == null) ? null : v.toString();
    }

	// Processes support ticket submissions with optional file attachments
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String category = request.getParameter("category");
        String priority = request.getParameter("priority");
        String subject = request.getParameter("subject");
        String description = request.getParameter("description");

        try {

            Part filePart = request.getPart("attachment");
            String fileName = null;
            if (filePart != null && filePart.getSize() > 0) {
                fileName = extractFileName(filePart);
            }

            // Generate unique ticket number
            String ticketNumber = generateTicketNumber();

            sendSupportEmail(name, email, category, priority, subject, description, fileName, ticketNumber);

            sendConfirmationEmail(email, name, subject, ticketNumber);

            response.sendRedirect(request.getContextPath() + "/support.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Failed to send support email: " + e.getMessage());

            response.sendRedirect(request.getContextPath() + "/help?error=true");
        }
    }

	// Extracts the filename from uploaded file attachment
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        return null;
    }

	// Sends detailed support request to FindNext support team
    private void sendSupportEmail(String name, String email, String category,
            String priority, String subject, String description, String fileName, String ticketNumber) throws MessagingException {

        String supportEmail = getSupportEmail();
        if (supportEmail == null || supportEmail.isEmpty() || "__SET_ME__".equals(supportEmail)) {
            throw new IllegalStateException("Support email is not configured. Set context-param 'mail.from' in WEB-INF/web.xml");
        }

        Session session = in.findnext.utils.MailConfig.getSession();

        Message emailMessage = new MimeMessage(session);

        try {
            emailMessage.setFrom(new InternetAddress(supportEmail, "FindNext Support"));
        } catch (java.io.UnsupportedEncodingException e) {
            emailMessage.setFrom(new InternetAddress(supportEmail));
        }

        emailMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(supportEmail));

        emailMessage.setReplyTo(InternetAddress.parse(email));

        String priorityLabel = priority.toUpperCase();
        emailMessage.setSubject(String.format("[TICKET-%s] [%s] [%s] Support Request: %s", ticketNumber, priorityLabel, category.toUpperCase(), subject));

        StringBuilder emailBody = new StringBuilder();
        emailBody.append("NEW SUPPORT REQUEST RECEIVED\n");
        emailBody.append("=" .repeat(50)).append("\n\n");
        emailBody.append("Ticket Number: TICKET-").append(ticketNumber).append("\n");
        emailBody.append("Priority: ").append(priorityLabel).append("\n");
        emailBody.append("Category: ").append(category).append("\n\n");
        emailBody.append("CUSTOMER INFORMATION\n");
        emailBody.append("-".repeat(50)).append("\n");
        emailBody.append("Name: ").append(name).append("\n");
        emailBody.append("Email: ").append(email).append("\n\n");
        emailBody.append("ISSUE DETAILS\n");
        emailBody.append("-".repeat(50)).append("\n");
        emailBody.append("Subject: ").append(subject).append("\n\n");
        emailBody.append("Description:\n").append(description).append("\n\n");

        if (fileName != null) {
            emailBody.append("Attachment: ").append(fileName).append("\n\n");
        }

        emailBody.append("=" .repeat(50)).append("\n");
        emailBody.append("Reply directly to: ").append(email).append("\n");

        emailMessage.setText(emailBody.toString());

        Transport.send(emailMessage);

        System.out.println("\u2713 Support email sent to: " + supportEmail);
        System.out.println("\u2713 From user: " + name + " (" + email + ")");
    }

	// Sends ticket confirmation with tracking number to user
    private void sendConfirmationEmail(String userEmail, String name, String subject, String ticketNumber)
            throws MessagingException {

        String supportEmail = getSupportEmail();
        if (supportEmail == null || supportEmail.isEmpty() || "__SET_ME__".equals(supportEmail)) {
            throw new IllegalStateException("Support email is not configured. Set context-param 'mail.from' in WEB-INF/web.xml");
        }

        Session session = in.findnext.utils.MailConfig.getSession();

        Message emailMessage = new MimeMessage(session);

        try {
            emailMessage.setFrom(new InternetAddress(supportEmail, "FindNext Support"));
        } catch (java.io.UnsupportedEncodingException e) {
            emailMessage.setFrom(new InternetAddress(supportEmail));
        }

        emailMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
        emailMessage.setSubject("FindNext Support - Request Received [TICKET-" + ticketNumber + "]");

        String emailBody = String.format(
            "Dear %s,\n\n" +
            "Thank you for contacting FindNext Support!\n\n" +
            "We have received your support request and our team will review it shortly.\n\n" +
            "TICKET DETAILS:\n" +
            "Ticket Number: TICKET-%s\n" +
            "Subject: %s\n\n" +
            "WHAT'S NEXT?\n" +
            "Our support team will investigate your issue and respond to this email address as soon as possible. " +
            "You will receive a direct reply from our team. Please reference your ticket number (TICKET-%s) in all future communications.\n\n" +
            "If you have any additional information to add, please reply to this email with your ticket number.\n\n" +
            "CONTACT US:\n" +
            "Email: " + supportEmail + "\n\n" +
            "Thank you for using FindNext!\n\n" +
            "Best regards,\n" +
            "The FindNext Support Team",
            name, ticketNumber, subject, ticketNumber
        );

        emailMessage.setText(emailBody);

        Transport.send(emailMessage);

        System.out.println("\u2713 Confirmation email sent to user: " + userEmail);
    }

	// Creates a unique ticket number for tracking support requests
    private String generateTicketNumber() {
        Random random = new Random();
        long timestamp = System.currentTimeMillis();
        int randomNum = 1000 + random.nextInt(9000);
        return String.format("%d%d", timestamp % 100000, randomNum);
    }
}
