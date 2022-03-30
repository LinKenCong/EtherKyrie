// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PlayersContract.sol";

contract KyrieEther is PlayersContract {
    uint256 public constant GOLD = 0;

    function initializeContract() public initializer {
        __TopContract_init();
        __PlayersContract_init();
        // 初始为合约创建者铸造货币
        _mint(msg.sender, GOLD, 100 * 10**18, "");
    }

    function mintGoldCoin(address to, uint256 amount) public {
        require(to != address(0), "ERC1155: mint to the zero address");

        _mint(to, GOLD, amount, "");
    }
}
