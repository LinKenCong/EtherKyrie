// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // VARIABLES 变量声明
    // 结构 投票
    struct Vote {
        // 投票人 地址
        address voterAddress;
        // 投票人 选择
        bool choice;
    }
    // 结构 投票人
    struct Voter {
        // 投票人 名称
        string voterName;
        // 投票人 选票（是否已投票）
        bool voted;
    }
    // 计算选票数量
    uint256 private countResult = 0;
    // 最终投票数量
    uint256 public finalResult = 0;
    // 总投票人数
    uint256 public totalVoter = 0;
    // 总票数
    uint256 public totalVote = 0;
    // 投票的官方地址
    address public ballotOfficialAddress;
    // 投票的官方名称
    string public ballotOfficialName;
    // 提案
    string public proposal;

    // 映射 投票权
    mapping(uint256 => Vote) private votes;
    // 映射 地址 选民
    mapping(address => Voter) public voterRegister;

    // 创建枚举 状态{创建，投票，结束}
    enum State {
        Created,
        Voting,
        Ended
    }
    // 创建变量 当前状态
    State public state;

    // MODIFIERS 修饰器
    modifier condition(bool _condition) {
        // 只有条件为真时
        require(_condition, "modifier condition Error");
        _;
    }
    modifier onlyOfficial() {
        // 只有官方
        require(
            msg.sender == ballotOfficialAddress,
            "Only official can call this."
        );
        _;
    }
    modifier inState(State _state) {
        // 确认当前状态
        require(state == _state, "modifier inState Error");
        _;
    }

    // EVENTS 监听器
    // FUNCTIONS 方法函数
    constructor(string memory _ballotOfficialName, string memory _proposal) {
        ballotOfficialAddress = msg.sender;
        ballotOfficialName = _ballotOfficialName;
        proposal = _proposal;

        state = State.Created;
    }

    function addVoter(address _voterAddress, string memory _voterName)
        public
        inState(State.Created)
        onlyOfficial
    {
        /// @notice 创建选民
        /// @dev 只有在投票未开始时 只有官方 可执行
        Voter memory v;
        v.voterName = _voterName;
        v.voted = false;
        voterRegister[_voterAddress] = v;
        totalVoter++;
    }

    function startVote() public inState(State.Created) onlyOfficial {
        /// @notice 开始投票
        /// @dev 只有在投票未开始时 只有官方 可执行
        state = State.Voting;
    }

    function doVote(bool _choice)
        public
        inState(State.Voting)
        returns (bool voted)
    {
        /// @notice 投票
        /// @dev 只有在投票开始时执行
        bool found = false;

        if (
            bytes(voterRegister[msg.sender].voterName).length != 0 &&
            !voterRegister[msg.sender].voted
        ) {
            // 如果 选民名称不为空 和 选民未投过票
            voterRegister[msg.sender].voted = true;
            Vote memory v;
            v.voterAddress = msg.sender;
            v.choice = _choice;
            if (_choice) {
                // 如果选择是真的
                countResult++;
            }
            votes[totalVote] = v;
            totalVote++;
            found = true;
        }
        return found;
    }

    function endVote() public inState(State.Voting) onlyOfficial {
        /// @notice 结束投票
        /// @dev 只有在托管未开始时执行
        state = State.Ended;
        finalResult = countResult;
    }
}
// memory
