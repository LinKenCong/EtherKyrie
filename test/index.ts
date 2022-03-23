import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Contract, ContractFactory } from "ethers";
import { ethers } from "hardhat";
import fs from "fs";

describe("Test", function () {
  let ContractFactory: ContractFactory, DevContract: Contract;
  let owner: SignerWithAddress, addr1: SignerWithAddress, addr2: SignerWithAddress, addr3: SignerWithAddress;
  const DecimalsNum = 10 ** 18;

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

  before(async function () {
    this.provider = new ethers.providers.JsonRpcProvider("http://localhost:8545");
    this.contractJson = fs.readFileSync("contract_abi/KyrieEther.json");
    this.contractAbi = JSON.parse(this.contractJson);
    this.contractAddress = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
    this.contract = new ethers.Contract(this.contractAddress, this.contractAbi, this.provider);
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    DevContract = this.contract;

    console.log("before->", {
      "provider": this.provider,
      "signer": this.provider,
      "contract": {
        "address": DevContract.address,
      }
    });
    
  })
  it("合约部署者 owner 账号余额除于 10**18 为 100", async function () {
    expect(await this.contract.balanceOf(owner.address) / DecimalsNum).to.equal(100);
    await ownerConsole();
  });

  it("被转帐者 addr1 账号余额 BigNumber 为 5000", async function () {
    const tx = await DevContract.transfer(addr1.address, 5000);
    await tx.wait(1);
    console.log(tx);
    expect(await DevContract.balanceOf(addr1.address)).to.equal(5000);
    await add1Console();
    await ownerConsole();
  });
  return;
  it("投票测试", async function () {
    const addVoterTest = await DevContract.addVoter(addr1.address, "voter1");
    await addVoterTest.wait();
    console.log("totalVoter->", await DevContract.totalVoter);
    // expect(await DevContract.totalVoter).to.equal(1);
  });

});