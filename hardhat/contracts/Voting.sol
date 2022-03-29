// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Voting is Initializable {
    // VARIABLES 变量声明
    // 结构 提案
    struct Proposal {
        string proposalName;
    }
    // 结构 提案投票人
    struct ProposalVote {
        address voteAddress;
        uint8 voteId;
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
    Proposal[] public proposals;

    // 映射 地址 选民
    mapping(address => Voter) public voterRegister;
    // 映射 地址 提案id=>投票人
    mapping(uint8 => ProposalVote[]) public voterProposal;
    // 赢家
    uint8[] public winnerProposal;
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
        require(_condition);
        _;
    }
    modifier onlyOfficial() {
        // 只有官方
        require(
            msg.sender == ballotOfficialAddress,
            "Only official can call this function."
        );
        _;
    }
    modifier inState(State _state) {
        // 确认当前状态
        require(state == _state);
        _;
    }

    modifier voteTrue() {
        // 判断是否投过票
        require(!voterRegister[msg.sender].voted, "you have already voted.");
        _;
    }

    modifier voterTrue() {
        // 判断是否有权限的投票者
        require(
            bytes(voterRegister[msg.sender].voterName).length != 0,
            "You do not have permission."
        );
        _;
    }

    // EVENTS 监听器
    // FUNCTIONS 方法函数
    function __Voting_init(string memory _ballotOfficialName)
        internal
        onlyInitializing
    {
        require(bytes(_ballotOfficialName).length != 0, "input is empty");
        ballotOfficialAddress = msg.sender;
        ballotOfficialName = _ballotOfficialName;

        state = State.Created;
    }

    // constructor(string memory _ballotOfficialName) {
    //     require(bytes(_ballotOfficialName).length != 0, "input is empty");
    //     ballotOfficialAddress = msg.sender;
    //     ballotOfficialName = _ballotOfficialName;

    //     state = State.Created;
    // }

    function addProposal(string memory _proposalName)
        public
        inState(State.Created)
        onlyOfficial
    {
        /// @notice 创建提案
        /// @dev 只有在投票未开始时 只有官方 可执行
        require(bytes(_proposalName).length != 0, "input is empty");
        Proposal memory newProposal = Proposal(_proposalName);
        proposals.push(newProposal);
    }

    function addVoter(address _voterAddress, string memory _voterName)
        public
        inState(State.Created)
        onlyOfficial
    {
        /// @notice 创建选民
        /// @dev 只有在投票未开始时 只有官方 可执行
        require(_voterAddress != address(0), "address is empty");
        require(bytes(_voterName).length != 0, "input is empty");
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

    function doVote(uint8 _proposalId)
        public
        inState(State.Voting)
        voteTrue
        voterTrue
        returns (bool voted)
    {
        /// @notice 投票
        /// @dev 只有在投票开始时执行
        require(_proposalId >= 0, "input is empty");
        bool found = false;

        // 如果 选民名称不为空
        // 更改状态为已投票
        voterRegister[msg.sender].voted = true;
        // 加入已被投票的提案
        ProposalVote memory pv;
        pv.voteAddress = msg.sender;
        pv.voteId = _proposalId;
        voterProposal[_proposalId].push(pv);
        // 投票数量增加
        countResult++;
        // 投票人数增加
        totalVote++;
        found = true;

        return found;
    }

    function endVote() public inState(State.Voting) onlyOfficial {
        /// @notice 结束投票
        /// @dev 只有在投票结束后执行
        // 状态为结束
        state = State.Ended;
        // 最终投票数量显示
        finalResult = countResult;
        for (uint8 i = 0; i < proposals.length; i++) {
            if (winnerProposal.length == 0) {
                // 如果没有赢家则加入
                winnerProposal.push(i);
            } else if (
                voterProposal[i].length <
                voterProposal[winnerProposal[0]].length
            ) {
                // 如果有更小的则变为最小的
                winnerProposal = [i];
            } else if (
                voterProposal[i].length ==
                voterProposal[winnerProposal[0]].length
            ) {
                // 如果有相同的则加入
                winnerProposal.push(i);
            }
        }
    }
}
