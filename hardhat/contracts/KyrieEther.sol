// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "./PlayersContract.sol";

contract KyrieEther is ERC1155Upgradeable, PlayersContract {
    uint256 public constant GOLD = 0;

    function initializeContract() public initializer {
        __ERC1155_init("https://api.frank.hk/api/nft/demo/1155/marvel/{id}.json");
        __PlayersContract_init();
        // 初始为合约创建者铸造货币
        _mint(msg.sender, GOLD, 100 * 10**18, "");
    }

    function mintGoldCoin(address to, uint256 amount) public {
        require(to != address(0), "ERC1155: mint to the zero address");

        _mint(to, GOLD, amount, "");
    }
}
