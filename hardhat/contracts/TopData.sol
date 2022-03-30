// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract TopData is
    OwnableUpgradeable,
    ERC1155Upgradeable,
    AccessControlUpgradeable,
    Initializable
{
    function __TopData_init() internal onlyInitializing {
        __Ownable_init();
        __ERC1155_init(
            "https://api.frank.hk/api/nft/demo/1155/marvel/{id}.json"
        );
    }
}
