import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber, Contract } from "ethers";
import { ethers } from "hardhat";
import fs from "fs";

describe("测试脚本 test/index.ts ", function () {
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

  // 复用函数
  const accountConsole = async () => {
    console.log("account data ->", {
      "owner->BigNumber": BigNumber.from(await DevContract.balanceOf(owner.address, 0)).toString(),
      "addr1->BigNumber": BigNumber.from(await DevContract.balanceOf(addr1.address, 0)).toString(),
      "addr2->BigNumber": BigNumber.from(await DevContract.balanceOf(addr2.address, 0)).toString(),
    });
  }

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

    console.log("before->", {
      "provider": this.provider,
      "contract": {
        "address": DevContract.address,
      }
    });

  })

  // 测试
  it("合约部署者 owner 账号余额除于 10**18 为 100", async function () {
    // expect(BigNumber.from(await this.contract.balanceOf(owner.address, 0)).toString()).to.equal(100 * 10 ** 18);
    const tx = await DevContract.mintGoldCoin(addr1.address, 10000);
    await tx.wait(1);
    await accountConsole();
  });

  it("被转帐者 addr1 账号余额 BigNumber 为 10000", async function () {
    const tx = await DevContract.safeTransferFrom(owner.address, addr1.address, 0, 10000, "0x00");
    await tx.wait(1);
    // console.log("tx->", tx);
    await accountConsole();
    // expect(BigNumber.from(await DevContract.balanceOf(addr1.address, 0)).toNumber()).to.equal(20000);
  });

  it("add1 转账 add2 5000", async function () {
    const wallet = new ethers.Wallet(DEV_DATA.private_key_1, this.provider);
    const contract = new ethers.Contract(this.contractAddress, this.contractAbi, wallet);
    const tx = await contract.safeTransferFrom(addr1.address, addr2.address, 0, 5000, "0x00");
    await tx.wait(1);
    // console.log("tx->", tx);
    await accountConsole();
    expect(BigNumber.from(await contract.balanceOf(addr2.address, 0)).toNumber()).to.equal(5000);
  });

  it("Upgrade Test", async function () {
    // expect(BigNumber.from(await this.contract.balanceOf(owner.address, 0)).toString()).to.equal(100 * 10 ** 18);
    const tx = await DevContract.getTest2();
    console.log(tx)
  });

});