function renderPcTable(pcs) {
  const tbody = document.getElementById("pcTableBody");
  tbody.innerHTML = "";

  pcs.forEach(pc => {
    tbody.insertAdjacentHTML("beforeend", `
      <tr class="inv-row">
        <td><input type="checkbox" class="pc-checkbox" value="${pc.pcid}"></td>
        <td>${pc.pcid}</td>
        <td>${pc.pcname}</td>
        <td>${pc.department_name}</td>
        <td>${pc.acquisition_cost}</td>
        <td>${pc.date_acquired}</td>
        <td>${pc.accountable}</td>
        <td>${pc.serial_no}</td>
        <td>${pc.municipal_serial_no}</td>
        <td>${pc.note ?? ""}</td>
        <td>
          <button class="btn-link" onclick="openPcModalById(${pc.pcid})">Edit</button>
        </td>
      </tr>
    `);
  });
}
