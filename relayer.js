const { ethers } = require("ethers");
const dotenv = require("dotenv");
const EthBridgeABI = require("./abis/EthBridge.json");
const PolygonBridgeABI = require("./abis/PolygonBridge.json");

dotenv.config();

// ENV
const ETH_RPC = "http://127.0.0.1:8545";
const POLY_RPC = "http://127.0.0.1:8545";
const PK = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";

// Contract addresses (after you deploy)
const ETH_BRIDGE_ADDR = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";      // EthBridge
const POLYGON_BRIDGE_ADDR = "0x5FbDB2315678afecb367f032d93F642f64180aa3";  // PolygonBridge
const BCOIN_ADDR = "0x700b6A60ce7EaaEA56F065753d8dcB9653dbAD35";           // bCoin
const COIN_ADDR="0x0116686E2291dbd5e317F47faDBFb43B599786Ef";

// Providers
const ethProvider = new ethers.JsonRpcProvider(ETH_RPC);
const polygonProvider = new ethers.JsonRpcProvider(POLY_RPC);

// Wallets
const walletEth = new ethers.Wallet(PK, ethProvider);
const walletPoly = new ethers.Wallet(PK, polygonProvider);

// Contracts
const ethBridge = new ethers.Contract(ETH_BRIDGE_ADDR, EthBridgeABI.abi, walletEth);
const polygonBridge = new ethers.Contract(POLYGON_BRIDGE_ADDR, PolygonBridgeABI.abi, walletPoly);

// Event listener
ethBridge.on("Locked", async (user, token, amount) => {
  console.log(`🔒 Locked event detected:
    user:   ${user}
    token:  ${token}
    amount: ${ethers.formatUnits(amount, 18)}
  `);

  try {
    // Relay: call PolygonBridge.minting
    const tx = await polygonBridge.minting(BCOIN_ADDR, amount);
    console.log("✅ Mint tx sent:", tx.hash);
    await tx.wait();
    console.log("✅ Mint confirmed on Polygon");
  } catch (err) {
    console.error("❌ Minting failed:", err);
  }
});

polygonBridge.on("Burned", async (user, token, amount, event) => {
  console.log(`🔥 Burn detected on Polygon: ${user} burned ${amount}`);
  const tx = await ethBridge.unlock(COIN_ADDR, user, amount);
  console.log("✅ Unlock tx:", tx.hash);
  await tx.wait();
});
