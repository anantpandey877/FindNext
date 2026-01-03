/** FindNext - ResetPasswordServlet */
package in.findnext.servlets;

import java.io.IOException;

import in.findnext.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    private static final long OTP_VALIDITY_DURATION = 10 * 60 * 1000;

	// Handles both OTP verification and password reset requests
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        if ("verifyOTP".equals(action)) {
            verifyOTP(request, response, session);
        } else if ("resetPassword".equals(action)) {
            resetPassword(request, response, session);
        }
    }

	// Checks if the OTP entered by user matches and is still valid
    private void verifyOTP(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        String enteredOTP = request.getParameter("otp");
        String storedOTP = (String) session.getAttribute("resetOTP");
        Long otpTimestamp = (Long) session.getAttribute("otpTimestamp");

        if (storedOTP == null || otpTimestamp == null) {
            request.setAttribute("error", "Session expired. Please request a new OTP.");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        long currentTime = System.currentTimeMillis();
        if (currentTime - otpTimestamp > OTP_VALIDITY_DURATION) {
            session.removeAttribute("resetOTP");
            session.removeAttribute("otpTimestamp");
            session.removeAttribute("resetEmail");
            request.setAttribute("error", "OTP expired. Please request a new one.");
            request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
            return;
        }

        if (storedOTP.equals(enteredOTP)) {
            session.setAttribute("otpVerified", true);
            response.sendRedirect("resetPassword.jsp");
        } else {
            request.setAttribute("error", "Invalid OTP. Please try again.");
            request.getRequestDispatcher("verifyOtp.jsp").forward(request, response);
        }
    }

	// Updates user's password after successful OTP verification
    private void resetPassword(HttpServletRequest request, HttpServletResponse response, HttpSession session)
            throws ServletException, IOException {

        Boolean otpVerified = (Boolean) session.getAttribute("otpVerified");
        String email = (String) session.getAttribute("resetEmail");

        if (otpVerified == null || !otpVerified || email == null) {
            response.sendRedirect("forgotPassword.jsp?error=Invalid session");
            return;
        }

        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            return;
        }

        try {
            boolean updated = UserDAO.updatePassword(email, newPassword);

            if (updated) {

                session.removeAttribute("resetOTP");
                session.removeAttribute("otpTimestamp");
                session.removeAttribute("resetEmail");
                session.removeAttribute("otpVerified");

                response.sendRedirect("signin?success=Password reset successful. Please login with your new password.");
            } else {
                request.setAttribute("error", "Failed to update password. Please try again.");
                request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred. Please try again.");
            request.getRequestDispatcher("resetPassword.jsp").forward(request, response);
        }
    }
}

