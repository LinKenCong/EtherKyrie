// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./TopContract.sol";

contract SpecialChoose is TopContract {
    /** 
    结构
    */
    /// @notice 结构 => 游戏记录
    /// @dev 单局游戏的记录结构(将会保存在mapping)
    struct SpecialChooseRecord {
        // 总投票玩家
        uint256 totalVoters;
        // 总投票对象
        uint256 totalSubjects;
        // 奖金池
        uint256 coinPool;
        // 赢家地址列表
        uint256[] winChose;
        // 投票对象
        uint256[] voteSubjects;
        // 赢家
        address[] winners;
        // 投票对象的玩家地址
        mapping(uint256 => address[]) voteSubjectsFrom;
        // 已投票玩家
        mapping(address => bool) voters;
    }
    /** 
    枚举
    */
    // 状态{创建，投票，结束}
    enum State {
        Initial,
        Created,
        Voting,
        Ended
    }
    /** 
    映射
    */
    mapping(uint256 => SpecialChooseRecord) internal games;
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
    function __SpecialChoose_init() internal onlyInitializing {}

    function newSCGame() public inState(State.Initial) {
        /// @notice 初始化本局游戏状态
        // 游戏状态为“创建”阶段
        state = State.Created;
    }

    /** 
    Function Add
    */
    function addSCVoter(uint256 _choseId) internal inState(State.Voting) {
        /// @notice 玩家选择投票即添加进游戏记录内
        // 获取合约储存的数据
        SpecialChooseRecord storage _newSCR = games[gamesNumber];
        require(_newSCR.voters[msg.sender] == false, "You have already voted.");
        // 将投票的玩家添加进 已投票玩家列表
        _newSCR.totalVoters++;
        _newSCR.voters[msg.sender] = true;
        // 将投票的玩家添加进 投票对象下的玩家列表
        if (_newSCR.voteSubjectsFrom[_choseId].length == 0) {
            _newSCR.totalSubjects++;
            _newSCR.voteSubjects.push(_choseId);
        }
        _newSCR.voteSubjectsFrom[_choseId].push(msg.sender);
    }

    function addSCWinner() internal inState(State.Ended) {
        /// @notice 获取赢家地址列表
        SpecialChooseRecord storage _newSCR = games[gamesNumber];

        for (uint256 i = 0; i < _newSCR.totalSubjects; i++) {
            // 遍历所有投票对象，若最小或相同则存入赢家对象数组
            if (_newSCR.winChose.length == 0) {
                // 如果没有赢家则加入
                _newSCR.winChose.push(_newSCR.voteSubjects[i]);
            } else if (
                _newSCR.voteSubjectsFrom[_newSCR.voteSubjects[i]].length <
                _newSCR.voteSubjectsFrom[_newSCR.winChose[0]].length
            ) {
                // 如果有更小的则变为最小的
                _newSCR.winChose = [_newSCR.voteSubjects[i]];
            } else if (
                _newSCR.voteSubjectsFrom[_newSCR.voteSubjects[i]].length ==
                _newSCR.voteSubjectsFrom[_newSCR.winChose[0]].length
            ) {
                // 如果有相同的则加入
                _newSCR.winChose.push(_newSCR.voteSubjects[i]);
            }
        }

        if (_newSCR.winChose.length > 0) {
            // 遍历赢家对象编号获得玩家地址并储存
            for (uint256 it = 0; it < _newSCR.winChose.length; it++) {
                for (
                    uint256 i = 0;
                    i < _newSCR.voteSubjectsFrom[_newSCR.winChose[it]].length;
                    i++
                ) {
                    _newSCR.winners.push(
                        _newSCR.voteSubjectsFrom[_newSCR.winChose[it]][i]
                    );
                }
            }
        }
    }

    /** 
    Function Set
    */
    function setSCStart() public inState(State.Created) {
        /// @notice 开始游戏
        state = State.Voting;
        // 游戏局数增加
        gamesNumber++;
    }

    function setSCEnd() public inState(State.Voting) {
        /// @notice 结束游戏
        state = State.Ended;
        addSCWinner();
    }   

    function doVote(uint256 _choseId) public inState(State.Voting) {
        /// @notice 支付游戏费用并添加玩家至游戏中
        SpecialChooseRecord storage _newSCR = games[gamesNumber];
        // 玩家支付费用
        safeTransferFrom(msg.sender, address(this), GOLD, 10000, "0x00");
        _newSCR.coinPool = SafeMathUpgradeable.add(_newSCR.coinPool, 10000);
        // 添加玩家至游戏中
        addSCVoter(_choseId);
    }

    function payWinner() public inState(State.Ended) {
        /// @notice 奖励发放给玩家并且投票状态重置
        SpecialChooseRecord storage _newSCR = games[gamesNumber];
        // 奖励发放
        for (uint256 i = 0; i < _newSCR.winners.length; i++) {
            _safeTransferFrom(
                address(this),
                _newSCR.winners[i],
                GOLD,
                SafeMathUpgradeable.div(_newSCR.coinPool, _newSCR.winners.length),
                "0x00"
            );
        }
        state = State.Initial;
    }

    /** 
    Function Get
    */
    function getSCWinChose(uint256 _gamesNumber)
        public
        view
        returns (uint256[] memory)
    {
        /// @notice 获取胜利对象
        SpecialChooseRecord storage _newSCR = games[_gamesNumber];
        return _newSCR.winChose;
    }

    function getSCWinner(uint256 _gamesNumber)
        public
        view
        returns (address[] memory)
    {
        /// @notice 获取所有胜利玩家的地址
        SpecialChooseRecord storage _newSCR = games[_gamesNumber];
        return _newSCR.winners;
    }
}
