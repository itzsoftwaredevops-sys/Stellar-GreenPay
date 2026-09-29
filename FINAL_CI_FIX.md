# Final CI Fix - Correct invoke_contract Usage

## Changes Made

### Issue
The `invoke_contract` calls were using incorrect argument syntax that would fail compilation.

### Fixed Code

#### 1. Main pause check (`check_pause_state` function)
**Changed:**
```rust
let is_paused: bool = env.invoke_contract(
    &greenpay_addr,
    &Symbol::new(env, "is_paused"),
    Vec::new(env),  // ❌ Wrong
);
```

**To:**
```rust
let is_paused: bool = env.invoke_contract(
    &greenpay_addr,
    &Symbol::new(env, "is_paused"),
    soroban_sdk::vec![env],  // ✅ Correct
);
```

#### 2. Test initialization calls
**Changed:**
```rust
env.invoke_contract::<()>(
    &greenpay_cid,
    &Symbol::new(&env, "initialize"),
    (true,).into_val(&env),  // ❌ Wrong
);
```

**To:**
```rust
env.invoke_contract::<()>(
    &greenpay_cid,
    &Symbol::new(&env, "initialize"),
    soroban_sdk::vec![&env, true],  // ✅ Correct
);
```

## Files Modified
- `contracts/escrow-contract/src/lib.rs`

## Why This Fix Works
- `soroban_sdk::vec![]` macro creates the correct vector type for contract invocation
- This matches the Soroban SDK's expected argument format
- Works with both empty argument lists and with parameters

## Commit and Push
Run:
```bash
cd c:\Users\HP\Stellar-GreenPay
git add contracts/escrow-contract/src/lib.rs
git commit -m "fix(escrow): correct invoke_contract argument syntax"
git push origin main
```

This should resolve all remaining compilation errors in the CI.
