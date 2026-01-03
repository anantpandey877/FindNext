<%--
    FindNext - Job Seeker Dashboard
    Shows available jobs, application status, resume update, and filtering options
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Set"%>
<%@ page import="in.findnext.models.JobPojo"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Dashboard | ${applicationScope.appName}</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/userDashboard.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

	<%@ include file="includes/header.jsp"%>
	<%
	if (session.getAttribute("userId") == null) {
		response.sendRedirect("login.jsp");
		return;
	}
	%>

	<%
	String resumeAnalysisError = (String) session.getAttribute("resume_analysis_error");
	if (resumeAnalysisError != null && !resumeAnalysisError.trim().isEmpty()) {
		session.removeAttribute("resume_analysis_error");
	%>
		<div class="container" style="margin-top: 1rem;">
			<div class="alert alert-warning" style="margin-bottom: 0;">
				<i class="fas fa-exclamation-triangle"></i>
				<%= resumeAnalysisError %>
			</div>
		</div>
	<%
	}
	%>

	<main class="container py-5">

		<!-- Welcome Message & Desktop Action Button -->
		<div class="welcome-header">
			<h2>
				Welcome, <%=session.getAttribute("userName")%> 👋
			</h2>
			<%
			Boolean resumeUploaded = (Boolean) request.getAttribute("resumeUploaded");
			if (resumeUploaded != null && resumeUploaded) {
			%>
			<button type="button" class="btn btn-success update-resume-btn" onclick="openUpdateResumeModal()">
				<i class="fas fa-sync-alt"></i> Update Resume
			</button>
			<%
			}
			%>
		</div>

		<!-- Mobile Action Buttons Row -->
		<div class="action-buttons-row">
			<!-- Mobile Filter Button (visible only on mobile) -->
			<button type="button" class="btn btn-primary mobile-filter-btn" onclick="openFilterModal()">
				<i class="fas fa-filter"></i> Filter Jobs
			</button>
		</div>

		<!-- Desktop Filter Form (hidden on mobile) -->
		<form method="get" action="userDashboard" class="filter-bar desktop-filter-form">
			<div class="row">
				<div class="col-4">
					<input type="text" name="search" class="form-control"
						placeholder="Search by title or company..."
						value="${param.search}" />
				</div>
				<div class="col-2">
					<input type="text" name="location" class="form-control"
						placeholder="Location" value="${param.location}" />
				</div>
				<div class="col-2">
					<select name="experience" class="form-select">
						<option value="">Any Experience</option>
						<option value="Fresher" ${param.experience == 'Fresher' ? 'selected' : ''}>Fresher</option>
						<option value="0 - 1 year" ${param.experience == '0 - 1 year' ? 'selected' : ''}>0 - 1 year</option>
						<option value="1 - 2 years" ${param.experience == '1 - 2 years' ? 'selected' : ''}>1 - 2 years</option>
						<option value="2 - 3 years" ${param.experience == '2 - 3 years' ? 'selected' : ''}>2 - 3 years</option>
						<option value="3 - 5 years" ${param.experience == '3 - 5 years' ? 'selected' : ''}>3 - 5 years</option>
						<option value="5+ years" ${param.experience == '5+ years' ? 'selected' : ''}>5+ years</option>
					</select>
				</div>
				<div class="col-2">
					<select name="packageLpa" class="form-select">
						<option value="">Any Package</option>
						<option value="1-2 Lacs P.A." ${param.packageLpa == '1-2 Lacs P.A.' ? 'selected' : ''}>1-2 LPA</option>
						<option value="2-3 Lacs P.A." ${param.packageLpa == '2-3 Lacs P.A.' ? 'selected' : ''}>2-3 LPA</option>
						<option value="3-4 Lacs P.A." ${param.packageLpa == '3-4 Lacs P.A.' ? 'selected' : ''}>3-4 LPA</option>
						<option value="4-5 Lacs P.A." ${param.packageLpa == '4-5 Lacs P.A.' ? 'selected' : ''}>4-5 LPA</option>
						<option value="5+ Lacs P.A." ${param.packageLpa == '5+ Lacs P.A.' ? 'selected' : ''}>5+ LPA</option>
						<option value="Not disclosed" ${param.packageLpa == 'Not disclosed' ? 'selected' : ''}>Not disclosed</option>
					</select>
				</div>
				<div class="col-2">
					<select name="sort" class="form-select">
						<option value="">Sort by Applicants</option>
						<option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Fewest First</option>
						<option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Most First</option>
					</select>
				</div>
				<div class="button-row">
					<div class="col-1">
						<button type="submit" class="btn btn-primary"><i class="fas fa-search"></i> Search</button>
					</div>
					<div class="col-1">
						<button type="button" class="btn btn-outline" onclick="clearAllFilters()"><i class="fas fa-times"></i> Clear</button>
					</div>
				</div>
			</div>
		</form>

		<%
		List<JobPojo> jobs = (List<JobPojo>) request.getAttribute("jobs");
		Set<Integer> appliedJobIds = (Set<Integer>) request.getAttribute("appliedJobIds");
		java.util.Map<Integer, String> jobStatusMap = (java.util.Map<Integer, String>) request.getAttribute("jobStatusMap");

		// Group jobs by status
		java.util.List<JobPojo> notAppliedJobs = new java.util.ArrayList<>();
		java.util.List<JobPojo> appliedJobs = new java.util.ArrayList<>();
		java.util.List<JobPojo> shortlistedJobs = new java.util.ArrayList<>();
		java.util.List<JobPojo> rejectedJobs = new java.util.ArrayList<>();

		if (jobs != null && !jobs.isEmpty()) {
			for (JobPojo job : jobs) {
				if (!appliedJobIds.contains(job.getId())) {
					notAppliedJobs.add(job);
				} else {
					String status = jobStatusMap.get(job.getId());
					if ("applied".equalsIgnoreCase(status)) {
						appliedJobs.add(job);
					} else if ("shortlisted".equalsIgnoreCase(status)) {
						shortlistedJobs.add(job);
					} else if ("rejected".equalsIgnoreCase(status)) {
						rejectedJobs.add(job);
					}
				}
			}
		}
		%>

		<div class="job-section">
			<h4 style="color: var(--primary); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.75rem;">
			</h4>
			<div class="row" style="margin: 0 -1rem;">
				<%
				if (!notAppliedJobs.isEmpty()) {
					for (JobPojo job : notAppliedJobs) {
				%>
				<div class="col-4" style="padding: 0 1rem; margin-bottom: 2rem;">
					<div class="job-card">
						<%-- Match Score Badge --%>
						<% if (resumeUploaded) { %>
						<div class="match-score">Match: <%=job.getScore()%>%</div>
						<% } %>

						<%-- Posted Date --%>
						<div style="font-size: 0.75rem; color: var(--gray); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.25rem;">
							<i class="fas fa-clock"></i>
							<%=job.getCreatedAt() != null ? new java.text.SimpleDateFormat("d MMM").format(job.getCreatedAt()) : ""%>
						</div>

						<div class="job-card-header" style="padding-right: 0;">
							<div style="flex: 1;">
								<div class="job-title"><%=job.getTitle()%></div>
								<div class="job-company"><%=job.getCompany()%></div>
							</div>
						</div>

						<div class="job-meta">
							<div class="job-meta-item">💼 <%=job.getExperience()%></div>
							<div class="job-meta-item">💰 <%=job.getPackageLpa()%></div>
							<div class="job-meta-item">📍 <%=job.getLocation()%></div>
							<div class="job-meta-item">👥 <%=job.getVacancies()%> Openings</div>
						</div>

						<div class="job-card-actions">
							<button type="button" class="btn btn-primary btn-sm"
								onclick="openResumePopup(<%=job.getId()%>, <%=job.getScore()%>, '<%=job.getSkills().replace("'", "\\'")%>')">
								<i class="fas fa-paper-plane"></i> Apply Now
							</button>
							<button type="button" class="btn btn-outline btn-sm"
								onclick='showDetails(<%=job.getId()%>, "<%=job.getTitle().replace("\"", "&quot;")%>", "<%=job.getCompany().replace("\"", "&quot;")%>", "<%=job.getLocation().replace("\"", "&quot;")%>", "<%=job.getExperience().replace("\"", "&quot;")%>", "<%=job.getPackageLpa().replace("\"", "&quot;")%>", "<%=job.getVacancies()%>", "<%=job.getSkills().replace("\"", "&quot;")%>", "<%=job.getDescription().replace("\"", "&quot;")%>", "<%=new java.text.SimpleDateFormat("dd MMM yyyy").format(job.getCreatedAt())%>")'>
								<i class="fas fa-info-circle"></i> Details
							</button>
						</div>
					</div>
				</div>
				<%
					}
				} else {
				%>
				<div class="col-12" style="padding: 2rem; text-align: center; color: var(--gray);">
					<i class="fas fa-inbox" style="font-size: 3rem; opacity: 0.3; margin-bottom: 1rem;"></i>
					<p>No available jobs at the moment</p>
				</div>
				<% } %>
			</div>
		</div>

		<% if (!appliedJobs.isEmpty()) { %>
		<div class="job-section" style="margin-top: 3rem;">
			<h4 class="collapsible-header" onclick="toggleSection('appliedSection')" style="color: #0ea5e9; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.75rem; cursor: pointer; user-select: none;">
				<i class="fas fa-chevron-down toggle-icon" id="appliedIcon"></i>
				<i class="fas fa-clock"></i> Applied Jobs <span class="badge badge-info" style="font-size: 0.875rem;"><%=appliedJobs.size()%></span>
			</h4>
			<div class="row collapsible-content" id="appliedSection" style="margin: 0 -1rem;">
				<%
				for (JobPojo job : appliedJobs) {
				%>
				<div class="col-4" style="padding: 0 1rem; margin-bottom: 2rem;">
					<div class="job-card">
						<% if (resumeUploaded) { %>
						<div class="match-score">Match: <%=job.getScore()%>%</div>
						<% } %>

						<div style="font-size: 0.75rem; color: var(--gray); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.25rem;">
							<i class="fas fa-clock"></i>
							<%=job.getCreatedAt() != null ? new java.text.SimpleDateFormat("d MMM").format(job.getCreatedAt()) : ""%>
						</div>

						<div class="job-card-header" style="padding-right: 0;">
							<div style="flex: 1;">
								<div class="job-title"><%=job.getTitle()%></div>
								<div class="job-company"><%=job.getCompany()%></div>
							</div>
						</div>

						<div class="job-meta">
							<div class="job-meta-item">💼 <%=job.getExperience()%></div>
							<div class="job-meta-item">💰 <%=job.getPackageLpa()%></div>
							<div class="job-meta-item">📍 <%=job.getLocation()%></div>
							<div class="job-meta-item">👥 <%=job.getVacancies()%> Openings</div>
						</div>

						<div class="job-card-actions">
							<span class="badge badge-info" style="padding: 0.5rem 1rem; font-size: 0.9rem; white-space: nowrap; background: #0ea5e9;">
								<i class="fas fa-paper-plane"></i> Applied
							</span>
							<button type="button" class="btn btn-outline btn-sm"
								onclick='showDetails(<%=job.getId()%>, "<%=job.getTitle().replace("\"", "&quot;")%>", "<%=job.getCompany().replace("\"", "&quot;")%>", "<%=job.getLocation().replace("\"", "&quot;")%>", "<%=job.getExperience().replace("\"", "&quot;")%>", "<%=job.getPackageLpa().replace("\"", "&quot;")%>", "<%=job.getVacancies()%>", "<%=job.getSkills().replace("\"", "&quot;")%>", "<%=job.getDescription().replace("\"", "&quot;")%>", "<%=new java.text.SimpleDateFormat("dd MMM yyyy").format(job.getCreatedAt())%>")'>
								<i class="fas fa-info-circle"></i> Details
							</button>
						</div>
					</div>
				</div>
				<% } %>
			</div>
		</div>
		<% } %>

		<% if (!shortlistedJobs.isEmpty()) { %>
		<div class="job-section" style="margin-top: 3rem;">
			<h4 class="collapsible-header" onclick="toggleSection('shortlistedSection')" style="color: var(--success); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.75rem; cursor: pointer; user-select: none;">
				<i class="fas fa-chevron-down toggle-icon" id="shortlistedIcon"></i>
				<i class="fas fa-star"></i> Shortlisted Jobs <span class="badge badge-success" style="font-size: 0.875rem;"><%=shortlistedJobs.size()%></span>
			</h4>
			<div class="row collapsible-content" id="shortlistedSection" style="margin: 0 -1rem;">
				<%
				for (JobPojo job : shortlistedJobs) {
				%>
				<div class="col-4" style="padding: 0 1rem; margin-bottom: 2rem;">
					<div class="job-card" style="border-color: var(--success);">
						<% if (resumeUploaded) { %>
						<div class="match-score">Match: <%=job.getScore()%>%</div>
						<% } %>

						<div style="font-size: 0.75rem; color: var(--gray); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.25rem;">
							<i class="fas fa-clock"></i>
							<%=job.getCreatedAt() != null ? new java.text.SimpleDateFormat("d MMM").format(job.getCreatedAt()) : ""%>
						</div>

						<div class="job-card-header" style="padding-right: 0;">
							<div style="flex: 1;">
								<div class="job-title"><%=job.getTitle()%></div>
								<div class="job-company"><%=job.getCompany()%></div>
							</div>
						</div>

						<div class="job-meta">
							<div class="job-meta-item">💼 <%=job.getExperience()%></div>
							<div class="job-meta-item">💰 <%=job.getPackageLpa()%></div>
							<div class="job-meta-item">📍 <%=job.getLocation()%></div>
							<div class="job-meta-item">👥 <%=job.getVacancies()%> Openings</div>
						</div>

						<div class="job-card-actions">
							<span class="badge badge-success" style="padding: 0.5rem 1rem; font-size: 0.9rem; white-space: nowrap;">
								<i class="fas fa-star"></i> Shortlisted
							</span>
							<button type="button" class="btn btn-outline btn-sm"
								onclick='showDetails(<%=job.getId()%>, "<%=job.getTitle().replace("\"", "&quot;")%>", "<%=job.getCompany().replace("\"", "&quot;")%>", "<%=job.getLocation().replace("\"", "&quot;")%>", "<%=job.getExperience().replace("\"", "&quot;")%>", "<%=job.getPackageLpa().replace("\"", "&quot;")%>", "<%=job.getVacancies()%>", "<%=job.getSkills().replace("\"", "&quot;")%>", "<%=job.getDescription().replace("\"", "&quot;")%>", "<%=new java.text.SimpleDateFormat("dd MMM yyyy").format(job.getCreatedAt())%>")'>
								<i class="fas fa-info-circle"></i> Details
							</button>
						</div>
					</div>
				</div>
				<% } %>
			</div>
		</div>
		<% } %>

		<% if (!rejectedJobs.isEmpty()) { %>
		<div class="job-section" style="margin-top: 3rem;">
			<h4 class="collapsible-header" onclick="toggleSection('rejectedSection')" style="color: var(--danger); margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.75rem; cursor: pointer; user-select: none;">
				<i class="fas fa-chevron-down toggle-icon" id="rejectedIcon"></i>
				<i class="fas fa-times-circle"></i> Rejected Jobs <span class="badge badge-danger" style="font-size: 0.875rem;"><%=rejectedJobs.size()%></span>
			</h4>
			<div class="row collapsible-content" id="rejectedSection" style="margin: 0 -1rem;">
				<%
				for (JobPojo job : rejectedJobs) {
				%>
				<div class="col-4" style="padding: 0 1rem; margin-bottom: 2rem;">
					<div class="job-card" style="border-color: var(--danger); opacity: 0.85;">
						<% if (resumeUploaded) { %>
						<div class="match-score" style="background: var(--danger);">Match: <%=job.getScore()%>%</div>
						<% } %>

						<div style="font-size: 0.75rem; color: var(--gray); margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.25rem;">
							<i class="fas fa-clock"></i>
							<%=job.getCreatedAt() != null ? new java.text.SimpleDateFormat("d MMM").format(job.getCreatedAt()) : ""%>
						</div>

						<div class="job-card-header" style="padding-right: 0;">
							<div style="flex: 1;">
								<div class="job-title"><%=job.getTitle()%></div>
								<div class="job-company"><%=job.getCompany()%></div>
							</div>
						</div>

						<div class="job-meta">
							<div class="job-meta-item">💼 <%=job.getExperience()%></div>
							<div class="job-meta-item">💰 <%=job.getPackageLpa()%></div>
							<div class="job-meta-item">📍 <%=job.getLocation()%></div>
							<div class="job-meta-item">👥 <%=job.getVacancies()%> Openings</div>
						</div>

						<div class="job-card-actions">
							<span class="badge badge-danger" style="padding: 0.5rem 1rem; font-size: 0.9rem; white-space: nowrap;">
								<i class="fas fa-times-circle"></i> Rejected
							</span>
							<button type="button" class="btn btn-outline btn-sm"
								onclick='showDetails(<%=job.getId()%>, "<%=job.getTitle().replace("\"", "&quot;")%>", "<%=job.getCompany().replace("\"", "&quot;")%>", "<%=job.getLocation().replace("\"", "&quot;")%>", "<%=job.getExperience().replace("\"", "&quot;")%>", "<%=job.getPackageLpa().replace("\"", "&quot;")%>", "<%=job.getVacancies()%>", "<%=job.getSkills().replace("\"", "&quot;")%>", "<%=job.getDescription().replace("\"", "&quot;")%>", "<%=new java.text.SimpleDateFormat("dd MMM yyyy").format(job.getCreatedAt())%>")'>
								<i class="fas fa-info-circle"></i> Details
							</button>
						</div>
					</div>
				</div>
				<% } %>
			</div>
		</div>
		<% } %>

		<% if (jobs == null || jobs.isEmpty()) { %>
		<div style="text-align: center; padding: 4rem 2rem;">
			<i class="fas fa-search" style="font-size: 4rem; color: var(--gray-light); margin-bottom: 1rem;"></i>
			<p style="color: var(--danger); font-size: 1.2rem;">No jobs found matching your criteria.</p>
		</div>
		<% } %>

	</main>

	<!-- Job Details Modal -->
	<div class="modal" id="jobDetailsModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modalJobTitle">Job Title</h5>
					<button type="button" class="modal-close" onclick="closeModal('jobDetailsModal')">&times;</button>
				</div>
				<div class="modal-body">
					<p><strong>Company:</strong> <span id="modalCompany"></span></p>
					<p><strong>Location:</strong> <span id="modalLocation"></span></p>
					<p><strong>Experience:</strong> <span id="modalExperience"></span></p>
					<p><strong>Package:</strong> <span id="modalPackage"></span></p>
					<p><strong>Vacancies:</strong> <span id="modalVacancies"></span></p>
					<p><strong>Skills:</strong> <span id="modalSkills"></span></p>
					<p><strong>Description:</strong> <span id="modalDescription"></span></p>
					<p><strong>Posted On:</strong> <span id="modalPostedDate"></span></p>
				</div>
			</div>
		</div>
	</div>

	<!-- Update Resume Modal -->
	<div class="modal" id="updateResumeModal">
		<div class="modal-dialog">
			<form id="updateResumeForm" method="post" action="update-resume" enctype="multipart/form-data" class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fas fa-sync-alt"></i> Update Your Resume
					</h5>
					<button type="button" class="modal-close" onclick="closeModal('updateResumeModal')">&times;</button>
				</div>
				<div class="modal-body">
					<div class="alert alert-info" style="margin-bottom: 1rem; display: block; overflow: hidden;">
						<div style="display: flex; align-items: flex-start; gap: 0.5rem; margin-bottom: 0.5rem;">
							<i class="fas fa-info-circle" style="flex-shrink: 0; margin-top: 0.125rem;"></i>
							<strong>Note:</strong>
						</div>
						<div style="font-size: 0.9rem;">Updating your resume will:</div>
						<ul style="margin: 0.5rem 0 0 1.25rem; padding: 0; font-size: 0.875rem; line-height: 1.6;">
							<li>Replace your current resume</li>
							<li>Re-analyze your skills using AI</li>
							<li>Recalculate match scores for all your applications</li>
						</ul>
					</div>

					<div class="form-group">
						<label for="updateResumeFile" class="form-label">
							<i class="fas fa-file-pdf"></i> Select New Resume (PDF only)
						</label>
						<input type="file" id="updateResumeFile" name="resume" class="form-control"
							accept=".pdf" required
							onchange="showFileName(this)" />
						<small class="form-text" style="color: var(--gray); display: block; margin-top: 0.5rem;">
							Maximum file size: 5MB
						</small>
					</div>

					<div id="updateFileInfo" style="display: none; margin-top: 1rem; padding: 0.75rem; background: #f0fdf4; border: 1px solid #86efac; border-radius: var(--radius-md);">
						<i class="fas fa-check-circle" style="color: var(--success);"></i>
						<span id="updateFileName" style="color: var(--success); font-weight: 600;"></span>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" onclick="closeModal('updateResumeModal')">
						<i class="fas fa-times"></i> Cancel
					</button>
					<button type="submit" class="btn btn-success" id="updateResumeBtn">
						<i class="fas fa-upload"></i> Update Resume
					</button>
				</div>
			</form>
		</div>
	</div>

	<!-- Mobile Filter Modal -->
	<div class="modal" id="filterModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">
						<i class="fas fa-filter"></i> Search Filters
					</h5>
					<button type="button" class="modal-close" onclick="closeFilterModal()">&times;</button>
				</div>
				<form method="get" action="userDashboard" id="mobileFilterForm">
					<div class="modal-body">
						<div class="form-group" style="margin-bottom: 1rem;">
							<label class="form-label">
								<i class="fas fa-search"></i> Search
							</label>
							<input type="text" name="search" class="form-control"
								placeholder="Search by title or company..."
								value="${param.search}" />
						</div>
						<div class="form-group" style="margin-bottom: 1rem;">
							<label class="form-label">
								<i class="fas fa-map-marker-alt"></i> Location
							</label>
							<input type="text" name="location" class="form-control"
								placeholder="Location" value="${param.location}" />
						</div>
						<div class="form-group" style="margin-bottom: 1rem;">
							<label class="form-label">
								<i class="fas fa-briefcase"></i> Experience
							</label>
							<select name="experience" class="form-select">
								<option value="">Any Experience</option>
								<option value="Fresher" ${param.experience == 'Fresher' ? 'selected' : ''}>Fresher</option>
								<option value="0 - 1 year" ${param.experience == '0 - 1 year' ? 'selected' : ''}>0 - 1 year</option>
								<option value="1 - 2 years" ${param.experience == '1 - 2 years' ? 'selected' : ''}>1 - 2 years</option>
								<option value="2 - 3 years" ${param.experience == '2 - 3 years' ? 'selected' : ''}>2 - 3 years</option>
								<option value="3 - 5 years" ${param.experience == '3 - 5 years' ? 'selected' : ''}>3 - 5 years</option>
								<option value="5+ years" ${param.experience == '5+ years' ? 'selected' : ''}>5+ years</option>
							</select>
						</div>
						<div class="form-group" style="margin-bottom: 1rem;">
							<label class="form-label">
								<i class="fas fa-dollar-sign"></i> Package
							</label>
							<select name="packageLpa" class="form-select">
								<option value="">Any Package</option>
								<option value="1-2 Lacs P.A." ${param.packageLpa == '1-2 Lacs P.A.' ? 'selected' : ''}>1-2 LPA</option>
								<option value="2-3 Lacs P.A." ${param.packageLpa == '2-3 Lacs P.A.' ? 'selected' : ''}>2-3 LPA</option>
								<option value="3-4 Lacs P.A." ${param.packageLpa == '3-4 Lacs P.A.' ? 'selected' : ''}>3-4 LPA</option>
								<option value="4-5 Lacs P.A." ${param.packageLpa == '4-5 Lacs P.A.' ? 'selected' : ''}>4-5 LPA</option>
								<option value="5+ Lacs P.A." ${param.packageLpa == '5+ Lacs P.A.' ? 'selected' : ''}>5+ LPA</option>
								<option value="Not disclosed" ${param.packageLpa == 'Not disclosed' ? 'selected' : ''}>Not disclosed</option>
							</select>
						</div>
						<div class="form-group">
							<label class="form-label">
								<i class="fas fa-sort"></i> Sort by Applicants
							</label>
							<select name="sort" class="form-select">
								<option value="">Default</option>
								<option value="asc" ${param.sort == 'asc' ? 'selected' : ''}>Fewest First</option>
								<option value="desc" ${param.sort == 'desc' ? 'selected' : ''}>Most First</option>
							</select>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary" onclick="clearMobileFilters()">
							<i class="fas fa-times"></i> Clear
						</button>
						<button type="submit" class="btn btn-primary">
							<i class="fas fa-search"></i> Search
						</button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<%@ include file="includes/footer.jsp"%>
	<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
	<script>
    <%if (request.getParameter("applied") != null) {%>
      Swal.fire({ icon: 'success', title: 'Applied Successfully', showConfirmButton: false, timer: 1500 }).then(() => {
        window.location.href = 'userDashboard';
      });
    <%}%>

    <%if (request.getParameter("resumeUpdated") != null) {%>
      Swal.fire({
        icon: 'success',
        title: 'Resume Updated Successfully!',
        text: 'Your match scores have been recalculated.',
        showConfirmButton: false,
        timer: 2000
      }).then(() => {
        window.location.href = 'userDashboard';
      });
    <%}%>

    // Pass resume uploaded status to JS (always boolean)
    const resumeUploaded = <%= Boolean.TRUE.equals(request.getAttribute("resumeUploaded")) ? "true" : "false" %>;

    // Override function to pass resumeUploaded parameter
    const originalOpenResumePopup = window.openResumePopup;
    window.openResumePopup = function(jobId, score, skills) {
      if (typeof originalOpenResumePopup === 'function') {
        originalOpenResumePopup(jobId, score, skills, resumeUploaded);
      }
    };
  </script>
	<script src="${pageContext.request.contextPath}/js/userDashboard.js"></script>

	<!-- Upload Resume Modal -->
	<div class="modal" id="resumeModal">
		<div class="modal-dialog">
			<form id="resumeForm" method="post" enctype="multipart/form-data" action="upload-resume" class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">📄 Upload Resume</h5>
					<button type="button" class="modal-close" onclick="closeModal('resumeModal')">&times;</button>
				</div>
				<div class="modal-body">
					<input type="hidden" name="jobId" id="modalJobId">
					<div class="form-group">
						<label for="resumeFile" class="form-label">Upload Resume (PDF)</label>
						<input type="file" name="resume" id="resumeFile" class="form-control" accept=".pdf" required />
					</div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-success">Continue</button>
					<button type="button" class="btn btn-secondary" onclick="closeModal('resumeModal')">Cancel</button>
				</div>
			</form>
		</div>
	</div>

</body>
</html>


