<%--
    FindNext - Landing Page (Homepage)
    Displays hero section, features, job listings, and call-to-action for visitors
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=5">
<title><%=application.getAttribute("appName")%> - AI-Powered Job Portal</title>
<meta name="description" content="Find your dream job with AI-powered resume analysis and smart job matching">
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/index.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

	<%@include file="/includes/header.jsp"%>

	<main>
		<section class="hero-section">
			<div class="container">
				<h1><i class="fas fa-rocket"></i> Find Your Dream Job with AI Intelligence</h1>
				<p>Transform your job search with AI-powered resume analysis, intelligent matching, and personalized recommendations</p>
				<div class="hero-buttons">
					<a href="${pageContext.request.contextPath}/register.jsp" class="btn-white">
						<i class="fas fa-user-plus"></i> Get Started Free
					</a>
					<a href="#features" class="btn-outline-white">
						<i class="fas fa-info-circle"></i> Learn More
					</a>
				</div>
			</div>
		</section>

		<section id="features" style="padding: 4rem 0; background: var(--white);">
			<div class="container">
				<div class="section-header">
					<h2><i class="fas fa-star"></i> Powerful Features to Accelerate Your Career</h2>
					<p>Everything you need to find the perfect job match</p>
				</div>
				<div class="features-grid">
					<div class="feature-box">
						<i class="fas fa-brain"></i>
						<h3>AI Resume Analysis</h3>
						<p>Advanced AI extracts skills, experience, and insights from your resume in seconds</p>
					</div>
					<div class="feature-box">
						<i class="fas fa-bullseye"></i>
						<h3>Smart Job Matching</h3>
						<p>Get matched with jobs that perfectly align with your skills and career goals</p>
					</div>
					<div class="feature-box">
						<i class="fas fa-bolt"></i>
						<h3>Quick Applications</h3>
						<p>Apply to jobs instantly using your analyzed resume with just one click</p>
					</div>
					<div class="feature-box">
						<i class="fas fa-bell"></i>
						<h3>Real-time Alerts</h3>
						<p>Get notified when your application status changes - shortlisted or rejected</p>
					</div>
					<div class="feature-box">
						<i class="fas fa-sync-alt"></i>
						<h3>Easy Updates</h3>
						<p>Update your resume anytime and our AI will re-analyze it automatically</p>
					</div>
					<div class="feature-box">
						<i class="fas fa-shield-alt"></i>
						<h3>Data Security</h3>
						<p>Your data is encrypted and stored securely. We never share your information</p>
					</div>
				</div>
			</div>
		</section>

		<section style="padding: 4rem 0; background: var(--light);">
			<div class="container">
				<div class="section-header">
					<h2>How It Works</h2>
					<p>Get hired in 3 simple steps</p>
				</div>
				<div class="steps-grid">
					<div class="step-card">
						<div class="step-number">1</div>
						<i class="fas fa-user-plus"></i>
						<h3>Create Your Profile</h3>
						<p>Sign up and upload your resume. Our AI will analyze it instantly and extract your skills.</p>
					</div>
					<div class="step-card">
						<div class="step-number">2</div>
						<i class="fas fa-search"></i>
						<h3>Browse Smart Matches</h3>
						<p>View personalized job recommendations based on your skills and experience with match scores.</p>
					</div>
					<div class="step-card">
						<div class="step-number">3</div>
						<i class="fas fa-rocket"></i>
						<h3>Apply & Get Hired</h3>
						<p>Apply with one click and track your applications in real-time with status updates.</p>
					</div>
				</div>
			</div>
		</section>

		<section style="padding: 4rem 0;">
			<div class="container">
				<div class="cta-section">
					<h2><i class="fas fa-star"></i> Ready to Transform Your Job Search?</h2>
					<p>Join professionals who have found their dream jobs using our AI-powered platform</p>
					<div class="hero-buttons">
						<a href="${pageContext.request.contextPath}/register.jsp" class="btn-white">
							<i class="fas fa-user-plus"></i> Create Free Account
						</a>
						<a href="${pageContext.request.contextPath}/login.jsp" class="btn-outline-white">
							<i class="fas fa-sign-in-alt"></i> Sign In
						</a>
					</div>
				</div>
			</div>
		</section>
	</main>

	<%@include file="includes/footer.jsp"%>

</body>
</html>

