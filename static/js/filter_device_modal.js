window.currentSection = "item"; // global state to track current section (pc, item, consumable, surrendered)

async function openDeviceFilterModalFromFile() {

  if (!document.getElementById("filterDeviceModal")) {
    try {
      const res = await fetch("/device-filter-modal");
      if (!res.ok) throw new Error(`Failed to load modal: ${res.status}`);

      const html = await res.text();
      document.body.insertAdjacentHTML("beforeend", html);

      if (window.lucide) lucide.createIcons();

    } catch (err) {
      console.error("❌ Error loading Device Filter Modal:", err);
      alert("Failed to load Device Filter Modal.");
      return;
    }
  }

  const modal = document.getElementById("filterDeviceModal");
  const content = document.getElementById("deviceFilterModalContent");

  modal.classList.remove("hidden");

  if (content) {
    content.classList.remove("scale-100");
    content.classList.add("scale-95");
  }

  setTimeout(() => {
    if (!content) return;
    content.classList.remove("scale-95");
    content.classList.add("scale-100");
  }, 50);

  // Auto set device type depending on section
  const dtInput = modal.querySelector('input[name="device_type"]');

  if (window.currentSection === "consumable") {
    if (dtInput) dtInput.value = "Consumable";
  } else {
    if (dtInput) dtInput.value = "";
  }

  if (window.lucide) lucide.createIcons();
}

function closeDeviceFilterModal() {
  const modal = document.getElementById("filterDeviceModal");
  const content = document.getElementById("deviceFilterModalContent");

  if (!modal) return;

  if (content) {
    content.classList.remove("scale-100");
    content.classList.add("scale-95");
    setTimeout(() => {
      modal.classList.add("hidden");
    }, 130);
    return;
  }

  modal.classList.add("hidden");
}


// =============================
// FILTER SUBMIT
// =============================
document.addEventListener("submit", async (e) => {

  if (e.target.id !== "filterDeviceForm") return;

  e.preventDefault();

  const params = new URLSearchParams(new FormData(e.target));

  let sectionParam = "pc";

  if (window.currentSection === "item") {
    sectionParam = "items";
  }
  else if (window.currentSection === "consumable") {
    sectionParam = "consumables";
    params.set("device_type", "Consumable");
  }

  params.set("section", sectionParam);
  params.set("ui_section", window.currentSection);

  window.location.href = `/manage_inventory?${params.toString()}`;

});
 