<%--
    FindNext - Support Page
    Help and support ticket submission form with category selection
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Support Center | <%=application.getAttribute("appName")%></title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/support.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<%@include file="/includes/header.jsp"%>

<main>
        <div class="support-container">
            <div class="support-header">
                <h1><i class="fas fa-headset"></i> Support Center</h1>
                <p class="lead">We're here to help! Get support, report issues, or ask questions.</p>
            </div>

            <div class="support-categories">
                <div class="support-category" onclick="scrollToForm('technical')">
                    <i class="fas fa-laptop-code"></i>
                    <h3>Technical Issues</h3>
                    <p>Report bugs, errors, or technical problems</p>
                </div>
                <div class="support-category" onclick="scrollToForm('account')">
                    <i class="fas fa-user-circle"></i>
                    <h3>Account Help</h3>
                    <p>Login issues, password reset, profile problems</p>
                </div>
                <div class="support-category" onclick="scrollToForm('payment')">
                    <i class="fas fa-credit-card"></i>
                    <h3>Billing & Payments</h3>
                    <p>Payment issues, refunds, invoices</p>
                </div>
                <div class="support-category" onclick="scrollToForm('feature')">
                    <i class="fas fa-lightbulb"></i>
                    <h3>Feature Request</h3>
                    <p>Suggest new features or improvements</p>
                </div>
            </div>

            <div class="complaint-form-section" id="complaintForm">
                <h2><i class="fas fa-file-alt"></i> Submit a Support Ticket</h2>

                <% if (request.getParameter("success") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>Your support ticket has been submitted successfully! We'll respond to your email within 24 hours. Ticket ID: #<%= request.getParameter("ticketId") != null ? request.getParameter("ticketId") : "XXXXX" %></span>
                </div>
                <% } %>

                <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>Failed to submit ticket. Please try again or contact us directly at findnextteam@gmail.com</span>
                </div>
                <% } %>

                <form action="${pageContext.request.contextPath}/support" method="post" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-6">
                            <div class="form-group">
                                <label class="form-label">Your Name *</label>
                                <input type="text" name="name" class="form-control" placeholder="John Doe" required
                                    value="<%= session.getAttribute("userName") != null ? session.getAttribute("userName") : "" %>">
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-group">
                                <label class="form-label">Email Address *</label>
                                <input type="email" name="email" class="form-control" placeholder="john@example.com" required
                                    value="<%= session.getAttribute("userEmail") != null ? session.getAttribute("userEmail") : "" %>">
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Issue Category *</label>
                        <select name="category" id="categorySelect" class="form-select" required>
                            <option value="">-- Select a category --</option>
                            <option value="technical">Technical Issues</option>
                            <option value="account">Account & Login</option>
                            <option value="payment">Billing & Payments</option>
                            <option value="feature">Feature Request</option>
                            <option value="resume">Resume Analysis Issues</option>
                            <option value="application">Job Application Problems</option>
                            <option value="profile">Profile & Settings</option>
                            <option value="security">Security Concerns</option>
                            <option value="other">Other</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Priority Level *</label>
                        <div class="row">
                            <div class="col-4">
                                <label class="priority-option" id="priorityLow">
                                    <input type="radio" name="priority" value="low" required onchange="updatePriority('low')">
                                    <div style="padding: 1rem; border: 2px solid var(--gray-light); border-radius: var(--radius-md); cursor: pointer;">
                                        <i class="fas fa-info-circle" style="color: var(--success); font-size: 1.5rem;"></i>
                                        <h4 style="margin: 0.5rem 0;">Low</h4>
                                        <p style="font-size: 0.85rem; margin: 0;">General inquiry</p>
                                    </div>
                                </label>
                            </div>
                            <div class="col-4">
                                <label class="priority-option" id="priorityMedium">
                                    <input type="radio" name="priority" value="medium" required onchange="updatePriority('medium')">
                                    <div style="padding: 1rem; border: 2px solid var(--gray-light); border-radius: var(--radius-md); cursor: pointer;">
                                        <i class="fas fa-exclamation-triangle" style="color: var(--warning); font-size: 1.5rem;"></i>
                                        <h4 style="margin: 0.5rem 0;">Medium</h4>
                                        <p style="font-size: 0.85rem; margin: 0;">Needs attention</p>
                                    </div>
                                </label>
                            </div>
                            <div class="col-4">
                                <label class="priority-option" id="priorityHigh">
                                    <input type="radio" name="priority" value="high" required onchange="updatePriority('high')">
                                    <div style="padding: 1rem; border: 2px solid var(--gray-light); border-radius: var(--radius-md); cursor: pointer;">
                                        <i class="fas fa-exclamation-circle" style="color: var(--danger); font-size: 1.5rem;"></i>
                                        <h4 style="margin: 0.5rem 0;">High</h4>
                                        <p style="font-size: 0.85rem; margin: 0;">Urgent issue</p>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Subject *</label>
                        <input type="text" name="subject" class="form-control" placeholder="Brief description of your issue" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Detailed Description *</label>
                        <textarea name="description" class="form-control" rows="8" placeholder="Please describe your issue in detail. Include any error messages, steps to reproduce, and what you expected to happen..." required></textarea>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Attachment (Optional)</label>
                        <input type="file" name="attachment" class="form-control" accept=".jpg,.jpeg,.png,.pdf,.doc,.docx">
                        <small style="color: var(--gray); display: block; margin-top: 0.5rem;">
                            <i class="fas fa-info-circle"></i> Attach screenshots or files that help explain the issue (Max 5MB)
                        </small>
                    </div>

                    <div style="background: var(--light); padding: 1rem; border-radius: var(--radius-md); margin-bottom: 1.5rem;">
                        <p style="margin: 0; color: var(--gray); font-size: 0.9rem;">
                            <i class="fas fa-shield-alt" style="color: var(--primary);"></i>
                            <strong>Privacy Notice:</strong> Your information will be used solely to respond to your support request. We take your privacy seriously and will never share your data with third parties.
                        </p>
                    </div>

                    <button type="submit" class="btn btn-primary btn-lg btn-block">
                        <i class="fas fa-paper-plane"></i> Submit Support Ticket
                    </button>
                </form>
            </div>

            <div class="quick-help">
                <h3><i class="fas fa-bolt"></i> Quick Help Resources</h3>
                <div class="help-links">
                    <a href="${pageContext.request.contextPath}/faq.jsp" class="help-link">
                        <i class="fas fa-question-circle"></i>
                        <span>View FAQ</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/contact.jsp" class="help-link">
                        <i class="fas fa-envelope"></i>
                        <span>Contact Us</span>
                    </a>
                    <a href="mailto:findnextteam@gmail.com" class="help-link">
                        <i class="fas fa-at"></i>
                        <span>Email Support</span>
                    </a>
                    <a href="tel:+15551234567" class="help-link">
                        <i class="fas fa-phone"></i>
                        <span>Call Us</span>
                    </a>
                </div>
            </div>

            <div class="row" style="margin-top: 2rem;">
                <div class="col-4">
                    <div class="card text-center">
                        <i class="fas fa-clock" style="font-size: 2.5rem; color: var(--success); margin-bottom: 1rem;"></i>
                        <h4>Low Priority</h4>
                        <p style="color: var(--gray); margin: 0;">Response within 48 hours</p>
                    </div>
                </div>
                <div class="col-4">
                    <div class="card text-center">
                        <i class="fas fa-hourglass-half" style="font-size: 2.5rem; color: var(--warning); margin-bottom: 1rem;"></i>
                        <h4>Medium Priority</h4>
                        <p style="color: var(--gray); margin: 0;">Response within 24 hours</p>
                    </div>
                </div>
                <div class="col-4">
                    <div class="card text-center">
                        <i class="fas fa-bolt" style="font-size: 2.5rem; color: var(--danger); margin-bottom: 1rem;"></i>
                        <h4>High Priority</h4>
                        <p style="color: var(--gray); margin: 0;">Response within 4 hours</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%@include file="/includes/footer.jsp"%>

    <script src="${pageContext.request.contextPath}/js/support.js"></script>
</body>
</html>


