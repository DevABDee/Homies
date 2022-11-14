// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./IWhitelist.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTs is ERC721 {
    address public owner;
    uint256 public counter;
    uint256 public constant maxNFTs = 20;
    uint256 public immutable timeStamp;
    uint256 public price = 0.01 ether;

    IWhitelist public whitelist;

    constructor(address _whitelist) ERC721("Homies DAO", "HOMIES"){
        owner = msg.sender;
        whitelist = IWhitelist(_whitelist);
        timeStamp = block.timestamp;
    }

    function presaleMint() public payable {
        counter++;
        require(counter <= 20, "All NFTs minted");
        require(balanceOf(msg.sender) == 0, "You already minted an NFT Bruh");
        require(timeStamp + 300 > block.timestamp, "Whitelisting NFT minting time ended");
        require(whitelist.getWhitelister(msg.sender), "Only Whitelisters can call this func");
        require(msg.value >= price, "Not Enough ETH sent");
        
        _mint(msg.sender, counter);
    }

    function mintNFT() public payable {
        counter++;
        require(timeStamp + 300 < block.timestamp, "Whitelisting NFT minting time ended");
        require(counter <= 20, "All NFTs minted");
        require(balanceOf(msg.sender) == 0, "You already minted an NFT Bruh");
        require(msg.value >= price, "Not Enough ETH sent");
        
        _mint(msg.sender, counter);
    }

    function withdraw() public {
        require(msg.sender == owner, "Only Owner allowed");
        (bool pass,) = owner.call{value: address(this).balance}("");
        require(pass);
    }
    
}