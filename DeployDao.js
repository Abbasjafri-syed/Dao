const hre = require("hardhat");

async function main() {
  // file name where contract is written...bracket have contract name
  const Dao = await hre.ethers.getContractFactory("DaoMaking");
  const dao = await Dao.deploy();

  await dao.deployed();

  /* checking in terminal either contract is deployed

  cmd line to deploy contract through hardhat is
  npx hardhat run scripts/filename[contract.js] --network networkname[bsc or polygon]

  after deploying verify and publish contract through API key of the Network generated in mainnet
  cmd line to verify and publish contract through hardhat is
  npx hardhat verify contract-address --network networkname[bsc or polygon]
      */
  console.log("Dao deployed to:", dao.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
