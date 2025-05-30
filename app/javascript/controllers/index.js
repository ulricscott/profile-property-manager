// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

eagerLoadControllersFrom("controllers", application)

window.populateModalWithSelectedProfiles = function() {
  console.log('js populate function')
  const selectedRows = document.querySelectorAll('tr:has(input[type="checkbox"][name="profile_ids[]"]:checked)');
  const selectedRowsCount = selectedRows.length;
  console.log(selectedRows)

  const selectedIds = [];
  selectedRows.forEach((row) => {
      const secondTd = row.querySelector('td:nth-child(2)');
      const idValue = secondTd.textContent.trim();
      selectedIds.push(idValue);
  });

  console.log('Selected IDs:', selectedIds);

  fetch('/profiles', {
    method: 'PUT',
    headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
    },
    body: JSON.stringify({
            engagement: document.querySelector('.engagement-status-dropdown').value,
            profile_ids: selectedIds
    })
  })
  .then(response => response.json())
  .then(data => {
      console.log('Success:', data);
      if (data.failed_ids.length > 0) {
        alert(`Failed Ids:  ${data.failed_ids}`)
      }
      window.location.reload();
  })
  .catch(error => {
      console.error('Error:', error);
  });
 }
window.openModal = function() {
  const selectedRows = document.querySelectorAll('tr:has(input[type="checkbox"][name="profile_ids[]"]:checked)');
  const selectedRowsCount = selectedRows.length;
  console.log(selectedRows)

  const selectedIds = [];
  selectedRows.forEach((row) => {
      const secondTd = row.querySelector('td:nth-child(2)');
      const idValue = secondTd.textContent.trim();
      selectedIds.push(idValue);
  });
  
  document.getElementById("selected-profiles").innerHTML = `
  <ul>
    ${selectedIds.map(id => `<li>${id}</li>`).join('')}
  </ul>
`;
}
window.exportCSV = function() {
  $('#tag-table').tableExport({type:'csv'});
}

 window.addEventListener('DOMContentLoaded', function () {
  const checkboxes = document.querySelectorAll('input[name="profile_ids[]"]');
  const selectAll = document.getElementById('select-all');
  const selectedCountEl = document.getElementById('selected-count');

  function updateSelectedCount() {
    const count = document.querySelectorAll('input[name="profile_ids[]"]:checked').length;
    selectedCountEl.textContent = count;
  }

  // Individual checkboxes update count
  checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', updateSelectedCount);
  });

  // "Select All" checkbox logic
  if (selectAll) {
    selectAll.addEventListener('change', function () {
      checkboxes.forEach(cb => cb.checked = selectAll.checked);
      updateSelectedCount();
    });
  }

  updateSelectedCount(); // Initialize on page load
});
