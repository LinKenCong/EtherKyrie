// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/utils/math/SafeMath.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract KyrieEther is ERC20 {
    uint256 public playerCount = 0;

    enum Level {
        Rookie,
        Elementary,
        Intermediate,
        Advanced,
        Master
    }

    struct Player {
        address playerAddress;
        string name;
        uint256 createdTime;
        Level playerLevel;
    }

    Player[] public playersInGame;
    mapping(address => Player) public players;

    constructor() ERC20("ZKCoin", "KC") {
        // 初始为合约创建者铸造货币
        _mint(msg.sender, 100 * 10**uint256(decimals()));
    }

    function addPlayer() private {}

    function getPlayer() public view {}

    function getPlayerLevel() private view {}

    function changePlayerLevel() private {}

    function joinGame() public {}

    function winner() private {}
}
