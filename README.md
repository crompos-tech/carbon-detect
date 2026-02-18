# 🌱 Blockchain-Based Carbon Footprint Tracking (BCFT)

> A decentralized, transparent, and tamper-proof system for tracking individual carbon emissions from daily transportation using smart contracts on Ethereum.

---

## 📌 Project Overview

The **Blockchain-Based Carbon Footprint Tracking (BCFT)** system provides real-time, user-centric carbon emission monitoring for daily transportation activities using blockchain technology.

Unlike traditional carbon tracking systems focused on industrial supply chains or carbon markets, BCFT enables:

- ✅ Individual-level emission tracking  
- ✅ On-chain CO₂ calculation  
- ✅ Immutable trip storage  
- ✅ Time-based emission analytics  
- ✅ Future-ready carbon credit integration  

This project is based on our research work:  
**“Blockchain-Powered Individual Carbon Footprint Tracking: A Daily Transportation Perspective”**

---

## 🚨 Problem Statement

Most existing carbon tracking platforms are:

- Centralized  
- Non-transparent  
- Vulnerable to tampering  
- Not designed for individual users  

There is a clear gap in **real-time, decentralized, user-focused carbon emission tracking for transportation.**

BCFT addresses this gap using Ethereum smart contracts.

---

## 🏗 System Architecture

The BCFT framework consists of three core components:

### 1️⃣ Blockchain Network
- Ethereum-based smart contracts
- Immutable emission record storage
- Wallet-based authentication (MetaMask)

### 2️⃣ Smart Contracts
- On-chain CO₂ calculation
- Predefined emission factors
- Input validation using `require()`
- Event logging
- Time-based emission query functions

### 3️⃣ Frontend + IoT Layer
- Manual trip entry
- GPS/IoT integration (future scope)
- Emission dashboard
- Ether.js integration for contract interaction

---

## 🔄 System Workflow

1. User logs a trip (distance + vehicle type)
2. Smart contract validates input
3. CO₂ is calculated on-chain:

   CO₂ (grams) = (Distance in meters / 1000) × Emission Factor

4. Trip stored in `userTrips` mapping
5. Event emitted for transparency
6. User queries:
   - Daily emissions
   - Weekly emissions
   - Monthly emissions
   - Yearly emissions

---

## ⚙️ Smart Contract Features

### ✔ Emission Categories

- Personal Vehicles (Petrol, Diesel, Electric)
- Commercial Roadways (Taxi, Bus, Auto)
- Railways
- Airways

### ✔ Gas Optimization Techniques

| Technique | Gas Reduction |
|------------|---------------|
| Const Emission Factors | 15–20% |
| Pure Functions | 8–12% |
| Enum Optimization | 5–10% |
| Event-based Logging | 25–30% |
| View Queries | 100% (external calls) |

Optimized implementation reduces gas usage by ~25% compared to naive implementation.

---

## 🔐 Security Implementation

- Input validation using `require()`
- Enum-based type safety
- Solidity 0.8.x overflow protection
- No personally identifiable information stored on-chain
- Wallet-based pseudonymous identity

### Security Tools Used

- Slither
- MythX
- Echidna
- Hardhat Gas Reporter
- Mocha & Chai (Load testing)

All major vulnerability tests passed:
- Reentrancy
- Integer overflow
- Access control
- Event log consistency

---

## 📊 Performance Evaluation

### Optimized Gas Usage

| Operation | Gas Used |
|------------|----------|
| Personal Vehicle Trip | 65k–85k |
| Commercial Vehicle | 60k–80k |
| Railways/Airways | 45k–65k |
| Emission Query | 0 gas (view functions) |

### Network Metrics

- Finality Time: ~12–14 seconds
- Consensus Failure Rate: <1%
- Cross-chain consistency: 98.7%

---

## 🖥 Tech Stack

### Blockchain
- Solidity
- Ethereum
- Hardhat

### Frontend
- HTML5
- CSS3
- JavaScript
- Ether.js

### Testing & Security
- Hardhat Gas Reporter
- Slither
- MythX
- Echidna
- Mocha & Chai

---
## 🚀 How to Run Locally

### 1️⃣ Install Dependencies
```bash
npm install
```

### 2️⃣ Compile Smart Contract
```bash
npx hardhat compile
```

### 3️⃣ Start Local Blockchain
```bash
npx hardhat node
```

### 4️⃣ Deploy Contract
```bash
npx hardhat run scripts/deploy.js --network localhost
```

### 5️⃣ Open Frontend

- Open `index.html` in your browser  
- Connect MetaMask  
- Start logging trips 🚀  

---

## 🌍 Sustainability Impact

This system:

- Empowers individuals to quantify environmental impact  
- Enables transparent ESG reporting  
- Reduces carbon credit verification costs (estimated 40–60%)  
- Supports UN SDG 13 (Climate Action)  

---

## 🔮 Future Enhancements

### 🤖 AI-Driven Predictive Analytics

- Forecast emission trends  
- Suggest low-carbon routes  
- Detect anomalous emission spikes  

### 🪙 Carbon Market Integration

- Auto-mint carbon credits  
- Peer-to-peer carbon credit trading via DeFi  

### 🔐 Privacy with zk-SNARKs

- Prove emission compliance without revealing trip details  
- Maintain auditability while protecting privacy  

---

## 👨‍💻 Author

**Aneesh Kumar Yadav**  
B.Tech CSE | Full-Stack Developer | Blockchain Enthusiast  

---

## ⭐ Why This Project Stands Out

Unlike traditional carbon tracking platforms focused on enterprises or supply chains, this system provides:

- ✔ Real-time, individual-level on-chain emission tracking  
- ✔ Automated CO₂ computation inside smart contracts  
- ✔ Gas-optimized and security-audited implementation  
- ✔ Transparent, immutable emission history  
- ✔ Research-backed architecture with experimental validation  

This project bridges blockchain technology with climate accountability at the individual level.
