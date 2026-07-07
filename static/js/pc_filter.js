// ===========================
// PC Filter Modal Management
// ===========================

// Open Modal
async function openPcFilterModal() {
  let modal = document.getElementById('pcFilterModal');

  if (!modal) {
    try {
      const res = await fetch('/manage_inventory/pc-filter-modal');
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const html = await res.text();
      document.body.insertAdjacentHTML('beforeend', html);
      modal = document.getElementById('pcFilterModal');
      lucide.createIcons();
    } catch (err) {
      console.error("❌ Error loading PC filter modal:", err);
      alert("Failed to load PC filter modal.");
      return;
    }
  }

  // Load departments once
  const deptSelect = document.querySelector('#pcFilterForm select[name="department_id"]');
  if (deptSelect && deptSelect.options.length <= 1) {
    try {
      const res = await fetch('/get-departments');
      const departments = await res.json();
      deptSelect.innerHTML = '<option value="">All</option>';
      departments.forEach(dep => {
        const opt = document.createElement('option');
        opt.value = dep.department_id;
        opt.textContent = dep.department_name;
        deptSelect.appendChild(opt);
      });
    } catch {
      deptSelect.innerHTML = '<option value="">Error loading</option>';
    }
  }

  modal.classList.remove('hidden');
}

// Close Modal
function closePcFilterModal() {
  const modal = document.getElementById('pcFilterModal');
  if (modal) modal.classList.add('hidden');
}

// Filter Form Submission
document.addEventListener("submit", async (e) => {
  if (e.target.id === "pcFilterForm") {
    e.preventDefault();
    const form = e.target;
    const formData = new FormData(form);
    const url = new URL(window.location.href);
    const nextParams = new URLSearchParams();

    for (const [key, value] of formData.entries()) {
      if (value !== null && String(value).trim() !== "") {
        nextParams.append(key, String(value).trim());
      }
    }

    const perPageSelect = document.getElementById("pcPerPageSelect");
    const nav = document.getElementById("pcPaginationNav");
    const perPage = Number(perPageSelect?.value) || Number(nav?.dataset.perPage) || 10;

    nextParams.set("section", "pc");
    nextParams.set("page", "1");
    nextParams.set("per_page", String(perPage));

    window.history.replaceState({}, "", `${url.pathname}?${nextParams.toString()}`);

    if (typeof loadPcPageAjax === "function") {
      await loadPcPageAjax(1, perPage, true, "pcFilterSearch");
      closePcFilterModal();
      return;
    }

    window.location.href = `${url.pathname}?${nextParams.toString()}`;
  }
});

// Render PCs into table
function renderPcTable(pcs) {
  const tbody = document.getElementById("pcTableBody");
  if (!tbody) return;
  tbody.innerHTML = "";

    if (!pcs.length) {
    tbody.innerHTML = `
      <tr>
        <td colspan="12" class="text-center py-6 text-gray-500">No PCs found.</td>
      </tr>`;
    return;
  }

  pcs.forEach(pc => {
    const riskClass =
      pc.risk_level === "High" ? "text-red-600" :
      pc.risk_level === "Medium" ? "text-yellow-600" :
      "text-green-600";

    const statusValue = String(pc.status || "").toLowerCase();
    const statusClass =
      statusValue === "damaged" ? "text-red-600" :
      statusValue === "critical" ? "text-red-700 font-bold" :
      statusValue === "needs checking" ? "text-yellow-600" :
      (['in used','in use','in-used','inuse'].includes(statusValue) ? 'text-blue-600' :
      statusValue === "inactive" ? "text-gray-500" :
      "text-green-600");

    tbody.insertAdjacentHTML("beforeend", `
      <tr class="hover:bg-gray-100 transition">
      <th class="px-4 py-2 border-b text-left">
  <input type="checkbox" id="selectAllPcs" onclick="toggleSelectAllPCs()">
</th>
        <td class="px-4 py-2 border-b">${pc.pcid ?? "—"}</td>
        <td class="px-4 py-2 border-b">${pc.pcname ?? "—"}</td>
        <td class="px-4 py-2 border-b">${pc.department_name ?? "—"}</td>
        <td class="px-4 py-2 border-b">${pc.acquisition_cost ?? "—"}</td>
        <td class="px-4 py-2 border-b">${pc.date_acquired ?? "—"}</td>
        <td class="px-4 py-2 border-b">${pc.accountable ?? "—"}</td>
        <td class="px-4 py-2 border-b">${pc.serial_no ?? "—"}</td>
        <td class="px-4 py-2 border-b">${pc.municipal_serial_no ?? "—"}</td>

        <td class="px-4 py-2 border-b ${statusClass}">${pc.status ?? "—"}</td> 

        <td class="px-4 py-2 border-b flex gap-2">
          

         
                    <button onclick="openPcModalById(${pc.pcid})" class="bg-blue-500 hover:bg-blue-600 text-white px-3 py-2 rounded text-xs font-medium transition">Edit</button>
                    
<button onclick="openDeleteModal('/delete-pc/${pc.pcid}')"
class="bg-red-600 hover:bg-red-700 text-white px-3 py-2 rounded text-xs font-medium transition">
Delete
</button>

                    <button onclick="markPcChecked(${ pc.pcid })" class="bg-green-600 hover:bg-green-700 text-white px-3 py-2 rounded text-xs font-medium transition">Mark Checked</button>
                     
                    <button onclick="openMaintenanceLog(${ pc.pcid }, 'PC')" class="bg-gray-600 hover:bg-gray-700 text-white px-3 py-2 rounded text-xs font-medium transition">History</button>
                   
                   
          
        </td>
      </tr>
    `);
  });
}

// Open PC modal safely from button
function openPcModalFromBtn(btn) {
  const pc = JSON.parse(decodeURIComponent(btn.dataset.pc));
  openPcModal(pc);
}
