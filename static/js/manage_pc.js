// =======================
// MANAGE PC SECTION
// =======================

// SECTION STATE
 

 
function notifyUser(message, type = "info") {
  if (typeof showToast === "function") {
    showToast(message, type);
    return;
  }
  console.warn(message);
}

// ---------- PC MODAL ----------
async function openPcModalById(pcid) {
  try {
    const res = await fetch(`/manage_inventory/get-pc-by-id/${pcid}`);
    if (!res.ok) throw new Error();
    const pc = await res.json();
    openPcModal(pc);
  } catch {
    notifyUser("Failed to load PC data.");
  }
}

// ---------- MAINTENANCE ----------
function openMaintenanceLog(id, type) {
  window.location.href = `/maintenance-history?type=${type}&id=${id}`;
}

// ---------- CHECK / BULK CHECK ----------
function markPcChecked(pcid) {
  if (!confirm("Mark this PC as checked?")) return;

  fetch(`/inventory/pc/${pcid}/check`, { method: "POST" })
    .then(r => r.json())
    .then(d => {
      if (d.success) {
        refreshPcTableWithoutReload();
      } else {
        notifyUser("Update failed");
      }
    });
}

function bulkMarkPcChecked() {
  const selected = [...document.querySelectorAll(".pc-checkbox:checked")]
    .map(cb => cb.value);

  if (!selected.length) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one PC to mark as checked', 'warning');
    } else if (typeof showConfirmationModal === 'function') {
      showConfirmationModal(
        'Selection Required',
        'Please select at least one PC to mark as checked.',
        'OK',
        null
      );
    } else {
      notifyUser("Select at least one PC.");
    }
    return;
  }

  const executeBulkCheck = () => {
    const toastId = typeof showToast === 'function' 
      ? showToast(`Marking ${selected.length} PC(s) as checked...`, 'loading', { showProgress: false })
      : null;
    
    fetch("/inventory/pc/bulk-check", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ pcids: selected })
    })
      .then(res => res.json())
      .then(d => {
        if (toastId) hideToast(toastId);
        
        if (d.success) {
          if (typeof showMarkCheckedToast === 'function') {
            showMarkCheckedToast({
              count: selected.length,
              type: 'PC',
              healthRestored: 100,
              riskLevel: 'Low'
            });
          } else if (typeof showToast === 'function') {
            showToast(`${selected.length} PC(s) marked as checked successfully`, 'success', { showProgress: false });
          }
          setTimeout(() => refreshPcTableWithoutReload(), 2000);
        } else {
          if (typeof showToast === 'function') {
            showToast(d.error || 'Failed to mark PCs as checked', 'error', { showProgress: false });
          } else {
            notifyUser("Bulk update failed");
          }
        }
      })
      .catch(() => {
        if (toastId) hideToast(toastId);
        if (typeof showToast === 'function') {
          showToast('Server error during bulk check', 'error', { showProgress: false });
        } else {
          notifyUser("Bulk update failed");
        }
      });
  };

  if (typeof showBulkMarkCheckedModal === 'function') {
    showBulkMarkCheckedModal(
      `Mark ${selected.length} selected PC(s) as checked? This will restore their health to 100% and set risk level to Low.`,
      executeBulkCheck
    );
  } else if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Confirm Mark Checked',
      `Mark ${selected.length} PC(s) as checked? Health will be restored to 100% and risk level set to Low.`,
      'Mark Checked',
      executeBulkCheck
    );
  } else {
    if (!confirm(`Mark ${selected.length} PCs as checked?`)) return;
    executeBulkCheck();
  }
}

// ---------- SELECT ALL ----------
function toggleSelectAllPCs(master) {
  document.querySelectorAll(".pc-checkbox")
    .forEach(cb => cb.checked = master.checked);
}
function bulkSurrenderSelectedPCs() {
  const checked = Array.from(document.querySelectorAll('.pc-checkbox'))
    .filter(cb => cb.checked)
    .map(cb => cb.value);
  
  if (checked.length === 0) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one PC to surrender', 'warning');
    } else {
      notifyUser('No PCs selected');
    }
    return;
  }

  const executeSurrender = () => {
    const toastId = typeof showToast === 'function'
      ? showToast(`Surrendering ${checked.length} PC(s)...`, 'loading')
      : null;

    fetch('/inventory/pc/bulk-surrender', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ pcids: checked })
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
            type: 'PC'
          });
        } else if (typeof showToast === 'function') {
          showToast(`${checked.length} PC(s) surrendered successfully`, 'success');
        }
        setTimeout(() => {
          const nav = document.getElementById("pcPaginationNav");
          const perPageSelect = document.getElementById("pcPerPageSelect");
          const pageInput = document.getElementById("pcPageInput");
          const page = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
          const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

          if (typeof loadPcPageAjax === "function") {
            loadPcPageAjax(page, perPage, false);
          }
        }, 2000);
      } else {
        if (typeof showToast === 'function') {
          const errorMessage = (data && (data.error || data.message))
            ? (data.error || data.message)
            : `Surrender failed (${res?.status || 'unknown'})`;
          showToast(errorMessage, 'error');
        } else {
          notifyUser('Surrender failed: ' + ((data && (data.error || data.message)) || 'unknown'));
        }
      }
    })
    .catch(err => {
      if (toastId) hideToast(toastId);
      console.error(err);
      if (typeof showToast === 'function') {
        showToast('Server error during surrender', 'error');
      } else {
        notifyUser('Surrender failed');
      }
    });
  };

  if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Confirm Surrender',
      `Are you sure you want to surrender ${checked.length} PC(s)? This will move them to the Surrendered section and remove them from active inventory.`,
      'Surrender',
      executeSurrender
    );
  } else {
    if (!confirm(`Surrender ${checked.length} selected PC(s)? This will mark them as Surrendered.`)) return;
    executeSurrender();
  }
}

function exportSelectedPCs() {
  const selected = Array.from(document.querySelectorAll('.pc-checkbox'))
    .filter(cb => cb.checked)
    .map(cb => cb.value);

  if (selected.length === 0) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one PC to export', 'warning');
    } else {
      notifyUser("Select at least one PC to export.");
    }
    return;
  }

  const toastId = typeof showToast === 'function'
    ? showToast(`Exporting ${selected.length} PC(s)...`, 'loading')
    : null;

  fetch('/manage_pc/export-selected-pcs', {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ pcids: selected })
  })
  .then(res => {
    if (!res.ok) throw new Error('Export failed');
    return res.blob();
  })
  .then(blob => {
    if (toastId) hideToast(toastId);
    
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "selected_pcs.xlsx";
    document.body.appendChild(a);
    a.click();
    a.remove();
    window.URL.revokeObjectURL(url);
    
    if (typeof showExportToast === 'function') {
      showExportToast({
        count: selected.length,
        type: 'PC',
        filename: 'selected_pcs.xlsx'
      });
    } else if (typeof showToast === 'function') {
      showToast(`${selected.length} PC(s) exported successfully`, 'success');
    }
  })
  .catch(err => {
    if (toastId) hideToast(toastId);
    console.error(err);
    if (typeof showToast === 'function') {
      showToast('Export failed. Please try again.', 'error');
    } else {
      notifyUser("Export failed.");
    }
  });
}

function exportCurrentPcTableToExcel() {
  const visibleCheckboxes = Array.from(
    document.querySelectorAll("#pcTableBody .pc-checkbox, #pcMobileCards .pc-checkbox")
  );

  let visiblePcids = [...new Set(
    visibleCheckboxes
      .map(cb => Number(cb.value))
      .filter(Number.isFinite)
  )];

  if (!visiblePcids.length) {
    const actionButtons = Array.from(
      document.querySelectorAll("#pcTableBody button[onclick*='openPcModalById'], #pcMobileCards button[onclick*='openPcModalById']")
    );

    visiblePcids = [...new Set(
      actionButtons
        .map(btn => {
          const onclick = btn.getAttribute("onclick") || "";
          const match = onclick.match(/openPcModalById\((\d+)\)/);
          return match ? Number(match[1]) : NaN;
        })
        .filter(Number.isFinite)
    )];
  }

  if (!visiblePcids.length) {
    if (typeof showToast === 'function') {
      showToast('No PC rows found to export on this page', 'warning');
    } else {
      notifyUser('No PC rows found to export.');
    }
    return;
  }

  const toastId = typeof showToast === 'function'
    ? showToast(`Exporting ${visiblePcids.length} PC(s) from table...`, 'loading')
    : null;

  fetch('/manage_pc/export-selected-pcs', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ pcids: visiblePcids })
  })
    .then(res => {
      if (!res.ok) throw new Error('Export failed');
      return res.blob();
    })
    .then(blob => {
      if (toastId) hideToast(toastId);

      const url = window.URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'pc_table_export.xlsx';
      document.body.appendChild(a);
      a.click();
      a.remove();
      window.URL.revokeObjectURL(url);

      if (typeof showExportToast === 'function') {
        showExportToast({
          count: visiblePcids.length,
          type: 'PC',
          filename: 'pc_table_export.xlsx'
        });
      } else if (typeof showToast === 'function') {
        showToast(`${visiblePcids.length} PC(s) exported successfully`, 'success');
      }
    })
    .catch(err => {
      if (toastId) hideToast(toastId);
      console.error(err);
      if (typeof showToast === 'function') {
        showToast('Export failed. Please try again.', 'error');
      } else {
        notifyUser('Export failed.');
      }
    });
}

window.exportCurrentPcTableToExcel = exportCurrentPcTableToExcel;
window.exportSelectedPCs = exportSelectedPCs;

function exportSinglePC(pcid) {
  const id = pcid;
  if (!id && id !== 0) {
    if (typeof showToast === 'function') {
      showToast('Invalid PC selected for export', 'error');
    } else {
      alert('Invalid PC selected for export');
    }
    return;
  }

  const toastId = typeof showToast === 'function'
    ? showToast('Exporting PC...', 'loading')
    : null;

  fetch('/manage_pc/export-selected-pcs', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ pcids: [id] })
  })
  .then(res => {
    if (!res.ok) throw new Error('Export failed');
    return res.blob();
  })
  .then(blob => {
    if (toastId) hideToast(toastId);

    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `pc_${id}.xlsx`;
    document.body.appendChild(a);
    a.click();
    a.remove();
    window.URL.revokeObjectURL(url);

    if (typeof showExportToast === 'function') {
      showExportToast({ count: 1, type: 'PC', filename: `pc_${id}.xlsx` });
    } else if (typeof showToast === 'function') {
      showToast('PC exported successfully', 'success');
    }
  })
  .catch(err => {
    if (toastId) hideToast(toastId);
    console.error(err);
    if (typeof showToast === 'function') {
      showToast(err?.message || 'Export failed. Please try again.', 'error');
    } else {
      alert(err?.message || 'Export failed');
    }
  });
}

window.exportSinglePC = exportSinglePC;
function bulkMarkDamagedSelectedPCs() {
  const checked = Array.from(document.querySelectorAll('.pc-checkbox'))
    .filter(cb => cb.checked)
    .map(cb => cb.value);

  if (checked.length === 0) {
    if (typeof showToast === 'function') {
      showToast('Please select at least one PC to mark as damaged', 'warning');
    } else {
      notifyUser('No PCs selected');
    }
    return;
  }

  const executeMarkDamaged = () => {
    const toastId = typeof showToast === 'function'
      ? showToast(`Marking ${checked.length} PC(s) as damaged...`, 'loading')
      : null;

    fetch('/inventory/pc/bulk-damaged', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        pcids: checked,
        damage_type_id: 1,
        severity: 'High',
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
            type: 'PC',
            severity: 'High'
          });
        } else if (typeof showToast === 'function') {
          showToast(`${checked.length} PC(s) marked as damaged`, 'warning');
        }
        setTimeout(() => {
          const nav = document.getElementById("pcPaginationNav");
          const perPageSelect = document.getElementById("pcPerPageSelect");
          const pageInput = document.getElementById("pcPageInput");
          const page = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
          const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

          if (typeof loadPcPageAjax === "function") {
            loadPcPageAjax(page, perPage, false);
          }
        }, 2000);
      } else {
        if (typeof showToast === 'function') {
          showToast(d.error || 'Failed to mark PCs as damaged', 'error');
        } else {
          notifyUser('Failed: ' + (d.error || 'unknown'));
        }
      }
    })
    .catch(err => {
      if (toastId) hideToast(toastId);
      console.error(err);
      if (typeof showToast === 'function') {
        showToast('Server error during operation', 'error');
      } else {
        notifyUser('Operation failed');
      }
    });
  };

  if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Confirm Mark as Damaged',
      `Are you sure you want to mark ${checked.length} PC(s) as DAMAGED? This will set their status to "Damaged" and risk level to HIGH. This action cannot be undone easily.`,
      'Mark as Damaged',
      executeMarkDamaged
    );
  } else {
    if (!confirm(`Mark ${checked.length} PC(s) as DAMAGED?`)) return;
    executeMarkDamaged();
  }
}


// ---------- RISK UPDATE ----------
async function runRiskUpdate() {
  // Check if showConfirmationModal is available, otherwise use native confirm
  if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Confirm Recalculation',
      'Do you want to recalculate all risk levels? This may take a few moments.',
      'Recalculate',
      async function() {
        try {
          const res = await fetch("/manage_inventory/run-risk-update", {
            method: "POST"
          });
          const data = await res.json();
          notifyUser(data.message || "Risk updated.");
        } catch {
          notifyUser("Risk update failed.");
        }
      }
    );
  } else {
    // Fallback to native confirm if modal function is not available
    if (!confirm("Recalculate PC risk levels?")) return;
    
    try {
      const res = await fetch("/manage_inventory/run-risk-update", {
        method: "POST"
      });
      const data = await res.json();
      notifyUser(data.message || "Risk updated.");
    } catch {
      notifyUser("Risk update failed.");
    }
  }
}

window.openPcModalById = async function (pcid) {
  try {
    const res = await fetch(`/manage_inventory/get-pc-by-id/${pcid}`);
    if (!res.ok) throw new Error(res.status);
    const pc = await res.json();
    openPcModal(pc);
  } catch {
    notifyUser("Failed to load PC data.");
  }
};

window.markPcChecked = function (pcid) {
  if (!confirm("Mark this PC as checked?")) return;

  fetch(`/inventory/pc/${pcid}/check`, { method: "POST" })
    .then(r => r.json())
    .then(d => {
      if (d.success) {
        refreshPcTableWithoutReload();
      } else {
        notifyUser("Failed");
      }
    });
};


window.runRiskUpdate = async function () {
  // Check if toast system is available
  if (typeof showConfirmationModal === 'function' && typeof showToast === 'function') {
    showConfirmationModal(
      'Update PC Risk Levels',
      'This will analyze all PCs and recalculate their risk levels based on maintenance history and current status. Continue?',
      'Start Analysis',
      async function() {
        const toastId = showToast('Analyzing PC risk levels...', 'loading');
        
        try {
          const res = await fetch("/manage_inventory/run-risk-update", { 
            method: "POST",
            headers: { "Content-Type": "application/json" }
          });
          
          const data = await res.json();
          hideToast(toastId);
          
          if (data.success || res.ok) {
            showToast('PC risk levels updated successfully!', 'success');
          } else {
            showToast(data.message || 'Risk update failed', 'error');
          }
        } catch (err) {
          hideToast(toastId);
          showToast('Failed to update risk levels', 'error');
        }
      }
    );
  } else {
    // Fallback to native confirm if modal function is not available
    if (!confirm("Run risk recalculation?")) return;
    await fetch("/manage_inventory/run-risk-update", { method: "POST" });
  }
};

window.openMaintenanceLog = function (id, type) {
  window.location.href = `/maintenance-history?type=${type}&id=${id}`;
};

window.openDeleteModal = function openDeleteModal(actionUrl) {
  const modal = document.getElementById("deleteModal");
  const form = document.getElementById("deleteForm");

  if (!modal || !form) {
    console.error("Delete modal or form not found in DOM");
    return;
  }

  form.action = actionUrl;
  modal.classList.remove("hidden");

  if (window.lucide) {
    lucide.createIcons();
  }
};

window.closeDeleteModal = function closeDeleteModal() {
  const modal = document.getElementById("deleteModal");
  if (modal) modal.classList.add("hidden");
};

document.addEventListener("DOMContentLoaded", () => {
  const cancelBtn = document.getElementById("cancelDelete");
  if (cancelBtn) {
    cancelBtn.addEventListener("click", window.closeDeleteModal);
  }

  const modal = document.getElementById("deleteModal");
  if (modal) {
    modal.addEventListener("click", function(e) {
      if (e.target === modal) {
        window.closeDeleteModal();
      }
    });
  }

  const deleteForm = document.getElementById("deleteForm");
  if (deleteForm) {
    deleteForm.addEventListener("submit", async function (event) {
      const action = deleteForm.getAttribute("action") || "";
      const isPcDelete = action.includes("/delete-pc/");
      const isDeviceDelete = action.includes("/delete-item/");
      const isConsumableDelete = action.includes("/delete-consumable/");

      if (!isPcDelete && !isDeviceDelete && !isConsumableDelete) {
        return;
      }

      event.preventDefault();

      const entityLabel = isPcDelete ? "PC" : (isDeviceDelete ? "Device" : "Consumable");

      const submitBtn = deleteForm.querySelector("button[type='submit']");
      if (submitBtn) submitBtn.disabled = true;

      const toastId = typeof showToast === "function"
        ? showToast(`Deleting ${entityLabel.toLowerCase()}...`, "loading")
        : null;

      try {
        const response = await fetch(action, {
          method: "POST",
          headers: {
            "X-Requested-With": "XMLHttpRequest"
          }
        });

        const contentType = response.headers.get("content-type") || "";
        const payload = contentType.includes("application/json") ? await response.json() : null;

        if (!response.ok || (payload && payload.success === false)) {
          throw new Error((payload && payload.error) || `Failed to delete ${entityLabel.toLowerCase()}.`);
        }

        if (toastId) hideToast(toastId);
        if (typeof showToast === "function") {
          showToast(`${entityLabel} deleted successfully`, "success");
        }

        window.closeDeleteModal();

        if (isPcDelete) {
          refreshPcTableWithoutReload();
        } else if (isDeviceDelete) {
          if (typeof window.refreshItemTableWithoutReload === "function") {
            window.refreshItemTableWithoutReload();
          }
        } else if (isConsumableDelete) {
          if (typeof window.refreshConsumableTableWithoutReload === "function") {
            window.refreshConsumableTableWithoutReload();
          }
        }
      } catch (error) {
        if (toastId) hideToast(toastId);
        if (typeof showToast === "function") {
          showToast(error.message || `Failed to delete ${entityLabel.toLowerCase()}`, "error");
        } else {
          notifyUser(error.message || `Failed to delete ${entityLabel.toLowerCase()}`);
        }
      } finally {
        if (submitBtn) submitBtn.disabled = false;
      }
    });
  }

  const pcExcelFileInput = document.getElementById("pcExcelFile");
  const pcExcelFileName = document.getElementById("pcExcelFileName");

  if (pcExcelFileInput && pcExcelFileName) {
    const updatePcExcelFileName = () => {
      const selectedFile = pcExcelFileInput.files && pcExcelFileInput.files[0];
      const text = selectedFile ? selectedFile.name : "No file chosen";

      pcExcelFileName.textContent = text;
      pcExcelFileName.title = text;
    };

    const confirmPcExcelSelection = () => {
      const selectedFile = pcExcelFileInput.files && pcExcelFileInput.files[0];
      if (!selectedFile) {
        updatePcExcelFileName();
        return;
      }

      if (typeof showConfirmationModal === "function") {
        const cancelBtn = document.getElementById("confirmationCancel");
        const modal = document.getElementById("confirmationModal");
        let isFinalized = false;

        const cleanup = () => {
          if (cancelBtn) cancelBtn.removeEventListener("click", handleCancel);
          if (modal) modal.removeEventListener("click", handleBackdropClick);
        };

        const finalizeSelection = (approved) => {
          if (isFinalized) return;
          isFinalized = true;
          cleanup();

          if (!approved) {
            pcExcelFileInput.value = "";
          }

          updatePcExcelFileName();
        };

        const handleCancel = () => finalizeSelection(false);
        const handleBackdropClick = (event) => {
          if (event.target === modal) {
            finalizeSelection(false);
          }
        };

        if (cancelBtn) cancelBtn.addEventListener("click", handleCancel);
        if (modal) modal.addEventListener("click", handleBackdropClick);

        showConfirmationModal(
          "Confirm File Selection",
          `Use \"${selectedFile.name}\" for import?`,
          "Use File",
          () => finalizeSelection(true)
        );
        return;
      }

      const approved = window.confirm(`Use \"${selectedFile.name}\" for import?`);
      if (!approved) {
        pcExcelFileInput.value = "";
      }
      updatePcExcelFileName();
    };

    pcExcelFileInput.addEventListener("change", confirmPcExcelSelection);

    updatePcExcelFileName();
  }

  initPcAjaxPagination();
});

function escapeHtml(value) {
  if (value === null || value === undefined) return "";
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function getPcStatusTextClass(status) {
  const key = String(status || '').trim().toLowerCase();
  if (key === 'available') return 'text-green-600';
  if (key === 'in use' || key === 'in used' || key === 'in-used' || key === 'inuse') return 'text-blue-600';
  if (key === 'inactive') return 'text-gray-500';
  return 'text-red-600';
}

function getPcStatusBadgeClass(status) {
  const key = String(status || '').trim().toLowerCase();
  if (key === 'available') return 'bg-green-100 text-green-600';
  if (key === 'in use' || key === 'in used' || key === 'in-used' || key === 'inuse') return 'bg-blue-100 text-blue-600';
  if (key === 'inactive') return 'bg-gray-100 text-gray-500';
  return 'bg-red-100 text-red-600';
}

function getEffectivePcRisk(status, riskLevel) {
  const statusKey = String(status || "").trim().toLowerCase();
  if (statusKey === "damaged" || statusKey === "damage" || statusKey === "unusable") {
    return "High";
  }
  const normalizedRisk = String(riskLevel || "").trim();
  return normalizedRisk || "--";
}

function getPcRiskTextClass(riskLevel) {
  const riskKey = String(riskLevel || "").trim().toLowerCase();
  if (riskKey === "high") return "text-red-600 font-semibold";
  if (riskKey === "medium") return "text-yellow-600 font-semibold";
  if (riskKey === "low") return "text-green-600 font-semibold";
  return "text-gray-500";
}

function isPcDamagedHighRisk(pc) {
  const statusKey = String(pc?.status || "").trim().toLowerCase();
  const riskKey = String(getEffectivePcRisk(pc?.status, pc?.risk_level) || "").trim().toLowerCase();
  return (statusKey === "damaged" || statusKey === "damage") && riskKey === "high";
}

function isPcZeroDurationStatus(status) {
  const statusKey = String(status || "").trim().toLowerCase();
  return statusKey === "damaged" || statusKey === "damage" || statusKey === "unusable";
}

function toPcHealthPercent(value) {
  const numericValue = Number(value);
  if (!Number.isFinite(numericValue)) return null;
  const clamped = Math.max(0, Math.min(100, numericValue));
  return Math.round(clamped * 100) / 100;
}

function getPcHealthBarClass(healthPercent) {
  if (healthPercent >= 80) return "bg-green-500";
  if (healthPercent >= 50) return "bg-yellow-500";
  return "bg-red-500";
}

function toPcDurationYears(maintenanceIntervalDays) {
  const durationValue = Number(maintenanceIntervalDays);
  if (!Number.isFinite(durationValue) || durationValue <= 0) return null;
  if (durationValue >= 365) {
    return Math.max(1, Math.round(durationValue / 365));
  }
  return Math.round(durationValue);
}

function renderPcMaintenanceHealthCell(healthScore, maintenanceIntervalDays, status) {
  const forceZero = isPcZeroDurationStatus(status);
  let durationLabel = "--";
  if (forceZero) {
    durationLabel = "0 years";
  } else {
    const durationYears = toPcDurationYears(maintenanceIntervalDays);
    if (durationYears !== null) {
      durationLabel = `${durationYears} year${durationYears === 1 ? "" : "s"}`;
    }
  }
  return `
    <div class="min-w-[140px]">
      <span class="text-xs text-gray-600">${escapeHtml(durationLabel)}</span>
    </div>
  `;
}

function shouldShowPcMarkCheckedButton(pc) {
  return !isPcDamagedHighRisk(pc);
}

const PC_FILTER_PARAM_KEYS = [
  "department_id",
  "status",
  "accountable",
  "serial_no",
  "date_from",
  "date_to",
  "risk_level",
  "last_checked_from",
  "last_checked_to",
  "overdue",
  "needs_checking",
  "search"
];

function getActivePcFilterParamsFromUrl() {
  const url = new URL(window.location.href);
  const params = new URLSearchParams();

  PC_FILTER_PARAM_KEYS.forEach((key) => {
    const value = url.searchParams.get(key);
    if (value !== null && value !== "") {
      params.set(key, value);
    }
  });

  return params;
}

function createPcPageUrl(page, perPage) {
  const url = new URL(window.location.origin + window.location.pathname);
  const params = getActivePcFilterParamsFromUrl();
  params.set("section", "pc");
  params.set("page", String(page));
  params.set("per_page", String(perPage));
  params.forEach((value, key) => {
    url.searchParams.set(key, value);
  });
  return `${url.pathname}?${url.searchParams.toString()}`;
}

function refreshPcTableWithoutReload() {
  const nav = document.getElementById("pcPaginationNav");
  const perPageSelect = document.getElementById("pcPerPageSelect");
  const pageInput = document.getElementById("pcPageInput");

  const page = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
  const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

  if (typeof loadPcPageAjax === "function") {
    loadPcPageAjax(page, perPage, false, "refresh");
  }
}

window.refreshPcTableWithoutReload = refreshPcTableWithoutReload;

function renderPcDesktopRows(pcs, canEdit) {
  const tbody = document.getElementById("pcTableBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!pcs.length) {
    const emptyCols = canEdit ? 13 : 12;
    tbody.innerHTML = `
      <tr>
        <td colspan="${emptyCols}" class="px-4 py-6 text-center text-gray-500">No PCs found.</td>
      </tr>
    `;
    return;
  }

  pcs.forEach((pc) => {
    const effectiveRisk = getEffectivePcRisk(pc.status, pc.risk_level);
    const markCheckedButton = shouldShowPcMarkCheckedButton(pc)
      ? `
        <button onclick="markPcChecked(${Number(pc.pcid)})" class="bg-green-600 hover:bg-green-700 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
          <i data-lucide="check" class="w-3 h-3"></i> Mark Checked
        </button>
      `
      : `
        <span class="inline-flex items-center gap-1 bg-yellow-100 text-yellow-700 px-2 py-1 rounded-lg text-xs font-semibold border border-yellow-300 whitespace-nowrap">
          <i data-lucide="alert-circle" class="w-3 h-3"></i> Needs to be Checked
        </span>
      `;

    const actionsHtml = canEdit
      ? `
      <td class="px-4 py-2 border-b">
        <div class="flex flex-wrap gap-1">
          <button onclick="openPcModalById(${Number(pc.pcid)})" class="bg-blue-500 hover:bg-blue-600 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
            <i data-lucide="pencil" class="w-3 h-3"></i> Edit
          </button>
          <button type="button" onclick="openDeleteModal('/delete-pc/${encodeURIComponent(pc.pcid)}')" class="bg-red-600 hover:bg-red-700 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
            <i data-lucide="trash-2" class="w-3 h-3"></i> Archive
          </button>
          ${markCheckedButton}
          <button onclick="openMaintenanceLog(${Number(pc.pcid)}, 'PC')" class="bg-gray-600 hover:bg-gray-700 text-white px-2 py-1 rounded-lg text-xs shadow whitespace-nowrap flex items-center gap-1">
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
          <input type="checkbox" class="pc-checkbox" value="${escapeHtml(pc.pcid)}">
        </td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.pcid)}</td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.pcname)}</td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.department_name)}</td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.acquisition_cost)}</td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.date_acquired)}</td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.accountable)}</td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.serial_no)}</td>
        <td class="px-4 py-2 border-b">${escapeHtml(pc.municipal_serial_no)}</td>
        <td class="px-4 py-2 border-b font-medium ${getPcStatusTextClass(pc.status)}">${escapeHtml(pc.status)}</td>
        <td class="px-4 py-2 border-b">${renderPcMaintenanceHealthCell(pc.health_score, pc.maintenance_interval_days, pc.status)}</td>
        <td class="px-4 py-2 border-b ${getPcRiskTextClass(effectiveRisk)}">${escapeHtml(effectiveRisk)}</td>
        ${actionsHtml}
      </tr>
    `
    );
  });
}

function renderPcMobileCards(pcs, canEdit) {
  const container = document.getElementById("pcMobileCards");
  if (!container) return;

  container.innerHTML = "";

  if (!pcs.length) {
    container.innerHTML = `
      <div class="bg-gray-100 text-gray-600 p-4 rounded-lg text-center">No PCs found.</div>
    `;
    return;
  }

  pcs.forEach((pc) => {
    const serialLine = pc.serial_no
      ? `<p><span class="font-medium">Serial:</span> ${escapeHtml(pc.serial_no)}</p>`
      : "";

    const functionalText = pc.status === "Damaged" ? "Not Functional" : "Functional";
    const functionalClass = pc.status === "Damaged" ? "text-red-600" : "text-green-600";

    const markCheckedButton = shouldShowPcMarkCheckedButton(pc)
      ? `
      <button onclick="markPcChecked(${Number(pc.pcid)})" class="bg-green-600 hover:bg-green-700 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
        <i data-lucide="check" class="w-3 h-3"></i> Mark Checked
      </button>
      `
      : `
      <span class="bg-yellow-100 text-yellow-700 px-3 py-2 rounded-lg text-xs font-semibold border border-yellow-300 transition flex items-center justify-center gap-1">
        <i data-lucide="alert-circle" class="w-3 h-3"></i> Needs to be Checked
      </span>
      `;

    const actionsHtml = canEdit
      ? `
      <div class="grid grid-cols-2 gap-2">
        <button onclick="openPcModalById(${Number(pc.pcid)})" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
          <i data-lucide="pencil" class="w-3 h-3"></i> Edit
        </button>
        <button type="button" onclick="openDeleteModal('/delete-pc/${encodeURIComponent(pc.pcid)}')" class="bg-red-600 hover:bg-red-700 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
          <i data-lucide="trash-2" class="w-3 h-3"></i> Delete
        </button>
        ${markCheckedButton}
        <button onclick="openMaintenanceLog(${Number(pc.pcid)}, 'PC')" class="bg-gray-600 hover:bg-gray-700 text-white px-3 py-2 rounded-lg text-xs font-medium transition flex items-center justify-center gap-1">
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
            <h4 class="font-semibold text-gray-900">${escapeHtml(pc.pcname)}</h4>
            <p class="text-sm text-gray-600">ID: ${escapeHtml(pc.pcid)}</p>
          </div>
          <span class="px-2 py-1 text-xs font-semibold rounded-full ${getPcStatusBadgeClass(pc.status)}">
            ${escapeHtml(pc.status)}
          </span>
        </div>

        <div class="space-y-1 text-sm text-gray-600 mb-3">
          <p><span class="font-medium">Office and Facility:</span> ${escapeHtml(pc.department_name)}</p>
          <p><span class="font-medium">Accountable:</span> ${escapeHtml(pc.accountable)}</p>
          ${serialLine}
          <p class="px-4 py-2 border-b font-medium ${functionalClass}">${functionalText}</p>
        </div>

        <div class="flex items-center gap-2 mb-3">
          <input type="checkbox" class="pc-checkbox rounded" value="${escapeHtml(pc.pcid)}">
          <label class="text-sm text-gray-600">Select for bulk actions</label>
        </div>

        ${actionsHtml}
      </div>
      `
    );
  });
}

function buildPcPaginationMarkup(currentPage, totalPages, perPage) {
  let html = "";

  const prevLinkClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-blue-600 transition-colors";
  const prevDisabledClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed";
  const nextLinkClass = prevLinkClass;
  const nextDisabledClass = prevDisabledClass;

  if (currentPage > 1) {
    html += `<a href="${createPcPageUrl(currentPage - 1, perPage)}" data-pc-page="${currentPage - 1}" class="${prevLinkClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</a>`;
  } else {
    html += `<span class="${prevDisabledClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</span>`;
  }

  if (totalPages > 0) {
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    if (startPage > 1) {
      html += `<a href="${createPcPageUrl(1, perPage)}" data-pc-page="1" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-blue-600 transition-colors">1</a>`;
      if (startPage > 2) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
    }

    for (let page = startPage; page <= endPage; page++) {
      if (page === currentPage) {
        html += `<span class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors z-10 bg-blue-600 text-white border border-blue-600">${page}</span>`;
      } else {
        html += `<a href="${createPcPageUrl(page, perPage)}" data-pc-page="${page}" class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 hover:text-blue-600">${page}</a>`;
      }
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
      html += `<a href="${createPcPageUrl(totalPages, perPage)}" data-pc-page="${totalPages}" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-blue-600 transition-colors">${totalPages}</a>`;
    }
  }

  if (currentPage < totalPages) {
    html += `<a href="${createPcPageUrl(currentPage + 1, perPage)}" data-pc-page="${currentPage + 1}" class="${nextLinkClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></a>`;
  } else {
    html += `<span class="${nextDisabledClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></span>`;
  }

  return html;
}

function updatePcPaginationSummary(page, perPage, totalItems) {
  const summary = document.getElementById("pcPaginationSummary");
  if (!summary) return;

  const start = totalItems > 0 ? (page - 1) * perPage + 1 : 0;
  const end = totalItems > 0 ? Math.min(page * perPage, totalItems) : 0;

  summary.innerHTML = `Showing <span class="font-medium">${start}</span> - <span class="font-medium">${end}</span> of <span class="font-medium">${totalItems}</span> records`;
}

function applyPcPaginationState(page, perPage, totalItems, totalPages) {
  const nav = document.getElementById("pcPaginationNav");
  const perPageSelect = document.getElementById("pcPerPageSelect");
  const pageInput = document.getElementById("pcPageInput");
  const selectAll = document.getElementById("selectAllPcs");

  if (nav) {
    nav.dataset.page = String(page);
    nav.dataset.perPage = String(perPage);
    nav.dataset.totalPages = String(totalPages);
    nav.dataset.totalItems = String(totalItems);
    nav.innerHTML = buildPcPaginationMarkup(page, totalPages, perPage);
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

  updatePcPaginationSummary(page, perPage, totalItems);
}

async function loadPcPageAjax(page, perPage, updateUrl = true, source = "unknown") {
  const pageNumber = Number(page) || 1;
  const perPageNumber = Number(perPage) || 10;

  const query = getActivePcFilterParamsFromUrl();
  query.set("section", "pc");
  query.set("page", String(pageNumber));
  query.set("per_page", String(perPageNumber));
  const requestKey = query.toString();

  if (window.__pcPageAjaxPending) {
    console.warn("Skipping duplicate PC AJAX load while another request is pending", { source, page: pageNumber, perPage: perPageNumber, requestKey });
    return;
  }

  if (window.__pcLastPcAjaxRequestKey === requestKey && window.__pcLastPcAjaxRequestSource === source && Date.now() - (window.__pcLastPcAjaxRequestTime || 0) < 1000) {
    console.debug("Skipping repeated PC AJAX request for same query", { source, page: pageNumber, perPage: perPageNumber, requestKey });
    return;
  }

  window.__pcPageAjaxPending = true;
  window.__pcLastPcAjaxRequestKey = requestKey;
  window.__pcLastPcAjaxRequestSource = source;
  window.__pcLastPcAjaxRequestTime = Date.now();

  console.debug("PC AJAX load", { source, page: pageNumber, perPage: perPageNumber, requestKey });

  try {
    const response = await fetch(`/manage_inventory/pcs-paged?${query.toString()}`, {
      headers: {
        "X-Request-Source": source,
        "X-Page-Request": requestKey
      }
    });
    if (!response.ok) throw new Error(`Failed to load PC page: ${response.status}`);

    const data = await response.json();
    const pcs = Array.isArray(data.pcs) ? data.pcs : [];
    const currentPage = Number(data.page) || 1;
    const currentPerPage = Number(data.per_page) || perPage;
    const totalItems = Number(data.total_items) || 0;
    const totalPages = Number(data.total_pages) || 0;

    const tbody = document.getElementById("pcTableBody");
    const canEdit = tbody && tbody.dataset.canEdit === "1";

    renderPcDesktopRows(pcs, canEdit);
    renderPcMobileCards(pcs, canEdit);
    applyPcPaginationState(currentPage, currentPerPage, totalItems, totalPages);

    if (window.lucide) {
      lucide.createIcons();
    }

    if (updateUrl) {
      window.history.replaceState({}, "", createPcPageUrl(currentPage, currentPerPage));
    }
  } catch (error) {
    console.error(error);
    if (typeof showToast === "function") {
      showToast("Failed to load page. Please try again.", "error");
    }
  } finally {
    window.__pcPageAjaxPending = false;
  }
}

function initPcAjaxPagination() {
  const nav = document.getElementById("pcPaginationNav");
  const perPageSelect = document.getElementById("pcPerPageSelect");
  const perPageForm = document.getElementById("pcPerPageForm");
  const pcTableBody = document.getElementById("pcTableBody");

  if (!nav || !perPageSelect || !perPageForm || !pcTableBody) {
    return;
  }

  const handlePcPaginationClick = (event) => {
    const link = event.target.closest("a");
    if (!link || !nav.contains(link)) return;

    let targetPage = null;
    try {
      const url = new URL(link.href, window.location.origin);
      targetPage = Number(url.searchParams.get("page"));
    } catch {
      targetPage = null;
    }

    if (!Number.isInteger(targetPage) || targetPage < 1) return;

    event.preventDefault();
    event.stopPropagation();
    event.stopImmediatePropagation();

    const perPage = Number(perPageSelect.value) || Number(nav.dataset.perPage) || 10;
    console.debug("PC pagination click", { href: link.href, targetPage, perPage });
    loadPcPageAjax(targetPage, perPage, true, "click");
  };

  nav.addEventListener("click", handlePcPaginationClick);

  perPageForm.addEventListener("submit", (event) => {
    event.preventDefault();
  });

  perPageSelect.addEventListener("change", () => {
    const perPage = Number(perPageSelect.value) || 10;
    loadPcPageAjax(1, perPage, true, "perPageChange");
  });

  window.addEventListener("popstate", () => {
    const url = new URL(window.location.href);
    const section = url.searchParams.get("section") || "pc";
    if (section !== "pc") return;

    const page = Number(url.searchParams.get("page")) || 1;
    const perPage = Number(url.searchParams.get("per_page")) || Number(perPageSelect.value) || 10;
    console.debug("PC popstate load", { page, perPage });
    loadPcPageAjax(page, perPage, false, "popstate");
  });
}

function importPCExcel(forceFirstPage = false) {
  const fileInput = document.getElementById("pcExcelFile");
  const option = document.getElementById("duplicateOption").value;

  if (!fileInput.files.length) {
    if (typeof showToast === 'function') {
      showToast('Please select an Excel file first', 'warning');
    } else {
      notifyUser("Select an Excel file first.");
    }
    return;
  }

  const filename = fileInput.files[0].name;
  const toastId = typeof showToast === 'function'
    ? showToast(`Importing ${filename}...`, 'loading')
    : null;

  const formData = new FormData();
  formData.append("file", fileInput.files[0]);
  formData.append("duplicate_option", option);

  fetch("/manage_pc/import-pcs-excel", {
    method: "POST",
    body: formData
  })
  .then(res => res.json())
  .then(data => {
    if (toastId) hideToast(toastId);

    if (data.success) {
      const added = Number(data.added) || 0;
      const updated = Number(data.updated) || 0;
      const skipped = Number(data.skipped) || 0;

      if (added === 0 && updated === 0 && skipped > 0 && typeof showToast === 'function') {
        showToast(`No new PC was added. ${skipped} row(s) skipped (duplicate or missing serial data).`, 'warning');
      }

      if (typeof showImportToast === 'function') {
        showImportToast({
          type: 'PC',
          filename: filename,
          added,
          updated,
          skipped
        });
      } else if (typeof showToast === 'function') {
        showToast(`Import complete: ${added} added, ${updated} updated`, 'success');
      }
      const nav = document.getElementById("pcPaginationNav");
      const perPageSelect = document.getElementById("pcPerPageSelect");
      const pageInput = document.getElementById("pcPageInput");

      const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;
      const currentPage = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
      const targetPage = forceFirstPage ? 1 : currentPage;

      if (typeof loadPcPageAjax === "function") {
        loadPcPageAjax(targetPage, perPage, true);
      } else {
        refreshPcTableWithoutReload();
      }
    } else {
      if (typeof showToast === 'function') {
        showToast(data.error || 'Import failed', 'error');
      } else {
        notifyUser("Import failed: " + data.error);
      }
    }
  })
  .catch(err => {
    if (toastId) hideToast(toastId);
    console.error(err);
    if (typeof showToast === 'function') {
      showToast('Import failed. Please check the file and try again.', 'error');
    } else {
      notifyUser("Import failed.");
    }
  });
}

function addPcExcelToManageList() {
  importPCExcel(true);
}

window.addPcExcelToManageList = addPcExcelToManageList;

// --- MODAL PAGINATION HIDE LOGIC ---
// Fallback modal handlers: only define these if a richer implementation
// (for example from the `pceditmodal.html` partial) hasn't already
// provided them. This prevents accidentally overriding the modal logic
// which populates form fields when editing a PC.
if (typeof window.openPcModal !== 'function') {
  window.openPcModal = function (pc) {
    const modal = document.getElementById("pcModal");
    if (modal) {
      modal.classList.remove("hidden");
      document.body.classList.add("modal-open-pc");
      if (window.lucide) lucide.createIcons();
      // Basic fallback: populate a minimal field if provided
      if (pc && document.getElementById('modalPcName')) {
        try { document.getElementById('modalPcName').value = pc.pcname || ''; } catch (e) { /* ignore */ }
      }
    }
  };
}

if (typeof window.closePcModal !== 'function') {
  window.closePcModal = function () {
    const modal = document.getElementById("pcModal");
    if (modal) {
      modal.classList.add("hidden");
      document.body.classList.remove("modal-open-pc");
    }
  };
}
