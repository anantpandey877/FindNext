<%--
    FindNext - Registration Page
    New user signup form with OTP verification for job seekers and employers
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Register | <%=application.getAttribute("appName")%></title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<%@include file="includes/header.jsp"%>

<main>
    <div class="auth-page">
        <div class="container">
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <i class="fas fa-user-plus"></i>
                        <h2>Create Account</h2>
                        <p>Join thousands of professionals finding their dream jobs</p>
                    </div>

                    <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <span><%= request.getParameter("error") %></span>
                    </div>
                    <% } %>

                    <form action="send-otp" method="post" id="registerForm">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-user"></i> Full Name</label>
                            <input type="text" name="name" class="form-control"
                                placeholder="Enter your full name" required />
                        </div>

                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-envelope"></i> Email Address</label>
                            <input type="email" name="email" class="form-control"
                                placeholder="Enter your email" required />
                        </div>

                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-lock"></i> Password</label>
                            <div style="position: relative;">
                                <input type="password" id="regPassword" name="password" class="form-control"
                                    placeholder="Create a strong password" minlength="6" required
                                    oninput="checkRegPasswordStrength()" style="padding-right: 3rem;" />
                                <i class="fas fa-eye" id="toggleRegPassword"
                                   style="position: absolute; right: 1rem; top: 50%; transform: translateY(-50%); cursor: pointer; color: var(--gray);"
                                   onclick="toggleRegPasswordVisibility()"></i>
                            </div>
                            <div id="regPasswordStrength" style="margin-top: 0.5rem; font-size: 0.8rem;"></div>
                        </div>

                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-user-tag"></i> I am a</label>
                            <select name="role" class="form-select" required>
                                <option value="">Select your role</option>
                                <option value="user"><i class="fas fa-user"></i> Job Seeker - Looking for opportunities</option>
                                <option value="employer"><i class="fas fa-building"></i> Employer - Hiring talent</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block btn-lg">
                            <i class="fas fa-paper-plane"></i> Send OTP
                        </button>
                    </form>

                    <div class="divider">
                        <span>OR</span>
                    </div>

                    <div class="text-center">
                        <p style="color: var(--gray); margin-bottom: var(--spacing-sm);">Already have an account?</p>
                        <a href="login.jsp" class="btn btn-outline btn-block">
                            <i class="fas fa-sign-in-alt"></i> Sign In
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%
if ("true".equals(request.getParameter("showOtp"))) {
%>
<div class="modal show" id="otpModal">
    <div class="modal-dialog">
        <form action="verify-otp" method="post" class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title"><i class="fas fa-shield-alt"></i> Verify Email</h4>
            </div>
            <div class="modal-body">
                <% if ("invalid".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Invalid OTP! Please try again.</span>
                    </div>
                <% } %>

                <div class="alert alert-info">
                    <i class="fas fa-info-circle"></i>
                    <span>We've sent a 6-digit code to your email. Please enter it below.</span>
                </div>

                <div class="form-group">
                    <label class="form-label"><i class="fas fa-key"></i> Enter OTP Code</label>
                    <input type="text" name="otp" class="form-control"
                        placeholder="Enter 6-digit code" maxlength="6" pattern="[0-9]{6}" required autofocus />
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success btn-lg">
                    <i class="fas fa-check"></i> Verify & Create Account
                </button>
                <a href="register.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Back
                </a>
            </div>
        </form>
    </div>
</div>
<% } %>

<%@include file="includes/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script src="${pageContext.request.contextPath}/js/register.js"></script>

</body>
</html>


