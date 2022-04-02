// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PlayersContract.sol";
import "./TopContract.sol";

contract KyrieEther is PlayersContract {
    function initializeContract() public initializer {
        __TopContract_init();
        __PlayersContract_init();
        // 初始为合约创建者铸造货币
        _mint(msg.sender, GOLD, 100 * 10**18, "");
    }
}
