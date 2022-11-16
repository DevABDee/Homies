// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./INFTs.sol";
import "./INFTMarketplace.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAO is Ownable {

    uint256 public  _proposalId;
    INFTs public nfts;
    INFTMarketplace public nftMarketplace;

    constructor(address _nfts, address _nftMarketplace) {
        nfts = INFTs(_nfts);
        nftMarketplace = INFTMarketplace(_nftMarketplace);
    }

    struct Proposals {
        uint256 deadline;
        string proposal;
        address propossedBy;
        uint8 votes;
        uint8 againstVotes;
        bool execute;
    }

    mapping (uint256 => Proposals) public proposalId;

    function createProposal(uint256 _deadlineDays, string memory _proposal) public returns(uint256){
        require(nfts.balanceOf(msg.sender) == 1, "Only Homies NFT Hodlers can create proposals BRUH");
        _proposalId++;
        proposalId[_proposalId] = Proposals(block.timestamp + _deadlineDays * 60, _proposal, msg.sender, 0, 0, false);
        return _proposalId;
    }

    function voteProposal(uint256 _proposalID, bool _vote) public {
        require(nfts.balanceOf(msg.sender) == 1, "Only Homies NFT Hodlers can vote on proposals BRUH");
        if(_vote == true){
            proposalId[_proposalID].votes++;
        } else {
            proposalId[_proposalID].againstVotes++;
        }
        if(proposalId[_proposalID].votes >= proposalId[_proposalID].againstVotes){
            proposalId[_proposalID].execute = true;
        } else {
            proposalId[_proposalID].execute = false;
        }
    }

    function execute(uint256 _proposalID) public returns(string memory){
        require(nfts.balanceOf(msg.sender) == 1, "Only Homies NFT Hodlers can execute proposals BRUH");
        if(proposalId[_proposalID].execute == true){
            return "Let's Go! :)";
        } else {
            return "This proposal got rejected BRUH xD";
        }
    }

    function getProposal(uint256 _proposalID) public view returns(string memory){
        return proposalId[_proposalID].proposal;
    }

}