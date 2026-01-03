// FindNext - Employer Dashboard JavaScript
// Handles job posting modal and filter functionality for employers

// Opens the modal for creating a new job posting
function openPostJobModal() {
  document.getElementById("postJobModal").classList.add("show");
}

// Closes the job posting modal
function closePostJobModal() {
  document.getElementById("postJobModal").classList.remove("show");
}

// Setup: Close modals when clicking outside the modal content
document.addEventListener("DOMContentLoaded", function () {
  const postJobModal = document.getElementById("postJobModal");
  if (postJobModal) {
    postJobModal.addEventListener("click", function (e) {
      if (e.target === this) {
        closePostJobModal();
      }
    });
  }

  const filterModal = document.getElementById("filterModal");
  if (filterModal) {
    filterModal.addEventListener("click", function (e) {
      if (e.target === this) {
        closeFilterModal();
      }
    });
  }

  const openFilterBtn = document.getElementById("openFilterModalBtn");
  if (openFilterBtn) {
    openFilterBtn.addEventListener("click", openFilterModal);
  }
});

// Opens the filter modal for job filtering options
function openFilterModal() {
  document.getElementById("filterModal").style.display = "flex";
  document.body.classList.add("modal-open");
}

// Closes the filter modal and restores page scrolling
function closeFilterModal() {
  document.getElementById("filterModal").style.display = "none";
  document.body.classList.remove("modal-open");
}
