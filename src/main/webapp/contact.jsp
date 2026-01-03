<%--
    FindNext - Contact Page
    Contact form for users to reach out to FindNext team
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Contact Us | <%=application.getAttribute("appName")%></title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/contact.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <%@include file="/includes/header.jsp"%>

    <main>
        <div class="contact-container">
            <div class="contact-header">
                <h1><i class="fas fa-envelope"></i> Contact Us</h1>
                <p class="lead">Get in touch with us. We'd love to hear from you!</p>
            </div>

            <div class="contact-grid">
                <div class="contact-info">
                    <h3><i class="fas fa-envelope-open-text"></i> Get in Touch</h3>

                    <div class="info-item">
                        <i class="fas fa-envelope"></i>
                        <div>
                            <h4>Email Address</h4>
                            <p><a href="mailto:findnextteam@gmail.com" style="color: var(--primary); text-decoration: none;">findnextteam@gmail.com</a></p>
                            <small style="color: var(--gray);">We respond within 24 hours</small>
                        </div>
                    </div>

                    <div class="info-item">
                        <i class="fas fa-clock"></i>
                        <div>
                            <h4>Response Time</h4>
                            <p>We aim to respond to all inquiries within 24 hours during business days.</p>
                        </div>
                    </div>

                    <div class="info-item">
                        <i class="fas fa-globe"></i>
                        <div>
                            <h4>Online Support</h4>
                            <p>100% remote support available worldwide. We're here to help you succeed!</p>
                        </div>
                    </div>

                    <div style="background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%); padding: 1.5rem; border-radius: var(--radius-lg); color: var(--white); margin-top: 1rem;">
                        <h4 style="color: var(--white); margin-bottom: 0.5rem;"><i class="fas fa-star"></i> Quick Help</h4>
                        <p style="margin: 0; font-size: 0.9rem;">For immediate assistance, check our <a href="${pageContext.request.contextPath}/faq.jsp" style="color: var(--white); text-decoration: underline;">FAQ page</a> or submit a <a href="${pageContext.request.contextPath}/support.jsp" style="color: var(--white); text-decoration: underline;">support ticket</a>.</p>
                    </div>
                </div>

                <div class="contact-form">
                    <h3><i class="fas fa-paper-plane"></i> Send us a Message</h3>

                    <% if (request.getParameter("success") != null) { %>
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Thank you! Your message has been sent successfully. We'll get back to you soon.</span>
                    </div>
                    <% } %>

                    <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>Oops! Something went wrong. Please try again later.</span>
                    </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/contact" method="post">
                        <div class="form-group">
                            <label class="form-label">Your Name *</label>
                            <input type="text" name="name" class="form-control" placeholder="John Doe" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email Address *</label>
                            <input type="email" name="email" class="form-control" placeholder="john@example.com" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Phone Number</label>
                            <input type="tel" name="phone" class="form-control" placeholder="+1 (555) 123-4567">
                        </div>

                        <div class="form-group">
                            <label class="form-label">Subject *</label>
                            <input type="text" name="subject" class="form-control" placeholder="How can we help you?" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Message *</label>
                            <textarea name="message" class="form-control" rows="6" placeholder="Tell us more about your inquiry..." required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block">
                            <i class="fas fa-paper-plane"></i> Send Message
                        </button>
                    </form>
                </div>
            </div>

            <div class="card" style="margin-top: 3rem; padding: 2rem; background: var(--light); border: none;">
                <div class="text-center">
                    <h3><i class="fas fa-comments"></i> We Value Your Feedback</h3>
                    <p style="color: var(--gray); margin: 1rem 0;">Whether you have a question, suggestion, or just want to say hello, we'd love to hear from you. Our team is dedicated to providing the best experience possible.</p>
                    <div style="display: flex; justify-content: center; gap: 2rem; margin-top: 2rem; flex-wrap: wrap;">
                        <div>
                            <i class="fas fa-check-circle" style="color: var(--success); font-size: 2rem;"></i>
                            <p style="margin: 0.5rem 0 0 0; font-weight: 600;">Fast Response</p>
                        </div>
                        <div>
                            <i class="fas fa-shield-alt" style="color: var(--info); font-size: 2rem;"></i>
                            <p style="margin: 0.5rem 0 0 0; font-weight: 600;">Secure</p>
                        </div>
                        <div>
                            <i class="fas fa-heart" style="color: var(--danger); font-size: 2rem;"></i>
                            <p style="margin: 0.5rem 0 0 0; font-weight: 600;">Friendly Team</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row" style="margin-top: 3rem;">
                <div class="col-4">
                    <div class="card text-center">
                        <i class="fas fa-headset" style="font-size: 3rem; color: var(--primary); margin-bottom: 1rem;"></i>
                        <h4>Need Help?</h4>
                        <p>Visit our support center for technical assistance and troubleshooting.</p>
                        <a href="${pageContext.request.contextPath}/support.jsp" class="btn btn-outline">
                            <i class="fas fa-life-ring"></i> Visit Support
                        </a>
                    </div>
                </div>
                <div class="col-4">
                    <div class="card text-center">
                        <i class="fas fa-question-circle" style="font-size: 3rem; color: var(--info); margin-bottom: 1rem;"></i>
                        <h4>Have Questions?</h4>
                        <p>Check our FAQ section for quick answers to common questions.</p>
                        <a href="${pageContext.request.contextPath}/faq.jsp" class="btn btn-outline">
                            <i class="fas fa-book"></i> View FAQs
                        </a>
                    </div>
                </div>
                <div class="col-4">
                    <div class="card text-center">
                        <i class="fas fa-briefcase" style="font-size: 3rem; color: var(--success); margin-bottom: 1rem;"></i>
                        <h4>Start Your Journey</h4>
                        <p>Join thousands of job seekers finding their dream careers with AI.</p>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary">
                            <i class="fas fa-rocket"></i> Get Started
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@include file="/includes/footer.jsp"%>
</body>
</html>


