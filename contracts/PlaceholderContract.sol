// SPDX-License-Identifier: MIT  
pragma solidity ^0.8.24;  
  
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";  
import "@openzeppelin/contracts/access/Ownable.sol";  
  
/**  
 * @title PlaceholderContract  
 * @dev A contract that allows users to buy placeholders with ETH and later withdraw their funds  
 * @notice Users pay 0.05 ETH to get a placeholder ID, which they can later use to withdraw their funds  
 */  
contract PlaceholderContract is ReentrancyGuard, Ownable {  
    // Constants  
    uint256 public constant PLACEHOLDER_PRICE = 0.05 ether;  
      
    // State variables  
    uint256 private _nextPlaceholderId;  
    mapping(uint256 => address) private _placeholderOwners;  
    mapping(uint256 => uint256) private _placeholderValues;  
    mapping(address => uint256[]) private _userPlaceholders;  
      
    // Events for comprehensive logging  
    event PlaceholderPurchased(  
        uint256 indexed placeholderId,  
        address indexed buyer,  
        uint256 value,  
        uint256 timestamp  
    );  
      
    event PlaceholderWithdrawn(  
        uint256 indexed placeholderId,  
        address indexed owner,  
        uint256 value,  
        uint256 timestamp  
    );  
      
    event PlaceholderBurned(  
        uint256 indexed placeholderId,  
        address indexed owner,  
        uint256 timestamp  
    );  
      
    // Custom errors for better gas efficiency and clearer error messages  
    error InvalidPaymentAmount(uint256 sent, uint256 required);  
    error PlaceholderNotFound(uint256 placeholderId);  
    error NotPlaceholderOwner(uint256 placeholderId, address caller);  
    error PlaceholderAlreadyWithdrawn(uint256 placeholderId);  
    error WithdrawalFailed(uint256 placeholderId, uint256 amount);  
    error ZeroAddress();  
      
    /**  
     * @dev Constructor sets the initial owner  
     */  
    constructor() Ownable(msg.sender) {  
        _nextPlaceholderId = 1; // Start IDs from 1  
    }  
      
    /**  
     * @dev Buy a placeholder by sending exactly 0.05 ETH  
     * @return placeholderId The ID of the purchased placeholder  
     */  
    function buyPlaceholder() external payable nonReentrant returns (uint256) {  
        // Validate payment amount  
        if (msg.value != PLACEHOLDER_PRICE) {  
            revert InvalidPaymentAmount(msg.value, PLACEHOLDER_PRICE);  
        }  
          
        // Validate caller is not zero address (additional safety)  
        if (msg.sender == address(0)) {  
            revert ZeroAddress();  
        }  
          
        uint256 placeholderId = _nextPlaceholderId++;  
          
        // Store placeholder data  
        _placeholderOwners[placeholderId] = msg.sender;  
        _placeholderValues[placeholderId] = msg.value;  
        _userPlaceholders[msg.sender].push(placeholderId);  
          
        // Emit comprehensive event  
        emit PlaceholderPurchased(  
            placeholderId,  
            msg.sender,  
            msg.value,  
            block.timestamp  
        );  
          
        return placeholderId;  
    }  
      
    /**  
     * @dev Withdraw funds from a placeholder and burn the ID  
     * @param placeholderId The ID of the placeholder to withdraw from  
     */  
    function withdrawPlaceholder(uint256 placeholderId) external nonReentrant {  
        // Validate placeholder exists  
        if (_placeholderOwners[placeholderId] == address(0)) {  
            revert PlaceholderNotFound(placeholderId);  
        }  
          
        // Validate caller owns the placeholder  
        if (_placeholderOwners[placeholderId] != msg.sender) {  
            revert NotPlaceholderOwner(placeholderId, msg.sender);  
        }  
          
        // Check if already withdrawn  
        if (_placeholderValues[placeholderId] == 0) {  
            revert PlaceholderAlreadyWithdrawn(placeholderId);  
        }  
          
        uint256 withdrawAmount = _placeholderValues[placeholderId];  
          
        // Burn the placeholder (clear data)  
        _placeholderValues[placeholderId] = 0;  
          
        emit PlaceholderWithdrawn(  
            placeholderId,  
            msg.sender,  
            withdrawAmount,  
            block.timestamp  
        );  
          
        emit PlaceholderBurned(  
            placeholderId,  
            msg.sender,  
            block.timestamp  
        );  
          
        // Remove from user's placeholder list  
        _removePlaceholderFromUser(msg.sender, placeholderId);  
          
        // Transfer funds (using call for better security)  
        (bool success, ) = payable(msg.sender).call{value: withdrawAmount}("");  
        if (!success) {  
            revert WithdrawalFailed(placeholderId, withdrawAmount);  
        }  
    }  
      
    /**  
     * @dev Get placeholder details  
     * @param placeholderId The ID of the placeholder  
     * @return owner The owner address  
     * @return value The stored value  
     * @return isActive Whether the placeholder is still active  
     */  
    function getPlaceholderDetails(uint256 placeholderId)   
        external   
        view   
        returns (address owner, uint256 value, bool isActive)   
    {  
        owner = _placeholderOwners[placeholderId];  
        value = _placeholderValues[placeholderId];  
        isActive = (owner != address(0) && value > 0);  
    }  
      
    /**  
     * @dev Get all placeholder IDs owned by a user  
     * @param user The user address  
     * @return An array of placeholder IDs  
     */  
    function getUserPlaceholders(address user) external view returns (uint256[] memory) {  
        return _userPlaceholders[user];  
    }  
      
    /**  
     * @dev Get the next placeholder ID that will be assigned  
     * @return The next placeholder ID  
     */  
    function getNextPlaceholderId() external view returns (uint256) {  
        return _nextPlaceholderId;  
    }  
      
    /**  
     * @dev Get contract balance  
     * @return The contract's ETH balance  
     */  
    function getContractBalance() external view returns (uint256) {  
        return address(this).balance;  
    }  
      
    /**  
     * @dev Internal function to remove placeholder from user's list  
     * @param user The user address  
     * @param placeholderId The placeholder ID to remove  
     */  
    function _removePlaceholderFromUser(address user, uint256 placeholderId) internal {  
        uint256[] storage userPlaceholders = _userPlaceholders[user];  
        for (uint256 i = 0; i < userPlaceholders.length; i++) {  
            if (userPlaceholders[i] == placeholderId) {  
                userPlaceholders[i] = userPlaceholders[userPlaceholders.length - 1];  
                userPlaceholders.pop();  
                break;  
            }  
        }  
    }  
      
    /**  
     * @dev Emergency function to withdraw contract balance (owner only)  
     * @notice This should only be used in emergency situations  
     */  
    function emergencyWithdraw() external onlyOwner {  
        uint256 balance = address(this).balance;  
        require(balance > 0, "No funds to withdraw");  
          
        (bool success, ) = payable(owner()).call{value: balance}("");  
        require(success, "Emergency withdrawal failed");  
    }  
}  