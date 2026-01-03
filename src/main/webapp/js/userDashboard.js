// FindNext - User Dashboard JavaScript
// Handles job application, resume upload modal, and filter functionality for job seekers

// Opens any modal by ID and prevents page scrolling
function openModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
}

// Closes any modal by ID and restores page scrolling
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) {
        modal.classList.remove('show');
        document.body.style.overflow = '';
    }
}

// Shows resume upload popup or applies directly if resume already uploaded
function openResumePopup(jobId, score, skills, resumeUploaded) {
    if (resumeUploaded) {
        Swal.fire({
            title: "Apply for this job?",
            icon: "question",
            showCancelButton: true,
            confirmButtonText: "Yes, Apply",
            cancelButtonText: "Cancel"
        }).then((result) => {
            if (result.isConfirmed) {
                const form = document.createElement("form");
                form.method = "POST";
                form.action = "apply";

                const input1 = document.createElement("input");
                input1.type = "hidden";
                input1.name = "jobId";
                input1.value = jobId;
                form.appendChild(input1);

                const input2 = document.createElement("input");
                input2.type = "hidden";
                input2.name = "score";
                input2.value = score;
                form.appendChild(input2);

                document.body.appendChild(form);
                form.submit();
            }
        });
    } else {
        document.getElementById("modalJobId").value = jobId;
        document.getElementById("modalSkills").value = skills;
        document.getElementById("resumeFile").value = "";
        openModal('resumeModal');
    }
}

function showDetails(id, title, company, location, experience, packageLpa, vacancies, skills, description, posted) {
    document.getElementById("modalJobTitle").innerText = title;
    document.getElementById("modalCompany").innerText = company;
    document.getElementById("modalLocation").innerText = location;
    document.getElementById("modalExperience").innerText = experience;
    document.getElementById("modalPackage").innerText = packageLpa;
    document.getElementById("modalVacancies").innerText = vacancies;
    document.getElementById("modalSkills").innerText = skills;
    document.getElementById("modalDescription").innerText = description;
    document.getElementById("modalPostedDate").innerText = posted;
    openModal('jobDetailsModal');
}

function clearAllFilters() {
    window.location.href = 'userDashboard';
}

function toggleSection(sectionId) {
    const section = document.getElementById(sectionId);
    const iconId = sectionId.replace('Section', 'Icon');
    const icon = document.getElementById(iconId);

    if (section && icon) {
        section.classList.toggle('collapsed');
        icon.classList.toggle('rotated');
    }
}

function openUpdateResumeModal() {
    openModal('updateResumeModal');
}

function showFileName(input) {
    const fileInfo = document.getElementById('updateFileInfo');
    const fileName = document.getElementById('updateFileName');

    if (input.files && input.files[0]) {
        const file = input.files[0];
        const fileSize = (file.size / 1024 / 1024).toFixed(2);

        if (file.size > 5 * 1024 * 1024) {
            Swal.fire({
                icon: 'error',
                title: 'File Too Large',
                text: 'Please select a file smaller than 5MB'
            });
            input.value = '';
            fileInfo.style.display = 'none';
            return;
        }

        fileName.textContent = file.name + ' (' + fileSize + ' MB)';
        fileInfo.style.display = 'block';
    }
}

// Mobile Filter Modal Functions
function openFilterModal() {
    openModal('filterModal');
}

function closeFilterModal() {
    closeModal('filterModal');
}

function clearMobileFilters() {
    const form = document.getElementById('mobileFilterForm');
    if (form) {
        const inputs = form.querySelectorAll('input[type="text"]');
        inputs.forEach(input => input.value = '');

        const selects = form.querySelectorAll('select');
        selects.forEach(select => select.selectedIndex = 0);
    }
}

// Initialize on DOM ready
document.addEventListener('DOMContentLoaded', function() {
    // Update Resume form submission
    document.getElementById('updateResumeForm')?.addEventListener('submit', function(e) {
        const btn = document.getElementById('updateResumeBtn');
        btn.disabled = true;
        btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Updating...';

        Swal.fire({
            title: 'Updating Resume...',
            text: 'Please wait while we analyze your resume',
            allowOutsideClick: false,
            allowEscapeKey: false,
            showConfirmButton: false,
            didOpen: () => {
                Swal.showLoading();
            }
        });
    });

    // Mobile Filter form submission - close modal before submitting
    document.getElementById('mobileFilterForm')?.addEventListener('submit', function(e) {
        closeFilterModal();
    });

    // Close modals when clicking outside
    document.querySelectorAll('.modal').forEach(modal => {
        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                closeModal(modal.id);
            }
        });
    });
});



