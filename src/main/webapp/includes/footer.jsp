<%--
    FindNext - Footer Component
    Reusable footer with links, company info, and copyright notice
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<footer>
	<div class="container">
		<div class="footer-content">
			<div class="footer-section">
				<h4><i class="fas fa-briefcase"></i> <%=application.getAttribute("appName")%></h4>
				<p style="color: var(--gray-light); margin: 1rem 0;">AI-powered job portal connecting talent with opportunities worldwide.</p>
				<div style="margin-top: 1rem;">
					<a href="mailto:findnextteam@gmail.com" style="color: var(--gray-light); text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; transition: color 0.3s;" onmouseover="this.style.color='var(--primary)'" onmouseout="this.style.color='var(--gray-light)'">
						<i class="fas fa-envelope"></i> findnextteam@gmail.com
					</a>
				</div>
			</div>

			<div class="footer-section">
				<h4>For Job Seekers</h4>
				<ul>
					<li><a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-user-plus"></i> Create Profile</a></li>
					<li><a href="${pageContext.request.contextPath}/userDashboard"><i class="fas fa-search"></i> Browse Jobs</a></li>
					<li><a href="#"><i class="fas fa-file-upload"></i> Upload Resume</a></li>
					<li><a href="#"><i class="fas fa-chart-line"></i> Career Resources</a></li>
				</ul>
			</div>

			<div class="footer-section">
				<h4>For Employers</h4>
				<ul>
					<li><a href="${pageContext.request.contextPath}/register.jsp"><i class="fas fa-building"></i> Create Account</a></li>
					<li><a href="${pageContext.request.contextPath}/employerDashboard"><i class="fas fa-plus-circle"></i> Post Jobs</a></li>
					<li><a href="#"><i class="fas fa-users"></i> Find Candidates</a></li>
					<li><a href="#"><i class="fas fa-dollar-sign"></i> Pricing</a></li>
				</ul>
			</div>

			<div class="footer-section">
				<h4>Company</h4>
				<ul>
					<li><a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-info-circle"></i> About Us</a></li>
					<li><a href="${pageContext.request.contextPath}/contact.jsp"><i class="fas fa-envelope"></i> Contact</a></li>
					<li><a href="${pageContext.request.contextPath}/faq.jsp"><i class="fas fa-question-circle"></i> FAQ</a></li>
					<li><a href="${pageContext.request.contextPath}/support.jsp"><i class="fas fa-headset"></i> Support</a></li>
				</ul>
			</div>
		</div>

		<div class="footer-bottom">
			<p>&copy; <%= java.time.Year.now() %>  <%=application.getAttribute("appName")%>. All rights reserved. | Empowering careers with AI intelligence.</p>
		</div>
	</div>
</footer>
