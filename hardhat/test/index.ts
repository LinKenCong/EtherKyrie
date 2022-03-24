import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Contract } from "ethers";
import { ethers } from "hardhat";
import fs from "fs";

describe("测试脚本 test/index.ts ", function () {
  // 参数
  const DEV_DATA = {
    "deploy_net": "http://localhost:8545",
    "abi_path": "contract_abi/KyrieEther.json",
    "contract_address": "0x5FbDB2315678afecb367f032d93F642f64180aa3",
    "private_key_0": "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
    "private_key_1": "0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d",
  }

  // 公共变量
  let DevContract: Contract;
  let owner: SignerWithAddress, addr1: SignerWithAddress, addr2: SignerWithAddress, addr3: SignerWithAddress;
  const DecimalsNum = 10 ** 18;

  // 复用函数
  const ownerConsole = async () => {
    console.log("owner ->", {
      "address": owner.address,
      "BigNumber": await DevContract.balanceOf(owner.address),
      "Balance": ethers.utils.formatUnits(await DevContract.balanceOf(owner.address), await DevContract.decimals()),
    });
  }

  const add1Console = async () => {
    console.log("addr1 ->", {
      "address": addr1.address,
      "BigNumber": await DevContract.balanceOf(addr1.address),
      "Balance": ethers.utils.formatUnits(await DevContract.balanceOf(addr1.address), await DevContract.decimals()),
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
    expect(await this.contract.balanceOf(owner.address) / DecimalsNum).to.equal(100);
    await ownerConsole();
  });

  it("被转帐者 addr1 账号余额 BigNumber 为 10000", async function () {
    const tx = await DevContract.transfer(addr1.address, 10000);
    await tx.wait(1);
    // console.log("tx->", tx);
    expect(await DevContract.balanceOf(addr1.address)).to.equal(10000);
    await add1Console();
    await ownerConsole();
  });

  it("add1 转账 add2 5000", async function () {
    const wallet = new ethers.Wallet(DEV_DATA.private_key_1, this.provider);
    const contract = new ethers.Contract(this.contractAddress, this.contractAbi, wallet);
    const tx = await contract.transfer(addr2.address, 5000);
    await tx.wait(1);
    // console.log("tx->", tx);
    expect(await contract.balanceOf(addr2.address)).to.equal(5000);
    await add1Console();
    console.log("add2 balance->", ethers.utils.formatUnits(await contract.balanceOf(addr2.address), await contract.decimals()))
  });

  it("投票人数为1", async function () {
    const tx = await DevContract.addVoter(addr1.address, "voter1");
    await tx.wait(1);
    // console.log("tx->", tx);
    console.log("getTotalVoter->", await DevContract.getTotalVoter());
    expect(await DevContract.getTotalVoter()).to.equal(1);
  });

});