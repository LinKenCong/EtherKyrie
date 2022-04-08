import { Web3Provider } from '@ethersproject/providers'
import { Contract, ethers, Signer } from 'ethers'

const CONTRACT_DATA = {
    ContractAddress: '0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0',
    ContractAbi: [
        "event ApprovalForAll(address indexed,address indexed,bool)",
        "event OwnershipTransferred(address indexed,address indexed)",
        "event RoleAdminChanged(bytes32 indexed,bytes32 indexed,bytes32 indexed)",
        "event RoleGranted(bytes32 indexed,address indexed,address indexed)",
        "event RoleRevoked(bytes32 indexed,address indexed,address indexed)",
        "event TransferBatch(address indexed,address indexed,address indexed,uint256[],uint256[])",
        "event TransferSingle(address indexed,address indexed,address indexed,uint256,uint256)",
        "event URI(string,uint256 indexed)",
        "function DEFAULT_ADMIN_ROLE() view returns (bytes32)",
        "function GOLD() view returns (uint256)",
        "function PLAYER_ROLE() view returns (bytes32)",
        "function addPlayer(string)",
        "function balanceOf(address,uint256) view returns (uint256)",
        "function balanceOfBatch(address[],uint256[]) view returns (uint256[])",
        "function doVote(uint256)",
        "function etherKyrieFaucet()",
        "function gamesNumber() view returns (uint256)",
        "function getPlayerInfo(address) view returns (tuple(address,string,uint8))",
        "function getRoleAdmin(bytes32) view returns (bytes32)",
        "function getSCWinChose(uint256) view returns (uint256[])",
        "function getSCWinner(uint256) view returns (address[])",
        "function grantRole(bytes32,address)",
        "function hasRole(bytes32,address) view returns (bool)",
        "function initializeContract()",
        "function isApprovedForAll(address,address) view returns (bool)",
        "function newSCGame()",
        "function onERC1155BatchReceived(address,address,uint256[],uint256[],bytes) returns (bytes4)",
        "function onERC1155Received(address,address,uint256,uint256,bytes) returns (bytes4)",
        "function owner() view returns (address)",
        "function payWinner()",
        "function playerCount() view returns (uint256)",
        "function players(address) view returns (address, string, uint8)",
        "function playersInGame(uint256) view returns (address, string, uint8)",
        "function renounceOwnership()",
        "function renounceRole(bytes32,address)",
        "function revokeRole(bytes32,address)",
        "function safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)",
        "function safeTransferFrom(address,address,uint256,uint256,bytes)",
        "function setApprovalForAll(address,bool)",
        "function setSCEnd()",
        "function setSCStart()",
        "function supportsInterface(bytes4) view returns (bool)",
        "function transferOwnership(address)",
        "function uri(uint256) view returns (string)"
    ]

}
let provider: Web3Provider
let signer: Signer
let contractWithSigner: Contract
let account: string
let balance: string

const connectETH = async () => {

    let result = {
        state: 1000,
        errmsg: '',
        data: {
            provider: provider,
            signer: signer,
            contractWithSigner: contractWithSigner,
            account: account,
            balance: balance
        }
    }

    try {
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
        result.state = 0
        result.data.provider = provider
        result.data.signer = signer
        result.data.contractWithSigner = contractWithSigner
        result.data.account = account
        result.data.balance = balance
        return result
    } catch (error: any) {
        result.errmsg = 'Connect Error.'
        if (error.message == 'User rejected the request.') {
            result.errmsg = 'MateMask rejected the request.'
        }
        console.error(result.errmsg)
        return result
    }

}
const transferGold = async (transferAccount: string, transferAmount: number) => {
    contractWithSigner || await connectETH()
    let result = {
        state: 1000,
        errmsg: '',
        data: { transactionHash: '' }
    }
    try {
        let tx = await contractWithSigner.safeTransferFrom(
            account,
            transferAccount,
            0,
            ethers.BigNumber.from(transferAmount),
            '0x00'
        )
        const res = await tx.wait(1)
        await connectETH()
        result.state = 0
        result.data.transactionHash = res.transactionHash
        return result
    } catch (error) {
        result.errmsg = 'Transfer Error.'
        console.error(result.errmsg)
        return result
    }
}
const SpecialChooseNew = async () => {
    let result = {
        state: 1000,
        errmsg: '',
        data: { transactionHash: '' }
    }
    try {
        contractWithSigner || await connectETH()
        let tx = await contractWithSigner.newSCGame()
        const res = await tx.wait(1)
        result.state = 0
        result.data.transactionHash = res.transactionHash
        return result
    } catch (error) {
        result.errmsg = 'Game New Error.'
        console.error(result.errmsg)
        return result
    }
}

const SpecialChooseStart = async () => {
    let result = {
        state: 1000,
        errmsg: '',
        data: { transactionHash: '' }
    }
    try {
        contractWithSigner || await connectETH()
        let tx = await contractWithSigner.setSCStart()
        const res = await tx.wait(1)
        result.state = 0
        result.data.transactionHash = res.transactionHash
        return result
    } catch (error: any) {
        result.errmsg = 'Game Start Error.'
        if (error.data.message.indexOf('The current game state cannot perform this operation') != -1) {
            result.errmsg = 'The current game state cannot perform this operation.'
        }
        console.error(result.errmsg)
        return result
    }
}

const SpecialChooseEnd = async () => {
    let result = {
        state: 1000,
        errmsg: '',
        data: { transactionHash: '' }
    }
    try {
        contractWithSigner || await connectETH()
        let tx1 = await contractWithSigner.setSCEnd()
        await tx1.wait(1)
        let tx2 = await contractWithSigner.payWinner()
        const res = await tx2.wait(1)
        result.state = 0
        result.data.transactionHash = res.transactionHash
        return result
    } catch (error: any) {
        result.errmsg = 'Game End Error.'
        if (error.data.message.indexOf('The current game state cannot perform this operation') != -1) {
            result.errmsg = 'The current game state cannot perform this operation.'
        }
        console.error(result.errmsg)
        return result
    }
}

const SpecialChooseDoVote = async (voteNum: number) => {
    let result = {
        state: 1000,
        errmsg: '',
        data: { transactionHash: '' }
    }
    try {
        contractWithSigner || await connectETH()
        let tx = await contractWithSigner.doVote(voteNum)
        const res = await tx.wait(1)
        result.state = 0
        result.data.transactionHash = res.transactionHash
        return result
    } catch (error) {
        result.errmsg = 'DoVote Error.'
        console.error(result.errmsg)
        return result
    }
}

const EtherKyrieFaucet = async () => {
    let result = {
        state: 1000,
        errmsg: '',
        data: { transactionHash: '' }
    }
    try {
        contractWithSigner || await connectETH()
        let tx = await contractWithSigner.etherKyrieFaucet()
        const res = await tx.wait(1)
        result.state = 0
        result.data.transactionHash = res.transactionHash
        return result
    } catch (error) {
        result.errmsg = 'Faucet Error.'
        console.error(result.errmsg)
        return result
    }
}

export { connectETH, transferGold, EtherKyrieFaucet, SpecialChooseNew, SpecialChooseStart, SpecialChooseDoVote, SpecialChooseEnd }