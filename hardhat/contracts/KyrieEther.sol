// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./PlayersContract.sol";

contract KyrieEther is ERC1155, PlayersContract {
    uint256 public constant GOLD = 0;

    constructor()
        ERC1155("https://api.frank.hk/api/nft/demo/1155/marvel/{id}.json")
        PlayersContract()
    {
        // 初始为合约创建者铸造货币
        _mint(msg.sender, GOLD, 100 * 10**18, "");
    }
}
