//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
    安全数学
 */
contract SafeMath {
    function safeAdd(uint256 a, uint256 b) public pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint256 a, uint256 b) public pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint256 a, uint256 b) public pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint256 a, uint256 b) public pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
}

/**
    所有者身份校验
 */
contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }

    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

/**
    ERC20 接口
 */
interface IERC20 {
    // 返回token的总供应量
    function totalSupply() external view returns (uint256);

    // 返回某个地址(账户)的账户余额
    function balanceOf(address account) external view returns (uint256);

    // 从代币合约的调用者地址上转移_value的数量token到的地址_to，并且必须触发Transfer事件。
    function transfer(address to, uint256 amount) external returns (bool);

    // 返回_spender仍然被允许从_owner提取的金额。
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    // approve是授权第三方（比如某个服务合约）从发送者账户转移代币，然后通过 transferFrom() 函数来执行具体的转移操作
    function approve(address spender, uint256 amount) external returns (bool);

    // 用于允许合同代理某人转移token。条件是from账户必须经过了approve
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    // 监听事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
    合约
 */
contract ZKCoin is IERC20, Owned, SafeMath {
    // token名称
    string private name;
    // token简称
    string private symbol;
    // 小数点位
    uint8 public decimals;
    // 总token量
    uint256 private totalSupply_;

    // 根据地址取余额
    mapping(address => uint256) private balances;
    // 根据此地址查询其它地址对此地址可以调用多少token
    mapping(address => mapping(address => uint256)) private allowed;

    constructor() {
        address _owner = msg.sender;
        name = "ZKCoin";
        symbol = "ZKC";
        decimals = 2;
        totalSupply_ = 10000;
        balances[_owner] = totalSupply_;
        emit Transfer(address(0), _owner, totalSupply_);
    }

    // 返回token的总供应量
    function totalSupply() public view override(IERC20) returns (uint256) {
        return totalSupply_ - balances[address(0)];
    }

    // 返回某个地址(账户)的账户余额
    function balanceOf(address account)
        public
        view
        override(IERC20)
        returns (uint256)
    {
        return balances[account];
    }

    // 从代币合约的调用者地址上转移_value的数量token到的地址_to，并且必须触发Transfer事件。
    function transfer(address to, uint256 amount)
        public
        override(IERC20)
        returns (bool)
    {
        balances[msg.sender] = safeSub(balances[msg.sender], amount);
        balances[to] = safeAdd(balances[to], amount);
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // 返回_spender仍然被允许从_owner提取的金额。
    function allowance(address owner, address spender)
        public
        view
        override(IERC20)
        returns (uint256)
    {
        return allowed[owner][spender];
    }

    // approve是授权第三方（比如某个服务合约）从发送者账户转移代币，然后通过 transferFrom() 函数来执行具体的转移操作
    function approve(address spender, uint256 amount)
        public
        override(IERC20)
        returns (bool)
    {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 用于允许合同代理某人转移token。条件是from账户必须经过了approve
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override(IERC20) returns (bool) {
        balances[from] = safeSub(balances[from], amount);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], amount);
        balances[to] = safeAdd(balances[to], amount);
        emit Transfer(from, to, amount);
        return true;
    }
}
