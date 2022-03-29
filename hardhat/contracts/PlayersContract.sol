// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

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
        Level playerLevel;
    }

    Player[] public playersInGame;
    mapping(address => Player) public players;

    function __PlayersContract_init() internal onlyInitializing {
        __Voting_init("ballotOfficialName");
    }

    // function addPlayer() internal {
    //     Player memory _newPlayer = Player();
    //     players.push(_newPlayer);
    // }

    // function getPlayer() public view {}

    // function getPlayerLevel() private view {}

    // function changePlayerLevel() private {}

    // function joinGame() public {}

    // function winner() private {}
}
