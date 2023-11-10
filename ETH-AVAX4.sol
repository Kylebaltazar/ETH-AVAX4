// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.9.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.0/utils/math/SafeMath.sol";

contract DegenToken is ERC20, Ownable {
    using SafeMath for uint256;

    enum GachaItem { None, Sword, Potion, Shield }

    mapping(address => uint256) public burnedTokens;
    mapping(address => GachaItem[]) public inventory;

    event GachaResult(address indexed user, GachaItem item);
    event InventoryUpdated(address indexed user, GachaItem[] items);

    constructor() ERC20("Degen", "DGN") {
        _mint(msg.sender, 10000);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
        burnedTokens[msg.sender] = burnedTokens[msg.sender].add(amount);
    }

    function gacha() public {
        require(balanceOf(msg.sender) >= 100, "Insufficient balance to play gacha");
        require(burnedTokens[msg.sender] >= 1, "You must have burned tokens to play gacha");

        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, msg.sender))) % 100;

        GachaItem item;

        if (randomNumber < 2) {
            item = GachaItem.Sword;
        } else if (randomNumber < 35) {
            item = GachaItem.Potion;
        } else {
            item = GachaItem.Shield;
        }

        inventory[msg.sender].push(item);
        _burn(msg.sender, 100); // Deduct 100 tokens for each gacha attempt

        emit GachaResult(msg.sender, item); // Emit an event with the gacha result
        emit InventoryUpdated(msg.sender, inventory[msg.sender]);
    }

    function getInventory() public view returns (string memory) {
        GachaItem[] memory items = inventory[msg.sender];
        uint256 swordCount;
        uint256 potionCount;
        uint256 shieldCount;

        for (uint256 i = 0; i < items.length; i++) {
            if (items[i] == GachaItem.Sword) {
                swordCount++;
            } else if (items[i] == GachaItem.Potion) {
                potionCount++;
            } else if (items[i] == GachaItem.Shield) {
                shieldCount++;
            }
        }

        return string(abi.encodePacked(
            "Swords: ", uint2str(swordCount),
            ", Potions: ", uint2str(potionCount),
            ", Shields: ", uint2str(shieldCount)
        ));
    }

    function uint2str(uint _i) internal pure returns (string memory str) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        str = string(bstr);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
}
