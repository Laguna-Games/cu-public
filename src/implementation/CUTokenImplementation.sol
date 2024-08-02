// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CutERC20Diamond} from 'lib/@cu-tokens/src/implementation/CutERC20Diamond.sol';

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract CUTokenImplementation is CutERC20Diamond {
    function initLZOFTV2(uint8 _sharedDecimals, address _lzEndpoint) external {}

    function setMinDstGas(uint16 _dstChainId, uint16 _packetType, uint _minGas) external {}

    function getTrustedRemoteAddress(uint16 _remoteChainId) external view returns (bytes memory) {}

    function lzReceive(uint16 _srcChainId, bytes calldata _srcAddress, uint64 _nonce, bytes calldata _payload) public {}

    function setTrustedRemoteAddress(uint16 _remoteChainId, bytes calldata _remoteAddress) external {}

    function retryMessage(
        uint16 _srcChainId,
        bytes calldata _srcAddress,
        uint64 _nonce,
        bytes calldata _payload
    ) public payable {}

    function nonblockingLzReceive(
        uint16 _srcChainId,
        bytes calldata _srcAddress,
        uint64 _nonce,
        bytes calldata _payload
    ) public {}

    function setL1RouterAddress(address _l1RouterAddress) external {}

    function setL1CustomGatewayAddress(address _customGatewayAddress) external {}

    function isArbitrumEnabled() external view returns (uint8) {}

    function registerTokenOnL2(
        address l2CustomTokenAddress,
        uint256 maxSubmissionCostForCustomBridge,
        uint256 maxSubmissionCostForRouter,
        uint256 maxGasForCustomBridge,
        uint256 maxGasForRouter,
        uint256 gasPriceBid,
        uint256 valueForGateway,
        uint256 valueForRouter,
        address creditBackAddress
    ) external {}
}
