// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./INFTs.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenICO is ERC20 {

    address public immutable owner;
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant PRICE = 0.001 ether;
    uint256 public minted;

    INFTs public nfts;
    constructor(address _nfts) ERC20("Homies Token", "HT") {
        nfts = INFTs(_nfts);
        owner = msg.sender;
    }

    function nftHoldlerMint() public {
        require(MAX_SUPPLY >= minted, "All HT minted BRUH");
        require(nfts.balanceOf(msg.sender) == 1, "You are not Homies NFT Hodler BRUH");
        minted += 10;
        _mint(msg.sender, 10);
    }

    function mintToken(uint256 _amount) public payable {
        require(MAX_SUPPLY >= minted, "All HT minted");
        require(msg.value >= PRICE * _amount, "not enough ETH sent BRUH");
        minted += _amount;
        _mint(msg.sender, _amount);
    }

    function withdraw() public {
        require(msg.sender == owner, 'Only Owner allowed BRUH');
        (bool success,) = owner.call{value: address(this).balance}("");
        require(success);
    }

}