<%--
    FindNext - Reset Password Page
    Form to set new password after OTP verification
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpServletRequest" %>
<%@ page import="jakarta.servlet.http.HttpServletResponse" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
// Explicit declarations to avoid IDE warnings
HttpServletRequest req = (HttpServletRequest) pageContext.getRequest();
HttpServletResponse resp = (HttpServletResponse) pageContext.getResponse();
HttpSession sess = req.getSession(false);

// Check if OTP is verified
Boolean otpVerified = sess != null ? (Boolean) sess.getAttribute("otpVerified") : null;
if (otpVerified == null || !otpVerified) {
    resp.sendRedirect(req.getContextPath() + "/forgotPassword.jsp?error=Session expired");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Reset Password | <%=pageContext.getServletContext().getAttribute("appName")%></title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/resetPassword.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <i class="fas fa-lock"></i>
                <h2>Reset Password</h2>
                <p>Create a strong new password</p>
            </div>

            <% if (req.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= req.getAttribute("error") %>
            </div>
            <% } %>

            <form action="reset-password" method="post" onsubmit="return validatePassword()">
                <input type="hidden" name="action" value="resetPassword" />

                <div class="form-group">
                    <label class="form-label" for="newPassword">
                        <i class="fas fa-key"></i> New Password
                    </label>
                    <input
                        type="password"
                        id="newPassword"
                        name="newPassword"
                        class="form-control"
                        placeholder="Enter new password"
                        minlength="6"
                        required
                        oninput="checkPasswordStrength()"
                    />
                    <i class="fas fa-eye password-toggle" onclick="togglePassword('newPassword', this)"></i>
                    <div id="passwordStrength" class="password-strength"></div>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">
                        <i class="fas fa-key"></i> Confirm Password
                    </label>
                    <input
                        type="password"
                        id="confirmPassword"
                        name="confirmPassword"
                        class="form-control"
                        placeholder="Confirm new password"
                        minlength="6"
                        required
                    />
                    <i class="fas fa-eye password-toggle" onclick="togglePassword('confirmPassword', this)"></i>
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-check"></i> Reset Password
                </button>
            </form>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/resetPassword.js"></script>
</body>
</html>


