// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract FoundryToken is ERC20, Ownable {
    uint256 public burnRate = 100; // 1% burn rate
    uint256 public constant MAX_BURN_RATE = 1000; // 10% burn rate

    /**
     * @notice Constructor that initializes the token with a name and symbol.
     * @param initialSupply The initial supply of the token.
     */
    constructor(string memory name, string memory symbol, uint256 initialSupply)
        ERC20(name, symbol)
        Ownable(msg.sender)
    {
        require(initialSupply > 0, "Incorrect initial supply");
        _mint(msg.sender, initialSupply);
    }

    /**
     * @notice Mints new tokens and assigns them to the specified address.
     * @param to The address to mint tokens to.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        require(to != address(0), "Cannot mint to zero address");
        _mint(to, amount);
    }

    /**
     * @notice Sets the burn rate for the token.
     * @param _burnRate The new burn rate (in basis points).
     */
    function setBurnRate(uint256 _burnRate) external onlyOwner {
        require(_burnRate <= MAX_BURN_RATE, "Burn rate exceeds maximum limit");
        burnRate = _burnRate;
    }

    /**
     * @notice Transfers tokens from the sender to the recipient, applying the burn rate.
     * @param recipient The address to transfer tokens to.
     * @param amount The amount of tokens to transfer.
     */
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 burnAmount = (amount * burnRate) / 10000; // Calculate the burn amount based on the burn rate
        uint256 difference = amount - burnAmount; // Calculate the amount to be transferred
        uint256 totalAmount = amount + burnAmount; // Calculate the total amount of the transaction
        require(totalAmount <= balanceOf(msg.sender), "Insufficient balance");
        require(difference > 0, "Transfer amount must be greater than zero");
        _transfer(msg.sender, recipient, amount);
        _burn(msg.sender, burnAmount); // Burn the calculated amount
        return true;
    }

    /**
     * @notice Transfers tokens from the sender to the recipient, applying the burn rate.
     * @param sender The address to transfer tokens from.
     * @param recipient The address to transfer tokens to.
     * @param amount The amount of tokens to transfer.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 burnAmount = (amount * burnRate) / 10000; // Calculate the burn amount based on the burn rate
        uint256 difference = amount - burnAmount; // Calculate the amount to be transferred
        uint256 totalAmount = amount + burnAmount; // Calculate the total amount of the transaction
        require(totalAmount <= balanceOf(sender), "Insufficient balance");
        require(difference > 0, "Transfer amount must be greater than zero");
        _spendAllowance(sender, msg.sender, amount);
        _transfer(sender, recipient, amount);
        _burn(sender, burnAmount); // Burn the calculated amount

        return true;
    }
}
