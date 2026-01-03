/** FindNext - ForgotPasswordServlet */
package in.findnext.servlets;

import java.io.IOException;
import java.util.Random;

import in.findnext.dao.UserDAO;
import in.findnext.models.UserPojo;
import in.findnext.utils.MailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

	// Sends OTP to user's email for password reset verification
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        try {

            UserPojo user = UserDAO.getUserByEmail(email);

            if (user != null) {

                String otp = generateOTP();

                HttpSession session = request.getSession();
                session.setAttribute("resetEmail", email);
                session.setAttribute("resetOTP", otp);
                session.setAttribute("otpTimestamp", System.currentTimeMillis());

                boolean emailSent = MailUtil.sendPasswordResetOTP(user.getName(), email, otp);

                if (emailSent) {
                    response.sendRedirect("verifyOtp.jsp?success=OTP sent to your email");
                } else {
                    request.setAttribute("error", "Failed to send OTP. Please try again.");
                    request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Email not found in our system.");
                request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
        }
    }

	// Creates a random 6-digit verification code
    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);
        return String.valueOf(otp);
    }
}

