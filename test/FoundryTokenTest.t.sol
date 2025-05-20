// SPDX License-Identifier: MIT

pragma solidity ^0.8.28;

import "forge-std/Test.sol";
import "../src/FoundryToken.sol";
import "../script/FoundryTokenDeploy.s.sol";

contract FoundryTokenTest is Test {
    FoundryToken public foundryToken;
    address public owner = vm.addr(1);
    address public user1 = vm.addr(2);
    address public user2 = vm.addr(3);
    string public name = "Foundry Token";
    string public symbol = "FRY";
    uint256 public initialSupply = 1000000 * 10 ** 18; // 1 million tokens with 18 decimals

    /**
     * @notice Creates a new instance of the FoundryToken contract.
     */
    function setUp() public {
        vm.startPrank(owner);
        foundryToken = new FoundryToken(name, symbol, initialSupply);
        vm.stopPrank();
    }

    /**
     * @notice Tests the initial supply of the token.
     */
    function testCreatedCorrectly() public view {
        uint256 actual = foundryToken.totalSupply();
        string memory actualName = foundryToken.name();
        string memory actualSymbol = foundryToken.symbol();
        assert(
            actual == initialSupply && keccak256(bytes(actualName)) == keccak256(bytes(name))
                && keccak256(bytes(actualSymbol)) == keccak256(bytes(symbol))
        );
    }

    /**
     * @notice test burn rate
     */
    function testSetBurnRateCorrectly() public {
        uint256 burnRate = 100; // 1%
        vm.startPrank(owner);
        foundryToken.setBurnRate(burnRate); // Set burn rate to 1%
        assert(foundryToken.burnRate() == burnRate);
        vm.stopPrank();
    }

    /**
     * @notice Tests that the burn rate cannot be set higher than the maximum limit.
     */
    function testCannotSetBurnRateMoreThanMax() public {
        uint256 burnRate = 1001; // 10.01%
        vm.startPrank(owner);
        vm.expectRevert("Burn rate exceeds maximum limit");
        foundryToken.setBurnRate(burnRate); // Attempt to set burn rate to 10.01%
        vm.stopPrank();
    }

    /**
     * @notice Tests that the burn rate cannot be set by a non-owner.
     */
    function testCannotSetBurnRateIfNotOwner() public {
        uint256 burnRate = 100; // 1%
        vm.startPrank(user1);
        vm.expectRevert();
        foundryToken.setBurnRate(burnRate); // Attempt to set burn rate as a non-owner
        vm.stopPrank();
    }

    /**
     * @notice Tests the minting of new tokens.
     */
    function testMintingCorrectly() public {
        uint256 mintAmount = 1000 * 10 ** 18; // 1000 tokens
        vm.startPrank(owner);
        foundryToken.mint(user1, mintAmount);
        assert(foundryToken.balanceOf(user1) == mintAmount);
        vm.stopPrank();
    }

    /**
     * @notice Tests that a non-owner cannot mint new tokens.
     */
    function testCannotMintIfNotOwner() public {
        uint256 mintAmount = 1000 * 10 ** 18; // 1000 tokens
        vm.startPrank(user1);
        vm.expectRevert();
        foundryToken.mint(user1, mintAmount); // Attempt to mint as a non-owner
        vm.stopPrank();
    }

    /**
     * @notice Test that Address(0) cannot be minted to.
     */
    function testCannotMintAddressZero() public {
        uint256 mintAmount = 1000 * 10 ** 18; // 1000 tokens
        vm.startPrank(owner);
        vm.expectRevert("Cannot mint to zero address");
        foundryToken.mint(address(0), mintAmount);
        vm.stopPrank();
    }

    /**
     * @notice Tests the transfer function with burn rate.
     */
    function testTransferWithBurnRate() public {
        uint256 transferAmount = 1000 * 10 ** 18; // 1000 tokens
        uint256 burnRate = 100; // 1%
        vm.startPrank(owner);
        foundryToken.setBurnRate(burnRate); // Set burn rate to 1%
        uint256 burnAmount = (transferAmount * burnRate) / 10000; // Calculate the burn amount
        uint256 expectedBalanceSender = foundryToken.balanceOf(owner) - transferAmount - burnAmount;
        foundryToken.transfer(user1, transferAmount);

        assert(foundryToken.balanceOf(user1) == transferAmount);
        assert(foundryToken.totalSupply() == initialSupply - burnAmount);
        assert(foundryToken.balanceOf(owner) == expectedBalanceSender);
        vm.stopPrank();
    }

    /**
     * @notice Tests that a user cannot transfer more tokens than they own.
     */
    function testCannotTransferMoreThanBalance() public {
        uint256 transferAmount = 1000 * 10 ** 18; // 1000 tokens
        vm.startPrank(user1);
        vm.expectRevert("Insufficient balance");
        foundryToken.transfer(owner, transferAmount); // Attempt to transfer more than balance
        vm.stopPrank();
    }

    /**
     * @notice Tests that the initial supply cannot be zero.
     */
    function testIncorrectInitialSupply() public {
        vm.startPrank(owner);
        vm.expectRevert("Incorrect initial supply");
        foundryToken = new FoundryToken(name, symbol, 0); // Attempt to create with zero initial supply
        vm.stopPrank();
    }

    /**
     * @notice Tests that reverts the transfer if amount is not greater than zero.
     */
    function testCannotTransferMinimumAmount() public {
        uint256 transferAmount = 0;
        vm.startPrank(owner);
        vm.expectRevert("Transfer amount must be greater than zero");
        foundryToken.transfer(user1, transferAmount);
        vm.stopPrank();
    }

    /**
     * @notice Tests the transferFrom function with burn rate.
     */
    function testTransferFromWithBurnRate() public {
        uint256 transferAmount = 1000 * 10 ** 18; // 1000 tokens
        uint256 burnRate = 100; // 1%
        vm.startPrank(owner);
        foundryToken.setBurnRate(burnRate); // Set burn rate to 1%
        uint256 burnAmount = (transferAmount * burnRate) / 10000; // Calculate the burn amount
        uint256 expectedBalanceSender = foundryToken.balanceOf(owner) - transferAmount - burnAmount;
        foundryToken.approve(owner, transferAmount);
        foundryToken.transferFrom(owner, user1, transferAmount);

        assert(foundryToken.balanceOf(user1) == transferAmount);
        assert(foundryToken.totalSupply() == initialSupply - burnAmount);
        assert(foundryToken.balanceOf(owner) == expectedBalanceSender);
        vm.stopPrank();
    }

    /**
     * @notice Tests that a user cannot transferFrom more tokens than they own.
     */
    function testCannotTransferFromMoreThanBalance() public {
        uint256 transferAmount = 1000 * 10 ** 18; // 1000 tokens
        vm.prank(user1);
        foundryToken.approve(owner, transferAmount);
        vm.startPrank(owner);
        vm.expectRevert("Insufficient balance");
        foundryToken.transferFrom(user1, owner, transferAmount);
        vm.stopPrank();
    }

    /**
     * @notice Tests that a user cannot transferFrom less than the minimum amount.
     */
    function testCannotTransferFromMinimumAmount() public {
        uint256 transferAmount = 0;
        vm.startPrank(owner);
        vm.expectRevert("Transfer amount must be greater than zero");
        foundryToken.transferFrom(owner, user1, transferAmount);
        vm.stopPrank();
    }

    /**
     * @notice Tests fuzzing the burn rate.
     * @param burnRate The burn rate to test.
     * @dev Assumes that the burn rate is less than or equal to 1000 (10%).
     */
    function testFuzzBurnRate(uint256 burnRate) public {
        vm.assume(burnRate <= 1000); // 10% max burn rate
        vm.startPrank(owner);
        foundryToken.setBurnRate(burnRate);
        assert(foundryToken.burnRate() == burnRate);
        vm.stopPrank();
    }

    /**
     * @notice Tests fuzzing the mint amount.
     * @param mintAmount The amount to mint.
     * @dev Assumes that the mint amount is greater than 0.
     */
    function testFuzzMinting(uint256 mintAmount) public {
        vm.assume(mintAmount > 0 && mintAmount <= 10000000000000 * 10 ** 18); // Ensure mintAmount is reasonable
        vm.startPrank(owner);
        foundryToken.mint(user1, mintAmount);
        assert(foundryToken.balanceOf(user1) == mintAmount);
        vm.stopPrank();
    }
}
