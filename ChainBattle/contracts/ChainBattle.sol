// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// The ERC721URIStorage contract that will be used as a foundation of our ERC721 Smart contract
// The counters.sol library, will take care of handling and storing our tokenIDs
// The string.sol library to implement the "toString()" function, that converts data into strings - sequences of characters
// The Base64 library that, as we've seen previous, will help us handle base64 data like our on-chain SVGs
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Original contract deployed to Mumbai - 0xD638d9783C8896F2A8cfB0726C8F192010aa53b9
// Challenge 1 deployed to Mumbai - 0xc34c49dA764cA8Ea74262BFedbD5A9682d4464A1;
// Challenge 1 try 2 deployed to Mumbai - 0x199bd68020a1dbD791935432E335EFbdf057953D;

contract ChainBattle is ERC721URIStorage {

    // In this case "using Strings for uint256" means we're associating all the methods inside the "Strings" library to the uint256 type. 
    using Strings for uint256;
    using Counters for Counters.Counter; 

    Counters.Counter private _tokenIds;

    //The mapping will link an uint256, the NFTId, to another uint256, the level of the NFT
    //mapping(uint256 => uint256) public tokenIdToLevels;
    
    //Challenge 1
    struct Character { 
      uint256 tokenID;
      uint256 level;
      uint256 speed;
      uint256 strength;
      uint256 life;
   }

    //The mapping will look up the Struct for that ID
    mapping(uint256 => Character) public tokenIdToLevels;
    
    // need to declare the constructor function of our smart contract
    constructor() ERC721 ("Chain Battles", "CBTLS"){
    }

    function generateCharacter(uint256 tokenId) public returns(string memory){
        // The first thing you should notice is the "bytes" type, a dynamically sized array of up to 32 bytes where you can store strings, and integers.
        // store the SVG code representing the image of our NFT, transformed into an array of bytes thanks to the abi.encodePacked() function that takes one or more variables and encodes them into abi.
        // return value of a getLevels() function and use it to populate the "Levels:" property - we'll implement this function later on, but take note that you can use functions and variables to dynamically change your SVGs.
        
        //Challenge 1
        //Return Struct values from mapping table
        (string memory level, string memory speed, string memory strength,string memory life) = getLevels(tokenId);
        
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            // '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            // '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            //Challenge 1
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",level,'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",speed,'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",strength,'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",life,'</text>',
            '</svg>'
        );

        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    // function getLevels(uint256 tokenId) public view returns (string memory) {
    //Challenge 1
    function getLevels(uint256 tokenId) public view returns (string memory,string memory,string memory,string memory) {
        // uint256 levels = tokenIdToLevels[tokenId];
        Character memory levels = tokenIdToLevels[tokenId];

        // the toString() function, that's coming from the OpenZeppelin Strings library, and transforms our level, that is an uint256, into a string - that will be then be used by generateCharacter function as we've seen before.
        //return levels.toString();
                
        //Challenge 1
        return (levels.level.toString(),levels.speed.toString(),levels.strength.toString(),levels.life.toString());
    }

    // Create the getTokenURI Function to generate the tokenURI
    // The getTokenURI function will need one parameter, the tokenId, and will use that to generate the image, and build the name of the NFT.
    function getTokenURI(uint256 tokenId) public returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    //Challenge #1
    //randome number generator
    //number =100 generates random number between 0-100
    function random(uint number) public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number;
    }

    function mint() public {
        // we first increment the value of our _tokenIds variable, and store its current value on a new uint256 variable, in this case, "newItemId".
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        // _safeMint() function from the OpenZeppelin ERC721 library, passing the msg.sender variable, and the current id.
        _safeMint(msg.sender, newItemId);

        // create a new item in the tokenIdToLevels mapping and assign its value to 0
        //tokenIdToLevels[newItemId] = 0;
        
        //Challenge 1
        tokenIdToLevels[newItemId] = Character(newItemId,0,random(100),random(100),random(100));

        // we set the token URI passing the newItemId and the return value of getTokenURI()
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId), "Please use an existing token");
        require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
        // uint256 currentLevel = tokenIdToLevels[tokenId];
        // Challenge 1
        Character memory character = tokenIdToLevels[tokenId];
        uint currentLevel = character.level;
        tokenIdToLevels[tokenId].level = currentLevel + 1;

        //tokenIdToLevels[tokenId] = currentLevel + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}