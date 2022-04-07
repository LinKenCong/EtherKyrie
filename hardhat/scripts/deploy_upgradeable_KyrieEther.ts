import { ethers, upgrades } from "hardhat";

async function main() {
  const ContractFactory = await ethers.getContractFactory("KyrieEther");
  console.log('Deploying KyrieEther...');
  const UpgradesContract = await upgrades.deployProxy(ContractFactory, [], { initializer: "initializeContract" });
  await UpgradesContract.deployed();

  console.log("KyrieEther Deployed To-->", UpgradesContract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
