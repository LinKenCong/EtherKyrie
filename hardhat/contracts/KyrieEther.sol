// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./PlayersContract.sol";
import "./TopContract.sol";

contract KyrieEther is PlayersContract {
    function initializeContract() public initializer {
        __TopContract_init();
        __PlayersContract_init();
        // 初始为合约创建者铸造货币
        _safeMint(msg.sender, 100 * 10**18, "Gold");
    }

    // 为用户提供铸造NFT功能
    function mintNFT(address to, string memory name) external payable {
        require(msg.value == 0.01 ether, "Need Pay Mint NFT Fee 0.01 Ether.");
        _safeMint(to, 1, name);
    }
}
