 <%--
    FindNext - Error Page
    Global error handling page displayed when exceptions occur
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error | <%= application.getAttribute("appName") %></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<%@ include file="includes/header.jsp" %>

<div class="auth-container">
	<div class="auth-card text-center" style="max-width: 600px;">
		<div style="font-size: 4rem; color: var(--danger); margin-bottom: 1rem;">
			<i class="fas fa-exclamation-triangle"></i>
		</div>
		<h3 class="mb-3" style="color: var(--danger);">Oops! Something Went Wrong</h3>

		<p style="color: var(--gray); margin-bottom: 1.5rem;">We're sorry, an unexpected error occurred while processing your request.</p>

		<%
		String errorMessage = (String) request.getAttribute("errorMessage");
		Throwable ex = exception;
		if (ex == null) {
			Object attr = request.getAttribute("jakarta.servlet.error.exception");
			if (attr instanceof Throwable) {
				ex = (Throwable) attr;
			}
		}

		String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
		if (requestUri == null) {
			requestUri = request.getRequestURI();
		}
		%>

		<%
		if (errorMessage != null && !errorMessage.isEmpty()) {
		%>
			<div class="alert alert-danger" style="text-align: left; margin-bottom: 1.5rem;">
				<strong><i class="fas fa-info-circle"></i> Error Details:</strong><br>
				<%= errorMessage %>
				<div style="margin-top: 0.75rem; font-size: 0.9rem; opacity: 0.85;">
					<strong>Request:</strong> <%= requestUri %>
				</div>
			</div>
		<% } else if (ex != null) { %>
			<div class="alert alert-danger" style="text-align: left; margin-bottom: 1.5rem;">
				<strong><i class="fas fa-bug"></i> Technical Details:</strong><br>
				<%= ex.getClass().getName() %>: <%= ex.getMessage() %>
				<div style="margin-top: 0.75rem; font-size: 0.9rem; opacity: 0.85;">
					<strong>Request:</strong> <%= requestUri %>
				</div>
			</div>
		<% } else { %>
			<div class="alert alert-warning" style="margin-bottom: 1.5rem;">
				<i class="fas fa-question-circle"></i> An unknown error occurred. Please try again.
				<div style="margin-top: 0.75rem; font-size: 0.9rem; opacity: 0.85;">
					<strong>Request:</strong> <%= requestUri %>
				</div>
			</div>
		<% } %>

		<%
		// Determine which dashboard to go back to based on user role
		String backUrl = "index.jsp";
		String backText = "Back to Home";
		String backIcon = "fa-home";

		String userRole = (String) session.getAttribute("userRole");
		if (userRole == null) {
			// Check if role passed via request attribute (for error forwards)
			userRole = (String) request.getAttribute("userRole");
		}

		if ("user".equals(userRole)) {
			backUrl = "userDashboard";
			backText = "Back to Dashboard";
			backIcon = "fa-th-large";
		} else if ("employer".equals(userRole)) {
			backUrl = "employerDashboard";
			backText = "Back to Dashboard";
			backIcon = "fa-th-large";
		} else if ("admin".equals(userRole)) {
			backUrl = "adminPanel";
			backText = "Back to Admin Panel";
			backIcon = "fa-cog";
		}
		%>

		<div style="display: flex; gap: 0.75rem; justify-content: center; margin-top: 2rem;">
			<a href="<%= backUrl %>" class="btn btn-primary" style="display: inline-flex; align-items: center; gap: 0.5rem;">
				<i class="fas <%= backIcon %>"></i> <%= backText %>
			</a>
			<a href="${pageContext.request.contextPath}/support.jsp" class="btn btn-outline" style="display: inline-flex; align-items: center; gap: 0.5rem;">
				<i class="fas fa-life-ring"></i> Get Help
			</a>
		</div>
	</div>
</div>

<%@ include file="includes/footer.jsp" %>
</body>
</html>
