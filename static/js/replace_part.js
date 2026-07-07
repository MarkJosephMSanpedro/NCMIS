// Replace Part JS (supports multiple parts)

const RP_PARTS = ['monitor','motherboard','ram','storage','gpu','psu','casing','mouse','keyboard','other_parts'];

function getRowForPcid(pcid) {
  const checkbox = document.querySelector(`#pcTableBody input.pc-checkbox[value="${pcid}"]`);
  return checkbox ? checkbox.closest('tr') : null;
}

function getAttrFromRow(row, part) {
  if (!row) return '';
  const attr = 'data-' + part.replace(/_/g, '-');
  return row.getAttribute(attr) || '';
}

function setAttrOnRow(row, part, value) {
  if (!row) return;
  const attr = 'data-' + part.replace(/_/g, '-');
  row.setAttribute(attr, value || '');
}

function openReplacePartModal(pcid, triggerEl) {
  const modal = document.getElementById('replacePartModal');
  const content = document.getElementById('replacePartModalContent');
  const replacePcId = document.getElementById('replacePcId');
  const replacePcIdWrapper = document.getElementById('replacePcIdWrapper');
  const replacePcIdInput = document.getElementById('replacePcIdInput');

  // Show input for PC ID when no pcid provided (toolbar invocation)
  if (pcid) {
    replacePcId.value = pcid;
    if (replacePcIdWrapper) replacePcIdWrapper.classList.add('hidden');
    if (replacePcIdInput) replacePcIdInput.value = '';
  } else {
    replacePcId.value = '';
    if (replacePcIdWrapper) replacePcIdWrapper.classList.remove('hidden');
    if (replacePcIdInput) replacePcIdInput.value = '';
  }

  let row = triggerEl ? triggerEl.closest('tr') : (pcid ? getRowForPcid(pcid) : null);

  // populate current values and clear new-value inputs
  RP_PARTS.forEach(part => {
    const neu = document.getElementById(`new-${part}`);
    const val = getAttrFromRow(row, part) || '';
    if (neu) {
      neu.value = '';
      neu.placeholder = val;
    }
  });

  // --- Autocomplete / suggestions for part inputs ---
  function debounce(fn, wait) {
    let t = null;
    return function(...args) {
      if (t) clearTimeout(t);
      t = setTimeout(() => fn.apply(this, args), wait);
    };
  }

  async function getSuggestions(part, q) {
    try {
      const url = `/part-suggestions?part=${encodeURIComponent(part)}&q=${encodeURIComponent(q || '')}`;
      const res = await fetch(url);
      const data = await res.json();
      if (res.ok && data && data.success) return data.results || [];
    } catch (e) {
      console.error('Suggestion fetch error:', e);
    }
    return [];
  }

  function renderSuggestions(container, results, inputEl) {
      container.innerHTML = '';
      if (!results || results.length === 0) {
        container.style.display = 'none';
        container.setAttribute('aria-hidden', 'true');
        return;
      }
      results.forEach(r => {
        const d = document.createElement('div');
        d.className = 'rp-suggestion';
        d.tabIndex = 0;

        const labelSpan = document.createElement('span');
        labelSpan.className = 'rp-suggestion-label';
        labelSpan.textContent = r.label || (r.accession_id || '');

        const idSpan = document.createElement('small');
        idSpan.className = 'rp-suggestion-id';
        idSpan.textContent = r.accession_id ? `#${r.accession_id}` : '';

        d.appendChild(labelSpan);
        if (idSpan.textContent) d.appendChild(idSpan);

        d.dataset.value = r.label || (r.accession_id || '');
        d.dataset.acc = r.accession_id || '';
        d.addEventListener('click', () => {
          inputEl.value = d.dataset.value;
          container.style.display = 'none';
          container.setAttribute('aria-hidden', 'true');
        });
        d.addEventListener('keydown', (ev) => {
          if (ev.key === 'Enter') {
            ev.preventDefault();
            d.click();
          }
        });
        container.appendChild(d);
      });
      container.style.display = 'block';
      container.setAttribute('aria-hidden', 'false');
  }

  // Attach listeners for each part input
  RP_PARTS.forEach(part => {
    const input = document.getElementById(`new-${part}`);
    const container = document.getElementById(`sug-${part}`);
    if (!input || !container) return;

    const fetchAndShow = debounce(async () => {
      const q = (input.value || '').trim();
      const results = await getSuggestions(part, q);
      renderSuggestions(container, results, input);
    }, 220);

    input.addEventListener('input', fetchAndShow);
    input.addEventListener('focus', async () => {
      // Show suggestions even if empty (popular / recent items)
      const results = await getSuggestions(part, input.value.trim());
      renderSuggestions(container, results, input);
    });
    // Close suggestions when focus leaves the field (input or suggestions)
    const field = input.closest('.rp-field');
    if (field) {
      field.addEventListener('focusout', () => {
        // small timeout to allow suggestion click to receive focus/click
        setTimeout(() => {
          if (!field.contains(document.activeElement)) {
            container.style.display = 'none';
            container.setAttribute('aria-hidden', 'true');
          }
        }, 120);
      });
    }

    // Allow Esc to close suggestion list
    input.addEventListener('keydown', (ev) => {
      if (ev.key === 'Escape' || ev.key === 'Esc') {
        container.style.display = 'none';
        container.setAttribute('aria-hidden', 'true');
        input.blur();
      }
    });
  });

  // Hide suggestion boxes when clicking outside
  document.addEventListener('click', (e) => {
    if (!e.target.closest('.rp-field') && !e.target.classList.contains('rp-suggestion')) {
      document.querySelectorAll('.rp-suggestions').forEach(c => {
        c.style.display = 'none';
        c.setAttribute('aria-hidden', 'true');
      });
    }
  });

  function tryUpdateFromInputId() {
    if (!replacePcIdInput) return;
    const idVal = replacePcIdInput.value.trim();
    if (!idVal) return;
    const r = getRowForPcid(idVal);
    if (!r) return;
    RP_PARTS.forEach(part => {
      const neu = document.getElementById(`new-${part}`);
      if (neu) neu.placeholder = getAttrFromRow(r, part) || '';
    });
  }

  if (replacePcIdInput) replacePcIdInput.oninput = tryUpdateFromInputId;

  modal.classList.remove('hidden');
  document.body.classList.add('modal-open-pc');
  setTimeout(() => content.classList.add('scale-100'), 50);
  if (window.lucide && typeof window.lucide.createIcons === 'function') window.lucide.createIcons();
}

function closeReplacePartModal() {
  const modal = document.getElementById('replacePartModal');
  const content = document.getElementById('replacePartModalContent');
  if (content) content.classList.remove('scale-100');
  if (modal) {
    modal.classList.add('hidden');
    document.body.classList.remove('modal-open-pc');
  }
}

document.addEventListener('DOMContentLoaded', function() {
  const form = document.getElementById('replacePartForm');
  if (!form) return;

  form.addEventListener('submit', async function(e) {
    e.preventDefault();
    let pcid = (document.getElementById('replacePcId') || {}).value || '';
    const replacePcIdInput = document.getElementById('replacePcIdInput');
    if (!pcid && replacePcIdInput) pcid = replacePcIdInput.value.trim();

    if (!pcid) {
      if (typeof showPopup === 'function') showPopup('error', 'Please provide a PC ID or open the modal from a row.');
      return;
    }

    const replacements = {};
    RP_PARTS.forEach(part => {
      const newInput = document.getElementById(`new-${part}`);
      const newVal = newInput ? (newInput.value || '').trim() : '';
      if (newVal) replacements[part] = newVal;
    });

    if (Object.keys(replacements).length === 0) {
      if (typeof showPopup === 'function') showPopup('error', 'Provide at least one new part value to replace.');
      return;
    }

    try {
      const res = await fetch('/replace-pc-part', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ pcid: pcid, replacements: replacements })
      });
      const data = await res.json();
      if (res.ok && data.success) {
        if (typeof showPopup === 'function') showPopup('success', data.message || 'Parts replaced successfully.');
        const row = getRowForPcid(pcid);
        Object.keys(replacements).forEach(part => {
          const newVal = replacements[part];
          setAttrOnRow(row, part, newVal);
        });
        // Cache replacements briefly so the edit modal can show them even
        // if the table refresh replaces DOM attrs before the modal opens.
        try {
          window.__lastPcReplacements = window.__lastPcReplacements || {};
          window.__lastPcReplacements[pcid] = { replacements: replacements, ts: Date.now() };
        } catch (e) {
          /* ignore */
        }
        closeReplacePartModal();
        if (typeof window.refreshPcTableWithoutReload === 'function') window.refreshPcTableWithoutReload();
        if (typeof window.refreshItemTableWithoutReload === 'function') window.refreshItemTableWithoutReload();
        // Notify other UI components (dashboard, charts) that inventory changed
        try {
          window.dispatchEvent(new Event('inventory-updated'));
        } catch (err) {
          console.warn('Could not dispatch inventory-updated event', err);
        }
      } else {
        if (typeof showPopup === 'function') showPopup('error', data.error || 'Failed to replace part(s).');
      }
    } catch (err) {
      console.error('Replace part error:', err);
      if (typeof showPopup === 'function') showPopup('error', 'Something went wrong while replacing part(s).');
    }
  });
});
