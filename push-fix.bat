@echo off
cd /d c:\Users\HP\Stellar-GreenPay
git add contracts/escrow-contract/src/lib.rs
git commit -m "fix(escrow): correct invoke_contract argument syntax"
git push origin main
pause
