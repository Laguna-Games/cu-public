// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IArbToken} from "./arbtoken/IArbToken.sol";

abstract contract ERC20ArbReceiverFacet is IArbToken {

    function setL2Gateway(address _l2Gateway) external virtual;

    function getL2Gateway() external view virtual returns (address);

    function setL1TokenAddress(address _l1TokenAddress) external virtual;

    function l1Address() external view virtual returns (address);

    /**
     * @notice should increase token supply by amount, and should only be callable by the L2Gateway.
     */
    function bridgeMint(address account, uint256 amount) external virtual;

    /**
     * @notice should decrease token supply by amount, and should only be callable by the L2Gateway.
     */
    function bridgeBurn(address account, uint256 amount) external virtual;
}
