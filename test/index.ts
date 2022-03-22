import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { Contract, ContractFactory } from "ethers";
import { ethers } from "hardhat";

describe("Test", () => {
  let ContractFactory: ContractFactory, DevContract: Contract, owner: SignerWithAddress, addr1: SignerWithAddress;
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

  beforeEach(async () => {
    ContractFactory = await ethers.getContractFactory("KyrieEther");
    DevContract = await ContractFactory.deploy();
    [owner, addr1] = await ethers.getSigners();
    await DevContract.deployed();
  })

  it("合约部署者 owner 账号余额除于 10**18 为 100", async () => {
    expect(await DevContract.balanceOf(owner.address) / DecimalsNum).to.equal(100);
    await ownerConsole();
  });

  it("被转帐者 addr1 账号余额 BigNumber 为 5000", async () => {
    const transferTest = await DevContract.transfer(addr1.address, 5000);
    await transferTest.wait();
    expect(await DevContract.balanceOf(addr1.address)).to.equal(5000);
    await add1Console();
    await ownerConsole();
  });

});