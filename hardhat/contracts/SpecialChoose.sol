// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**

重写 投票合约，使其可多次使用投票
！未完成

 */

contract SpecialChose {
    /** 
    结构
    */
    /// @notice 结构 => 游戏记录
    /// @dev 单局游戏的记录结构(将会保存在mapping)
    struct SpecialChoseRecord {
        // 总选择人数
        uint256 totalVoter;
        // 投票对象
        uint8[] voteSubjects;
        // 玩家是否已投票
        address[] voters;
        // 赢家
        address[] winners;
    }
    /** 
    枚举
    */
    // 状态{创建，投票，结束}
    enum State {
        Created,
        Voting,
        Ended
    }
    /** 
    映射
    */
    mapping(uint256 => SpecialChoseRecord) internal games;
    /** 
    变量
    */
    // 当前游戏局数
    uint256 public gamesNumber;
    // 当前状态
    State private state;

    /** 
    修饰器
    */
    modifier inState(State _state) {
        /// @notice 确认当前状态
        require(
            state == _state,
            "The current game state cannot perform this operation."
        );
        _;
    }

    /** 
    Function Init
    */
    /// @notice 本合约初始化
    function __SpecialChose_init() internal {
        // 游戏局数 初始为 0
        gamesNumber = 0;
    }

    function newSpecialChoseGame() public {
        /// @notice 初始化本局游戏状态
        // 游戏状态为“创建”阶段
        state = State.Created;
        // 游戏局数增加
        gamesNumber++;
        // 初始 投票对象 为一个且票数为 0
        uint8[] memory _newVoteSubjects = new uint8[](1);
        _newVoteSubjects[0] = 0;
        // 初始 玩家 为一个 默认添加 游戏创建者
        address[] memory _newVoters = new address[](1);
        _newVoters[0] = msg.sender;
        // 初始 赢家 为一个且地址为 空地址
        address[] memory _newWinners = new address[](1);
        _newWinners[0] = address(0);
        // 数据加入结构
        SpecialChoseRecord memory _newGames = SpecialChoseRecord(
            1,
            _newVoteSubjects,
            _newVoters,
            _newWinners
        );
        // 数据存入映射中
        games[gamesNumber] = _newGames;
    }

    /** 
    Function Add
    */
    function addSpecialChoseSubjects() public inState(State.Created) {}

    function addSpecialChoseVoter() public inState(State.Created) {}

    function addSpecialChoseWinner() public inState(State.Created) {}

    /** 
    Function Set
    */
    function setSpecialChoseStart() public inState(State.Created) {
        /// @notice 开始游戏
        state = State.Voting;
    }

    function setSpecialChoseEnd() public inState(State.Voting) {
        /// @notice 结束游戏
        state = State.Ended;
    }
    /** 
    Function Get
    */
}
