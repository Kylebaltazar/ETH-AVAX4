# DegenToken

## Overview

The `DegenToken` is an ERC20-compliant token contract written in Solidity. It extends the OpenZeppelin `ERC20` and `Ownable` contracts, implementing additional features such as burning tokens, minting tokens, and a gacha system for obtaining items.

## License

This contract is released under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contract Details

### Functions

#### `constructor()`

- Description: Initializes the contract with a name ("Degen"), symbol ("DGN"), and mints 10,000 tokens to the deployer's address.
- Modifiers:
  - None

#### `mint(address to, uint256 amount)`

- Description: Allows the owner to mint (create) new tokens and assign them to a specific address.
- Parameters:
  - `to` (address): The address to which the new tokens will be assigned.
  - `amount` (uint256): The amount of tokens to mint.
- Modifiers:
  - `onlyOwner`: Ensures that only the owner of the contract can call this function.

#### `burn(uint256 amount)`

- Description: Allows any user to burn a specific amount of tokens. The burned tokens are tracked for each user.
- Parameters:
  - `amount` (uint256): The amount of tokens to burn.
- Modifiers:
  - None

#### `gacha()`

- Description: Allows users to play a gacha game to obtain items based on randomness and their token balance.
- Revert Conditions:
  - Insufficient balance to play gacha.
  - The user must have burned tokens to play gacha.
- Emits:
  - `GachaResult`: Event with the gacha result.
  - `InventoryUpdated`: Event with the updated inventory after playing gacha.

#### `getInventory()`

- Description: Retrieves the current inventory of the calling user, showing the count of each obtained item.
- Returns:
  - A string representation of the user's inventory.
- Modifiers:
  - None
