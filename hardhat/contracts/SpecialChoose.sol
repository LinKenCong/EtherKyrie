// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 *
 * TokenVesting 锁仓合约
 *
 * [功能]
 * 创建锁仓(在用户钱包内);
 * 可设置首次金额解锁(按设置比率);
 * 按设置的间隔时间线性解锁锁仓余额;
 * 合约拥有者可设置撤回受益人剩余未解锁的金额;
 *
 */
abstract contract TokenVesting is ERC20, Ownable {
    // 首次解锁数据结构
    struct FirstGive {
        // 首次解锁金额
        uint256 amount;
        // 首次解锁比率
        uint256 ratio;
        // 是否已解锁首次金额
        bool done;
    }
    // 锁仓数据结构
    struct Vesting {
        // beneficiary
        address beneficiary;
        // 开始时间
        uint256 start;
        // 断崖时间
        uint256 cliff;
        // 持续时间
        uint256 duration;
        // 下一解锁金额时间
        uint256 nextGetTime;
        // 已解锁金额
        uint256 released;
        // 总锁仓金额
        uint256 totalLockAmount;
        // 是否可撤销
        bool revocable;
        // 是否已撤销
        bool revoked;
        // 定制解锁比率
        uint256[] customizeRatio;
        // 已解锁次数
        uint256 releaseCount;
        // 首次解锁金额
        FirstGive firstGive;
    }

    // 储存 锁仓数据
    mapping(address => Vesting) public _vestingOf;

    // 只有合约发布者或受益人可操作
    modifier onlyOwnerOrBeneficiary() {
        require(
            msg.sender == owner() ||
                msg.sender == _vestingOf[msg.sender].beneficiary,
            "TokenVesting: Permission denied"
        );
        _;
    }
    // 验证 可用金额
    modifier availableBalance(uint256 _amount) {
        require(
            _amount <= balanceOf(msg.sender) - unReleasedBalance(),
            "TokenVesting: Insufficient available balance"
        );
        _;
    }

    // 验证 已创建 Vesting
    modifier haveVesting(address _beneficiary) {
        require(
            _vestingOf[_beneficiary].beneficiary == _beneficiary,
            "TokenVesting: Beneficiary no vesting"
        );
        _;
    }

    // 代币解锁
    event TokensReleased(address token, uint256 amount);
    // 撤销代币归属
    event TokenVestingRevoked(address token);

    /**
     * @dev 创建锁仓合约
     *
     * [要求]
     * 只有合约拥有者可创建;
     *
     * @param _beneficiary 受益人地址
     * @param _start 开始锁仓时间戳
     * @param _cliff 解锁间隔时间
     * @param _duration 锁仓持续时间
     * @param _totalLockAmount 锁仓总金额
     * @param _revocable 是否可撤销金额 ( 可将未释放金额撤回至部署合约者账户 )
     * @param _customizeRatio 定制每次解锁比率
     * @param _firstRatio 首次释放金额比率
     *
     */
    function createVesting(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        uint256 _totalLockAmount,
        bool _revocable,
        uint256[] memory _customizeRatio,
        uint256 _firstRatio
    ) external onlyOwner {
        require(
            _vestingOf[_beneficiary].beneficiary == address(0),
            "TokenVesting: Beneficiary have vesting"
        );
        require(
            _beneficiary != address(0),
            "TokenVesting: beneficiary is the zero address"
        );
        require(_duration > 0, "TokenVesting: duration is 0");
        require(
            _cliff <= _duration,
            "TokenVesting: cliff is longer than duration"
        );
        require(
            _start + _duration > block.timestamp,
            "TokenVesting: final time is before current time"
        );
        require(_firstRatio < 100, "TokenVesting: No more than one hundred");

        // 如果设置定制解锁比率
        if (_customizeRatio.length > 0) {
            // 验证总比率是否超出 100%
            uint256 __total;
            for (uint256 i = 0; i < _customizeRatio.length; i++) {
                __total += _customizeRatio[i];
            }
            require(
                __total + _firstRatio == 100,
                "TokenVesting: The Ratio total is not 100"
            );

            uint256 _unlockCount = _duration / _cliff;

            // 验证解锁次数和时间是否对应
            require(
                _customizeRatio.length == _unlockCount ||
                    _customizeRatio.length == _unlockCount + 1,
                "TokenVesting: Unlock times and time do not correspond"
            );
        }

        // 储存数据
        _vestingOf[_beneficiary] = Vesting(
            _beneficiary,
            _start,
            _cliff,
            _duration,
            _start + _cliff,
            0,
            _totalLockAmount,
            _revocable,
            false,
            _customizeRatio,
            0,
            FirstGive(
                (_totalLockAmount * _firstRatio) / 100,
                _firstRatio,
                false
            )
        );

        // 转账代币给受益人
        transfer(_beneficiary, _totalLockAmount);
        // 允许合约发布者可以转账未解锁金额
        _approve(_beneficiary, owner(), _totalLockAmount);
    }

    /**
     * @dev 撤回：允许合约所有者撤销剩下金额。
     * @param _beneficiary 受益人地址
     */
    function revoke(address _beneficiary)
        public
        onlyOwner
        haveVesting(_beneficiary)
    {
        // 获取 储存的锁仓数据
        Vesting storage vestingOf_ = _vestingOf[_beneficiary];
        require(vestingOf_.revocable, "TokenVesting: cannot revoke");
        require(!vestingOf_.revoked, "TokenVesting: token already revoked");

        vestingOf_.revoked = true;
        vestingOf_.nextGetTime = 0;

        transferFrom(
            _beneficiary,
            owner(),
            vestingOf_.totalLockAmount - vestingOf_.released
        );
        emit TokenVestingRevoked(_beneficiary);
    }

    /**
     * @dev 解锁：给受益人解锁本次金额
     * @param _beneficiary 受益人地址
     */
    function release(address _beneficiary)
        public
        onlyOwnerOrBeneficiary
        haveVesting(_beneficiary)
    {
        require(
            !_vestingOf[_beneficiary].revoked,
            "TokenVesting: Amount has been revoked"
        );

        // 现在解锁的金额
        uint256 _nowReleased;
        // 获取 储存的锁仓数据
        Vesting storage vestingOf_ = _vestingOf[_beneficiary];

        // 首次解锁 如果设置了比率执行
        if (vestingOf_.firstGive.ratio > 0 && !vestingOf_.firstGive.done) {
            vestingOf_.firstGive.done = true;
            _nowReleased = vestingOf_.firstGive.amount;
        } else {
            _nowReleased = _releasableAmount(_beneficiary);
        }

        require(_nowReleased > 0, "TokenVesting: No tokens are due");

        // 获取下一个解锁时间
        if (block.timestamp >= vestingOf_.nextGetTime) {
            vestingOf_.nextGetTime = _getNextTime(_beneficiary);
        }

        vestingOf_.releaseCount++;
        vestingOf_.released += _nowReleased;
        _spendAllowance(_beneficiary, owner(), _nowReleased);

        emit TokensReleased(_beneficiary, _nowReleased);
    }

    /**
     * @dev 获取 本次应解锁金额
     * @param _beneficiary 受益人地址
     * @return uint256 token.balance
     */
    function _releasableAmount(address _beneficiary)
        private
        view
        returns (uint256)
    {
        return
            _vestedAmount(_beneficiary) +
            _vestingOf[_beneficiary].firstGive.amount -
            _vestingOf[_beneficiary].released;
    }

    /**
     * @dev 获取 所有应解锁的所有金额 ( 已减去首次解锁金额 )
     * @param _beneficiary 受益人地址
     * @return uint256 token.balance
     */
    function _vestedAmount(address _beneficiary)
        private
        view
        returns (uint256)
    {
        // 获取 储存的锁仓数据
        Vesting storage vestingOf_ = _vestingOf[_beneficiary];

        // 获取 需线性解锁的金额 (不包含首次解锁金额)
        uint256 _totalVestingBalance = vestingOf_.totalLockAmount -
            vestingOf_.firstGive.amount;

        // 返回 当前时间应解锁的所有金额
        if (block.timestamp > vestingOf_.start + vestingOf_.duration) {
            return _totalVestingBalance;
        } else if (block.timestamp < vestingOf_.nextGetTime) {
            return 0;
        } else {
            if (vestingOf_.customizeRatio.length > 0) {
                // 如果设置了定制解锁比率
                return _vestedCustomizeRatioAmount(_beneficiary);
            } else {
                return
                    (_totalVestingBalance *
                        (vestingOf_.nextGetTime - vestingOf_.start)) /
                    vestingOf_.duration;
            }
        }
    }

    /**
     * @dev 获取 定制解锁比率 应解锁的所有金额
     * @param _beneficiary 受益人地址
     * @return uint256 token.balance
     */
    function _vestedCustomizeRatioAmount(address _beneficiary)
        private
        view
        returns (uint256)
    {
        Vesting storage vestingOf_ = _vestingOf[_beneficiary];
        uint256 _ratioCount;
        for (uint256 i = 0; i < vestingOf_.releaseCount; i++) {
            _ratioCount += vestingOf_.customizeRatio[i];
        }
        return (vestingOf_.totalLockAmount * _ratioCount) / 100;
    }

    /**
     * @dev 获取 下一个解锁金额时间
     * @param _beneficiary 受益人地址
     * @return uint256 block.timestamp
     */
    function _getNextTime(address _beneficiary) private view returns (uint256) {
        // 获取 储存的锁仓数据
        Vesting storage vestingOf_ = _vestingOf[_beneficiary];
        uint256 _newTime = vestingOf_.nextGetTime;
        uint256 _endTime = vestingOf_.start + vestingOf_.duration;

        if (block.timestamp >= _endTime) {
            _newTime = _endTime;
        } else if (block.timestamp >= _newTime) {
            _newTime += vestingOf_.cliff;
        }

        return _newTime;
    }

    /**
     * @dev 获取 未解锁金额
     * @return uint256 token.balance
     */
    function unReleasedBalance() public view returns (uint256) {
        Vesting storage vestingOf_ = _vestingOf[msg.sender];
        return vestingOf_.totalLockAmount - vestingOf_.released;
    }
}

/**
 *
 * 代币合约
 *
 * [功能]
 * 限制最大发币量;
 * <TokenVesting> 创建锁仓(在用户钱包内);
 *
 */
contract Token is TokenVesting {
    // 代币总量限制
    uint256 public totalLimit;

    // 验证 代币总量限制
    modifier totalSupplyLimit(uint256 _value) {
        if (totalLimit > 0) {
            require(
                totalSupply() + _value <= totalLimit,
                "Token: The mint total amount exceeds the limit"
            );
        }
        _;
    }

    // /**
    //  * @dev 初始化
    //  *
    //  * @param _totalLimit 代币最大数量限制
    //  * @param _initMint 初次铸币数量
    //  * @param _name 代码名称
    //  * @param _symbol 代币简称
    //  *
    //  */
    // constructor(
    //     uint256 _totalLimit,
    //     uint256 _initMint,
    //     string memory _name,
    //     string memory _symbol
    // ) ERC20(_name, _symbol) {
    //     if (_totalLimit > 0) {
    //         require(_initMint <= _totalLimit, "Token: Not exceed limit");
    //         totalLimit = _totalLimit * 10**decimals();
    //     }
    //     _mint(msg.sender, _initMint * 10**decimals());
    // }

    constructor() ERC20("DMTT", "TMD") {
        uint256 _totalLimit = 300000000;
        uint256 _initMint = 100000000;
        if (_totalLimit > 0) {
            require(_initMint <= _totalLimit, "Token: Not exceed limit");
            totalLimit = _totalLimit * 10**decimals();
        }
        _mint(msg.sender, _initMint * 10**decimals());
    }

    /**
     * @dev 铸币 且增加代币总量
     *
     * [要求]
     * 只有合约部署者可操作
     * 总量不可超过限制
     */
    function mint(address _to, uint256 _amount)
        public
        onlyOwner
        totalSupplyLimit(_amount)
    {
        _mint(_to, _amount);
    }

    /**
     * @dev 转账
     * [要求]
     * 不得超过可用余额(锁仓未解锁金额不可使用)
     */
    function transfer(address to, uint256 amount)
        public
        virtual
        override
        availableBalance(amount)
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev 授权他人
     * [要求]
     * 不得超过可用余额(锁仓未解锁金额不可使用)
     */
    function approve(address spender, uint256 amount)
        public
        virtual
        override
        availableBalance(amount)
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev 销毁调用者的`amount` 代币
     */
    function burn(uint256 amount) public virtual {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev 销毁 `account` 中的 `amount` 代币，从调用者的账户中扣除
     */
    function burnFrom(address account, uint256 amount) public virtual {
        _spendAllowance(account, _msgSender(), amount);
        _burn(account, amount);
    }
}
