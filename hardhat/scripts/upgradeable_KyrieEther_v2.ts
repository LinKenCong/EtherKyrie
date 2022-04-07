import { ethers, upgrades } from "hardhat";

async function main() {
  const ContractFactory_v2 = await ethers.getContractFactory("KyrieEtherV2");
  console.log('Upgrading KyrieEther...');
  await upgrades.upgradeProxy('0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0', ContractFactory_v2)
  console.log("KyrieEther Upgraded");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
