<%--
    FindNext - Admin Panel
    User management, job moderation, and platform oversight dashboard
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="in.findnext.models.UserPojo"%>
<%@ page import="in.findnext.models.JobPojo"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Panel | <%=application.getAttribute("appName")%></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/adminPanel.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
	<%
	if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("userRole"))) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>
	<%@include file="includes/header.jsp"%>

	<main class="container py-5">
		<h2 class="mb-4">👑 Admin Dashboard</h2>

		<div class="card bg-glass p-4 mb-4">
			<h5>👥 Filter Users</h5>
			<form method="get" action="adminPanel">
				<div class="row g-2 align-items-center">
					<div class="col-md-4">
						<input type="text" name="search" class="form-control text-black"
							placeholder="Search by name or email..." value="${param.search}" />
					</div>
					<div class="col-md-3">
						<select name="role" class="form-select text-black">
							<option value="">All Roles</option>
							<option value="user" ${param.role == 'user' ? 'selected' : ''}>Job
								Seeker</option>
							<option value="employer"
								${param.role == 'employer' ? 'selected' : ''}>Employer</option>
						</select>
					</div>
					<div class="col-md-3">
						<select name="status" class="form-select text-black">
							<option value="">All Status</option>
							<option value="active"
								${param.status == 'active' ? 'selected' : ''}>Active</option>
							<option value="blocked"
								${param.status == 'blocked' ? 'selected' : ''}>Blocked</option>
						</select>
					</div>
					<div class="col-md-2">
						<button type="submit" class="btn btn-login">Apply</button>
					</div>
				</div>
			</form>
		</div>

		<div class="card bg-glass p-4 mb-5">
			<h5>📄 Users</h5>

			<%
			List<UserPojo> users = (List<UserPojo>) request.getAttribute("users");
			%>

			<div class="users-desktop-table">
				<table class="table text-white mt-3">
					<thead>
						<tr>
							<th>Name</th>
							<th>Email</th>
							<th>Role</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (users != null && !users.isEmpty()) {
							for (UserPojo user : users) {
						%>
						<tr>
							<td><%=user.getName()%></td>
							<td><%=user.getEmail()%></td>
							<td><%=user.getRole().equals("user") ? "Job Seeker" : "Employer"%></td>
							<td><%=user.getStatus()%></td>
							<td>
								<%
								if ("active".equals(user.getStatus())) {
								%>
								<a href="block-user?userId=<%=user.getId()%>" class="btn btn-sm btn-danger" style="min-width: 90px; display: inline-flex; align-items: center; justify-content: center; gap: 0.25rem;">
									<i class="fas fa-ban"></i> Block
								</a>
								<% } else { %>
								<a href="unblock-user?userId=<%=user.getId()%>" class="btn btn-sm btn-success" style="min-width: 90px; display: inline-flex; align-items: center; justify-content: center; gap: 0.25rem;">
									<i class="fas fa-check-circle"></i> Unblock
								</a>
								<% } %>
							</td>
						</tr>
						<%
							}
						} else {
						%>
						<tr>
							<td colspan="5" class="text-center text-warning">No users found.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>

			<div class="users-mobile-cards">
				<%
				if (users != null && !users.isEmpty()) {
					for (UserPojo user : users) {
						String initial = user.getName().substring(0, 1).toUpperCase();
						String roleDisplay = user.getRole().equals("user") ? "Job Seeker" : "Employer";
						String roleClass = user.getRole().equals("user") ? "user-role-seeker" : "user-role-employer";
				%>
				<div class="user-card-admin">
					<div class="user-card-header">
						<div class="user-avatar"><%=initial%></div>
						<div class="user-card-info">
							<h4><%=user.getName()%></h4>
							<p><%=user.getEmail()%></p>
						</div>
					</div>
					<div class="user-card-body">
						<div class="user-info-item">
							<i class="fas fa-user-tag"></i>
							<span class="user-role-badge <%=roleClass%>">
								<%=roleDisplay%>
							</span>
						</div>
						<div class="user-info-item">
							<i class="fas fa-info-circle"></i>
							<span class="user-status-badge user-status-<%=user.getStatus()%>">
								<%=user.getStatus()%>
							</span>
						</div>
					</div>
					<div class="user-card-actions">
						<%
						if ("active".equals(user.getStatus())) {
						%>
						<a href="block-user?userId=<%=user.getId()%>" class="btn btn-danger btn-sm">
							<i class="fas fa-ban"></i> Block User
						</a>
						<% } else { %>
						<a href="unblock-user?userId=<%=user.getId()%>" class="btn btn-success btn-sm">
							<i class="fas fa-check-circle"></i> Unblock User
						</a>
						<% } %>
					</div>
				</div>
				<%
					}
				} else {
				%>
				<div class="text-center py-4" style="color: var(--warning);">
					<i class="fas fa-users" style="font-size: 3rem; opacity: 0.3;"></i>
					<p class="mt-2">No users found.</p>
				</div>
				<%
				}
				%>
			</div>
		</div>

		<div class="glass-card">
			<h4>💼 Manage Job Listings</h4>

			<%
			List<JobPojo> jobs = (List<JobPojo>) request.getAttribute("jobs");
			%>

			<div class="desktop-table">
				<table class="table mt-3">
					<thead>
						<tr>
							<th>Job Title</th>
							<th>Company</th>
							<th>Applicants</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (jobs != null && !jobs.isEmpty()) {
							for (JobPojo job : jobs) {
						%>
						<tr>
							<td><%=job.getTitle()%></td>
							<td><%=job.getCompany()%></td>
							<td><%=job.getApplicantCount()%></td>
							<td><%=job.getStatus()%></td>
							<td><a href="remove-job?jobId=<%=job.getId()%>" class="btn btn-danger btn-sm">Remove</a></td>
						</tr>
						<%
							}
						} else {
						%>
						<tr>
							<td colspan="5" class="text-center" style="color: var(--warning);">No job listings found.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>

			<div class="mobile-cards">
				<%
				if (jobs != null && !jobs.isEmpty()) {
					for (JobPojo job : jobs) {
				%>
				<div class="job-card-admin">
					<div class="job-card-header">
						<div class="job-card-title">
							<h4><%=job.getTitle()%></h4>
							<p><%=job.getCompany()%></p>
						</div>
					</div>
					<div class="job-card-body">
						<div class="job-info-item">
							<i class="fas fa-users"></i>
							<span><strong>Applicants:</strong> <%=job.getApplicantCount()%></span>
						</div>
						<div class="job-info-item">
							<i class="fas fa-info-circle"></i>
							<span class="job-status-badge job-status-<%=job.getStatus()%>">
								<%=job.getStatus()%>
							</span>
						</div>
					</div>
					<div class="job-card-footer">
						<a href="remove-job?jobId=<%=job.getId()%>" class="btn btn-danger btn-sm" style="flex: 1;">
							<i class="fas fa-trash"></i> Remove Job
						</a>
					</div>
				</div>
				<%
					}
				} else {
				%>
				<div class="text-center py-4" style="color: var(--warning);">
					<i class="fas fa-briefcase" style="font-size: 3rem; opacity: 0.3;"></i>
					<p class="mt-2">No job listings found.</p>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</main>

	<%@include file="includes/footer.jsp"%>
</body>
</html>



