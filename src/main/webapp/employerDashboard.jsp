<%--
    FindNext - Employer Dashboard
    Job posting management, view applicants, and track hiring process
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employer Dashboard | <%=application.getAttribute("appName")%></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/employerDashboard.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

	<%@include file="includes/header.jsp"%>
	<%
	if ((session.getAttribute("userId") == null)
			|| !"employer".equalsIgnoreCase((String) session.getAttribute("userRole"))) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>
	<main class="container py-5">
		<div class="dashboard-header">
			<div class="welcome-message">
				<h2>Welcome, <%=session.getAttribute("userName")%> 👔</h2>
			</div>
			<div class="action-buttons">
				<button type="button" class="btn btn-primary" onclick="openPostJobModal()">
					<i class="fas fa-plus-circle"></i> Post New Job
				</button>
				<button type="button" class="btn btn-secondary" id="openFilterModalBtn">
					<i class="fas fa-filter"></i> Search by Filter
				</button>
			</div>
		</div>

		<form method="get" action="employerDashboard" class="filter-bar mb-4 desktop-filter-form">
			<div class="row">
				<div class="col-4">
					<input type="text" name="search" class="form-control"
						placeholder="Search by job title..." value="${param.search}" />
				</div>
				<div class="col-3">
					<select name="status" class="form-select">
						<option value="">All Status</option>
						<option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
						<option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
					</select>
				</div>
				<div class="col-3">
					<select name="sort" class="form-select">
						<option value="">Sort by Applicants</option>
						<option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Least to Most</option>
						<option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Most to Least</option>
					</select>
				</div>
				<div class="col-2">
					<button type="submit" class="btn btn-primary">Search</button>
				</div>
			</div>
		</form>

		<%
		java.util.List<in.findnext.models.JobPojo> jobList = (java.util.List<in.findnext.models.JobPojo>) request
				.getAttribute("jobList");
		if (jobList != null && !jobList.isEmpty()) {
		%>
		<div class="glass-card">
			<h4>📄 <%=jobList.get(0).getCompany()%>'s Posted Jobs</h4>

			<div class="employer-jobs-table">
				<table class="table mt-3">
					<thead>
						<tr>
							<th>Job Title</th>
							<th>Applicants</th>
							<th>Status</th>
							<th>Action</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (in.findnext.models.JobPojo job : jobList) {
						%>
						<tr>
							<td><%=job.getTitle()%></td>
							<td><%=job.getApplicantCount()%></td>
							<td><%=job.getStatus().toUpperCase()%></td>
							<td>
								<a href="view-applicants?jobId=<%=job.getId()%>" class="btn btn-info btn-sm" style="min-width: 80px; display: inline-flex; align-items: center; justify-content: center; gap: 0.25rem;">
									<i class="fas fa-eye"></i> View
								</a>
								<% if ("active".equals(job.getStatus())) { %>
								<a href="toggle-job?jobId=<%=job.getId()%>" class="btn btn-sm btn-warning" style="min-width: 100px; display: inline-flex; align-items: center; justify-content: center; gap: 0.25rem;">
									<i class="fas fa-pause-circle"></i> Deactivate
								</a>
								<% } else { %>
								<a href="toggle-job?jobId=<%=job.getId()%>" class="btn btn-sm btn-success" style="min-width: 100px; display: inline-flex; align-items: center; justify-content: center; gap: 0.25rem;">
									<i class="fas fa-play-circle"></i> Activate
								</a>
								<% } %>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>

			<div class="employer-jobs-cards">
				<%
				for (in.findnext.models.JobPojo job : jobList) {
				%>
				<div class="employer-job-card">
					<div class="employer-job-header">
						<div class="employer-job-title">
							<h4><%=job.getTitle()%></h4>
						</div>
					</div>
					<div class="employer-job-body">
						<div class="employer-job-info">
							<i class="fas fa-users"></i>
							<span><strong>Applicants:</strong> <%=job.getApplicantCount()%></span>
						</div>
						<div class="employer-job-info">
							<i class="fas fa-info-circle"></i>
							<span class="employer-job-status <%=job.getStatus()%>">
								<%=job.getStatus().toUpperCase()%>
							</span>
						</div>
					</div>
					<div class="employer-job-actions">
						<a href="view-applicants?jobId=<%=job.getId()%>" class="btn btn-info btn-sm">
							<i class="fas fa-eye"></i> View Applicants
						</a>
						<% if ("active".equals(job.getStatus())) { %>
						<a href="toggle-job?jobId=<%=job.getId()%>" class="btn btn-sm btn-warning">
							<i class="fas fa-pause-circle"></i> Deactivate
						</a>
						<% } else { %>
						<a href="toggle-job?jobId=<%=job.getId()%>" class="btn btn-sm btn-success">
							<i class="fas fa-play-circle"></i> Activate
						</a>
						<% } %>
					</div>
				</div>
				<%
				}
				%>
			</div>
		</div>
		<%
		} else {
		%>
		<div class="glass-card text-center">
			<p>No jobs posted yet.</p>
		</div>
		<%
		}
		%>
	</main>

	<%
	String success = request.getParameter("success");
	if ("1".equals(success)) {
	%>
	<script>
		Swal.fire({
			icon : 'success',
			title : 'Job Posted!',
			text : 'Your job has been posted successfully.',
			timer : 2000,
			showConfirmButton : false
		});
	</script>
	<%
	}
	%>

	<%
	String error = request.getParameter("error");
	if ("1".equals(error)) {
	%>
	<script>
		Swal.fire({
			icon : 'error',
			title : 'Failed!',
			text : 'Something went wrong. Please try again.',
			confirmButtonText : 'Okay'
		});
	</script>
	<%
	}
	%>

	<!-- Filter Modal -->
	<div class="modal" id="filterModal">
		<div class="modal-dialog">
			<form method="get" action="employerDashboard" class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Filter Jobs</h4>
					<button type="button" class="modal-close" onclick="closeFilterModal()">&times;</button>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label class="form-label">Search by title</label>
						<input type="text" name="search" class="form-control"
							placeholder="Search by job title..." value="${param.search}" />
					</div>
					<div class="form-group">
						<label class="form-label">Status</label>
						<select name="status" class="form-select">
							<option value="">All Status</option>
							<option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
							<option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
						</select>
					</div>
					<div class="form-group">
						<label class="form-label">Sort by Applicants</label>
						<select name="sort" class="form-select">
							<option value="">Sort by Applicants</option>
							<option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Least to Most</option>
							<option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Most to Least</option>
						</select>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-primary">Apply Filters</button>
					<button type="button" class="btn btn-secondary" onclick="closeFilterModal()">Cancel</button>
				</div>
			</form>
		</div>
	</div>

	<div class="modal" id="postJobModal">
		<div class="modal-dialog" style="max-width: 700px;">
			<form action="post-job" method="post" class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">📢 Post a New Job</h4>
					<button type="button" class="modal-close" onclick="closePostJobModal()">&times;</button>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-6">
							<div class="form-group">
								<label class="form-label">Job Title *</label>
								<input type="text" name="title" class="form-control"
									placeholder="e.g. Senior Java Developer" required />
							</div>
						</div>
						<div class="col-6">
							<div class="form-group">
								<label class="form-label">Company Name *</label>
								<input type="text" name="company" class="form-control"
									placeholder="Your Company Name" required />
							</div>
						</div>
					</div>

					<div class="form-group">
						<label class="form-label">Job Description *</label>
						<textarea name="description" class="form-control"
							placeholder="Describe the role, responsibilities, and requirements..."
							rows="4" required></textarea>
					</div>

					<div class="form-group">
						<label class="form-label">Required Skills *</label>
						<input type="text" name="skills" class="form-control"
							placeholder="Java, Spring Boot, MySQL, etc. (comma-separated)" required />
					</div>

					<div class="row">
						<div class="col-6">
							<div class="form-group">
								<label class="form-label">Location *</label>
								<select name="location" class="form-select" required>
									<option value="">Select Location</option>
									<option>Bangalore</option>
									<option>Mumbai</option>
									<option>Delhi</option>
									<option>Chennai</option>
									<option>Pune</option>
									<option>Hyderabad</option>
									<option>Bhopal</option>
									<option>Kolkata</option>
									<option>Remote</option>
									<option>Hybrid</option>
								</select>
							</div>
						</div>
						<div class="col-6">
							<div class="form-group">
								<label class="form-label">Experience Level *</label>
								<select name="experience" class="form-select" required>
									<option value="">Select Experience</option>
									<option>Fresher</option>
									<option>0 - 1 year</option>
									<option>1 - 2 years</option>
									<option>2 - 3 years</option>
									<option>3 - 5 years</option>
									<option>5+ years</option>
								</select>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-6">
							<div class="form-group">
								<label class="form-label">Package (LPA) *</label>
								<select name="packageLpa" class="form-select" required>
									<option value="">Select Package</option>
									<option>1-2 Lacs P.A.</option>
									<option>2-3 Lacs P.A.</option>
									<option>3-4 Lacs P.A.</option>
									<option>4-5 Lacs P.A.</option>
									<option>5-10 Lacs P.A.</option>
									<option>10-20 Lacs P.A.</option>
									<option>20+ Lacs P.A.</option>
									<option>Not disclosed</option>
								</select>
							</div>
						</div>
						<div class="col-6">
							<div class="form-group">
								<label class="form-label">Number of Vacancies *</label>
								<input type="number" name="vacancies" min="1" max="100"
									class="form-control" placeholder="e.g. 5" required />
							</div>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-primary btn-lg">Post Job</button>
					<button type="button" class="btn btn-secondary" onclick="closePostJobModal()">Cancel</button>
				</div>
			</form>
		</div>
	</div>

	<%@include file="includes/footer.jsp"%>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script src="${pageContext.request.contextPath}/js/employerDashboard.js"></script>
</body>
</html>

