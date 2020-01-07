pragma solidity 0.4.25;

contract LootBoxes {
    
    string[3] public items          = ["Dragon Sword", "Silver Sword", "Common Sword"];
    uint  [3] public probabilities  = [10,  20, 70];
    address   public gameDeveloper  = 0x00A877E0325Ba6c697f5a6ae05Fa8F91b544276C;
       
    mapping (string => uint) private blockLastPurchase;

    event Draws(string item, string screenName);
        
    function drawItem(string screenName) public returns(string){

        assert(block.number != blockLastPurchase[screenName]); 
        assert(msg.sender == gameDeveloper);
        
        blockLastPurchase[screenName] = block.number;
                
        uint randomValue   = RNG(screenName);
        uint lowerBoundary = 0;
            
        for (uint i=0; i< items.length; i++) {
            if (randomValue >= lowerBoundary && randomValue < lowerBoundary + probabilities[i]) {
                emit Draws(items[i], screenName);
                return items[i];
            }
            else {
                lowerBoundary = lowerBoundary + probabilities[i];
            }
        }
    }
    
    function RNG(string screenName) private view returns (uint8) { 
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp, screenName)))%100);
    }
    
}