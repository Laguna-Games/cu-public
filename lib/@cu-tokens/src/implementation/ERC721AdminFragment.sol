// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract ERC721AdminFragment {
    function setName(string calldata name) external {}

    function setSymbol(string calldata symbol) external {}

    function setContractURI(string memory uri) external {}

    function setLicense(string memory uri) external {}
}
