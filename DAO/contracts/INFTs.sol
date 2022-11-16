// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface INFTs {
    function balanceOf(address msgsender) external returns(uint256);
}