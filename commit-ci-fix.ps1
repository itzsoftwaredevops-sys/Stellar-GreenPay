# PowerShell script to commit and push the CI fix

Write-Host "Staging changes..." -ForegroundColor Green
git add contracts/escrow-contract/src/lib.rs

Write-Host "Committing changes..." -ForegroundColor Green
git commit -m "fix(escrow): replace contractclient macro with direct invoke_contract calls

- Remove contractclient attribute and trait definition
- Use env.invoke_contract() for cross-contract is_paused() call
- Update tests to use invoke_contract instead of generated client
- Fixes CI compilation errors

This approach is more compatible across Soroban SDK versions."

Write-Host "Pushing to origin..." -ForegroundColor Green
git push origin main

Write-Host "Done! CI should rebuild now." -ForegroundColor Green
