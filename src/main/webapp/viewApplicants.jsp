<%--
    FindNext - View Applicants Page
    Displays all candidates who applied to a specific job with filtering and status update
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page
	import="in.findnext.models.ApplicationPojo, in.findnext.models.JobPojo"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Applicants | <%=application.getAttribute("appName")%></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/viewApplicants.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
	<%@ include file="includes/header.jsp"%>

	<%
	if (session.getAttribute("userId") == null || !"employer".equals(session.getAttribute("userRole"))) {
		response.sendRedirect("login.jsp");
		return;
	}
	JobPojo job = (JobPojo) request.getAttribute("job");
	%>

	<main class="container py-5">
		<div class="job-header-card mb-4">
			<h3><%=job.getTitle()%> @ <%=job.getCompany()%></h3>
			<p>
				📍 <%=job.getLocation()%>
				&nbsp;&nbsp; 💼 <%=job.getExperience()%>
				&nbsp;&nbsp; 💰 <%=job.getPackageLpa()%>
				&nbsp;&nbsp; 👥 <%=job.getVacancies()%> vacancies
			</p>
		</div>

		<div class="filter-bar mb-4">
			<form method="get" action="ViewApplicantsServlet">
				<input type="hidden" name="jobId" value="<%=job.getId()%>" />
				<div class="row">
					<div class="col-4">
						<label for="status" class="form-label">Filter by Status</label>
						<select name="status" class="form-select" onchange="this.form.submit()">
							<option value=""
								<%=(request.getAttribute("selectedStatus") == null || "".equals(request.getAttribute("selectedStatus"))) ? "selected" : ""%>>All</option>
							<option value="applied"
								<%="applied".equals(request.getAttribute("selectedStatus")) ? "selected" : ""%>>Applied</option>
							<option value="shortlisted"
								<%="shortlisted".equals(request.getAttribute("selectedStatus")) ? "selected" : ""%>>Shortlisted</option>
							<option value="rejected"
								<%="rejected".equals(request.getAttribute("selectedStatus")) ? "selected" : ""%>>Rejected</option>
						</select>
					</div>
				</div>
			</form>
		</div>

		<h4 class="mb-3">👤 Applicants List</h4>
		<div class="row" style="margin: 0 -1rem; display: flex; flex-wrap: wrap;">
			<%
			List<ApplicationPojo> applicants = (List<ApplicationPojo>) request.getAttribute("applicants");
			if (applicants != null && !applicants.isEmpty()) {
				for (ApplicationPojo a : applicants) {
			%>
			<div class="col-4" style="padding: 0 1rem; margin-bottom: 2rem; display: flex;">
				<div class="applicant-card">
					<%-- Match Score Badge --%>
					<% if (a.getScore() > 0) { %>
					<div class="match-score">
						<i class="fas fa-chart-line"></i> <%=a.getScore()%>%
					</div>
					<% } %>

					<%-- Applicant Header --%>
					<div class="applicant-header">
						<div class="applicant-avatar">
							<i class="fas fa-user"></i>
						</div>
						<div class="applicant-info">
							<h5 class="applicant-name">Applicant #<%=a.getUserId()%></h5>
							<p class="applicant-id">ID: <%=a.getUserId()%></p>
						</div>
					</div>

					<%-- Status --%>
					<div class="info-row">
						<i class="fas fa-flag"></i>
						<strong>Status:</strong>
						<span class="status-badge status-<%=a.getStatus()%>">
							<% if ("shortlisted".equals(a.getStatus())) { %>
								<i class="fas fa-star"></i>
							<% } else if ("rejected".equals(a.getStatus())) { %>
								<i class="fas fa-times-circle"></i>
							<% } else { %>
								<i class="fas fa-clock"></i>
							<% } %>
							<%=a.getStatus()%>
						</span>
					</div>

					<%-- Applied Date --%>
					<div class="info-row">
						<i class="fas fa-calendar-alt"></i>
						<strong>Applied:</strong>
						<span>
							<% if (a.getAppliedAt() != null && !a.getAppliedAt().isEmpty()) { %>
								<%=a.getAppliedAt()%>
							<% } else { %>
								N/A
							<% } %>
						</span>
					</div>

					<%-- Resume Download --%>
					<div class="info-row">
						<i class="fas fa-file-pdf"></i>
						<strong>Resume:</strong>
						<%
						if (a.getResumePath() != null && !a.getResumePath().isEmpty()) {
						%>
						<a href="download-resume?path=<%=java.net.URLEncoder.encode(a.getResumePath(), "UTF-8")%>"
							target="_blank" class="btn btn-primary btn-sm" style="padding: 0.25rem 0.75rem; font-size: 0.85rem;">
							<i class="fas fa-download"></i> Download
						</a>
						<%
						} else {
						%>
						<span style="color: var(--danger); font-size: 0.85rem;">
							<i class="fas fa-exclamation-triangle"></i> No Resume
						</span>
						<%
						}
						%>
					</div>

					<%-- Actions --%>
					<div class="applicant-actions">
						<div class="action-button-group">
							<form method="post" action="update-status" class="action-buttons">
								<input type="hidden" name="appId" value="<%=a.getId()%>" />
								<input type="hidden" name="jobId" value="<%=job.getId()%>" />
								<button type="submit" name="status" value="shortlisted" class="btn btn-success btn-sm">
									<i class="fas fa-check"></i> Shortlist
								</button>
								<button type="submit" name="status" value="rejected" class="btn btn-danger btn-sm">
									<i class="fas fa-times"></i> Reject
								</button>
							</form>
						</div>
						<form action="resume-details" method="get" class="view-details-form">
							<input type="hidden" name="userId" value="<%=a.getUserId()%>">
							<button type="submit" class="btn btn-info btn-sm">
								<i class="fas fa-eye"></i> View Full Details
							</button>
						</form>
					</div>
				</div>
			</div>
			<%
			}
			} else {
			%>
			<div class="col-12">
				<div class="alert alert-warning text-center">
					<span>⚠ No applicants found for this status.</span>
				</div>
			</div>
			<%
			}
			%>
		</div>
		<div style="clear: both;"></div>
	</main>

	<%@ include file="includes/footer.jsp"%>
</body>
</html>


