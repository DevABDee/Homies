// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "./INFTs.sol";
import "./INFTMarketplace.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAO is Ownable {

    uint256 public _proposalId;
    uint256 public numProposals;
    INFTs public nfts;
    INFTMarketplace public nftMarketplace;


    struct Proposal {
        uint256 tokenId;
        uint256 deadline;
        address propossedBy;
        uint8 votes;
        uint8 againstVotes;
        bool execute;
    }

    mapping (uint256 => Proposal) public proposalId;

    constructor(address _nfts, address _nftMarketplace) {
        nfts = INFTs(_nfts);
        nftMarketplace = INFTMarketplace(_nftMarketplace);
    }

    modifier onlyDAOmember {
        require(nfts.balanceOf(msg.sender) > 0, "Only DAO memeber allowed BRUH");
        _;
    }

    function createProposal(uint256 _tokenId, uint256 _deadlineDays) public onlyDAOmember returns(uint256){
        _proposalId++;
        numProposals++;
        require(nftMarketplace.available(_tokenId), "NFT is not on sale BRUH");
        proposalId[_proposalId] = Proposal(_tokenId, block.timestamp + _deadlineDays * 60, msg.sender, 0, 0, false);
        return numProposals;
    }

    function voteProposal(uint256 _proposalID, bool _vote) public onlyDAOmember {
        require(proposalId[_proposalID].deadline > block.timestamp, "Proposal Ended");
        if(_vote == true){
            proposalId[_proposalID].votes++;
        } else {
            proposalId[_proposalID].againstVotes++;
        }
    }

    function execute(uint256 _proposalID) public onlyDAOmember {
        require(proposalId[_proposalID].deadline < block.timestamp, "Proposal in Progress");
        if(proposalId[_proposalID].votes >= proposalId[_proposalID].againstVotes){
            uint256 nftPrice = nftMarketplace.getPrice();
            require(address(this).balance >= nftPrice, "Funds not enough xD");
            nftMarketplace.purchase{value: nftPrice}(proposalId[_proposalID].tokenId);
        }
        proposalId[_proposalID].execute = true;
    }

    function withdraw() external onlyOwner {
            payable(owner()).transfer(address(this).balance);
    }

    function fund() public onlyDAOmember payable {
        require(msg.value >= 0.00005 ether, "Not enough BRUH");
    }

    receive() external payable {}
    fallback() external payable {}

}