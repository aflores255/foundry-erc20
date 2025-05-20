# 🪙 ERC20Token - A Standard-Compliant ERC-20 Token on Arbitrum One

## 📌 Description

**ERC20Token** is a minimal, production-ready ERC-20 token implementation built using **OpenZeppelin** contracts and tested with the Foundry framework. Designed for deployment on **Arbitrum One**, this project provides a robust foundation for any DeFi application, utility token, or protocol-native asset.

The contract follows the ERC-20 specification and integrates OpenZeppelin’s battle-tested libraries to ensure safety, upgradeability potential, and ease of use for developers. It includes standard metadata (name, symbol, decimals) and is deployable with an initial supply.

Developed in **Solidity 0.8.28**, this token contract emphasizes gas-efficiency, simplicity, and full test coverage.

---

## 🚀 Features

| **Feature**         | **Description**                                                  |
|---------------------|------------------------------------------------------------------|
| 💼 **ERC-20 Standard** | Fully compliant with ERC-20 (transfer, approve, allowance, etc). |
| 🧰 **OpenZeppelin Base** | Uses OpenZeppelin’s secure ERC-20 implementation.              |
| 🧪 **Foundry Test Suite** | Unit/fuzz tested for transfer, approval, and supply edge cases.     |
| 🌉 **Arbitrum One Ready** | Deployed on the Arbitrum One L2 network.                      |

---

## 🔧 Contract Details

### 📝 Constructor

```solidity
constructor(string memory name_, string memory symbol_, uint256 initialSupply_)
```

Initializes the token with a name, symbol, and an initial total supply (minted to the deployer).

---

### ⚙️ Core Functions

| **Function**       | **Description**                                   |
|--------------------|---------------------------------------------------|
| `transfer`         | Transfers tokens to a recipient.                  |
| `approve`          | Approves a spender to transfer tokens.            |
| `transferFrom`     | Allows a spender to transfer tokens on your behalf. |
| `balanceOf`        | Returns the token balance of an address.          |
| `totalSupply`      | Returns the total token supply.                   |
| `allowance`        | Returns the remaining allowance for a spender.    |

---

## 🚀 Deployment & Usage

This section demonstrates the functionality of the `foundry-erc20` smart contract, deployed on the **Arbitrum One** network.

🔗 **Deployed Contract:** [0xe3119b79e2908C7A9090b4744e9b9A45295E84d3 on Arbiscan](https://arbiscan.io/token/0xe3119b79e2908c7a9090b4744e9b9a45295e84d3)                                                      |

---

### 🔁 Real Transaction Example

Here is a real usage of the ERC-20 token on Arbitrum:

🔹 **Tx Hash:** [`0x3cbaae1de366b01fbb27e8861a0df2c8028cb6e0ae3af691a7dd93bad52c7a5b`](https://arbiscan.io/tx/0x3cbaae1de366b01fbb27e8861a0df2c8028cb6e0ae3af691a7dd93bad52c7a5b)  
- **Transferred:** `100` tokens  
- **From:** `0x...`  
- **To:** `0x...`  
- **Token:** [`ERC20Token`](https://arbiscan.io/token/0xe3119b79e2908c7a9090b4744e9b9a45295e84d3)

### 🔥 Token Burn on Transfer (Proportional to Sender)

Unlike typical deflationary tokens where the amount **received** is reduced (e.g., you send 100, recipient gets 98, and 2 are burned), this token implements a unique **burn-on-transfer** mechanism:

- The recipient receives **exactly** the amount specified in the transfer (`amount`).
- A **proportional amount is burned** from the sender *in addition* to what is transferred.

The amount burned on each transfer can be adjusted or fixed depending on the contract burnFee.

If you call:

```solidity
transfer(recipient, 100 * 10**decimals)
```

Then:

- The recipient receives exactly **100 tokens**.
- A fixed percentage (e.g. **1%**) is **burned from your balance**.
- You will actually lose **101 tokens in total** — 100 sent, 1 burned.

---

This behavior ensures:

- ✅ Transfers are **predictable** from the recipient's perspective.
- 🔒 Burn logic **does not affect the receiver**.
- 💰 **Holders pay the cost** of deflation, encouraging long-term holding and reducing total supply with every transfer.

---

## 🧪 Testing with Foundry

The contract is fully tested with the **Foundry** testing framework.

### ✅ Implemented Tests

| **Test**                         | **Description**                                                              |
|----------------------------------|------------------------------------------------------------------------------|
| `testCreatedCorrectly`          | Validates token name, symbol, and total supply at deployment.               |
| `testSetBurnRateCorrectly`      | Verifies that the owner can set a valid burn rate.                          |
| `testCannotSetBurnRateMoreThanMax` | Ensures the burn rate cannot exceed the maximum allowed.                  |
| `testCannotSetBurnRateIfNotOwner` | Prevents non-owners from setting the burn rate.                            |
| `testMintingCorrectly`          | Allows the owner to mint new tokens to a given address.                     |
| `testCannotMintIfNotOwner`      | Prevents minting by any address other than the owner.                       |
| `testCannotMintAddressZero`     | Ensures minting to the zero address is not allowed.                         |
| `testTransferWithBurnRate`      | Tests transfer logic with burn applied to sender.                           |
| `testCannotTransferMoreThanBalance` | Validates that users cannot transfer more than their balance.           |
| `testIncorrectInitialSupply`    | Prevents deployment with an initial supply of zero.                         |
| `testCannotTransferMinimumAmount` | Ensures transfer amount must be greater than zero.                       |
| `testTransferFromWithBurnRate`  | Validates `transferFrom` logic and burn behavior.                           |
| `testCannotTransferFromMoreThanBalance` | Prevents `transferFrom` with insufficient balance.                   |
| `testCannotTransferFromMinimumAmount` | Ensures `transferFrom` amount must be greater than zero.              |
| `testFuzzBurnRate`              | Fuzz test to ensure burn rate logic holds under variable inputs.            |
| `testFuzzMinting`               | Fuzz test to verify minting works with a wide range of valid inputs.        |


---

### 🧪 Run Tests

```bash
forge test
```

---

### 📊 Test Coverage

The contract achieves **full coverage** on lines, statements, and functions, with 90% branch coverage — ensuring strong reliability and confidence in its core logic.

| **File**                      | **% Lines**     | **% Statements** | **% Branches** | **% Functions** |
|------------------------------|-----------------|------------------|----------------|-----------------|
| `src/FoundryToken.sol`| 100.00% (28/28) | 100.00% (29/29)  | 100.00% (14/14)  | 100.00% (5/5)   |

---




