<%--
    FindNext - Login Page
    User authentication form for job seekers, employers, and admins
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Login | <%=application.getAttribute("appName")%></title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/auth.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<%@include file="includes/header.jsp" %>

<main>
    <div class="auth-page">
        <div class="container">
            <div class="auth-container">
                <div class="auth-card">
                    <div class="auth-header">
                        <i class="fas fa-sign-in-alt"></i>
                        <h2>Welcome Back!</h2>
                        <p>Sign in to continue to your dashboard</p>
                    </div>

                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) { %>
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle"></i>
                            <span><%=error%></span>
                            <button class="alert-close" onclick="this.parentElement.style.display='none'">&times;</button>
                        </div>
                    <% } %>

                    <% if ("true".equals(request.getParameter("registered"))) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span>Registration successful! Please sign in.</span>
                            <button class="alert-close" onclick="this.parentElement.style.display='none'">&times;</button>
                        </div>
                    <% } %>

                    <% if (request.getParameter("success") != null) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span><%= request.getParameter("success") %></span>
                            <button class="alert-close" onclick="this.parentElement.style.display='none'">&times;</button>
                        </div>
                    <% } %>

                    <form action="login" method="post">
                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-envelope"></i> Email Address</label>
                            <input type="email" name="email" class="form-control"
                                placeholder="Enter your email address" required autofocus />
                        </div>

                        <div class="form-group">
                            <label class="form-label"><i class="fas fa-lock"></i> Password</label>
                            <input type="password" name="password" class="form-control"
                                placeholder="Enter your password" required />
                            <div style="text-align: right; margin-top: 0.5rem;">
                                <a href="forgotPassword.jsp" style="color: var(--primary); text-decoration: none; font-size: 0.875rem; font-weight: 600;">
                                    <i class="fas fa-key"></i> Forgot Password?
                                </a>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block btn-lg">
                            <i class="fas fa-sign-in-alt"></i> Sign In
                        </button>
                    </form>

                    <div class="divider">
                        <span>OR</span>
                    </div>

                    <div class="text-center">
                        <p style="color: var(--gray); margin-bottom: var(--spacing-sm);">Don't have an account?</p>
                        <a href="register.jsp" class="btn btn-outline btn-block">
                            <i class="fas fa-user-plus"></i> Create New Account
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<%@include file="includes/footer.jsp" %>

</body>
</html>


