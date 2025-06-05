# ZKcandy Utility Contracts  
  
A collection of utility smart contracts designed for deployment on the ZKcandy Mainnet Layer2 blockchain.  
  
## Overview  
  
This repository contains utility smart contracts to be used on the ZKcandy Layer2 blockchain. The first contract in this collection is the `PlaceholderContract`, which allows users to purchase placeholder IDs for 0.05 ETH and withdraw their funds later.  
  
## Contracts  
  
### PlaceholderContract  
  
A contract that allows users to buy placeholders with ETH and later withdraw their funds.  
  
**Key Features:**  
- Purchase a placeholder ID for 0.05 ETH  
- Withdraw funds at any time  
- Comprehensive event logging  
- View placeholder details and ownership  
- Built-in security with ReentrancyGuard  
- Ownable with emergency withdrawal capability  
  
## Getting Started  
  
### Prerequisites  
  
- Node.js (v18 or later)  
- Yarn or npm  
- A wallet with ETH on ZKcandy Mainnet  
  
### Installation  
  
1. Clone the repository:  
   ```
bash  
   git clone https://github.com/ZKcandy/utility-contracts.git  
   cd utility-contracts  
   
```  
  
2. Install dependencies:  
   ```
bash  
   yarn install  
   # or  
   npm install  
   
```  
  
3. Create a `.env` file in the root directory with your private key:  
   ```
  
   WALLET_PRIVATE_KEY=your_private_key_here  
   
```  
  
### Compiling Contracts  
  
```
bash  
npx hardhat compile  

```  
  
### Deploying to ZKcandy Mainnet  
  
```
bash  
npx hardhat run scripts/deploy-placeholder.ts --network ZKcandyMainnet  

```  
  
### Verifying Contracts  
  
Contract verification should happen automatically during deployment, but if it fails, you can manually verify:  
  
```
bash  
npx hardhat verify --network ZKcandyMainnet <CONTRACT_ADDRESS>  

```  
  
## Using the PlaceholderContract  
  
### Buying a Placeholder  
  
To purchase a placeholder, send exactly 0.05 ETH to the `buyPlaceholder()` function. You will receive a unique placeholder ID.  
  
```
javascript  
// Example using ethers.js  
const tx = await placeholderContract.buyPlaceholder({  
  value: ethers.parseEther("0.05")  
});  
const receipt = await tx.wait();  

```  
  
### Withdrawing Funds  
  
To withdraw your funds, call the `withdrawPlaceholder(id)` function with your placeholder ID.  
  
```
javascript  
// Example using ethers.js  
const tx = await placeholderContract.withdrawPlaceholder(placeholderId);  
const receipt = await tx.wait();  

```  
  
### Viewing Placeholder Details  
  
You can check placeholder details using the `getPlaceholderDetails(id)` function.  
  
```
javascript  
// Example using ethers.js  
const details = await placeholderContract.getPlaceholderDetails(placeholderId);  
console.log("Owner:", details.owner);  
console.log("Value:", ethers.formatEther(details.value));  
console.log("Active:", details.isActive);  

```  
  
### Getting User's Placeholders  
  
To see all placeholders owned by an address:  
  
```
javascript  
// Example using ethers.js  
const placeholderIds = await placeholderContract.getUserPlaceholders(userAddress);  
console.log("User's placeholders:", placeholderIds.map(id => id.toString()));  

```  
  
## Contract Interface  
  
```
solidity  
function buyPlaceholder() external payable returns (uint256);  
function withdrawPlaceholder(uint256 placeholderId) external;  
function getPlaceholderDetails(uint256 placeholderId) external view returns (address owner, uint256 value, bool isActive);  
function getUserPlaceholders(address user) external view returns (uint256[] memory);  
function getNextPlaceholderId() external view returns (uint256);  
function getContractBalance() external view returns (uint256);  
function emergencyWithdraw() external onlyOwner;  

```  
  
## Contract Events  
  
The contract emits the following events:  
  
- `PlaceholderPurchased(uint256 indexed placeholderId, address indexed buyer, uint256 value, uint256 timestamp)`  
- `PlaceholderWithdrawn(uint256 indexed placeholderId, address indexed owner, uint256 value, uint256 timestamp)`  
- `PlaceholderBurned(uint256 indexed placeholderId, address indexed owner, uint256 timestamp)`  
  
## Security Features  
  
- ReentrancyGuard to prevent reentrancy attacks  
- Custom error messages for better debugging  
- Ownable contract pattern for access control  
- Secure withdrawal pattern using low-level call  
- Value validation to ensure correct payment  
  
## License  
  
This project is licensed under the MIT License - see the LICENSE file for details.  
  
## Contributing  
  
Contributions are welcome! Please feel free to submit a Pull Request.  
  
1. Fork the repository  
2. Create your feature branch (`git checkout -b feature/amazing-feature`)  
3. Commit your changes (`git commit -m 'Add some amazing feature'`)  
4. Push to the branch (`git push origin feature/amazing-feature`)  
5. Open a Pull Request  
  
