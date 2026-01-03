// FindNext - Support Page JavaScript
// Handles category selection, priority setting, and form scrolling for support tickets

// Scrolls to support form and pre-selects the chosen category
function scrollToForm(category) {
    document.getElementById('complaintForm').scrollIntoView({ behavior: 'smooth' });
    document.getElementById('categorySelect').value = category;
}

// Updates visual indicator for selected priority level
function updatePriority(level) {
    // Clear all priority classes first
    document.getElementById('priorityLow').querySelector('div').classList.remove('priority-low', 'priority-medium', 'priority-high');
    document.getElementById('priorityMedium').querySelector('div').classList.remove('priority-low', 'priority-medium', 'priority-high');
    document.getElementById('priorityHigh').querySelector('div').classList.remove('priority-low', 'priority-medium', 'priority-high');

    // Add selected priority class
    if (level === 'low') {
        document.getElementById('priorityLow').querySelector('div').classList.add('priority-low');
    } else if (level === 'medium') {
        document.getElementById('priorityMedium').querySelector('div').classList.add('priority-medium');
    } else if (level === 'high') {
        document.getElementById('priorityHigh').querySelector('div').classList.add('priority-high');
    }
}



