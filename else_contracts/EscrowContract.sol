// SPDX-License-Identifier: MIT
pragma solidity >=0.8.4 <0.9.0;

contract EscrowContract {
    // VARIABLES 变量声明
    //    枚举 状态 { 未启动,等待支付,等待送货,完成 }
    enum State {
        NOT_INITIATED,
        AWAITING_PAYMENT,
        AMAITING_DELIVERY,
        COMPLETE
    }
    //    公开 合约当前状态
    State public currState; 
    //    是否有买家
    bool public isBuyerIn;
    //    是否有卖家
    bool public isSellerIn;
    //    价格
    uint256 public price;
    //    公开 买家地址
    address public buyer;
    //    公开 应付 卖家地址
    address payable public seller;

    // MODIFIERS 修饰器
    modifier onlyBuyer() {
        // 只有买家
        require(msg.sender == buyer, "Only buyer can call this function.");
        _;
    }
    modifier escrowNotStarted() {
        // 托管未开始
        require(currState == State.NOT_INITIATED, "Escrow not started");
        _;
    }

    // FUNCTIONS 方法函数
    constructor(
        address _buyer,
        address payable _seller,
        uint256 _price
    ) {
        // 创建合约时 初始化三个参数
        buyer = _buyer;
        seller = _seller;
        price = _price * (1 ether);
    }

    function initContract() public escrowNotStarted {
        /// @notice 合约初始化
        /// @dev 只有在托管未开始时执行
        if (msg.sender == buyer) {
            // 如果操作者是 买家
            isBuyerIn = true;
        }
        if (msg.sender == seller) {
            // 如果操作者是 卖家
            isSellerIn = true;
        }
        if (isBuyerIn && isSellerIn) {
            // 如果已有 买家和卖家
            // 当前状态 变为 等待付款
            currState = State.AWAITING_PAYMENT;
        }
    }

    function depostit() public payable onlyBuyer {
        /// @notice 买方存入资金
        /// @dev 只有买家可以操作
        // 如果 当前状态为等待付款 则执行
        require(currState == State.AWAITING_PAYMENT, "Already paid.");
        // 如果 支付金额正确 则执行
        require(msg.value == price, "Wrong deposit amount.");
        // 当前状态变为 等待发货
        currState = State.AMAITING_DELIVERY;
    }

    function confirmDelivery() public payable onlyBuyer {
        /// @notice 买家确认交付- 买家允许合约通过
        /// @dev 只有买家可以操作
        // 如果 当前状态为等待发货 则执行
        require(
            currState == State.AMAITING_DELIVERY,
            "Cannot confirm delivery."
        );
        // 当前状态为 完成
        currState = State.COMPLETE;
        // 将金额转移给 卖家 (在改变状态后才转钱，不然有安全风险)
        seller.transfer(price);
    }

    function withdraw() public payable onlyBuyer {
        /// @notice 买家撤回
        /// @dev 只有买家可以操作
        // 如果 当前状态为等待发货 则执行
        require(
            currState == State.AMAITING_DELIVERY,
            "Cannot withdraw at this stage."
        );
        // 当前状态为 完成
        currState = State.COMPLETE;
        // 将金额转移给 买家 (在改变状态后才转钱，不然有安全风险)
        payable(msg.sender).transfer(price);
    }
}
 