const { ethers } = require("hardhat");
require("dotenv").config();

const { ProxyAddress } = process.env;

async function main() {
  const LCF = await ethers.getContractFactory("LockCloneFactory");

  console.log("Deploying LCF...");
  const lcf = await LCF.deploy(ProxyAddress);

  await lcf.deployed();
  console.log("SellerCloneFactory Contract deployed to: ", lcf.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
