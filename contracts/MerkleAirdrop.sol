// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./interfaces/IERC20.sol";


contract MerkleAirdrop {
    address public tokenAddress;
    bytes32 public merkleRoot;
    address public owner;

    constructor (address _tokenAddress, bytes32 _merkleRoot) {
        tokenAddress = _tokenAddress;
        merkleRoot = _merkleRoot;
        owner = msg.sender;
    }

    error addressHaveClaimedAirdropAlready();
    mapping(address => bool) claimedAirdrop;
    event airdropClaimedSuccessfully(address userAddress, uint256 amount);

    function claimAirdrop(address userAddress, uint256 amount, bytes32[] calldata merkleRootProof) external payable returns(bool) {
        if(claimedAirdrop[userAddress]) {
            revert addressHaveClaimedAirdropAlready();
        }

        bytes32 leaf = keccak256(abi.encode(keccak256(abi.encode(userAddress, amount))));;
        bool verification = MerkleProof.verify(merkleRootProof, merkleRoot, leaf);

        if (verification) {
            claimedAirdrop[userAddress] = true;
            IERC20(tokenAddress).transfer(userAddress, amount);
            emit airdropClaimedSuccessfully(userAddress, amount);
            
        }

    }

    function 
}