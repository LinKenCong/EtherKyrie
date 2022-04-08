import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber, Contract } from "ethers";
import { ethers } from "hardhat";
import fs from "fs";

// 参数
const DEV_DATA = {
  "deploy_net": "http://localhost:8545",
  "abi_path": "contract_abi/KyrieEther.json",
  "contract_address": "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
  "private_key_0": "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
  "private_key_1": "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d",
}

// 公共变量
let DevContract: Contract;
let owner: SignerWithAddress, addr1: SignerWithAddress, addr2: SignerWithAddress, addr3: SignerWithAddress;
const DecimalsNum = 10 ** 18;
const GOLD = 0

// 复用函数
const resGoldBalance = async (addr: SignerWithAddress) => {
  return BigNumber.from(await DevContract.balanceOf(addr.address, GOLD)).toString()
}

describe("KyrieEther Init TEST \t | Path: test/index.ts ", function () {

  // 初始执行
  before(async function () {
    this.provider = new ethers.providers.JsonRpcProvider(DEV_DATA.deploy_net);
    this.contractJson = fs.readFileSync(DEV_DATA.abi_path);
    this.contractAbi = JSON.parse(this.contractJson);
    this.contractAddress = DEV_DATA.contract_address;
    this.wallet = new ethers.Wallet(DEV_DATA.private_key_0, this.provider);
    this.contract = new ethers.Contract(this.contractAddress, this.contractAbi, this.wallet);
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    DevContract = this.contract;

    console.log("Before->", {
      "Provider": this.provider,
      "Contract Address": DevContract.address,
    });

  })

  // 测试
  it("Init Test \t | Owner init Gold: 100000000000000000000(100*10**18)", async function () {
    console.log('Gold Balance \t => Owner \t ->', await resGoldBalance(owner))
    expect(Number(await resGoldBalance(owner))).to.equal(100 * DecimalsNum);
  });

  it("Transfer Test \t | Owner transfer 10000 Gold to add1 => add1 Gold: 10000", async function () {
    const tx = await DevContract.safeTransferFrom(owner.address, addr1.address, GOLD, 10000, "0x00");
    await tx.wait(1);
    console.log('Gold Balance \t => Owner \t ->', await resGoldBalance(owner))
    console.log('Gold Balance \t => Add1 \t ->', await resGoldBalance(addr1))
    expect(Number(await resGoldBalance(addr1))).to.equal(10000);
  });

  it("Transfer Test \t | add1 transfer 5000 Gold to add2 => add2 Gold: 5000", async function () {
    const wallet = new ethers.Wallet(DEV_DATA.private_key_1, this.provider);
    const contract = new ethers.Contract(this.contractAddress, this.contractAbi, wallet);
    const tx = await contract.safeTransferFrom(addr1.address, addr2.address, GOLD, 5000, "0x00");
    await tx.wait(1);
    console.log('Gold Balance \t => Add1 \t ->', await resGoldBalance(addr1))
    console.log('Gold Balance \t => Add2 \t ->', await resGoldBalance(addr2))
    expect(Number(await resGoldBalance(addr2))).to.equal(5000);
  });

});