# 🔗 EVM Token Bridge

A **Ethereum ↔ Polygon token bridge** built with **Solidity, Foundry, and ethers.js**.  
This project demonstrates how to lock tokens on Ethereum, mint a wrapped token on Polygon, and burn + unlock during withdrawals.

---

## 📂 Project Structure
Bridge/
├── src/
│ ├── EthBridge.sol # Bridge contract on Ethereum
│ ├── PolygonBridge.sol # Bridge contract on Polygon
│ └── bCoin.sol # Wrapped token contract (ERC20)
├── abis/ # Compiled ABIs for JS relayer
├── relayer.js # Node.js relayer script
├── foundry.toml # Foundry config
└── README.md

markdown
Copy code

---

## ⚡ Flow

### Deposit (Ethereum → Polygon)
1. User calls `lock(token, amount)` on **EthBridge**.
2. Event `Locked(user, token, amount)` is emitted.
3. Relayer listens and triggers `minting(bCoin, amount)` on **PolygonBridge**.
4. User receives `bCoin` (wrapped token) on Polygon.

### Withdraw (Polygon → Ethereum)
1. User calls `burn(bCoin, amount)` on **PolygonBridge**.
2. Event `Burned(user, token, amount)` is emitted.
3. Relayer listens and triggers `unlock(token, user, amount)` on **EthBridge**.
4. User gets their original tokens back on Ethereum.

---

## 🚀 Deployment

### 1. Start a local chain
```bash
anvil
2. Deploy contracts with Foundry


forge create src/EthBridge.sol:EthBridge \
  --private-key <PRIVATE_KEY> \
  --rpc-url http://127.0.0.1:8545 --broadcast

forge create src/PolygonBridge.sol:PolygonBridge \
  --private-key <PRIVATE_KEY> \
  --rpc-url http://127.0.0.1:8545 --broadcast

forge create src/bCoin.sol:bCoin \
  --private-key <PRIVATE_KEY> \
  --rpc-url http://127.0.0.1:8545 --broadcast
Copy deployed addresses into relayer.js.

🔄 Relayer
The relayer listens for bridge events and forwards them cross-chain.

Run relayer

Copy code
node relayer.js
When a user locks tokens on Ethereum, the relayer mints bCoin on Polygon.
When a user burns bCoin on Polygon, the relayer unlocks tokens on Ethereum.

🧪 Testing with cast
Mint tokens for a user

Copy code
cast send <TOKEN_ADDR> "mint(address,uint256)" \
  <USER_ADDR> 100000000000000000000 \
  --private-key <PRIVATE_KEY> \
  --rpc-url http://127.0.0.1:8545
Approve bridge

Copy code
cast send <TOKEN_ADDR> "approve(address,uint256)" \
  <ETH_BRIDGE_ADDR> 100000000000000000000 \
  --private-key <PRIVATE_KEY> \
  --rpc-url http://127.0.0.1:8545
Lock tokens

Copy code
cast send <ETH_BRIDGE_ADDR> "lock(address,uint256)" \
  <TOKEN_ADDR> 100000000000000000000 \
  --private-key <PRIVATE_KEY> \
  --rpc-url http://127.0.0.1:8545
Relayer will detect this and mint bCoin on Polygon.

📌 Requirements
Foundry

Node.js v18+

ethers.js

dotenv

Install dependencies:

npm install
⚠️ Disclaimer
This project is for educational purposes only.
It is not audited and should not be used in production for real asset transfers.








