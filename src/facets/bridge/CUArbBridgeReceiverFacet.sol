// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC20ArbReceiverFacet} from "../../../lib/@lg-arb-bridge/src/ERC20ArbReceiverFacet.sol";
import {LibContractOwner} from "../../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol";
import {LibArbBridge} from "../../libraries/LibArbBridge.sol";
import {LibERC20} from "../../../lib/@cu-tokens/src/libraries/LibERC20.sol";

/*
 * @title CUArbBridgeReceiverFacet
 * @notice This contract is used to handle minting and burning operations on Xai. It should only be used in that network.
 */
contract CUArbBridgeReceiverFacet is ERC20ArbReceiverFacet {

    function setL2Gateway(address _l2Gateway) external override {
        LibContractOwner.enforceIsContractOwner();

        LibArbBridge.setL2Gateway(_l2Gateway);
    }

    function getL2Gateway() external view override returns (address) {
        return LibArbBridge.getL2Gateway();
    }

    function setL1TokenAddress(address _l1TokenAddress) external override {
        LibContractOwner.enforceIsContractOwner();
        
        LibArbBridge.setL1TokenAddress(_l1TokenAddress);
    }

    function l1Address() external view override returns (address) {
        return LibArbBridge.getL1TokenAddress();
    }

    /**
     * @notice should increase token supply by amount, and should only be callable by the L2Gateway.
     */
    function bridgeMint(address account, uint256 amount) external override {
        LibArbBridge.enforceIsL2Gateway();
        LibERC20.mint(account, amount);
    }

    /**
     * @notice should decrease token supply by amount, and should only be callable by the L2Gateway.
     */
    function bridgeBurn(address account, uint256 amount) external override {
        LibArbBridge.enforceIsL2Gateway();
        LibERC20.burn(account, amount);
    }
}
