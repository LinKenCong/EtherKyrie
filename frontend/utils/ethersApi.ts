import { Provider } from '@ethersproject/abstract-provider'
import { Web3Provider } from '@ethersproject/providers'
import { BigNumber, Contract, ethers, Signer } from 'ethers'

const CONTRACT_DATA = {
    ContractAddress: '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    ContractAbi: [
        'event ApprovalForAll(address indexed,address indexed,bool)',
        'event OwnershipTransferred(address indexed,address indexed)',
        'event TransferBatch(address indexed,address indexed,address indexed,uint256[],uint256[])',
        'event TransferSingle(address indexed,address indexed,address indexed,uint256,uint256)',
        'event URI(string,uint256 indexed)',
        'function GOLD() view returns (uint256)',
        'function addPlayer(string)',
        'function balanceOf(address,uint256) view returns (uint256)',
        'function balanceOfBatch(address[],uint256[]) view returns (uint256[])',
        'function doVote(uint256)',
        'function etherKyrieFaucet()',
        'function gamesNumber() view returns (uint256)',
        'function getPlayerInfo(address) view returns (tuple(address,string,uint8))',
        'function getSCWinChose(uint256) view returns (uint256[])',
        'function getSCWinner(uint256) view returns (address[])',
        'function initializeContract()',
        'function isApprovedForAll(address,address) view returns (bool)',
        'function newSCGame()',
        'function onERC1155BatchReceived(address,address,uint256[],uint256[],bytes) returns (bytes4)',
        'function onERC1155Received(address,address,uint256,uint256,bytes) returns (bytes4)',
        'function owner() view returns (address)',
        'function payWinner()',
        'function playerCount() view returns (uint256)',
        'function players(address) view returns (address, string, uint8)',
        'function playersInGame(uint256) view returns (address, string, uint8)',
        'function renounceOwnership()',
        'function safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)',
        'function safeTransferFrom(address,address,uint256,uint256,bytes)',
        'function setApprovalForAll(address,bool)',
        'function setSCEnd()',
        'function setSCStart()',
        'function supportsInterface(bytes4) view returns (bool)',
        'function transferOwnership(address)',
        'function uri(uint256) view returns (string)',
    ]
}
let provider: Web3Provider
let signer: Signer
let contractWithSigner: Contract
let account: string
let balance: string

const connectETH = async () => {
    provider = new ethers.providers.Web3Provider(
        window.ethereum,
        'any'
    )
    await provider.send('eth_requestAccounts', [])
    signer = provider.getSigner()
    account = await signer.getAddress()
    contractWithSigner = new ethers.Contract(CONTRACT_DATA.ContractAddress, CONTRACT_DATA.ContractAbi, signer)
    balance = await contractWithSigner
        .balanceOf(account, 0)
        .then((rel: Promise<string>) => rel.toString())
    return {
        provider: provider,
        signer: signer,
        contractWithSigner: contractWithSigner,
        account: account,
        balance: balance
    }
}
const transferGold = async (transferAccount: string, transferAmount: number) => {
    contractWithSigner || await connectETH()
    let tx = await contractWithSigner.safeTransferFrom(
        account,
        transferAccount,
        0,
        ethers.BigNumber.from(transferAmount),
        '0x00'
    )
    const res = await tx.wait(1)
    await connectETH()
    return { transactionHash: res.transactionHash }
}
const SpecialChooseNew = async () => {
    contractWithSigner || await connectETH()
    let tx = await contractWithSigner.newSCGame()
    const res = await tx.wait(1)
    return { req: res.transactionHash }
}

const SpecialChooseStart = async () => {
    contractWithSigner || await connectETH()
    let tx = await contractWithSigner.setSCStart()
    const res = await tx.wait(1)
    return { req: res.transactionHash }
}

const SpecialChooseEnd = async () => {
    contractWithSigner || await connectETH()
    let tx1 = await contractWithSigner.setSCEnd()
    await tx1.wait(1)
    let tx2 = await contractWithSigner.payWinner()
    const res = await tx2.wait(1)
    return { req: res.transactionHash }
}

const SpecialChooseDoVote = async (voteNum: number) => {
    contractWithSigner || await connectETH()
    let tx = await contractWithSigner.doVote(voteNum)
    const res = await tx.wait(1)
    return { req: res.transactionHash }
}

export { connectETH, transferGold, SpecialChooseNew, SpecialChooseStart, SpecialChooseDoVote, SpecialChooseEnd }