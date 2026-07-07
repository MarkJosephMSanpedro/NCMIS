# Toast Notification System Documentation

## Overview
A comprehensive toast notification system has been implemented for the NCMIS Inventory Management System. The system provides visual feedback for all bulk actions with loading states, success confirmations, and error handling.

---

## Files Modified

### 1. `@/templates/manage_inventory.html`
**Added Components:**
- **Toast Container** (line ~958): Fixed position container for all toast notifications
- **CSS Animations** (lines 9-65): Smooth slide-in/out transitions and progress bar animations
- **Toast Functions**:
  - `showToast()` - General purpose toast with multiple types
  - `hideToast()` - Dismiss a specific toast
  - `updateToast()` - Convert loading toast to success/error
  - `showRiskUpdateToast()` - Risk level update with statistics
  - `showMarkCheckedToast()` - Mark as checked with health/risk info
  - `showSurrenderToast()` - Surrender confirmation
  - `showExportToast()` - Export completion with filename
  - `showDamagedToast()` - Mark as damaged warning
  - `showImportToast()` - Import statistics with added/updated/skipped counts

### 2. `@/static/js/manage_pc.js`
**Updated Functions:**
- `bulkMarkPcChecked()` - Mark selected PCs as checked
- `bulkSurrenderSelectedPCs()` - Surrender selected PCs
- `exportSelectedPCs()` - Export PCs to Excel
- `bulkMarkDamagedSelectedPCs()` - Mark PCs as damaged
- `importPCExcel()` - Import PCs from Excel
- `runRiskUpdate()` - Update risk levels

### 3. `@/static/js/manage_device.js`
**Updated Functions:**
- `bulkMarkCheckedSelectedDevices()` - Mark devices as checked
- `bulkSurrenderSelectedDevices()` - Surrender devices
- `exportSelectedDevices()` - Export devices to Excel
- `bulkMarkDamagedSelectedDevices()` - Mark devices as damaged
- `confirmDeviceRiskUpdate()` - Update device risk levels

---

## Toast Types

### 1. **Success Toast** (Green)
```javascript
showToast('Operation completed successfully', 'success');
```
- **Icon**: check-circle
- **Background**: Green gradient (from-green-500 to-green-600)
- **Usage**: Successful completion of any operation

### 2. **Error Toast** (Red)
```javascript
showToast('Operation failed', 'error');
```
- **Icon**: x-circle
- **Background**: Red gradient (from-red-500 to-red-600)
- **Usage**: Failed operations, server errors

### 3. **Warning Toast** (Yellow/Orange)
```javascript
showToast('Please select at least one item', 'warning');
```
- **Icon**: alert-triangle
- **Background**: Yellow to orange gradient
- **Usage**: Validation warnings, user input required

### 4. **Info Toast** (Blue)
```javascript
showToast('Processing your request...', 'info');
```
- **Icon**: info
- **Background**: Blue gradient (from-blue-500 to-blue-600)
- **Usage**: General information messages

### 5. **Loading Toast** (Blue with Spinner)
```javascript
const toastId = showToast('Processing...', 'loading');
// ... async operation ...
hideToast(toastId);
```
- **Icon**: refresh-cw (with spin animation)
- **Background**: Blue gradient
- **Usage**: Async operations in progress
- **Note**: No auto-dismiss, must call `hideToast()` manually

---

## Specialized Toast Functions

### `showRiskUpdateToast(stats)`
**Purpose**: Display risk level update results

**Parameters:**
```javascript
{
  updated: 42,      // Total items updated
  low: 30,          // Items with Low risk
  medium: 8,        // Items with Medium risk
  high: 4,          // Items with High risk
  type: 'PC'        // 'PC' | 'Device'
}
```

**Visual Features:**
- Shield-check icon with green background
- Colored badges for risk levels (green/yellow/red)
- 6-second display duration

---

### `showMarkCheckedToast(params)`
**Purpose**: Confirm items marked as checked

**Parameters:**
```javascript
{
  count: 15,              // Number of items checked
  type: 'PC',             // 'PC' | 'Device' | 'Consumable'
  healthRestored: 100,    // Health percentage restored
  riskLevel: 'Low'        // New risk level
}
```

**Visual Features:**
- Check-square icon with green gradient
- Health badge (heart-pulse icon)
- Risk badge (shield icon)
- Date badge (calendar-check icon)
- 5-second display duration

---

### `showSurrenderToast(params)`
**Purpose**: Confirm items surrendered

**Parameters:**
```javascript
{
  count: 5,       // Number of items surrendered
  type: 'PC'      // 'PC' | 'Device'
}
```

**Visual Features:**
- Archive icon with amber/orange gradient
- Status badge showing "Surrendered"
- Archive badge showing "Moved to Archive"
- 5-second display duration

---

### `showExportToast(params)`
**Purpose**: Confirm successful export to Excel

**Parameters:**
```javascript
{
  count: 25,                          // Number of items exported
  type: 'PC',                         // 'PC' | 'Device'
  filename: 'selected_pcs.xlsx'       // Downloaded filename
}
```

**Visual Features:**
- File-spreadsheet icon with indigo/purple gradient
- Downloaded badge
- Filename badge (truncated if long)
- 5-second display duration

---

### `showDamagedToast(params)`
**Purpose**: Warn items marked as damaged

**Parameters:**
```javascript
{
  count: 3,           // Number of items damaged
  type: 'PC',         // 'PC' | 'Device'
  severity: 'High'    // Severity level
}
```

**Visual Features:**
- Alert-triangle icon with red/rose gradient (warning style)
- Status badge: "Damaged"
- Risk badge: Shows severity level
- Repair badge: "Needs Repair"
- 6-second display duration (longer for warning)

---

### `showImportToast(params)`
**Purpose**: Display Excel import statistics

**Parameters:**
```javascript
{
  type: 'PC',                       // 'PC' | 'Device'
  filename: 'import_data.xlsx',    // Imported filename
  added: 10,                        // Items added
  updated: 5,                       // Items updated
  skipped: 2                        // Items skipped
}
```

**Visual Features:**
- File-up icon with emerald/teal gradient
- Filename (truncated with tooltip)
- Added badge (green) - only shown if > 0
- Updated badge (blue) - only shown if > 0
- Skipped badge (gray) - only shown if > 0
- 6-second display duration

---

## User Flow Examples

### 1. Mark Selected as Checked
```
1. User selects 5 PCs via checkboxes
2. Clicks "Mark Selected Checked" button
3. Confirmation modal appears: "Mark 5 PC(s) as checked?"
4. User clicks "Mark Checked"
5. Loading toast: "Marking 5 PC(s) as checked..."
6. Success toast displays with health/risk badges
7. Page reloads after 2 seconds
```

### 2. Export to Excel
```
1. User selects 10 devices via checkboxes
2. Clicks "Export Selected" button
3. Loading toast: "Exporting 10 device(s)..."
4. File downloads automatically
5. Success toast displays with filename
6. No page reload (file already downloaded)
```

### 3. Import from Excel
```
1. User selects Excel file
2. Clicks "Import Excel" button
3. Loading toast: "Importing data.xlsx..."
4. Server processes file
5. Success toast displays:
   - 15 Added (green badge)
   - 5 Updated (blue badge)
   - 3 Skipped (gray badge)
6. Page reloads after 2 seconds
```

### 4. Mark as Damaged (Warning Flow)
```
1. User selects 2 PCs via checkboxes
2. Clicks "Mark as Damaged" button
3. Warning confirmation modal:
   "Are you sure? Status will be set to 'Damaged' and risk HIGH."
4. User clicks "Mark as Damaged"
5. Loading toast: "Marking 2 PC(s) as damaged..."
6. Warning toast displays (red/amber colors)
7. Page reloads after 2 seconds
```

---

## Technical Implementation

### Toast Container HTML
```html
<div id="toastContainer" class="fixed top-4 right-4 z-50 flex flex-col gap-3 pointer-events-none"></div>
```

### CSS Keyframe Animations
```css
/* Slide in animation */
.toast {
  transform: translateX(100%);
  opacity: 0;
  transition: all 0.4s cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
.toast.show {
  transform: translateX(0);
  opacity: 1;
}

/* Progress bar countdown */
@keyframes toastProgress {
  from { transform: scaleX(1); }
  to { transform: scaleX(0); }
}
```

### Fallback Strategy
All functions include fallback to native `alert()` when toast system is unavailable:
```javascript
if (typeof showToast === 'function') {
  showToast('Message', 'success');
} else {
  alert('Message');
}
```

---

## Toast Features

### Universal Features (All Toasts)
- **Slide-in animation** from right side
- **Progress bar** indicating auto-dismiss countdown
- **Close button** (X icon) for manual dismissal
- **Lucide icons** for visual enhancement
- **Auto-dismiss** after duration (except loading)
- **Click outside** to dismiss (built into hideToast)

### Duration Settings
- **Success/Info**: 5 seconds
- **Warning**: 5 seconds  
- **Error**: 5 seconds
- **Loading**: No auto-dismiss (manual hide required)
- **Specialized toasts**: 5-6 seconds

### Positioning
- **Fixed position**: Top-right corner
- **Z-index**: 50 (above modals)
- **Stacking**: Multiple toasts stack vertically with gap
- **Max-width**: 450px
- **Min-width**: 350px

---

## Testing Checklist

- [ ] Click "Update Risk Levels" → Loading toast → Success toast with stats
- [ ] Click "Mark Selected Checked" with no selection → Warning toast
- [ ] Click "Mark Selected Checked" with selection → Loading → Success toast
- [ ] Click "Surrender Selected" → Confirmation modal → Loading → Success toast
- [ ] Click "Export Selected" → Loading toast → Success toast with download
- [ ] Click "Mark as Damaged" → Warning confirmation → Loading → Warning toast
- [ ] Click "Import Excel" with file → Loading toast → Success toast with stats
- [ ] Verify all toasts auto-dismiss after correct duration
- [ ] Verify close button (X) works on all toasts
- [ ] Verify page reloads happen after toast displays

---

## Browser Compatibility
- **Chrome/Edge**: Full support
- **Firefox**: Full support
- **Safari**: Full support
- **Mobile browsers**: Responsive design, touch-friendly close buttons

## Dependencies
- **Tailwind CSS** (loaded via CDN)
- **Lucide Icons** (loaded via CDN)
- No additional JavaScript libraries required

---

## Summary

All bulk actions in the inventory system now have comprehensive toast feedback:

| Action | Toast Type | Duration | Reloads Page |
|--------|-----------|----------|--------------|
| Update Risk Levels | showRiskUpdateToast | 6s | Yes |
| Mark as Checked | showMarkCheckedToast | 5s | Yes |
| Surrender | showSurrenderToast | 5s | Yes |
| Export | showExportToast | 5s | No |
| Mark as Damaged | showDamagedToast | 6s | Yes |
| Import Excel | showImportToast | 6s | Yes |

The system provides clear visual feedback with smooth animations, making the user experience more professional and informative.
