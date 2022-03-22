// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KyrieEther is ERC20 {

    constructor()ERC20("ZKCoin","ZKC"){
        _mint(msg.sender, 100 * 10**uint(decimals()));
    }

}
