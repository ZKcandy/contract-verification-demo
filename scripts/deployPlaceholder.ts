import { ethers, network } from 'hardhat';  
import * as hre from 'hardhat';  
import '@matterlabs/hardhat-zksync-verify';  
import '@matterlabs/hardhat-zksync';  
  
async function main() {  
  try {  
    // Get the deployer account  
    const [deployer] = await ethers.getSigners();  
    console.log(`Deploying PlaceholderContract to ${network.name} with account: ${deployer.address}`);  
    console.log(`Account balance: ${(await ethers.provider.getBalance(deployer.address)).toString()}`);  
  
    // Deploy the contract using the newer pattern  
    const CONTRACT_NAME = 'PlaceholderContract';  
    console.log(`Deploying ${CONTRACT_NAME}...`);  
        
    const placeholderContract = await ethers.deployContract(CONTRACT_NAME, []);  
    await placeholderContract.waitForDeployment();  
    const placeholderContractAddress = await placeholderContract.getAddress();  
        
    console.log(`PlaceholderContract deployed to: ${placeholderContractAddress}`);  
        
    // Display initial contract information  
    try {  
      const placeholderPrice = await placeholderContract.PLACEHOLDER_PRICE();  
      const owner = await placeholderContract.owner();  
      const nextId = await placeholderContract.getNextPlaceholderId();  
      const contractBalance = await placeholderContract.getContractBalance();  
          
      console.log("\nContract Information:");  
      console.log(`- Placeholder Price: ${ethers.formatEther(placeholderPrice)} ETH`);  
      console.log(`- Contract Owner: ${owner}`);  
      console.log(`- Next Placeholder ID: ${nextId}`);  
      console.log(`- Contract Balance: ${ethers.formatEther(contractBalance)} ETH`);  
    } catch (error) {  
      console.log('Contract deployed but could not read initial values:', error);  
    }  
        
    // Wait a fixed time before verification (appropriate for zkCandy)  
    const WAIT_TIME_MS = 45000; // 45 seconds - zkCandy may need longer wait times  
    console.log(`Waiting ${WAIT_TIME_MS/1000} seconds before verification...`);  
        
    await new Promise(resolve => setTimeout(resolve, WAIT_TIME_MS));  
    console.log("Wait complete, proceeding with verification");  
  
    // zkCandy-specific verification  
    if (network.name !== "hardhat" && network.name !== "localhost") {  
      console.log("Verifying contract on zkCandy Explorer...");  
      try {  
        // For zkCandy verification  
        await hre.run("verify:verify", {  
          address: placeholderContractAddress,  
          contract: "contracts/PlaceholderContract.sol:PlaceholderContract",  
          constructorArguments: [],  
          bytecode: placeholderContract.deploymentTransaction()?.data || "",  
        });  
        console.log("Contract verified successfully!");  
      } catch (error: any) {  
        console.error("Error during verification:", error);  
            
        // Check if already verified  
        if (error.message?.toLowerCase().includes("already verified")) {  
          console.log("✅ Contract is already verified!");  
        } else {  
          // Alternative manual verification prompt  
          console.log("\n===== MANUAL VERIFICATION INSTRUCTIONS =====");  
          console.log(`If automatic verification failed, you can verify manually:`);  
          console.log(`1. Wait a few more minutes for the contract to be fully processed`);  
          console.log(`2. Run the following command:`);  
          console.log(`   npx hardhat verify --network ${network.name} ${placeholderContractAddress}`);  
          console.log(`3. Or verify manually on zkCandy Explorer:`);  
          console.log(`   https://explorer.zkcandy.io/address/${placeholderContractAddress}#contract`);  
          console.log("=============================================\n");  
        }  
      }  
    } else {  
      console.log("Skipping verification on local network");  
    }  
        
    // Log deployment summary  
    console.log("\n===== DEPLOYMENT SUMMARY =====");  
    console.log(`Network: ${network.name} (zkCandy)`);  
    console.log(`Contract: ${CONTRACT_NAME}`);  
    console.log(`Address: ${placeholderContractAddress}`);  
    console.log(`Deployer: ${deployer.address}`);  
    console.log(`Transaction Hash: ${placeholderContract.deploymentTransaction()?.hash}`);  
    console.log(`Block Number: ${placeholderContract.deploymentTransaction()?.blockNumber}`);  
    console.log(`Explorer: https://explorer.zkcandy.io/address/${placeholderContractAddress}`);  
    console.log("===============================");  
        
    // Log contract usage instructions  
    console.log("\n===== USAGE INSTRUCTIONS =====");  
    console.log("Contract Functions:");  
    console.log("- buyPlaceholder(): Send 0.05 ETH to get a placeholder ID");  
    console.log("- withdrawPlaceholder(id): Withdraw your ETH and burn the placeholder");  
    console.log("- getPlaceholderDetails(id): View placeholder information");  
    console.log("- getUserPlaceholders(address): View all user's placeholders");  
    console.log("\nExplorer Links:");  
    console.log(`- Contract: https://explorer.zkcandy.io/address/${placeholderContractAddress}`);  
    console.log(`- Transactions: https://explorer.zkcandy.io/address/${placeholderContractAddress}#transactions`);  
    console.log("===============================");  
  
    // Log initial contract setup  
    console.log("\nInitial contract setup:");  
    console.log(`- Contract owner: ${deployer.address}`);  
    console.log(`- Placeholder price: 0.05 ETH`);  
    console.log(`- ReentrancyGuard: Enabled`);  
    console.log(`- Emergency withdraw: Available to owner`);  
  
  } catch (error) {  
    console.error("Deployment failed:", error);  
    process.exitCode = 1;  
  }  
}  
  
// Execute the deployment  
main()  
  .then(() => process.exit(0))  
  .catch((error) => {  
    console.error(error);  
    process.exit(1);  
  });  
