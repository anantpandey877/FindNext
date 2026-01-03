/** FindNext - VerifyRegisterOTPServlet */
package in.findnext.servlets;

import java.io.IOException;

import in.findnext.dao.UserDAO;
import in.findnext.models.UserPojo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/verify-otp")
public class VerifyRegisterOTPServlet extends HttpServlet {
	// Validates OTP and completes user registration if correct
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		HttpSession session = req.getSession();
		String inputOtp = req.getParameter("otp");
		String actualOtp = (String) session.getAttribute("regOTP");

		if (inputOtp.equals(actualOtp)) {

			String name = (String) session.getAttribute("regName");
			String email = (String) session.getAttribute("regEmail");
			String password = (String) session.getAttribute("regPassword");
			String role = (String) session.getAttribute("regRole");

			try {
				UserPojo user = new UserPojo(0, name, email, password, role, "active", null);
				UserDAO.registerUser(user);
				session.removeAttribute("regOTP");
				res.sendRedirect("login.jsp?registered=true");
			} catch (Exception e) {
				throw new ServletException("Registration failed", e);
			}
		} else {
			res.sendRedirect("signup?showOtp=true&error=invalid");
		}
	}
}

