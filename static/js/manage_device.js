// =======================
// MANAGE DEVICES SECTION
// =======================


 
// ---------- BULK STATUS UPDATE ----------
function bulkUpdateDevices() {
  const status = document.getElementById("bulkDeviceStatus").value;
  const selected = [...document.querySelectorAll(".device-checkbox:checked")]
    .map(cb => cb.value);

  if (!status) {
    alert("Select a status.");
    return;
  }

  if (!selected.length) {
    alert("Select at least one device.");
    return;
  }

  // Use confirmation modal instead of native confirm
  showConfirmationModal(
    'Confirm Bulk Update',
    `Update ${selected.length} selected device(s) to status "${status}"? This action cannot be undone.`,
    'Update',
    function() {
      fetch("/inventory/device/bulk-update", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          device_ids: selected,
          new_status: status
        })
      })
        .then(res => res.json())
        .then(d => d.success ? refreshItemTableWithoutReload() : alert("Bulk update failed"));
    }
  );
}

// ---------- DEVICE MODAL ----------
async function openItemModalById(id) {
  try {
    const res = await fetch(`/manage_inventory/get-item-by-id/${id}`);
    if (!res.ok) throw new Error();
    const item = await res.json();
    openItemModal(item);
  } catch {
    alert("Failed to load device data.");
  }
}

// ---------- CHECK ----------
function markChecked(type, id) {
  fetch(`/inventory/${type}/${id}/check`, { method: "POST" })
    .then(res => res.json())
    .then(d => {
      if (!d.success) {
        alert("Update failed");
        return;
      }

      if (String(type).toUpperCase() === "CONSUMABLE") {
        if (typeof window.refreshConsumableTableWithoutReload === "function") {
          window.refreshConsumableTableWithoutReload();
        }
        return;
      }

      refreshItemTableWithoutReload();
    });
}

function exportSingleDevice(deviceId) {
  const id = deviceId;
  if (!id && id !== 0) {
    if (typeof showToast === 'function') {
      showToast('Invalid device selected for export', 'error');
    } else {
      alert('Invalid device selected for export');
    }
    return;
  }

  const toastId = typeof showToast === 'function'
    ? showToast('Exporting item...', 'loading')
    : null;

  fetch('/manage_inventory/export-selected-devices', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ device_ids: [id] })
  })
  .then(async (res) => {
    if (!res.ok) {
      let message = 'Export failed';
      try {
        const data = await res.json();
        if (data && data.error) {
          message = data.error;
        }
      } catch (_) {
      }
      throw new Error(message);
    }
    return res.blob();
  })
  .then((blob) => {
    if (toastId) hideToast(toastId);

    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `device_${id}.xlsx`;
    document.body.appendChild(a);
    a.click();
    a.remove();
    window.URL.revokeObjectURL(url);

    if (typeof showExportToast === 'function') {
      showExportToast({
        count: 1,
        type: 'Device',
        filename: `device_${id}.xlsx`
      });
    } else if (typeof showToast === 'function') {
      showToast('Item exported successfully', 'success');
    }
  })
  .catch((err) => {
    if (toastId) hideToast(toastId);
    console.error(err);
    if (typeof showToast === 'function') {
      showToast(err?.message || 'Export failed. Please try again.', 'error');
    } else {
      alert(err?.message || 'Export failed');
    }
  });
}

window.exportSingleDevice = exportSingleDevice;

window.archiveDevice = function (id, itemName) {
  if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Archive Device',
      `Are you sure you want to archive "${itemName}"? This action cannot be undone.`,
      'Archive',
      function () {
        const toastId = typeof showToast === 'function' ? showToast('Archiving device...', 'loading') : null;
        fetch(`/delete-item/${id}`, {
          method: 'POST',
          headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
          .then(async (res) => {
            const contentType = (res.headers.get('content-type') || '').toLowerCase();
            const payload = contentType.includes('application/json') ? await res.json() : { success: res.ok };
            return { res, payload };
          })
          .then(({ payload }) => {
            if (toastId) hideToast(toastId);
            if (payload && payload.success) {
              if (typeof showToast === 'function') {
                showToast('Device archived successfully', 'success');
              }
              if (typeof refreshItemTableWithoutReload === 'function') {
                refreshItemTableWithoutReload();
              } else {
                location.reload();
              }
            } else if (typeof showToast === 'function') {
              showToast(payload?.error || 'Failed to archive device', 'error');
            }
          })
          .catch(() => {
            if (toastId) hideToast(toastId);
            if (typeof showToast === 'function') {
              showToast('Server error during archive', 'error');
            }
          });
      }
    );
    return;
  }

  if (!confirm(`Archive "${itemName}"?`)) return;
  fetch(`/delete-item/${id}`, {
    method: 'POST',
    headers: { 'X-Requested-With': 'XMLHttpRequest' }
  }).then(() => location.reload());
};

window.openItemModalById = async function (id) {
  try {
    const res = await fetch(`/manage_inventory/get-item-by-id/${id}`);
    const item = await res.json();
    openItemModal(item);
  } catch {
    alert("Failed to load device.");
  }
};

window.bulkUpdateDevices = function () {
  const status = document.getElementById("bulkDeviceStatus").value;
  const ids = [...document.querySelectorAll(".device-checkbox:checked")]
    .map(cb => cb.value);

  if (!status) {
    alert("Select a status.");
    return;
  }

  if (!ids.length) {
    alert("Select at least one device.");
    return;
  }

  // Use confirmation modal instead of native confirm
  showConfirmationModal(
    'Confirm Bulk Update',
    `Update ${ids.length} selected device(s) to status "${status}"? This action cannot be undone.`,
    'Update',
    function() {
      fetch("/inventory/device/bulk-update", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ device_ids: ids, new_status: status })
      })
        .then(res => res.json())
        .then(d => d.success ? refreshItemTableWithoutReload() : alert("Bulk update failed"));
    }
  );
};

 
function bulkMarkDamagedSelectedDevices() {
  const checked = Array.from(document.querySelectorAll('.device-checkbox'))
    .filter(cb => cb.checked)
    .map(cb => cb.value);

  if (checked.length === 0) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one device to mark as damaged', 'warning');
    } else if (typeof showConfirmationModal === 'function') {
      showConfirmationModal(
        'Selection Required',
        'Please select at least one device to mark as damaged.',
        'OK',
        null
      );
    } else {
      alert('No devices selected');
    }
    return;
  }

  const executeMarkDamaged = () => {
    const toastId = typeof showToast === 'function'
      ? showToast(`Marking ${checked.length} device(s) as damaged...`, 'loading', { showProgress: false })
      : null;

    fetch('/inventory/device-bulk-damaged', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        device_ids: checked,
        damage_type: 'General Damage',
        description: 'Bulk marked as damaged'
      })
    })
    .then(r => r.json())
    .then(d => {
      if (toastId) hideToast(toastId);
      
      if (d && d.success) {
        if (typeof showDamagedToast === 'function') {
          showDamagedToast({
            count: checked.length,
            type: 'Device',
            severity: 'High'
          });
        } else if (typeof showToast === 'function') {
          showToast(`${checked.length} device(s) marked as damaged`, 'warning', { showProgress: false });
        }
        setTimeout(() => {
          if (typeof refreshItemTableWithoutReload === 'function') {
            refreshItemTableWithoutReload();
          }
        }, 2000);
      } else {
        if (typeof showToast === 'function') {
          showToast(d.error || 'Failed to mark devices as damaged', 'error', { showProgress: false });
        } else {
          alert('Failed: ' + (d.error || 'unknown'));
        }
      }
    })
    .catch(err => {
      if (toastId) hideToast(toastId);
      console.error(err);
      if (typeof showToast === 'function') {
        showToast('Server error during operation', 'error', { showProgress: false });
      } else {
        alert('Operation failed');
      }
    });
  };

  if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Confirm Mark as Damaged',
      `Are you sure you want to mark ${checked.length} device(s) as DAMAGED? This will set their status to "Damaged" and risk level to HIGH. This action cannot be undone easily.`,
      'Mark as Damaged',
      executeMarkDamaged
    );
  } else {
    if (!confirm(`Mark ${checked.length} Device(s) as DAMAGED?`)) return;
    executeMarkDamaged();
  }
}

function toggleSelectAllDevices(master) {
  document.querySelectorAll(".device-checkbox")
    .forEach(cb => cb.checked = master.checked);
}


function bulkMarkCheckedSelectedDevices() {
  const selected = [...document.querySelectorAll(".device-checkbox:checked")]
    .map(cb => cb.value);

  if (!selected.length) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one device to mark as checked', 'warning');
    } else if (typeof showConfirmationModal === 'function') {
      showConfirmationModal(
        'Selection Required',
        'Please select at least one device to mark as checked.',
        'OK',
        null
      );
    } else {
      alert('Select at least one device.');
    }
    return;
  }

  const executeBulkCheck = () => {
    const toastId = typeof showToast === 'function'
      ? showToast(`Marking ${selected.length} device(s) as checked...`, 'loading', { showProgress: false })
      : null;
    
    fetch("/inventory/device/bulk-check", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ device_ids: selected })
    })
    .then(res => res.json())
    .then(data => {
      if (toastId) hideToast(toastId);
      
      if (data.success) {
        if (typeof showMarkCheckedToast === 'function') {
          showMarkCheckedToast({
            count: selected.length,
            type: 'Device',
            healthRestored: 100,
            riskLevel: 'Low'
          });
        } else if (typeof showToast === 'function') {
          showToast(`${selected.length} device(s) marked as checked successfully`, 'success', { showProgress: false });
        }
        setTimeout(() => {
          if (typeof refreshItemTableWithoutReload === 'function') {
            refreshItemTableWithoutReload();
          }
        }, 2000);
      } else {
        if (typeof showToast === 'function') {
          showToast(data.error || 'Failed to mark devices as checked', 'error', { showProgress: false });
        } else {
          alert(data.error || "Bulk update failed");
        }
      }
    })
    .catch(err => {
      if (toastId) hideToast(toastId);
      console.error(err);
      if (typeof showToast === 'function') {
        showToast('Server error during bulk check', 'error', { showProgress: false });
      } else {
        alert("Server error during bulk update.");
      }
    });
  };

  if (typeof showBulkMarkCheckedModal === "function") {
    showBulkMarkCheckedModal(
      `Mark ${selected.length} selected device(s) as checked? This will restore their health to 100% and set risk level to Low.`,
      executeBulkCheck
    );
  } else if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Confirm Mark Checked',
      `Mark ${selected.length} device(s) as checked? Health will be restored to 100% and risk level set to Low.`,
      'Mark Checked',
      executeBulkCheck
    );
  } else {
    if (!confirm(`Mark ${selected.length} devices as checked?`)) return;
    executeBulkCheck();
  }
}


function exportSelectedDevices() {
  const selected = Array.from(document.querySelectorAll('.device-checkbox'))
    .filter(cb => cb.checked)
    .map(cb => cb.value);

  if (selected.length === 0) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one device to export', 'warning');
    } else {
      alert("Select at least one device to export.");
    }
    return;
  }

  const toastId = typeof showToast === 'function'
    ? showToast(`Exporting ${selected.length} device(s)...`, 'loading')
    : null;

  fetch('/manage_inventory/export-selected-devices', {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ device_ids: selected })
  })
  .then(async (res) => {
    if (!res.ok) {
      let message = 'Export failed';
      try {
        const data = await res.json();
        if (data && data.error) {
          message = data.error;
        }
      } catch (_) {
        // Keep fallback message when non-JSON response is returned.
      }
      throw new Error(message);
    }
    return res.blob();
  })
  .then(blob => {
    if (toastId) hideToast(toastId);
    
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "selected_devices.xlsx";
    document.body.appendChild(a);
    a.click();
    a.remove();
    window.URL.revokeObjectURL(url);
    
    if (typeof showExportToast === 'function') {
      showExportToast({
        count: selected.length,
        type: 'Device',
        filename: 'selected_devices.xlsx'
      });
    } else if (typeof showToast === 'function') {
      showToast(`${selected.length} device(s) exported successfully`, 'success');
    }
  })
  .catch(err => {
    if (toastId) hideToast(toastId);
    console.error(err);
    if (typeof showToast === 'function') {
      showToast(err?.message || 'Export failed. Please try again.', 'error');
    } else {
      alert(err?.message || "Export failed.");
    }
  });
}

function importDeviceExcel(forceFirstPage = false) {
  const fileInput = document.getElementById("deviceExcelFile");
  const duplicateOptionInput = document.getElementById("deviceDuplicateOption");
  const duplicateOption = duplicateOptionInput ? duplicateOptionInput.value : "skip";

  if (!fileInput || !fileInput.files || !fileInput.files.length) {
    if (typeof showToast === 'function') {
      showToast('Please select an Excel file first', 'warning');
    } else {
      alert('Please select an Excel file first.');
    }
    return;
  }

  const filename = fileInput.files[0].name;
  const toastId = typeof showToast === 'function'
    ? showToast(`Importing ${filename}...`, 'loading')
    : null;

  const formData = new FormData();
  formData.append('file', fileInput.files[0]);
  formData.append('duplicate_option', duplicateOption);

  fetch('/manage_inventory/import-devices-excel', {
    method: 'POST',
    body: formData
  })
    .then(res => res.json())
    .then(data => {
      if (toastId) hideToast(toastId);

      if (!data.success) {
        if (typeof showToast === 'function') {
          showToast(data.error || 'Import failed', 'error');
        } else {
          alert(data.error || 'Import failed.');
        }
        return;
      }

      const added = Number(data.added) || 0;
      const updated = Number(data.updated) || 0;
      const skipped = Number(data.skipped) || 0;

      if (typeof showImportToast === 'function') {
        showImportToast({
          type: 'Device',
          filename,
          added,
          updated,
          skipped
        });
      } else if (typeof showToast === 'function') {
        showToast(`Import complete: ${added} added, ${updated} updated, ${skipped} skipped`, 'success');
      }

      const nav = document.getElementById("itemPaginationNav");
      const perPageSelect = document.getElementById("itemPerPageSelect");
      const pageInput = document.getElementById("itemPageInput");

      const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;
      const currentPage = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
      const targetPage = forceFirstPage ? 1 : currentPage;

      if (typeof loadItemPageAjax === "function") {
        loadItemPageAjax(targetPage, perPage, true);
      } else {
        refreshItemTableWithoutReload();
      }

      fileInput.value = '';
      const fileNameSpan = document.getElementById('deviceExcelFileName');
      if (fileNameSpan) {
        fileNameSpan.textContent = 'No file chosen';
        fileNameSpan.title = 'No file chosen';
      }
    })
    .catch(err => {
      if (toastId) hideToast(toastId);
      console.error(err);
      if (typeof showToast === 'function') {
        showToast('Import failed. Please check the file and try again.', 'error');
      } else {
        alert('Import failed.');
      }
    });
}

function addDeviceExcelToManageList() {
  importDeviceExcel(true);
}

window.addDeviceExcelToManageList = addDeviceExcelToManageList;


function bulkSurrenderSelectedDevices() {
  const checked = Array.from(document.querySelectorAll('.device-checkbox'))
    .filter(cb => cb.checked)
    .map(cb => cb.value);

  if (checked.length === 0) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one device to surrender', 'warning');
    } else {
      alert('No devices selected');
    }
    return;
  }

  const executeSurrender = () => {
    const toastId = typeof showToast === 'function'
      ? showToast(`Surrendering ${checked.length} device(s)...`, 'loading')
      : null;

    fetch('/inventory/device/bulk-surrender', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ device_ids: checked })
    })
    .then(async (r) => {
      const contentType = (r.headers.get('content-type') || '').toLowerCase();
      let data = null;
      if (contentType.includes('application/json')) {
        data = await r.json();
      } else {
        const text = await r.text();
        data = {
          success: r.ok,
          error: text && text.trim() ? text.slice(0, 250) : `Unexpected server response (${r.status})`
        };
      }
      return { res: r, data };
    })
    .then(({ res, data }) => {
      if (toastId) hideToast(toastId);
      
      if (data && data.success) {
        if (typeof showSurrenderToast === 'function') {
          showSurrenderToast({
            count: checked.length,
            type: 'Device'
          });
        } else if (typeof showToast === 'function') {
          showToast(`${checked.length} device(s) surrendered successfully`, 'success');
        }
        setTimeout(() => {
          const nav = document.getElementById("itemPaginationNav");
          const perPageSelect = document.getElementById("itemPerPageSelect");
          const pageInput = document.getElementById("itemPageInput");
          const page = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
          const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

          if (typeof loadItemPageAjax === "function") {
            loadItemPageAjax(page, perPage, false);
          }
        }, 2000);
      } else {
        if (typeof showToast === 'function') {
          const errorMessage = (data && (data.error || data.message))
            ? (data.error || data.message)
            : `Surrender failed (${res?.status || 'unknown'})`;
          showToast(errorMessage, 'error');
        } else {
          alert('Surrender failed');
        }
      }
    })
    .catch(err => {
      if (toastId) hideToast(toastId);
      console.error(err);
      if (typeof showToast === 'function') {
        showToast('Server error during surrender', 'error');
      } else {
        alert('Operation failed');
      }
    });
  };

  if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Confirm Surrender',
      `Are you sure you want to surrender ${checked.length} device(s)? This will move them to the Surrendered section and remove them from active inventory.`,
      'Surrender',
      executeSurrender
    );
  } else {
    if (!confirm(`Surrender ${checked.length} selected device(s)?`)) return;
    executeSurrender();
  }
}

function confirmDeviceRiskUpdate() {
  // Use toast-based confirmation if available, otherwise fall back to native confirm
  if (typeof showConfirmationModal === 'function' && typeof showToast === 'function') {
    showConfirmationModal(
      'Update Device Risk Levels',
      'This will analyze all devices and recalculate their risk levels. Continue?',
      'Start Analysis',
      async function() {
        const toastId = showToast('Analyzing device risk levels...', 'loading');

        const postRiskUpdate = async (endpoint) => {
          const res = await fetch(endpoint, {
            method: "POST",
            headers: { "Content-Type": "application/json" }
          });

          const contentType = (res.headers.get('content-type') || '').toLowerCase();
          let data = null;

          if (contentType.includes('application/json')) {
            data = await res.json();
          } else {
            const text = await res.text();
            data = {
              success: false,
              message: text && text.trim() ? text.slice(0, 180) : `Unexpected server response (${res.status})`
            };
          }

          return { res, data };
        };
        
        try {
          let { res, data } = await postRiskUpdate("/manage_inventory/run-device-risk-update");

          // Backward-compatible fallback for deployments that only expose run-risk-update.
          if (!res.ok && res.status === 404) {
            ({ res, data } = await postRiskUpdate("/manage_inventory/run-risk-update"));
          }

          hideToast(toastId);
          
          if (data.success || res.ok) {
            showToast('Device risk levels updated successfully!', 'success');
          } else {
            showToast(data.message || `Risk update failed (${res.status})`, 'error');
          }
        } catch (err) {
          hideToast(toastId);
          showToast(err?.message || 'Failed to update risk levels', 'error');
          console.error('Device risk update error:', err);
        }
      }
    );
  } else {
    // Fallback to native confirm/alert
    if (!confirm("Recalculate device risk levels?")) return;

    fetch("/manage_inventory/run-device-risk-update", {
      method: "POST"
    })
    .then(res => res.json())
    .then(data => {
      alert(data.message || "Risk updated.");
    })
    .catch(() => {
      alert("Risk update failed.");
    });
  }
}

function escapeDeviceHtml(value) {
  if (value === null || value === undefined) return "";
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function formatDeviceCurrency(value) {
  const amount = Number(value);
  if (!Number.isFinite(amount)) return "\u20b10.00";
  return `\u20b1${amount.toFixed(2)}`;
}

function getDeviceStatusTextClass(status) {
  const key = String(status || '').trim().toLowerCase();
  if (key === 'available') return 'text-green-600';
  if (key === 'in use' || key === 'in used' || key === 'in-used' || key === 'inuse') return 'text-blue-600';
  if (key === 'inactive') return 'text-gray-500';
  return 'text-red-600';
}

function getDeviceStatusBadgeClass(status) {
  const key = String(status || '').trim().toLowerCase();
  if (key === 'available') return 'bg-green-100 text-green-600';
  if (key === 'in use' || key === 'in used' || key === 'in-used' || key === 'inuse') return 'bg-blue-100 text-blue-600';
  if (key === 'inactive') return 'bg-gray-100 text-gray-500';
  return 'bg-red-100 text-red-600';
}

function getDeviceRiskTextClass(riskLevel) {
  const riskKey = String(riskLevel || "").trim().toLowerCase();
  if (riskKey === "low") return "text-green-600 font-semibold";
  if (riskKey === "medium") return "text-yellow-600 font-semibold";
  if (riskKey === "high") return "text-red-600 font-semibold";
  return "text-gray-500";
}

function getEffectiveDeviceRisk(status, riskLevel) {
  const statusKey = String(status || "").trim().toLowerCase();
  if (statusKey === "damaged" || statusKey === "damage" || statusKey === "unusable") {
    return "High";
  }
  const normalizedRisk = String(riskLevel || "").trim();
  return normalizedRisk || "--";
}

function isDeviceDamagedHighRisk(item) {
  const statusKey = String(item?.status || "").trim().toLowerCase();
  const riskKey = String(getEffectiveDeviceRisk(item?.status, item?.risk_level) || "").trim().toLowerCase();
  return (statusKey === "damaged" || statusKey === "damage" || statusKey === "unusable") && riskKey === "high";
}

function isDeviceZeroDurationStatus(status) {
  const statusKey = String(status || "").trim().toLowerCase();
  return statusKey === "damaged" || statusKey === "damage" || statusKey === "unusable";
}

function toDeviceHealthPercent(value) {
  const numericValue = Number(value);
  if (!Number.isFinite(numericValue)) return null;
  const clamped = Math.max(0, Math.min(100, numericValue));
  return Math.round(clamped * 100) / 100;
}

function getDeviceHealthBarClass(healthPercent) {
  if (healthPercent >= 80) return "bg-green-500";
  if (healthPercent >= 50) return "bg-yellow-500";
  return "bg-red-500";
}

function toDeviceDurationYears(maintenanceIntervalDays) {
  const durationValue = Number(maintenanceIntervalDays);
  if (!Number.isFinite(durationValue) || durationValue <= 0) return null;
  if (durationValue >= 365) {
    return Math.max(1, Math.round(durationValue / 365));
  }
  return Math.round(durationValue);
}

function renderDeviceMaintenanceHealthCell(healthScore, maintenanceIntervalDays, status) {
  const forceZero = isDeviceZeroDurationStatus(status);
  const healthPercent = forceZero ? 0 : toDeviceHealthPercent(healthScore);
  if (healthPercent === null) {
    return '<span class="text-gray-400 text-xs">--</span>';
  }

  let durationLabel = "--";
  if (forceZero) {
    durationLabel = "0 years";
  } else {
    const durationYears = toDeviceDurationYears(maintenanceIntervalDays);
    if (durationYears !== null) {
      durationLabel = `${durationYears} year${durationYears === 1 ? "" : "s"}`;
    }
  }
  return `
    <div class="min-w-[140px]">
      <span class="text-xs text-gray-600">${escapeDeviceHtml(durationLabel)}</span>
    </div>
  `;
}

function getItemFilterValues() {
  const url = new URL(window.location.href);
  const filterKeys = [
    "search",
    "department_id",
    "status",
    "accountable",
    "serial_no",
    "item_name",
    "brand_model",
    "device_type",
    "date_from",
    "date_to"
  ];

  const filters = {};
  filterKeys.forEach((key) => {
    const value = url.searchParams.get(key);
    if (value) {
      filters[key] = value;
    }
  });

  return filters;
}

function createItemPageUrl(page, perPage) {
  const url = new URL(window.location.href);
  url.searchParams.set("section", "item");
  url.searchParams.set("item_page", String(page));
  url.searchParams.set("per_page", String(perPage));
  return `${url.pathname}?${url.searchParams.toString()}`;
}

function createItemPagedApiUrl(page, perPage) {
  const params = new URLSearchParams();
  params.set("page", String(page));
  params.set("per_page", String(perPage));

  const filters = getItemFilterValues();
  Object.keys(filters).forEach((key) => {
    params.set(key, filters[key]);
  });

  return `/manage_inventory/items-paged?${params.toString()}`;
}

function refreshItemTableWithoutReload() {
  const nav = document.getElementById("itemPaginationNav");
  const perPageSelect = document.getElementById("itemPerPageSelect");
  const pageInput = document.getElementById("itemPageInput");

  const page = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
  const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

  if (typeof loadItemPageAjax === "function") {
    loadItemPageAjax(page, perPage, false, "refresh");
  }
}

window.refreshItemTableWithoutReload = refreshItemTableWithoutReload;

function renderItemDesktopRows(items, canEdit) {
  const tbody = document.getElementById("deviceTableBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!items.length) {
    const emptyCols = canEdit ? 14 : 13;
    tbody.innerHTML = `
      <tr>
        <td colspan="${emptyCols}" class="px-4 py-6 text-center text-gray-500">No devices found.</td>
      </tr>
    `;
    return;
  }

  items.forEach((item) => {
    const itemId = Number(item.accession_id);
    const displayBrandModel = item.brand_model || "--";
    const displaySerial = item.serial_no || "--";
    const displayMunicipalSerial = item.municipal_serial_no || "--";
    const displayDateAcquired = item.date_acquired || "--";
    const displayAccountable = item.accountable || "--";
    const displayDepartment = item.department_name || "--";
    const displayRisk = getEffectiveDeviceRisk(item.status, item.risk_level);

    const markCheckedButton = isDeviceDamagedHighRisk(item)
      ? `
          <span class="inline-flex items-center gap-1 bg-yellow-100 text-yellow-700 px-2 py-1 rounded-lg text-xs font-semibold border border-yellow-300 whitespace-nowrap">
            <i data-lucide="alert-circle" class="w-3 h-3"></i> Needs to be Checked
          </span>
        `
      : `
          <button onclick="markChecked('DEVICE', ${itemId})" class="bg-green-600 hover:bg-green-700 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
            <i data-lucide="check" class="w-3 h-3"></i> Mark Checked
          </button>
        `;

    const actionsHtml = canEdit
      ? `
      <td class="px-4 py-2 border-b">
        <div class="flex flex-wrap gap-1">
          <button onclick="openItemModalById(${itemId})" class="bg-blue-500 hover:bg-blue-600 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
            <i data-lucide="pencil" class="w-3 h-3"></i> Edit
          </button>
          <button type="button" onclick="archiveDevice(${itemId}, '${escapeDeviceHtml(item.item_name)}')" class="bg-red-600 hover:bg-red-700 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
            <i data-lucide="trash-2" class="w-3 h-3"></i> Archive
          </button>
          ${markCheckedButton}
          <button onclick="openMaintenanceLog(${itemId}, 'DEVICE')" class="bg-gray-600 hover:bg-gray-700 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
            <i data-lucide="clock" class="w-3 h-3"></i> History
          </button>
        </div>
      </td>
    `
      : "";

    tbody.insertAdjacentHTML(
      "beforeend",
      `
      <tr class="hover:bg-gray-100 transition">
        <td class="px-4 py-2 border-b">
          <input type="checkbox" class="device-checkbox" value="${escapeDeviceHtml(item.accession_id)}">
        </td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(item.accession_id)}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(item.item_name)}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(displayBrandModel)}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(displaySerial)}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(displayMunicipalSerial)}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(formatDeviceCurrency(item.acquisition_cost))}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(displayDateAcquired)}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(displayAccountable)}</td>
        <td class="px-4 py-2 border-b">${escapeDeviceHtml(displayDepartment)}</td>
        <td class="px-4 py-2 border-b font-medium ${getDeviceStatusTextClass(item.status)}">${escapeDeviceHtml(item.status)}</td>
        <td class="px-4 py-2 border-b">${renderDeviceMaintenanceHealthCell(item.health_score, item.maintenance_interval_days, item.status)}</td>
        <td class="px-4 py-2 border-b ${getDeviceRiskTextClass(displayRisk)}">${escapeDeviceHtml(displayRisk)}</td>
        ${actionsHtml}
      </tr>
      `
    );
  });
}

function renderItemMobileCards(items, canEdit) {
  const container = document.getElementById("itemMobileCards");
  if (!container) return;

  container.innerHTML = "";

  if (!items.length) {
    container.innerHTML = `
      <div class="bg-gray-100 text-gray-600 p-4 rounded-lg text-center">No devices found.</div>
    `;
    return;
  }

  items.forEach((item) => {
    const itemId = Number(item.accession_id);
    const hasBrandModel = !!item.brand_model;
    const hasSerial = !!item.serial_no;
    const forceZeroHealth = isDeviceZeroDurationStatus(item.status);
    const healthScore = Number(item.health_score);
    const hasHealth = forceZeroHealth || Number.isFinite(healthScore);
    const clampedHealth = forceZeroHealth ? 0 : (hasHealth ? Math.max(0, Math.min(100, healthScore)) : 0);
    const healthClass = clampedHealth >= 80 ? "bg-green-500" : clampedHealth >= 50 ? "bg-yellow-500" : "bg-red-500";

    const brandModelLine = hasBrandModel
      ? `<p><span class="font-medium">Brand/Model:</span> ${escapeDeviceHtml(item.brand_model)}</p>`
      : "";

    const serialLine = hasSerial
      ? `<p><span class="font-medium">Serial:</span> ${escapeDeviceHtml(item.serial_no)}</p>`
      : "";

    const healthBlock = hasHealth
      ? `
      <div>
        <span class="font-medium">Health:</span>
        <div class="flex items-center gap-2 mt-1">
          <div class="w-20 bg-gray-200 rounded-full h-2">
            <div class="h-2 rounded-full ${healthClass}" style="width: ${clampedHealth}%"></div>
          </div>
          <span class="text-xs font-semibold">${escapeDeviceHtml(String(clampedHealth))}%</span>
        </div>
      </div>
      `
      : "";

    const displayRisk = getEffectiveDeviceRisk(item.status, item.risk_level);

    const markCheckedButton = isDeviceDamagedHighRisk(item)
      ? `
        <span class="bg-yellow-100 text-yellow-700 px-3 py-2 rounded-lg text-xs font-semibold border border-yellow-300 transition flex items-center justify-center gap-1">
          <i data-lucide="alert-circle" class="w-3 h-3"></i> Needs to be Checked
        </span>
      `
      : `
        <button onclick="markChecked('DEVICE', ${itemId})" class="bg-green-600 hover:bg-green-700 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
          <i data-lucide="check" class="w-3 h-3"></i> Mark Checked
        </button>
      `;

    const actionsHtml = canEdit
      ? `
      <div class="grid grid-cols-2 gap-2">
        <button onclick="openItemModalById(${itemId})" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
          <i data-lucide="pencil" class="w-3 h-3"></i> Edit
        </button>
        <button type="button" onclick="archiveDevice(${itemId}, '${escapeDeviceHtml(item.item_name)}')" class="bg-red-600 hover:bg-red-700 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
          <i data-lucide="trash-2" class="w-3 h-3"></i> Archive
        </button>
        ${markCheckedButton}
        <button onclick="openMaintenanceLog(${itemId}, 'DEVICE')" class="bg-gray-600 hover:bg-gray-700 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
          <i data-lucide="clock" class="w-3 h-3"></i> History
        </button>
      </div>
      `
      : "";

    container.insertAdjacentHTML(
      "beforeend",
      `
      <div class="bg-white border border-gray-200 rounded-xl p-4 shadow-sm">
        <div class="flex justify-between items-start mb-3">
          <div>
            <h4 class="font-semibold text-gray-900">${escapeDeviceHtml(item.item_name)}</h4>
            <p class="text-sm text-gray-600">ID: ${escapeDeviceHtml(item.accession_id)}</p>
          </div>
          <span class="px-2 py-1 text-xs font-semibold rounded-full ${getDeviceStatusBadgeClass(item.status)}">
            ${escapeDeviceHtml(item.status)}
          </span>
        </div>

        <div class="space-y-1 text-sm text-gray-600 mb-3">
          ${brandModelLine}
          ${serialLine}
          <p><span class="font-medium">Department:</span> ${escapeDeviceHtml(item.department_name || "--")}</p>
          <p><span class="font-medium">Accountable:</span> ${escapeDeviceHtml(item.accountable || "--")}</p>
          <p><span class="font-medium">Cost:</span> ${escapeDeviceHtml(formatDeviceCurrency(item.acquisition_cost))}</p>
          <p><span class="font-medium">Risk:</span> <span class="font-semibold ${getDeviceRiskTextClass(displayRisk)}">${escapeDeviceHtml(displayRisk)}</span></p>
          ${healthBlock}
        </div>

        <div class="flex items-center gap-2 mb-3">
          <input type="checkbox" class="device-checkbox rounded" value="${escapeDeviceHtml(item.accession_id)}">
          <label class="text-sm text-gray-600">Select for bulk actions</label>
        </div>

        ${actionsHtml}
      </div>
      `
    );
  });
}

function buildItemPaginationMarkup(currentPage, totalPages, perPage) {
  let html = "";

  const navButtonClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-blue-600 transition-colors";
  const disabledButtonClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed";

  if (currentPage > 1) {
    html += `<a href="${createItemPageUrl(currentPage - 1, perPage)}" data-item-page="${currentPage - 1}" class="${navButtonClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</a>`;
  } else {
    html += `<span class="${disabledButtonClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</span>`;
  }

  if (totalPages > 0) {
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    if (startPage > 1) {
      html += `<a href="${createItemPageUrl(1, perPage)}" data-item-page="1" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-blue-600 transition-colors">1</a>`;
      if (startPage > 2) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
    }

    for (let page = startPage; page <= endPage; page++) {
      if (page === currentPage) {
        html += `<span class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors z-10 bg-blue-600 text-white border border-blue-600">${page}</span>`;
      } else {
        html += `<a href="${createItemPageUrl(page, perPage)}" data-item-page="${page}" class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 hover:text-blue-600">${page}</a>`;
      }
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
      html += `<a href="${createItemPageUrl(totalPages, perPage)}" data-item-page="${totalPages}" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-blue-600 transition-colors">${totalPages}</a>`;
    }
  }

  if (currentPage < totalPages) {
    html += `<a href="${createItemPageUrl(currentPage + 1, perPage)}" data-item-page="${currentPage + 1}" class="${navButtonClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></a>`;
  } else {
    html += `<span class="${disabledButtonClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></span>`;
  }

  return html;
}

function updateItemPaginationSummary(page, perPage, totalItems) {
  const summary = document.getElementById("itemPaginationSummary");
  if (!summary) return;

  const start = totalItems > 0 ? (page - 1) * perPage + 1 : 0;
  const end = totalItems > 0 ? Math.min(page * perPage, totalItems) : 0;

  summary.innerHTML = `Showing <span class="font-medium">${start}</span> - <span class="font-medium">${end}</span> of <span class="font-medium">${totalItems}</span> records`;
}

function applyItemPaginationState(page, perPage, totalItems, totalPages) {
  const nav = document.getElementById("itemPaginationNav");
  const perPageSelect = document.getElementById("itemPerPageSelect");
  const pageInput = document.getElementById("itemPageInput");
  const selectAll = document.getElementById("selectAllDevices");

  if (nav) {
    nav.dataset.page = String(page);
    nav.dataset.perPage = String(perPage);
    nav.dataset.totalPages = String(totalPages);
    nav.dataset.totalItems = String(totalItems);
    nav.innerHTML = buildItemPaginationMarkup(page, totalPages, perPage);
  }

  if (perPageSelect) {
    perPageSelect.value = String(perPage);
  }

  if (pageInput) {
    pageInput.value = String(page);
  }

  if (selectAll) {
    selectAll.checked = false;
  }

  updateItemPaginationSummary(page, perPage, totalItems);
}

async function loadItemPageAjax(page, perPage, updateUrl = true, source = "unknown") {
  const pageNumber = Number(page) || 1;
  const perPageNumber = Number(perPage) || 10;

  const requestUrl = createItemPagedApiUrl(pageNumber, perPageNumber);
  const requestKey = requestUrl;

  if (window.__itemPageAjaxPending) {
    console.warn("Skipping duplicate item AJAX load while another request is pending", { source, page: pageNumber, perPage: perPageNumber, requestKey });
    return;
  }

  if (window.__itemLastPageAjaxRequestKey === requestKey && window.__itemLastPageAjaxRequestSource === source && Date.now() - (window.__itemLastPageAjaxRequestTime || 0) < 1000) {
    console.debug("Skipping repeated item AJAX request for same query", { source, page: pageNumber, perPage: perPageNumber, requestKey });
    return;
  }

  window.__itemPageAjaxPending = true;
  window.__itemLastPageAjaxRequestKey = requestKey;
  window.__itemLastPageAjaxRequestSource = source;
  window.__itemLastPageAjaxRequestTime = Date.now();

  console.debug("Item AJAX load", { source, page: pageNumber, perPage: perPageNumber, requestUrl });

  try {
    const response = await fetch(requestUrl, {
      headers: {
        "X-Request-Source": source,
        "X-Page-Request": requestKey
      }
    });
    if (!response.ok) throw new Error(`Failed to load item page: ${response.status}`);

    const data = await response.json();
    const items = Array.isArray(data.items) ? data.items : [];
    const currentPage = Number(data.page) || 1;
    const currentPerPage = Number(data.per_page) || perPage;
    const totalItems = Number(data.total_items) || 0;
    const totalPages = Number(data.total_pages) || 0;

    const tbody = document.getElementById("deviceTableBody");
    const canEdit = tbody && tbody.dataset.canEdit === "1";

    renderItemDesktopRows(items, canEdit);
    renderItemMobileCards(items, canEdit);
    applyItemPaginationState(currentPage, currentPerPage, totalItems, totalPages);

    if (window.lucide) {
      lucide.createIcons();
    }

    if (updateUrl) {
      window.history.replaceState({}, "", createItemPageUrl(currentPage, currentPerPage));
    }
  } catch (error) {
    console.error(error);
    if (typeof showToast === "function") {
      showToast("Failed to load page. Please try again.", "error");
    }
  } finally {
    window.__itemPageAjaxPending = false;
  }
}

function initItemAjaxPagination() {
  const nav = document.getElementById("itemPaginationNav");
  const perPageSelect = document.getElementById("itemPerPageSelect");
  const perPageForm = document.getElementById("itemPerPageForm");
  const itemTableBody = document.getElementById("deviceTableBody");

  if (!nav || !perPageSelect || !perPageForm || !itemTableBody) {
    return;
  }

  nav.addEventListener("click", (event) => {
    const link = event.target.closest("a");
    if (!link || !nav.contains(link)) return;

    event.preventDefault();

    let targetPage = Number(link.dataset.itemPage);
    if (!targetPage) {
      try {
        const linkUrl = new URL(link.href, window.location.origin);
        targetPage = Number(linkUrl.searchParams.get("item_page")) || Number(linkUrl.searchParams.get("page"));
      } catch {
        targetPage = null;
      }
    }

    if (!targetPage) return;

    const perPage = Number(perPageSelect.value) || Number(nav.dataset.perPage) || 10;
    loadItemPageAjax(targetPage, perPage, true, "click");
  });

  perPageForm.addEventListener("submit", (event) => {
    event.preventDefault();
  });

  perPageSelect.addEventListener("change", () => {
    const perPage = Number(perPageSelect.value) || 10;
    loadItemPageAjax(1, perPage, true, "perPageChange");
  });

  window.addEventListener("popstate", () => {
    const url = new URL(window.location.href);
    const section = url.searchParams.get("section");
    if (section !== "item") return;

    const page = Number(url.searchParams.get("item_page")) || 1;
    const perPage = Number(url.searchParams.get("per_page")) || Number(perPageSelect.value) || 10;
    loadItemPageAjax(page, perPage, false, "popstate");
  });
}

function initDeviceExcelImportControls() {
  const fileInput = document.getElementById('deviceExcelFile');
  const fileNameSpan = document.getElementById('deviceExcelFileName');

  if (!fileInput || !fileNameSpan) {
    return;
  }

  const updateFileName = () => {
    const selectedFile = fileInput.files && fileInput.files[0];
    const text = selectedFile ? selectedFile.name : 'No file chosen';
    fileNameSpan.textContent = text;
    fileNameSpan.title = text;
  };

  fileInput.addEventListener('change', updateFileName);
  updateFileName();
}

document.addEventListener("DOMContentLoaded", () => {
  initItemAjaxPagination();
  initDeviceExcelImportControls();
});