// Refresh Manage Item table without reload (AJAX)
window.refreshItemTableWithoutReload = function () {
  const nav = document.getElementById("itemPaginationNav");
  const perPageSelect = document.getElementById("itemPerPageSelect");
  const pageInput = document.getElementById("itemPageInput");

  const page = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
  const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

  if (typeof window.loadItemPageAjax === "function") {
    window.loadItemPageAjax(page, perPage, false);
  } else {
    location.reload();
  }
};
// Refresh items when inventory updates elsewhere (e.g., part replacement)
window.addEventListener('inventory-updated', function() {
  if (typeof window.refreshItemTableWithoutReload === 'function') {
    try { window.refreshItemTableWithoutReload(); } catch (e) { console.warn('refreshItemTableWithoutReload failed', e); }
  }
});

window.currentSection = "pc";
let inventorySearchObserver = null;
let inventoryLiveSearchTerm = "";

function getSectionKeyFromId(id) {
  if (id === "inventorySection") return "pc";
  if (id === "itemsSection") return "item";
  if (id === "consumablesSection") return "consumable";
  if (id === "surrenderedSection") return "surrendered";
  if (id === "surrenderedItemsSection") return "surrendered_item";
  return null;
}

function getSectionTargets(sectionParam) {
  if (sectionParam === "item" || sectionParam === "items") {
    return { sectionId: "itemsSection", buttonId: "itemsBtn" };
  }

  if (sectionParam === "consumable" || sectionParam === "consumables") {
    return { sectionId: "consumablesSection", buttonId: "consumablesBtn" };
  }

  if (sectionParam === "surrendered") {
    return { sectionId: "surrenderedSection", buttonId: "surrenderedBtn" };
  }

  if (
    sectionParam === "surrendered_item" ||
    sectionParam === "surrendered-items" ||
    sectionParam === "surrendereditem"
  ) {
    return { sectionId: "surrenderedItemsSection", buttonId: "surrenderedItemsBtn" };
  }

  return { sectionId: "inventorySection", buttonId: "inventoryBtn" };
}

function syncSectionQueryParam(sectionKey) {
  if (!sectionKey || !window.history || typeof window.history.replaceState !== "function") {
    return;
  }

  const url = new URL(window.location.href);
  url.searchParams.set("section", sectionKey);

  if (sectionKey !== "surrendered") {
    url.searchParams.delete("surrendered_page");
    url.searchParams.delete("surrendered_per_page");
  }

  if (sectionKey !== "surrendered_item") {
    url.searchParams.delete("surrendered_item_page");
    url.searchParams.delete("surrendered_item_per_page");
  }

  window.history.replaceState({}, "", `${url.pathname}?${url.searchParams.toString()}`);
}

function getInventorySearchControlIds(sectionKey) {
  if (sectionKey === "item") {
    return {
      inputId: "itemLiveSearchInput",
      clearBtnId: "itemLiveSearchClearBtn",
      statusId: "itemLiveSearchStatus"
    };
  }

  if (sectionKey === "consumable") {
    return {
      inputId: "consumableLiveSearchInput",
      clearBtnId: "consumableLiveSearchClearBtn",
      statusId: "consumableLiveSearchStatus"
    };
  }

  if (sectionKey === "surrendered") {
    return {
      inputId: "surrenderedPcLiveSearchInput",
      clearBtnId: "surrenderedPcLiveSearchClearBtn",
      statusId: "surrenderedPcLiveSearchStatus"
    };
  }

  if (sectionKey === "surrendered_item") {
    return {
      inputId: "surrenderedItemLiveSearchInput",
      clearBtnId: "surrenderedItemLiveSearchClearBtn",
      statusId: "surrenderedItemLiveSearchStatus"
    };
  }

  return {
    inputId: "inventoryLiveSearchInput",
    clearBtnId: "inventoryLiveSearchClearBtn",
    statusId: "inventoryLiveSearchStatus"
  };
}

function getInventorySearchControls(sectionKey) {
  const ids = getInventorySearchControlIds(sectionKey);
  return {
    input: document.getElementById(ids.inputId),
    clearBtn: document.getElementById(ids.clearBtnId),
    status: document.getElementById(ids.statusId)
  };
}

function syncInventorySearchInputs(value) {
  [
    "inventoryLiveSearchInput",
    "itemLiveSearchInput",
    "consumableLiveSearchInput",
    "surrenderedPcLiveSearchInput",
    "surrenderedItemLiveSearchInput"
  ].forEach((id) => {
    const input = document.getElementById(id);
    if (input && input.value !== value) {
      input.value = value;
    }
  });
}

function bindInventorySearchControl(inputId, clearBtnId) {
  const input = document.getElementById(inputId);
  if (input && input.dataset.bound !== "1") {
    input.dataset.bound = "1";
    input.addEventListener("input", () => {
      inventoryLiveSearchTerm = input.value;
      syncInventorySearchInputs(inventoryLiveSearchTerm);
      applyInventoryLiveSearch();
    });
  }

  const clearBtn = document.getElementById(clearBtnId);
  if (clearBtn && clearBtn.dataset.bound !== "1") {
    clearBtn.dataset.bound = "1";
    clearBtn.addEventListener("click", () => {
      inventoryLiveSearchTerm = "";
      syncInventorySearchInputs("");
      applyInventoryLiveSearch();

      const activeControls = getInventorySearchControls(window.currentSection || "pc");
      if (activeControls.input) {
        activeControls.input.focus();
      }
    });
  }
}

function getInventorySearchTargets(sectionKey) {
  if (sectionKey === "item") {
    return [
      { selector: "#deviceTableBody tr", countable: true },
      { selector: "#itemMobileCards > div", countable: false }
    ];
  }

  if (sectionKey === "consumable") {
    return [
      { selector: "#consumableTableBody tr", countable: true },
      { selector: "#consumableMobileCards > div", countable: false }
    ];
  }

  if (sectionKey === "surrendered") {
    return [
      { selector: "#surrenderedPcTableBody tr", countable: true },
      { selector: "#surrenderedPcMobileCards > div", countable: false }
    ];
  }

  if (sectionKey === "surrendered_item") {
    return [
      { selector: "#surrenderedItemTableBody tr", countable: true }
    ];
  }

  return [
    { selector: "#pcTableBody tr", countable: true },
    { selector: "#pcMobileCards > div", countable: false }
  ];
}

function getInventorySearchSectionLabel(sectionKey) {
  if (sectionKey === "item") return "Manage Item";
  if (sectionKey === "consumable") return "Manage Consumables";
  if (sectionKey === "surrendered") return "Surrendered PCs";
  if (sectionKey === "surrendered_item") return "Surrendered Item";
  return "Manage PC";
}

function updateInventoryLiveSearchContext() {
  const controls = getInventorySearchControls(window.currentSection || "pc");
  const input = controls.input;
  const status = controls.status;
  if (!input) return;

  const sectionLabel = getInventorySearchSectionLabel(window.currentSection || "pc");
  if (input.value !== inventoryLiveSearchTerm) {
    input.value = inventoryLiveSearchTerm;
  }
  input.placeholder = `Search ${sectionLabel}...`;

  if (status && !inventoryLiveSearchTerm.trim()) {
    status.textContent = `Type to auto-filter ${sectionLabel}.`;
  }
}

function applyInventoryLiveSearch() {
  const controls = getInventorySearchControls(window.currentSection || "pc");
  const input = controls.input;
  const clearBtn = controls.clearBtn;
  const status = controls.status;
  if (!input) return;

  const rawTerm = input.value.trim();
  inventoryLiveSearchTerm = rawTerm;
  syncInventorySearchInputs(rawTerm);
  const term = rawTerm.toLowerCase();
  const sectionKey = window.currentSection || "pc";
  const sectionLabel = getInventorySearchSectionLabel(sectionKey);
  // For paginated sections (PCs, Devices/Items, Consumables) perform a server-side
  // search so results include records that may be on other pages. For other
  // sections fall back to the existing in-DOM filtering logic.
  const serverSearchSections = new Set(["pc", "item", "consumable"]);

  // If there is a search term and the current section supports server search,
  // debounce and call the paged loader which will fetch filtered data from
  // the server (backend expects `search` query param for PCs; we add support
  // for items/consumables in the server as well).
  if (rawTerm && serverSearchSections.has(sectionKey)) {
    if (window.__inventorySearchDebounce) {
      clearTimeout(window.__inventorySearchDebounce);
    }

    if (status) status.textContent = `Searching ${sectionLabel} for "${rawTerm}"...`;
    if (clearBtn) clearBtn.classList.remove("hidden");

    window.__inventorySearchDebounce = setTimeout(async () => {
      try {
        const url = new URL(window.location.href);
        url.searchParams.set("search", rawTerm);

        if (sectionKey === "pc") {
          url.searchParams.set("page", "1");
          url.searchParams.set("per_page", "50");
          window.history.replaceState({}, "", `${url.pathname}?${url.searchParams.toString()}`);
          if (typeof window.loadPcPageAjax === "function") {
            await window.loadPcPageAjax(1, 50, true, "inventorySearch");
          }
        }

        if (sectionKey === "item") {
          url.searchParams.set("item_page", "1");
          url.searchParams.set("per_page", "50");
          window.history.replaceState({}, "", `${url.pathname}?${url.searchParams.toString()}`);
          if (typeof window.loadItemPageAjax === "function") {
            await window.loadItemPageAjax(1, 50, true);
          }
        }

        if (sectionKey === "consumable") {
          url.searchParams.set("consumable_page", "1");
          url.searchParams.set("per_page", "50");
          window.history.replaceState({}, "", `${url.pathname}?${url.searchParams.toString()}`);
          if (typeof window.loadConsumablePageAjax === "function") {
            await window.loadConsumablePageAjax(1, 50, true);
          }
        }
      } catch (err) {
        console.error("Inventory search error:", err);
      }
    }, 300);

    return;
  }

  // If the search input was cleared, remove the `search` query param and
  // refresh the currently visible paginated table (if available) to restore
  // the original state.
  if (!rawTerm && serverSearchSections.has(sectionKey)) {
    const url = new URL(window.location.href);
    if (url.searchParams.has("search")) {
      url.searchParams.delete("search");
      window.history.replaceState({}, "", `${url.pathname}?${url.searchParams.toString()}`);
    }

    if (sectionKey === "pc" && typeof window.refreshPcTableWithoutReload === "function") {
      window.refreshPcTableWithoutReload();
    }

    if (sectionKey === "item" && typeof window.refreshItemTableWithoutReload === "function") {
      window.refreshItemTableWithoutReload();
    }

    if (sectionKey === "consumable" && typeof window.refreshConsumableTableWithoutReload === "function") {
      window.refreshConsumableTableWithoutReload();
    }

    if (status) status.textContent = `Type to auto-filter ${sectionLabel}.`;
    if (clearBtn) clearBtn.classList.add("hidden");
    return;
  }

  // Fallback: client-side filtering for sections that don't use server search.
  const targets = getInventorySearchTargets(sectionKey);

  let totalCountableRows = 0;
  let matchedCountableRows = 0;

  targets.forEach((target) => {
    const nodes = document.querySelectorAll(target.selector);
    nodes.forEach((node) => {
      const text = String(node.textContent || "")
        .replace(/\s+/g, " ")
        .trim()
        .toLowerCase();
      const isEmptyState = text.includes("no ") && text.includes("found");
      const matches = !term || isEmptyState || text.includes(term);

      node.hidden = !matches;

      if (target.countable && !isEmptyState) {
        totalCountableRows += 1;
        if (matches) {
          matchedCountableRows += 1;
        }
      }
    });
  });

  if (clearBtn) {
    clearBtn.classList.toggle("hidden", rawTerm.length === 0);
  }

  if (!status) return;

  if (!rawTerm) {
    status.textContent = `Type to auto-filter ${sectionLabel}.`;
    return;
  }

  if (totalCountableRows > 0 && matchedCountableRows === 0) {
    status.textContent = `No matching records in ${sectionLabel}.`;
    return;
  }

  status.textContent = `Filtering ${sectionLabel} by "${rawTerm}".`;
}

function initInventoryLiveSearchObserver() {
  if (inventorySearchObserver || typeof MutationObserver === "undefined") {
    return;
  }

  const observerTargets = [
    "#pcTableBody",
    "#deviceTableBody",
    "#consumableTableBody",
    "#surrenderedPcTableBody",
    "#surrenderedItemTableBody",
    "#pcMobileCards",
    "#itemMobileCards",
    "#consumableMobileCards",
    "#surrenderedPcMobileCards"
  ]
    .map((selector) => document.querySelector(selector))
    .filter(Boolean);

  if (!observerTargets.length) return;

  inventorySearchObserver = new MutationObserver(() => {
    if (window.__inventorySearchRefreshScheduled) return;

    window.__inventorySearchRefreshScheduled = true;
    window.requestAnimationFrame(() => {
      window.__inventorySearchRefreshScheduled = false;
      applyInventoryLiveSearch();
    });
  });

  observerTargets.forEach((target) => {
    inventorySearchObserver.observe(target, { childList: true, subtree: true });
  });
}

function initInventoryLiveSearch() {
  bindInventorySearchControl("inventoryLiveSearchInput", "inventoryLiveSearchClearBtn");
  bindInventorySearchControl("itemLiveSearchInput", "itemLiveSearchClearBtn");
  bindInventorySearchControl("consumableLiveSearchInput", "consumableLiveSearchClearBtn");
  bindInventorySearchControl("surrenderedPcLiveSearchInput", "surrenderedPcLiveSearchClearBtn");
  bindInventorySearchControl("surrenderedItemLiveSearchInput", "surrenderedItemLiveSearchClearBtn");

  initInventoryLiveSearchObserver();
  updateInventoryLiveSearchContext();
  applyInventoryLiveSearch();
}

function showSection(id) {

  document.querySelectorAll("section").forEach(sec =>
    sec.classList.add("hidden")
  );

  const target = document.getElementById(id);
  if (target) target.classList.remove("hidden");

  const sectionKey = getSectionKeyFromId(id);
  if (sectionKey) {
    window.currentSection = sectionKey;
    syncSectionQueryParam(sectionKey);
    updateInventoryLiveSearchContext();
    applyInventoryLiveSearch();
  }

}

// ---------- ACTIVE NAV BUTTON ----------
function setActiveNav(button) {

  const navButtons = document.querySelectorAll("nav button");

  navButtons.forEach(btn => {
    btn.classList.remove(
      "bg-blue-50",
      "text-blue-700",
      "border-blue-300"
    );

    btn.classList.add(
      "bg-white",
      "text-gray-700",
      "border-gray-200"
    );
  });

  button.classList.remove(
    "bg-white",
    "text-gray-700",
    "border-gray-200"
  );

  button.classList.add(
    "bg-blue-50",
    "text-blue-700",
    "border-blue-300"
  );
}

// ---------- OPTIONAL AUTO LOAD ----------
document.addEventListener("DOMContentLoaded", () => {

  const params = new URLSearchParams(window.location.search);
  const section = params.get("section");

const { sectionId, buttonId } = getSectionTargets(section);

showSection(sectionId);

const btn = document.getElementById(buttonId);
if (btn) setActiveNav(btn);

  initInventoryLiveSearch();

  if (window.lucide) {
    lucide.createIcons();
  }

});

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
    modal.addEventListener("click", function (e) {
      if (e.target === modal) {
        window.closeDeleteModal();
      }
    });
  }
});

function toggleSelectAllDevices(master) {
  document.querySelectorAll(".device-checkbox")
    .forEach(cb => cb.checked = master.checked);
}

function escapeInventoryHtml(value) {
  if (value === null || value === undefined) return "";

  if (typeof window.escapeHtml === "function") {
    return window.escapeHtml(String(value));
  }

  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function createSurrenderedPageUrl(page, perPage) {
  const url = new URL(window.location.href);
  url.searchParams.set("section", "surrendered");
  url.searchParams.set("surrendered_page", String(page));
  url.searchParams.set("surrendered_per_page", String(perPage));
  return `${url.pathname}?${url.searchParams.toString()}`;
}

function createSurrenderedPagedApiUrl(page, perPage) {
  const params = new URLSearchParams();
  params.set("page", String(page));
  params.set("per_page", String(perPage));
  return `/manage_inventory/surrendered-pcs-paged?${params.toString()}`;
}

function renderSurrenderedDesktopRows(pcs) {
  const tbody = document.getElementById("surrenderedPcTableBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!pcs.length) {
    tbody.innerHTML = `
      <tr>
        <td colspan="7" class="px-4 py-6 text-center text-gray-500">No surrendered records found.</td>
      </tr>
    `;
    applyInventoryLiveSearch();
    return;
  }

  pcs.forEach((pc) => {
    tbody.insertAdjacentHTML(
      "beforeend",
      `
      <tr class="hover:bg-gray-100 transition">
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(pc.pcid)}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(pc.pcname)}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(pc.department_name || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(pc.accountable || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(pc.serial_no || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(pc.date_acquired || "--")}</td>
        <td class="px-4 py-2 border-b text-red-600 font-medium">${escapeInventoryHtml(pc.status || "Surrendered")}</td>
      </tr>
      `
    );
  });

  applyInventoryLiveSearch();
}

function renderSurrenderedMobileCards(pcs) {
  const container = document.getElementById("surrenderedPcMobileCards");
  if (!container) return;

  container.innerHTML = "";

  if (!pcs.length) {
    container.innerHTML = '<div class="bg-gray-100 text-gray-600 p-4 rounded-lg text-center">No surrendered records found.</div>';
    applyInventoryLiveSearch();
    return;
  }

  pcs.forEach((pc) => {
    container.insertAdjacentHTML(
      "beforeend",
      `
      <div class="bg-white border border-gray-200 rounded-xl p-4 shadow-sm">
        <div class="flex justify-between items-start mb-2">
          <div>
            <h4 class="font-semibold text-gray-900">${escapeInventoryHtml(pc.pcname)}</h4>
            <p class="text-sm text-gray-600">ID: ${escapeInventoryHtml(pc.pcid)}</p>
          </div>
          <span class="px-2 py-1 text-xs font-semibold rounded-full bg-red-100 text-red-600">${escapeInventoryHtml(pc.status || "Surrendered")}</span>
        </div>
        <div class="space-y-1 text-sm text-gray-600">
          <p><span class="font-medium">Office and Facility:</span> ${escapeInventoryHtml(pc.department_name || "--")}</p>
          <p><span class="font-medium">Accountable:</span> ${escapeInventoryHtml(pc.accountable || "--")}</p>
          <p><span class="font-medium">Serial:</span> ${escapeInventoryHtml(pc.serial_no || "--")}</p>
          <p><span class="font-medium">Date Acquired:</span> ${escapeInventoryHtml(pc.date_acquired || "--")}</p>
        </div>
      </div>
      `
    );
  });

  applyInventoryLiveSearch();
}

function buildSurrenderedPaginationMarkup(currentPage, totalPages) {
  let html = "";

  const navButtonClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-red-600 transition-colors";
  const disabledButtonClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed";

  if (currentPage > 1) {
    html += `<button type="button" data-surrendered-page="${currentPage - 1}" onclick="return goToSurrenderedPage(${currentPage - 1}, event)" class="${navButtonClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</button>`;
  } else {
    html += `<span class="${disabledButtonClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</span>`;
  }

  if (totalPages > 0) {
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    if (startPage > 1) {
      html += '<button type="button" data-surrendered-page="1" onclick="return goToSurrenderedPage(1, event)" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-red-600 transition-colors">1</button>';
      if (startPage > 2) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
    }

    for (let page = startPage; page <= endPage; page++) {
      if (page === currentPage) {
        html += `<span class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors z-10 bg-red-600 text-white border border-red-600">${page}</span>`;
      } else {
        html += `<button type="button" data-surrendered-page="${page}" onclick="return goToSurrenderedPage(${page}, event)" class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 hover:text-red-600">${page}</button>`;
      }
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
      html += `<button type="button" data-surrendered-page="${totalPages}" onclick="return goToSurrenderedPage(${totalPages}, event)" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-red-600 transition-colors">${totalPages}</button>`;
    }
  }

  if (currentPage < totalPages) {
    html += `<button type="button" data-surrendered-page="${currentPage + 1}" onclick="return goToSurrenderedPage(${currentPage + 1}, event)" class="${navButtonClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></button>`;
  } else {
    html += `<span class="${disabledButtonClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></span>`;
  }

  return html;
}

function updateSurrenderedPaginationSummary(page, perPage, totalItems) {
  const summary = document.getElementById("surrenderedPaginationSummary");
  if (!summary) return;

  const start = totalItems > 0 ? (page - 1) * perPage + 1 : 0;
  const end = totalItems > 0 ? Math.min(page * perPage, totalItems) : 0;

  summary.innerHTML = `Showing <span class="font-medium">${start}</span> - <span class="font-medium">${end}</span> of <span class="font-medium">${totalItems}</span> records`;
}

function updateSurrenderedPageSummary(page, totalPages, totalItems) {
  const pageSummary = document.getElementById("surrenderedPageSummary");
  if (!pageSummary) return;

  pageSummary.textContent = `Showing page ${page} of ${totalPages} (${totalItems} total surrendered)`;
}

function applySurrenderedPaginationState(page, perPage, totalItems, totalPages) {
  const nav = document.getElementById("surrenderedPaginationNav");
  const perPageSelect = document.getElementById("surrenderedPerPageSelect");
  const pageInput = document.getElementById("surrenderedPageInput");

  if (nav) {
    nav.dataset.page = String(page);
    nav.dataset.perPage = String(perPage);
    nav.dataset.totalPages = String(totalPages);
    nav.dataset.totalItems = String(totalItems);
    nav.innerHTML = buildSurrenderedPaginationMarkup(page, totalPages);
  }

  if (perPageSelect) {
    perPageSelect.value = String(perPage);
  }

  if (pageInput) {
    pageInput.value = String(page);
  }

  updateSurrenderedPaginationSummary(page, perPage, totalItems);
  updateSurrenderedPageSummary(page, totalPages, totalItems);
}

async function loadSurrenderedPageAjax(page, perPage, updateUrl = true) {
  try {
    const response = await fetch(createSurrenderedPagedApiUrl(page, perPage));
    if (!response.ok) {
      throw new Error(`Failed to load surrendered page: ${response.status}`);
    }

    const data = await response.json();
    const pcs = Array.isArray(data.pcs) ? data.pcs : [];
    const currentPage = Number(data.page) || 1;
    const currentPerPage = Number(data.per_page) || perPage;
    const totalItems = Number(data.total_items) || 0;
    const totalPages = Number(data.total_pages) || 0;

    renderSurrenderedDesktopRows(pcs);
    renderSurrenderedMobileCards(pcs);
    applySurrenderedPaginationState(currentPage, currentPerPage, totalItems, totalPages);

    if (window.lucide) {
      lucide.createIcons();
    }

    if (updateUrl) {
      window.history.replaceState({}, "", createSurrenderedPageUrl(currentPage, currentPerPage));
    }
  } catch (error) {
    console.error(error);
    if (typeof showToast === "function") {
      showToast("Failed to load surrendered page. Please try again.", "error");
    }
  }
}

window.goToSurrenderedPage = function (page, event) {
  if (event) {
    event.preventDefault();
    event.stopPropagation();
  }

  const targetPage = Number(page);
  if (!targetPage) return false;

  const nav = document.getElementById("surrenderedPaginationNav");
  const perPageSelect = document.getElementById("surrenderedPerPageSelect");
  const perPage = Number(perPageSelect && perPageSelect.value)
    || Number(nav && nav.dataset.perPage)
    || 10;

  loadSurrenderedPageAjax(targetPage, perPage, true);
  return false;
};

function initSurrenderedAjaxPagination() {
  if (window.__surrenderedPaginationInitialized) {
    return;
  }

  const nav = document.getElementById("surrenderedPaginationNav");
  const perPageSelect = document.getElementById("surrenderedPerPageSelect");
  const perPageForm = document.getElementById("surrenderedPerPageForm");
  const tableBody = document.getElementById("surrenderedPcTableBody");

  if (!nav || !perPageSelect || !perPageForm || !tableBody) {
    return;
  }

  window.__surrenderedPaginationInitialized = true;

  nav.addEventListener("click", (event) => {
    const pageButton = event.target && event.target.closest
      ? event.target.closest("[data-surrendered-page]")
      : null;

    if (!pageButton || !nav.contains(pageButton)) {
      return;
    }

    const page = Number(pageButton.getAttribute("data-surrendered-page"));
    if (!page) {
      return;
    }

    event.preventDefault();
    event.stopPropagation();
    window.goToSurrenderedPage(page, event);
  });

  perPageForm.addEventListener("submit", (event) => {
    event.preventDefault();
  });

  perPageSelect.addEventListener("change", () => {
    const perPage = Number(perPageSelect.value) || 10;
    loadSurrenderedPageAjax(1, perPage, true);
  });

  window.addEventListener("popstate", () => {
    const url = new URL(window.location.href);
    const section = url.searchParams.get("section");
    if (section !== "surrendered") return;

    const page = Number(url.searchParams.get("surrendered_page")) || 1;
    const perPage = Number(url.searchParams.get("surrendered_per_page")) || Number(perPageSelect.value) || 10;
    loadSurrenderedPageAjax(page, perPage, false);
  });
}

function createSurrenderedItemPageUrl(page, perPage) {
  const url = new URL(window.location.href);
  url.searchParams.set("section", "surrendered_item");
  url.searchParams.set("surrendered_item_page", String(page));
  url.searchParams.set("surrendered_item_per_page", String(perPage));
  return `${url.pathname}?${url.searchParams.toString()}`;
}

function createSurrenderedItemPagedApiUrl(page, perPage) {
  const params = new URLSearchParams();
  params.set("page", String(page));
  params.set("per_page", String(perPage));
  return `/manage_inventory/surrendered-items-paged?${params.toString()}`;
}

function renderSurrenderedItemRows(items) {
  const tbody = document.getElementById("surrenderedItemTableBody");
  if (!tbody) return;

  tbody.innerHTML = "";

  if (!items.length) {
    tbody.innerHTML = `
      <tr>
        <td colspan="9" class="px-4 py-6 text-center text-gray-500">No surrendered item records found.</td>
      </tr>
    `;
    applyInventoryLiveSearch();
    return;
  }

  items.forEach((item) => {
    tbody.insertAdjacentHTML(
      "beforeend",
      `
      <tr class="surrendered-item-row transition">
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.accession_id)}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.item_name || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.brand_model || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.device_type || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.department_name || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.accountable || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.serial_no || "--")}</td>
        <td class="px-4 py-2 border-b">${escapeInventoryHtml(item.date_acquired || "--")}</td>
        <td class="px-4 py-2 border-b"><span class="surrendered-item-status-pill">${escapeInventoryHtml(item.status || "Surrendered")}</span></td>
      </tr>
      `
    );
  });

  applyInventoryLiveSearch();
}

function buildSurrenderedItemPaginationMarkup(currentPage, totalPages) {
  let html = "";

  const navButtonClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-red-600 transition-colors";
  const disabledButtonClass = "flex items-center px-3 py-2 text-sm font-medium text-gray-400 bg-gray-100 border border-gray-300 rounded-lg cursor-not-allowed";

  if (currentPage > 1) {
    html += `<button type="button" data-surrendered-item-page="${currentPage - 1}" onclick="return goToSurrenderedItemPage(${currentPage - 1}, event)" class="${navButtonClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</button>`;
  } else {
    html += `<span class="${disabledButtonClass}"><svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>Prev</span>`;
  }

  if (totalPages > 0) {
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    if (startPage > 1) {
      html += '<button type="button" data-surrendered-item-page="1" onclick="return goToSurrenderedItemPage(1, event)" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-red-600 transition-colors">1</button>';
      if (startPage > 2) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
    }

    for (let page = startPage; page <= endPage; page++) {
      if (page === currentPage) {
        html += `<span class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors z-10 bg-red-600 text-white border border-red-600">${page}</span>`;
      } else {
        html += `<button type="button" data-surrendered-item-page="${page}" onclick="return goToSurrenderedItemPage(${page}, event)" class="flex items-center justify-center w-10 h-10 text-sm font-medium rounded-lg transition-colors text-gray-700 bg-white border border-gray-300 hover:bg-gray-50 hover:text-red-600">${page}</button>`;
      }
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        html += '<span class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-500">...</span>';
      }
      html += `<button type="button" data-surrendered-item-page="${totalPages}" onclick="return goToSurrenderedItemPage(${totalPages}, event)" class="hidden sm:flex items-center justify-center w-10 h-10 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 hover:text-red-600 transition-colors">${totalPages}</button>`;
    }
  }

  if (currentPage < totalPages) {
    html += `<button type="button" data-surrendered-item-page="${currentPage + 1}" onclick="return goToSurrenderedItemPage(${currentPage + 1}, event)" class="${navButtonClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></button>`;
  } else {
    html += `<span class="${disabledButtonClass}">Next<svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg></span>`;
  }

  return html;
}

function updateSurrenderedItemPaginationSummary(page, perPage, totalItems) {
  const summary = document.getElementById("surrenderedItemPaginationSummary");
  if (!summary) return;

  const start = totalItems > 0 ? (page - 1) * perPage + 1 : 0;
  const end = totalItems > 0 ? Math.min(page * perPage, totalItems) : 0;

  summary.innerHTML = `Showing <span class="font-medium">${start}</span> - <span class="font-medium">${end}</span> of <span class="font-medium">${totalItems}</span> records`;
}

function updateSurrenderedItemPageSummary(page, totalPages, totalItems) {
  const pageSummary = document.getElementById("surrenderedItemPageSummary");
  if (!pageSummary) return;

  pageSummary.textContent = `Showing page ${page} of ${totalPages} (${totalItems} total surrendered items)`;
}

function applySurrenderedItemPaginationState(page, perPage, totalItems, totalPages) {
  const nav = document.getElementById("surrenderedItemPaginationNav");
  const perPageSelect = document.getElementById("surrenderedItemPerPageSelect");
  const pageInput = document.getElementById("surrenderedItemPageInput");
  const totalChip = document.getElementById("surrenderedItemTotalChip");
  const pageChip = document.getElementById("surrenderedItemPageChip");

  if (nav) {
    nav.dataset.page = String(page);
    nav.dataset.perPage = String(perPage);
    nav.dataset.totalPages = String(totalPages);
    nav.dataset.totalItems = String(totalItems);
    nav.innerHTML = buildSurrenderedItemPaginationMarkup(page, totalPages);
  }

  if (perPageSelect) {
    perPageSelect.value = String(perPage);
  }

  if (pageInput) {
    pageInput.value = String(page);
  }

  if (totalChip) {
    totalChip.textContent = `Total ${totalItems}`;
  }

  if (pageChip) {
    pageChip.textContent = `Page ${page} / ${totalPages > 0 ? totalPages : 1}`;
  }

  updateSurrenderedItemPaginationSummary(page, perPage, totalItems);
  updateSurrenderedItemPageSummary(page, totalPages, totalItems);
}

async function loadSurrenderedItemPageAjax(page, perPage, updateUrl = true) {
  try {
    const response = await fetch(createSurrenderedItemPagedApiUrl(page, perPage));
    if (!response.ok) {
      throw new Error(`Failed to load surrendered item page: ${response.status}`);
    }

    const data = await response.json();
    const items = Array.isArray(data.items) ? data.items : [];
    const currentPage = Number(data.page) || 1;
    const currentPerPage = Number(data.per_page) || perPage;
    const totalItems = Number(data.total_items) || 0;
    const totalPages = Number(data.total_pages) || 0;

    renderSurrenderedItemRows(items);
    applySurrenderedItemPaginationState(currentPage, currentPerPage, totalItems, totalPages);

    if (window.lucide) {
      lucide.createIcons();
    }

    if (updateUrl) {
      window.history.replaceState({}, "", createSurrenderedItemPageUrl(currentPage, currentPerPage));
    }
  } catch (error) {
    console.error(error);
    if (typeof showToast === "function") {
      showToast("Failed to load surrendered item page. Please try again.", "error");
    }
  }
}

window.goToSurrenderedItemPage = function (page, event) {
  if (event) {
    event.preventDefault();
    event.stopPropagation();
  }

  const targetPage = Number(page);
  if (!targetPage) return false;

  const nav = document.getElementById("surrenderedItemPaginationNav");
  const perPageSelect = document.getElementById("surrenderedItemPerPageSelect");
  const perPage = Number(perPageSelect && perPageSelect.value)
    || Number(nav && nav.dataset.perPage)
    || 10;

  loadSurrenderedItemPageAjax(targetPage, perPage, true);
  return false;
};

function initSurrenderedItemAjaxPagination() {
  if (window.__surrenderedItemPaginationInitialized) {
    return;
  }

  const nav = document.getElementById("surrenderedItemPaginationNav");
  const perPageSelect = document.getElementById("surrenderedItemPerPageSelect");
  const perPageForm = document.getElementById("surrenderedItemPerPageForm");
  const tableBody = document.getElementById("surrenderedItemTableBody");

  if (!nav || !perPageSelect || !perPageForm || !tableBody) {
    return;
  }

  window.__surrenderedItemPaginationInitialized = true;

  nav.addEventListener("click", (event) => {
    const pageButton = event.target && event.target.closest
      ? event.target.closest("[data-surrendered-item-page]")
      : null;

    if (!pageButton || !nav.contains(pageButton)) {
      return;
    }

    const page = Number(pageButton.getAttribute("data-surrendered-item-page"));
    if (!page) {
      return;
    }

    event.preventDefault();
    event.stopPropagation();
    window.goToSurrenderedItemPage(page, event);
  });

  perPageForm.addEventListener("submit", (event) => {
    event.preventDefault();
  });

  perPageSelect.addEventListener("change", () => {
    const perPage = Number(perPageSelect.value) || 10;
    loadSurrenderedItemPageAjax(1, perPage, true);
  });

  window.addEventListener("popstate", () => {
    const url = new URL(window.location.href);
    const section = url.searchParams.get("section");
    if (section !== "surrendered_item" && section !== "surrendered-items" && section !== "surrendereditem") return;

    const page = Number(url.searchParams.get("surrendered_item_page")) || 1;
    const perPage = Number(url.searchParams.get("surrendered_item_per_page")) || Number(perPageSelect.value) || 10;
    loadSurrenderedItemPageAjax(page, perPage, false);
  });
}

function initInventoryPaginationHandlers() {
  initSurrenderedAjaxPagination();
  initSurrenderedItemAjaxPagination();
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initInventoryPaginationHandlers);
} else {
  initInventoryPaginationHandlers();
}

// --- MODAL PAGINATION HIDE LOGIC FOR ITEM MODAL ---
// ========== ARCHIVE DEVICE (ITEM) ========== //
window.archiveDevice = function (id, itemName) {
  if (typeof showConfirmationModal === 'function') {
    showConfirmationModal(
      'Archive Device',
      `Are you sure you want to archive "${itemName}"? This action cannot be undone.`,
      'Archive',
      function () {
        const toastId = showToast('Archiving device...', 'loading');
        fetch(`/manage_inventory/delete-item/${id}`, {
          method: 'POST',
          headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
          .then(res => res.json())
          .then(d => {
            hideToast(toastId);
            if (d.success) {
              showToast('Device archived successfully', 'success');
              // Refresh Manage Item table
              if (typeof window.refreshItemTableWithoutReload === 'function') {
                window.refreshItemTableWithoutReload();
              } else {
                location.reload();
              }
              // Refresh Archive (Surrendered Item) table
              if (typeof window.refreshSurrenderedItemTableWithoutReload === 'function') {
                window.refreshSurrenderedItemTableWithoutReload();
              }
            } else {
              showToast(d.error || 'Failed to archive device', 'error');
            }
          })
          .catch(() => {
            hideToast(toastId);
            showToast('Server error during archive', 'error');
          });
      }
    );
  } else {
    if (confirm('Archive this device?')) {
      fetch(`/manage_inventory/delete-item/${id}`, {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
      })
        .then(() => location.reload());
    }
  }
};

// Refresh surrendered item (archive) table without reload
window.refreshSurrenderedItemTableWithoutReload = function () {
  const nav = document.getElementById("surrenderedItemPaginationNav");
  const perPageSelect = document.getElementById("surrenderedItemPerPageSelect");
  const pageInput = document.getElementById("surrenderedItemPageInput");

  const page = Number(nav?.dataset.page) || Number(pageInput?.value) || 1;
  const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

  if (typeof loadSurrenderedItemPageAjax === "function") {
    loadSurrenderedItemPageAjax(page, perPage, false);
  }
};
function openItemModalFallback(item) {
  const modal = document.getElementById("itemModal");
  if (modal) {
    modal.classList.remove("hidden");
    document.body.classList.add("modal-open-item");
    if (window.lucide) lucide.createIcons();
    // Minimal fallback: leave detailed population to template implementation
    if (item) {
      // optional population for legacy callers
    }
  }
}

function closeItemModalFallback() {
  const modal = document.getElementById("itemModal");
  if (modal) {
    modal.classList.add("hidden");
    document.body.classList.remove("modal-open-item");
  }
}

// Only set global functions if a template-provided implementation doesn't exist
if (typeof window.openItemModal !== 'function') {
  window.openItemModal = openItemModalFallback;
}
if (typeof window.closeItemModal !== 'function') {
  window.closeItemModal = closeItemModalFallback;
}