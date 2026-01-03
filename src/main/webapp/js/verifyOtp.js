// FindNext - Verify OTP Page JavaScript
// Handles OTP input validation and formatting

// Ensures OTP input only accepts numeric characters
document.addEventListener('DOMContentLoaded', function() {
    const otpInput = document.getElementById('otp');
    if (otpInput) {
        otpInput.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }
});



