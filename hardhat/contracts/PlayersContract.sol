// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./SpecialChoose.sol";
import "./TopContract.sol";

contract PlayersContract is SpecialChoose {
    uint256 public playerCount;

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
        /// @notice 初始化
        /// @dev
        __SpecialChoose_init();
    }

    function addPlayer(string memory _name) external {
        /// @notice 增加玩家
        /// @dev 只有外部可调用，只能注册自己的游戏账户
        require(msg.sender != address(0), "address is empty");
        require(bytes(_name).length != 0, "name is empty");
        // 添加角色控制
        _setupRole(PLAYER_ROLE, msg.sender);
        // 添加进玩家列表
        players[msg.sender] = Player(msg.sender, _name, Level.Rookie);
        playerCount++;
    }

    function changePlayerLevel(address _address)
        internal
        onlyOwner
        returns (Level)
    {
        /// @notice 玩家升级
        /// @dev
        Player storage _player = players[_address];
        if (_player.playerLevel == Level.Rookie) {
            _player.playerLevel = Level.Elementary;
        } else if (_player.playerLevel == Level.Elementary) {
            _player.playerLevel = Level.Intermediate;
        } else if (_player.playerLevel == Level.Intermediate) {
            _player.playerLevel = Level.Advanced;
        } else if (_player.playerLevel == Level.Advanced) {
            _player.playerLevel = Level.Master;
        }
        return _player.playerLevel;
    }

    // function joinGame() public {}

    // function winner() private {}

    function getPlayerInfo(address _address)
        public
        view
        returns (Player memory)
    {
        /// @notice 获取玩家信息
        /// @dev
        return players[_address];
    }
}
