/** @type import('hardhat/config').HardhatUserConfig */
require("hardhat-gas-reporter");

module.exports = {
  solidity: "0.8.0",
  gasReporter: {
    enabled: true,
    currency: "USD",  // Shows cost in USD
    gasPrice: 30,  // Gas price in Gwei (adjust as needed)
    coinmarketcap: "YOUR_API_KEY",  // Optional: Fetch live ETH price
  },
};
