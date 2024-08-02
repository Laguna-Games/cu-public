// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CutERC20Diamond} from 'lib/@cu-tokens/src/implementation/CutERC20Diamond.sol';

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract wCUTokenImplementation is CutERC20Diamond {
    function setL2Gateway(address _l2Gateway) external {}

    function getL2Gateway() external view returns (address) {}

    function setL1TokenAddress(address _l1TokenAddress) external {}

    function l1Address() external view returns (address) {}

    /**
     * @notice should increase token supply by amount, and should only be callable by the L2Gateway.
     */
    function bridgeMint(address account, uint256 amount) external {}

    /**
     * @notice should decrease token supply by amount, and should only be callable by the L2Gateway.
     */
    function bridgeBurn(address account, uint256 amount) external {}
}
