// FindNext - Reset Password Page JavaScript
// Handles password visibility toggle, strength checking, and validation

// Toggles password field visibility between hidden and visible
function togglePassword(inputId, icon) {
    const input = document.getElementById(inputId);
    if (!input) return;

    if (input.type === 'password') {
        input.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        input.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
}

// Checks and displays password strength indicator
function checkPasswordStrength() {
    const password = document.getElementById('newPassword').value || '';
    const strengthDiv = document.getElementById('passwordStrength');

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
        strengthDiv.innerHTML = '<span class="strength-weak"><i class="fas fa-exclamation-triangle"></i> Weak password</span>';
    } else if (strength <= 3) {
        strengthDiv.innerHTML = '<span class="strength-medium"><i class="fas fa-shield-alt"></i> Medium password</span>';
    } else {
        strengthDiv.innerHTML = '<span class="strength-strong"><i class="fas fa-check-circle"></i> Strong password</span>';
    }
}

// Validates that password and confirm password fields match
function validatePassword() {
    const newPassword = document.getElementById('newPassword').value || '';
    const confirmPassword = document.getElementById('confirmPassword').value || '';

    if (newPassword !== confirmPassword) {
        alert('Passwords do not match!');
        return false;
    }

    if (newPassword.length < 6) {
        alert('Password must be at least 6 characters long!');
        return false;
    }

    return true;
}

// Attach event listeners when DOM is ready
document.addEventListener('DOMContentLoaded', function() {
    const newPasswordInput = document.getElementById('newPassword');
    if (newPasswordInput) {
        newPasswordInput.addEventListener('input', checkPasswordStrength);
    }
});



