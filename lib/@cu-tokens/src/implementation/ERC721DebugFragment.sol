// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract ERC721DebugFragment {
    function debugMint(address receiver) external {}

    function debugBurn(uint256 tokenId) external {}

    function debugSetTokenURI(uint256 tokenId, string calldata tokenURI) external {}
}
