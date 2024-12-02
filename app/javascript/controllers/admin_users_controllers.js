/* global fetch */

document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".delete-user-button").forEach(button => {
    button.addEventListener("click", event => {
      const userId = button.dataset.userId;

      // Disable the button and add a loading indicator
      button.disabled = true;
      const originalText = button.textContent;
      button.textContent = "Deleting...";

      fetch(`/admin/users/${userId}`, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': document.querySelector("meta[name='csrf-token']").content
        }
      }).then(response => {
        if (response.ok) {
          console.log("User deleted successfully");
          // Optionally remove the user row from the DOM
          button.closest("tr").remove();
        } else {
          console.error("Failed to delete user");
          // Re-enable the button and restore original text if delete fails
          button.disabled = false;
          button.textContent = originalText;
        }
      }).catch(error => {
        console.error("Error:", error);
        // Re-enable the button and restore original text in case of an error
        button.disabled = false;
        button.textContent = originalText;
      });
    });
  });
});
