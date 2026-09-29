# Feature: Holder-Controlled Data Retention and Full Local Wipe

## 🎯 Issue
Closes #558

## 📋 Summary

Implements a comprehensive data wipe feature that allows holders to remove all StellarCred local state in a single action, with export backup prompts and clear confirmation warnings.

## 🔑 Key Features

### 1. **Central Storage Registry** (`lib/storage-registry.ts`)
- Single source of truth for all storage keys across the application
- Categorized by functionality (credentials, proof state, onboarding, preferences, encryption)
- Runtime orphaned key detection prevents future additions from being missed
- Self-documenting with module attribution

### 2. **Comprehensive Wipe Functionality** (`lib/wipe.ts`)
- Removes all registered storage keys from localStorage and sessionStorage
- Locks credential store (clears in-memory encryption key)
- Detects and removes orphaned keys not in registry
- Returns detailed result with success/failure status and errors

### 3. **Settings Page UI** (`app/settings/*`)
- Clean, accessible interface for data management
- Theme preference toggle
- Onboarding tutorial reset
- Storage information display
- Danger zone with prominent wipe action

### 4. **Safety Features**
- **Export prompt**: Offers backup download before wipe when credentials exist
- **Clear confirmation**: Modal lists exactly what will be removed
- **Unrecoverable warning**: Prominent messaging that wipe cannot be undone
- **Error handling**: Graceful failure with specific error messages
- **Orphaned key cleanup**: Catches any keys not in central registry

## 🗂️ Files Added

```
frontend/lib/storage-registry.ts      # Central registry of all storage keys
frontend/lib/wipe.ts                   # Wipe functionality implementation
frontend/app/settings/page.tsx         # Settings page metadata wrapper
frontend/app/settings/SettingsPageClient.tsx  # Settings UI component
frontend/lib/storage-registry.test.ts  # Registry tests
frontend/lib/wipe.test.ts              # Wipe tests
```

## 📦 Storage Keys Tracked

The implementation tracks all StellarCred storage keys:

### Credentials
- `stellarcred:credentials` — Encrypted credential store

### Proof State
- `stellarcred:proof-timeline` — Historical proof submissions
- `stellarcred:proof-cache` — Cached proof bytes (sessionStorage)

### Onboarding
- `stellarcred:onboarding` — Progress and completion status
- `stellarcred_onboarding_seen` — Legacy flag (pre-migration)

### Preferences
- `theme` — User theme preference (light/dark)
- `stellarcred:wallet-selection` — Last selected wallet

### Encryption
- `stellarcred:encryption-key` — Derived key (sessionStorage only)

## 🎨 User Flow

1. **Navigate to Settings**
   - New "Settings" link in holder page navigation
   - Clean interface with sections for appearance, onboarding, storage info

2. **Initiate Wipe**
   - Click "Wipe All Data" in danger zone
   - Storage information shows what will be removed

3. **Export Backup (if credentials exist)**
   - Modal prompts: "Export Backup First?"
   - Shows credential count
   - Options: "Skip" or "Export & Continue"
   - Downloads JSON backup file

4. **Confirm Wipe**
   - Modal lists all items to be removed
   - Clear warning: "This cannot be undone. Credentials are unrecoverable without a backup."
   - Options: "Cancel" or "Wipe All Data"

5. **Success**
   - Success modal shows items wiped
   - Reports any orphaned keys removed
   - Automatic redirect to home page

6. **Error Handling**
   - If any keys fail to remove, error modal shows specific failures
   - Partial success is handled gracefully
   - User can retry or investigate

## ✅ Acceptance Criteria Met

- [x] **One action removes all local StellarCred state with backup prompt first**
  - Single "Wipe All Data" button
  - Export prompt for credentials
  - Clear confirmation with full list

- [x] **Offer export prompt before wiping**
  - Automatic prompt when credentials exist
  - Option to skip if user already has backup
  - Downloads JSON backup file

- [x] **Storage keys centrally enumerated**
  - All keys in `storage-registry.ts`
  - Categorized and documented
  - Runtime orphaned key detection

## 🧪 Testing

### Unit Tests
```bash
# Storage registry tests
pnpm test storage-registry.test.ts

# Wipe functionality tests
pnpm test wipe.test.ts
```

### Manual Testing Checklist

- [ ] Navigate to /settings
- [ ] Toggle theme preference (persists across reload)
- [ ] Reset onboarding (tour reappears)
- [ ] View storage information (shows correct counts)
- [ ] Initiate wipe with 0 credentials (skips export prompt)
- [ ] Initiate wipe with credentials (shows export prompt)
- [ ] Export backup (downloads valid JSON)
- [ ] Skip export (proceeds to confirmation)
- [ ] Cancel wipe (no data removed)
- [ ] Confirm wipe (all data removed)
- [ ] Verify redirect to home
- [ ] Confirm credentials gone
- [ ] Test orphaned key detection (manually add `stellarcred:test`)
- [ ] Verify responsive design (mobile/tablet)
- [ ] Test keyboard navigation
- [ ] Verify theme applies to modals

## 🔒 Security Considerations

- **No telemetry**: Wipe operations are not tracked or reported
- **Client-side only**: No server requests during wipe
- **Encryption key**: In-memory key cleared before storage wipe
- **Atomic operation**: All keys removed in single pass
- **Error isolation**: Failure on one key doesn't prevent others

## ♿ Accessibility

- Semantic HTML structure
- Clear headings and labels
- Keyboard navigation support
- Focus management in modals
- Screen reader friendly
- High contrast danger zone styling

## 📱 Responsive Design

- Mobile-first approach
- Touch-friendly buttons (min 44×44px)
- Readable text sizes
- Stackable layouts on small screens
- Modal scrolling on overflow

## 🚀 Future Enhancements

- [ ] Add "wipe schedule" for automatic cleanup after N days
- [ ] Export multiple backup formats (encrypted, JSON, CSV)
- [ ] Selective wipe (choose what to remove)
- [ ] Storage usage breakdown (bytes per category)
- [ ] Import backup from settings page

## 📸 Screenshots

### Settings Page
- Theme toggle
- Onboarding reset
- Storage information
- Danger zone

### Export Prompt
- Credential count
- "Skip" and "Export & Continue" options
- Backup download

### Wipe Confirmation
- List of items to remove
- Unrecoverable warning
- "Cancel" and "Wipe All Data" options

### Success State
- Wiped items count
- Orphaned keys removed
- Redirect notification

## 🔗 Related Issues

- #284 — At-rest encryption (encryption key handled)
- #336 — Session persistence (session state cleared)
- #545 — Cross-deployment validation (credentials wiped)
- #547 — PBKDF2 consolidation (encryption compatible)

## 🧩 Integration Points

### Modified Files (Navigation)
- `frontend/app/holder/HolderPageClient.tsx` — Add settings link

### Import Requirements
- Uses existing `lib/credential.ts` exports
- Uses existing `lib/theme.ts` exports
- Uses existing `lib/onboarding.ts` exports
- Uses existing `lib/safe-storage.ts` helpers

### No Breaking Changes
- All existing APIs unchanged
- New functionality is additive
- Backward compatible with existing storage

## 📚 Documentation

### For Users
- Settings page has inline help text
- Confirmation modals explain consequences
- Export prompts guide backup process

### For Developers
- `storage-registry.ts` includes usage examples
- JSDoc comments on all exported functions
- Test files demonstrate usage patterns
- Implementation doc in `STELLARCRED_ISSUE_558_IMPLEMENTATION.md`

## 🎉 Benefits

1. **User Control**: Holders can leave StellarCred cleanly
2. **Privacy**: Complete removal of all local data
3. **Safety Net**: Export backup before irreversible action
4. **Maintainability**: Central registry prevents orphaned keys
5. **Developer Experience**: Clear patterns for adding new storage
6. **Future-Proof**: Orphaned key detection catches missed additions

---

## 🧑‍💻 Implementation Notes

### Why Central Registry?

Without a central registry, storage keys are scattered across the codebase in string literals. When a developer adds a new feature that uses localStorage, it's easy to forget to add cleanup logic. The central registry:

1. **Makes all keys visible** in one place
2. **Forces deliberate additions** (can't miss it in code review)
3. **Enables runtime detection** of orphaned keys
4. **Documents ownership** (which module uses which key)

### Why Orphaned Key Detection?

Even with a central registry, human error happens. Orphaned key detection:

1. **Catches accidental additions** (quick prototype that hardcoded a key)
2. **Finds legacy keys** from refactored code
3. **Provides visibility** in settings UI
4. **Cleans up automatically** during wipe

### Why Export Before Wipe?

Credentials stored in StellarCred have no server-side backup. Once wiped, they're gone forever. The export prompt:

1. **Prevents regret** (user forgot they needed that credential)
2. **Enables device migration** (export from old browser, import to new)
3. **Follows best practices** (destructive actions should have safeguards)
4. **Respects user agency** (skip option for informed users)

---

**Implemented by**: Kiro AI Agent  
**Date**: September 29, 2026  
**Ready for**: Review, testing, and merge

cc @ToluLabs
