// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Voting.sol";

contract PlayersContract is Voting {
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

    constructor() Voting("ballotOfficialName", "proposal") {}

    // function addPlayer() private {}

    // function getPlayer() public view {}

    // function getPlayerLevel() private view {}

    // function changePlayerLevel() private {}

    // function joinGame() public {}

    // function winner() private {}
}
