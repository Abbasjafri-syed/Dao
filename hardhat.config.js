require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
const dotenv = require('dotenv');

// all lib to use when deploy contract through hardhat

dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.12",
  networks: {
    // determining network url and account pvt key [should be used in .env file to protect sensitive information]
    Bsc: {
      url: process.env.BSC_TESTNET,
      accounts: [process.env.PVT_KEY]
    },
  },
  // using API key to verify and publish contract on blockchain [in .env file]
  etherscan: {
    apiKey: process.env.API_KEY,
  }
};
