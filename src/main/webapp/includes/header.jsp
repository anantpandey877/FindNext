<%--
    FindNext - Navigation Header Component
    Reusable navigation bar with logo, menu items, and user authentication links
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<nav class="navbar" id="navbar">
	<div class="container">
		<div class="navbar-content">
			<a class="navbar-brand" href="${pageContext.request.contextPath}/home">
				<i class="fas fa-briefcase"></i>
				<%=application.getAttribute("appName")%>
			</a>

			<button class="navbar-toggle" id="navbarToggle" onclick="toggleMenu()">
				<i class="fas fa-bars"></i>
			</button>

			<ul class="navbar-menu" id="navbarMenu">
				<%
				String role = (String) session.getAttribute("userRole");
				if (role == null) {
				%>
				<li><a href="${pageContext.request.contextPath}/home#features"><i class="fas fa-star"></i> Features</a></li>
				<li><a href="${pageContext.request.contextPath}/signin"><i class="fas fa-sign-in-alt"></i> Login</a></li>
				<li><a href="${pageContext.request.contextPath}/signup"><i class="fas fa-user-plus"></i> Sign Up</a></li>
				<%
				} else if ("user".equals(role)) {
				%>
				<li><a href="${pageContext.request.contextPath}/userDashboard"><i class="fas fa-th-large"></i> Dashboard</a></li>
				<li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
				<%
				} else if ("employer".equals(role)) {
				%>
				<li><a href="${pageContext.request.contextPath}/employerDashboard"><i class="fas fa-th-large"></i> Dashboard</a></li>
				<li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
				<%
				} else if ("admin".equals(role)) {
				%>
				<li><a href="${pageContext.request.contextPath}/adminPanel"><i class="fas fa-cog"></i> Admin Panel</a></li>
				<li><a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
				<%
				}
				%>
			</ul>
		</div>
	</div>
</nav>

<script>
function toggleMenu() {
	const menu = document.getElementById('navbarMenu');
	menu.classList.toggle('active');
}

// Add scroll effect to navbar
window.addEventListener('scroll', function() {
	const navbar = document.getElementById('navbar');
	if (window.scrollY > 50) {
		navbar.classList.add('scrolled');
	} else {
		navbar.classList.remove('scrolled');
	}
});
</script>
