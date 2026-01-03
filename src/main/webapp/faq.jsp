<%--
    FindNext - FAQ Page
    Frequently asked questions with accordion-style answers for users
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>FAQ - Frequently Asked Questions | <%=application.getAttribute("appName")%></title>
<link rel="icon" type="image/jpeg" href="${pageContext.request.contextPath}/assets/favicon.jpeg">
<link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/css/faq.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

    <%@include file="/includes/header.jsp"%>

    <main>
        <div class="faq-container">
            <div class="faq-header">
                <h1><i class="fas fa-question-circle"></i> Frequently Asked Questions</h1>
                <p>Find answers to common questions about FindNext</p>
            </div>

            <div class="search-box">
                <input type="text" id="faqSearch" placeholder="Search for answers..." onkeyup="searchFAQ()">
            </div>

            <div class="faq-section">
                <h2><i class="fas fa-info-circle"></i> General Questions</h2>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>What is FindNext?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            FindNext is an AI-powered job portal that uses advanced artificial intelligence to analyze resumes, match candidates with suitable jobs, and streamline the hiring process. We help job seekers find their dream careers and employers find the perfect candidates.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>Is FindNext free to use?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Yes! FindNext is completely free for job seekers. You can create a profile, upload your resume, browse jobs, and apply to positions at no cost. Employers have access to both free and premium features.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>How does the AI resume analysis work?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Our AI technology uses natural language processing and machine learning to extract skills, experience, education, and other relevant information from your resume. It then analyzes this data to provide skill gap insights and match you with the most suitable job opportunities.
                        </div>
                    </div>
                </div>
            </div>

            <div class="faq-section">
                <h2><i class="fas fa-user-tie"></i> For Job Seekers</h2>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>How do I create an account?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Click on "Register" in the navigation menu, fill in your details, verify your email address with the OTP sent to you, and then upload your resume. Our AI will analyze it immediately and you can start browsing jobs right away.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>What resume formats are supported?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            We support PDF and DOCX formats. For best results, use a well-formatted resume with clear sections for experience, education, skills, and contact information. The maximum file size is 5MB.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>How do I apply for jobs?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Browse available jobs on your dashboard, click on any job that interests you, and hit the "Apply" button. Your analyzed resume and profile information will be sent to the employer automatically. You can track all your applications from your dashboard.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>What is the match score?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            The match score is a percentage that indicates how well your skills and experience align with a job's requirements. A higher score means you're a better fit for the position. Our AI calculates this by comparing your resume analysis with the job description.
                        </div>
                    </div>
                </div>
            </div>

            <div class="faq-section">
                <h2><i class="fas fa-building"></i> For Employers</h2>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>How do I post a job?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            After registering as an employer, go to your dashboard and click the "Post New Job" button. Fill in the job details including title, description, required skills, location, and salary range. Your job will be live immediately after posting.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>How does the candidate matching work?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            When candidates apply to your job, our AI automatically calculates a match score based on how well their skills and experience align with your requirements. You can view applicants sorted by match score to find the best candidates quickly.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>Can I deactivate a job posting?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Yes! You can activate or deactivate any job posting from your dashboard. Deactivated jobs won't appear in search results, but you can reactivate them anytime without losing the existing applicants.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>How do I review applicants?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Click on "View" next to any job in your dashboard to see all applicants. You can review their profiles, download resumes, see match scores, and update application status (Pending, Shortlisted, Rejected, Hired).
                        </div>
                    </div>
                </div>
            </div>

            <div class="faq-section">
                <h2><i class="fas fa-shield-alt"></i> Technical & Security</h2>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>Is my data secure?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Absolutely! We use industry-standard encryption for all data transmission and storage. Your resume and personal information are protected with enterprise-grade security measures. We never share your data with third parties without your consent.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>What browsers are supported?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            FindNext works on all modern browsers including Chrome, Firefox, Safari, and Edge. For the best experience, we recommend using the latest version of your browser.
                        </div>
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question" onclick="toggleFAQ(this)">
                        <span>I forgot my password. What should I do?</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="faq-answer">
                        <div class="faq-answer-content">
                            Click on "Forgot Password" on the login page, enter your email address, and we'll send you instructions to reset your password. If you don't receive the email, check your spam folder or contact our support team.
                        </div>
                    </div>
                </div>
            </div>

            <div class="card text-center" style="margin-top: 3rem; padding: 2rem;">
                <h3><i class="fas fa-headset"></i> Still have questions?</h3>
                <p style="margin: 1rem 0;">Can't find the answer you're looking for? Our support team is here to help!</p>
                <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                    <a href="${pageContext.request.contextPath}/support.jsp" class="btn btn-primary">
                        <i class="fas fa-life-ring"></i> Contact Support
                    </a>
                    <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-outline">
                        <i class="fas fa-envelope"></i> Send Message
                    </a>
                </div>
            </div>
        </div>
    </main>

    <%@include file="/includes/footer.jsp"%>

    <script src="${pageContext.request.contextPath}/js/faq.js"></script>
</body>
</html>


