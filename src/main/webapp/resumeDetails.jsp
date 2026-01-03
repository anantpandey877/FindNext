<%--
    FindNext - Resume Details Page
    Displays AI-analyzed resume information including skills, experience, and education
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Resume Details | FindNext</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/jpeg"
	href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css"
	rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>
	<%@ include file="includes/header.jsp"%>

	<main class="container py-5">
		<%
		String error = (String) request.getAttribute("error");
		if (error != null) {
		%>
		<div class="alert alert-warning">
			<span>⚠ <%=error%></span>
		</div>
		<%
		} else {
		String summary = (String) request.getAttribute("summary");
		List<String> skills = (List<String>) request.getAttribute("skillsList");
		String personal = (String) request.getAttribute("personalDetails");
		String education = (String) request.getAttribute("education");
		String work = (String) request.getAttribute("workExperience");
		int skillCount = skills != null ? skills.size() : 0;
		%>

		<div class="glass-card mb-4">
			<div class="card-header" style="background: var(--primary-color); color: white; border-radius: var(--border-radius); padding: 1rem; margin-bottom: 1rem;">
				🔎 Personal Details
			</div>
			<p><%=personal != null ? personal : "No personal details available."%></p>
		</div>

		<div class="glass-card mb-4">
			<div class="card-header" style="background: var(--success-color); color: white; border-radius: var(--border-radius); padding: 1rem; margin-bottom: 1rem;">
				🛠️ Skills
			</div>
			<ul style="margin-left: 1.5rem;">
				<%
				if (skills != null && !skills.isEmpty()) {
					for (String skill : skills) {
				%>
					<li><%=skill%></li>
				<%
					}
				} else {
				%>
					<li style="color: rgba(255, 255, 255, 0.6);">No skills detected.</li>
				<%
				}
				%>
			</ul>
		</div>

		<div class="glass-card mb-4">
			<div class="card-header" style="background: var(--primary-color); color: white; border-radius: var(--border-radius); padding: 1rem; margin-bottom: 1rem;">
				🔎 Summary
			</div>
			<p><%=summary != null ? summary : "No summary available."%></p>
		</div>

		<div class="glass-card mb-4">
			<div class="card-header" style="background: var(--primary-color); color: white; border-radius: var(--border-radius); padding: 1rem; margin-bottom: 1rem;">
				🔎 Education
			</div>
			<p><%=education != null ? education : "No education available."%></p>
		</div>

		<div class="glass-card mb-4">
			<div class="card-header" style="background: var(--primary-color); color: white; border-radius: var(--border-radius); padding: 1rem; margin-bottom: 1rem;">
				🔎 Work Experience
			</div>
			<p><%=work != null ? work : "No work experience available."%></p>
		</div>

		<%
		if (skillCount > 0) {
		%>
		<div class="glass-card mb-4">
			<div class="card-header" style="background: var(--info-color); color: white; border-radius: var(--border-radius); padding: 1rem; margin-bottom: 1rem;">
				📊 Resume Analysis Summary
			</div>
			<p>Detected skills: <%=skillCount%></p>
		</div>
		<%
		}
		%>
		<% } %>
	</main>

	<%@ include file="includes/footer.jsp"%>
</body>
</html>

