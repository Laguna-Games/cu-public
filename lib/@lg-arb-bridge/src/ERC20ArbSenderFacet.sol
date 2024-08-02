// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ICustomToken} from "./arbtoken/ICustomToken.sol";

abstract contract ERC20ArbSenderFacet is ICustomToken {

    function setL1CustomGatewayAddress(address _customGatewayAddress) external virtual;

    function setL1RouterAddress(address _l1RouterAddress) external virtual;

    /// @dev we only set shouldRegisterGateway to true when in `registerTokenOnL2`
    function isArbitrumEnabled() external view virtual returns (uint8);

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
    ) external virtual;
}
