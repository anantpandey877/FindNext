<%--
    FindNext - Verify OTP Page
    OTP verification form for password reset confirmation
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Verify OTP | <%=application.getAttribute("appName")%></title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <i class="fas fa-shield-alt"></i>
                <h2>Verify OTP</h2>
                <p>Enter the 6-digit code sent to your email</p>
            </div>

            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getParameter("success") %>
            </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <div class="info-box">
                <i class="fas fa-info-circle"></i>
                OTP is valid for 10 minutes only
            </div>

            <form action="reset-password" method="post">
                <input type="hidden" name="action" value="verifyOTP" />

                <div class="form-group">
                    <label class="form-label" for="otp">
                        <i class="fas fa-key"></i> Enter OTP
                    </label>
                    <input
                        type="text"
                        id="otp"
                        name="otp"
                        class="form-control"
                        placeholder="000000"
                        maxlength="6"
                        pattern="[0-9]{6}"
                        required
                        autofocus
                    />
                </div>

                <button type="submit" class="btn-primary">
                    <i class="fas fa-check"></i> Verify OTP
                </button>
            </form>

            <div class="back-link">
                <a href="forgotPassword.jsp">
                    <i class="fas fa-arrow-left"></i> Request New OTP
                </a>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/verifyOtp.js"></script>
</body>
</html>


