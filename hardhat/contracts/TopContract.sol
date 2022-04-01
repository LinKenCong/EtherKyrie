// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";

// import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract TopContract is OwnableUpgradeable, ERC1155Upgradeable,SafeMathUpgradeable {
    uint256 public constant GOLD = 0;

    function __TopContract_init() internal onlyInitializing {
        __Ownable_init();
        __ERC1155_init(
            "https://api.frank.hk/api/nft/demo/1155/marvel/{id}.json"
        );
    }

    function mintGoldCoin(address to, uint256 amount) internal {
        require(to != address(0), "ERC1155: mint to the zero address");

        _mint(to, GOLD, amount, "");
    }
}
