// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/**

重写 投票合约，使其可多次使用投票
！未完成


部分功能由前端执行。
随机生成5个

 */

contract SpecialChose {
    /** 
    结构
    */
    /// @notice 结构 => 游戏记录
    /// @dev 单局游戏的记录结构(将会保存在mapping)
    struct SpecialChoseRecord {
        // 总投票玩家
        uint256 totalVoters;
        // 总投票对象
        uint256 totalSubjects;
        // 赢家地址列表
        uint256[] winChose;
        // 投票对象
        mapping(uint256 => address[]) voteSubjects;
        // 已投票玩家
        mapping(address => bool) voters;
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
    }

    /** 
    Function Add
    */
    function addSpecialChoseVoter(uint256 _choseNum)
        public
        inState(State.Created)
    {
        /// @notice 玩家选择投票即添加进游戏记录内
        // 获取合约储存的数据
        SpecialChoseRecord storage _newSCR = games[gamesNumber];
        require(_newSCR.voters[msg.sender] == false, "");
        // 将投票的玩家添加进 已投票玩家列表
        _newSCR.totalVoters++;
        _newSCR.voters[msg.sender] = true;
        // 将投票的玩家添加进 投票对象下的玩家列表
        _newSCR.voteSubjects[_choseNum].push(msg.sender);
    }

    function addSpecialChoseWinner() internal inState(State.Ended) {
        /// @notice 获取赢家地址列表
        SpecialChoseRecord storage _newSCR = games[gamesNumber];

        for (uint256 i = 0; i < _newSCR.totalVoters; i++) {
            // 遍历所有投票对象，若最小或相同则存入赢家对象数组
            if (_newSCR.winChose.length == 0) {
                // 如果没有赢家则加入
                _newSCR.winChose.push(i);
            } else if (
                _newSCR.voteSubjects[i].length <
                _newSCR.voteSubjects[_newSCR.winChose[0]].length
            ) {
                // 如果有更小的则变为最小的
                _newSCR.winChose = [i];
            } else if (
                _newSCR.voteSubjects[i].length ==
                _newSCR.voteSubjects[_newSCR.winChose[0]].length
            ) {
                // 如果有相同的则加入
                _newSCR.winChose.push(i);
            }
        }

        if (_newSCR.winChose.length > 0) {
            // 遍历赢家对象编号获得玩家地址并储存
            for (uint256 it = 0; it < _newSCR.winChose.length; it++) {
                for (uint256 i = 0; i < _newSCR.voteSubjects[_newSCR.winChose[it]].length; i++) {
                    _newSCR.winners.push(
                        _newSCR.voteSubjects[_newSCR.winChose[it]][i]
                    );
                }
            }
        }
    }

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
        addSpecialChoseWinner();
    }

    /** 
    Function Get
    */
    function getSpecialChoseWinner(uint256 _gamesNumber)
        public
        view
        returns (address[] memory)
    {
        SpecialChoseRecord storage _newSCR = games[_gamesNumber];
        return _newSCR.winners;
    }
}
