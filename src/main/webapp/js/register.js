// FindNext - Registration Page JavaScript
// Handles form validation, password strength checking, and OTP verification

// Prevents double submission by disabling button after form submit
document.addEventListener('DOMContentLoaded', function() {
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function() {
            const btn = this.querySelector('button[type="submit"]');
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Sending...';
            }
        });
    }
});

// Password strength checker for registration
function checkRegPasswordStrength() {
    const password = document.getElementById('regPassword')?.value || '';
    const strengthDiv = document.getElementById('regPasswordStrength');

    if (!strengthDiv) return;

    if (password.length === 0) {
        strengthDiv.innerHTML = '';
        return;
    }

    let strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 10) strength++;
    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
    if (/[0-9]/.test(password)) strength++;
    if (/[^a-zA-Z0-9]/.test(password)) strength++;

    if (strength <= 2) {
        strengthDiv.innerHTML = '<span style="color: #dc2626;"><i class="fas fa-exclamation-triangle"></i> Weak password</span>';
    } else if (strength <= 3) {
        strengthDiv.innerHTML = '<span style="color: #f59e0b;"><i class="fas fa-shield-alt"></i> Medium password</span>';
    } else {
        strengthDiv.innerHTML = '<span style="color: #10b981;"><i class="fas fa-check-circle"></i> Strong password</span>';
    }
}

// Toggle password visibility
function toggleRegPasswordVisibility() {
    const passwordInput = document.getElementById('regPassword');
    const toggleIcon = document.getElementById('toggleRegPassword');

    if (!passwordInput || !toggleIcon) return;

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('fa-eye');
        toggleIcon.classList.add('fa-eye-slash');
    } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('fa-eye-slash');
        toggleIcon.classList.add('fa-eye');
    }
}



