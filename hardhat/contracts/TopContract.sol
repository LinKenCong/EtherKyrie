// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";

contract TopContract is
    OwnableUpgradeable,
    ERC1155Upgradeable,
    ERC1155HolderUpgradeable,
    AccessControlUpgradeable
{
    using SafeMathUpgradeable for uint256;
    using CountersUpgradeable for CountersUpgradeable.Counter;
    uint256 public constant GOLD = 0;
    bytes32 public constant PLAYER_ROLE = keccak256("PLAYER_ROLE");
    // token id 计数
    CountersUpgradeable.Counter internal _tokenIdCounter;
    // token 名称
    mapping(uint256 => string) internal _tokenName;

    event MintToken(address to, uint256 tokenId, uint256 value, string name);

    function __TopContract_init() internal onlyInitializing {
        __Ownable_init();
        __ERC1155_init("https://linkencong.com/api/nft/{id}.json");
        __AccessControl_init_unchained();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(
            ERC1155Upgradeable,
            ERC1155ReceiverUpgradeable,
            AccessControlUpgradeable
        )
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // 铸造代币
    function _safeMint(
        address to,
        uint256 value,
        string memory name
    ) internal {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _tokenName[tokenId] = name;
        _mint(to, tokenId, value, "");
        emit MintToken(to, tokenId, value, name);
    }

    // 提取用户制作NFT支付的手续费
    function withdrawFee() public onlyOwner {
        require(address(this).balance > 0, "Contract Balance is 0.");
        payable(owner()).transfer(address(this).balance);
    }

    // 游戏金币水龙头
    function mintGoldCoin(address to, uint256 amount) internal {
        require(to != address(0), "ERC1155: mint to the zero address");
        _mint(to, GOLD, amount, "");
    }

    function etherKyrieFaucet() public {
        mintGoldCoin(msg.sender, 10000);
    }
}
