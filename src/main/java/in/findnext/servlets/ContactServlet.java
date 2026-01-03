/** FindNext - ContactServlet */
package in.findnext.servlets;

import java.io.IOException;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private String getSupportEmail() {
        Object v = getServletContext().getAttribute("mail.from");
        return (v == null) ? null : v.toString();
    }

	// Handles contact form submissions and sends emails to support team
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        try {

            sendContactEmail(name, email, phone, subject, message);

            sendContactConfirmation(email, name);

            response.sendRedirect(request.getContextPath() + "/contact.jsp?success=true");

        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect(request.getContextPath() + "/get-in-touch?error=true");
        }
    }

	// Sends the contact inquiry to FindNext support team
    private void sendContactEmail(String name, String email, String phone, String subject, String message)
            throws MessagingException {

        String supportEmail = getSupportEmail();
        if (supportEmail == null || supportEmail.isEmpty() || "__SET_ME__".equals(supportEmail)) {
            throw new IllegalStateException("Support email is not configured. Set context-param 'mail.from' in WEB-INF/web.xml");
        }

        Session session = in.findnext.utils.MailConfig.getSession();

        Message emailMessage = new MimeMessage(session);

        try {
            emailMessage.setFrom(new InternetAddress(supportEmail, "FindNext Contact"));
        } catch (java.io.UnsupportedEncodingException e) {
            emailMessage.setFrom(new InternetAddress(supportEmail));
        }

        emailMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(supportEmail));

        emailMessage.setReplyTo(InternetAddress.parse(email));
        emailMessage.setSubject("FindNext Contact Form: " + subject);

        String emailBody = String.format(
            "New contact form submission from FindNext:\n\n" +
            "Name: %s\n" +
            "Email: %s\n" +
            "Phone: %s\n" +
            "Subject: %s\n\n" +
            "Message:\n%s\n\n" +
            "---\n" +
            "This message was sent from the FindNext contact form.",
            name, email, phone != null ? phone : "Not provided", subject, message
        );

        emailMessage.setText(emailBody);

        Transport.send(emailMessage);

        System.out.println("Contact email sent successfully to: " + supportEmail);
    }

	// Sends acknowledgment email to user confirming their message was received
    private void sendContactConfirmation(String userEmail, String name) throws MessagingException {
        String supportEmail = getSupportEmail();
        if (supportEmail == null || supportEmail.isEmpty() || "__SET_ME__".equals(supportEmail)) {
            throw new IllegalStateException("Support email is not configured. Set context-param 'mail.from' in WEB-INF/web.xml");
        }

        Session session = in.findnext.utils.MailConfig.getSession();

        Message emailMessage = new MimeMessage(session);

        try {
            emailMessage.setFrom(new InternetAddress(supportEmail, "FindNext Team"));
        } catch (java.io.UnsupportedEncodingException e) {
            emailMessage.setFrom(new InternetAddress(supportEmail));
        }

        emailMessage.setRecipients(Message.RecipientType.TO, InternetAddress.parse(userEmail));
        emailMessage.setSubject("Thank You for Contacting FindNext");

        String emailBody = String.format(
            "Dear %s,\n\n" +
            "Thank you for reaching out to FindNext!\n\n" +
            "We have received your message and our team will review it shortly. " +
            "This is an automated confirmation to let you know that your inquiry has been successfully submitted.\n\n" +
            "WHAT'S NEXT?\n" +
            "Our team will get back to you as soon as possible via email. " +
            "We typically respond within 24-48 business hours.\n\n" +
            "CONTACT INFORMATION:\n" +
            "Email: " + supportEmail + "\n\n" +
            "Thank you for choosing FindNext. We look forward to assisting you!\n\n" +
            "Best regards,\n" +
            "The FindNext Team\n\n" +
            "---\n" +
            "This is an automated message. Please do not reply directly to this email.",
            name
        );

        emailMessage.setText(emailBody);

        Transport.send(emailMessage);

        System.out.println("\u2713 Confirmation email sent to: " + userEmail);
    }
}
