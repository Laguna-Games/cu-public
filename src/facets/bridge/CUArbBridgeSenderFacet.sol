// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC20ArbSenderFacet} from "../../../lib/@lg-arb-bridge/src/ERC20ArbSenderFacet.sol";
import {LibContractOwner} from "../../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol";
import {LibArbBridge} from "../../libraries/LibArbBridge.sol";
import {IL1GatewayRouter} from "../../../lib/@lg-arb-bridge/src/arbtoken/IL1GatewayRouter.sol";
import {IL1CustomGateway} from "../../../lib/@lg-arb-bridge/src/arbtoken/IL1CustomGateway.sol";

/*
 * @title CUArbBridgeSenderFacet
 * @notice This contract is used to set the L1RouterAddress and L1CustomGatewayAddress on Arbitrum. It should only be used in that network.
 */
contract CUArbBridgeSenderFacet is ERC20ArbSenderFacet {
    function setL1RouterAddress(address _l1RouterAddress) external override {
        LibContractOwner.enforceIsContractOwner();

        LibArbBridge.setL1RouterAddress(_l1RouterAddress);
    }

    function setL1CustomGatewayAddress(
        address _customGatewayAddress
    ) external override {
        LibContractOwner.enforceIsContractOwner();

        LibArbBridge.setL1CustomGatewayAddress(_customGatewayAddress);
    }

    function isArbitrumEnabled() external view override returns (uint8) {
        require(LibArbBridge.getShouldRegisterGateway(), "NOT_EXPECTED_CALL");
        return uint8(0xb1);
    }

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
    ) external override {
        LibContractOwner.enforceIsContractOwner();
        // we temporarily set `shouldRegisterGateway` to true for the callback in registerTokenToL2 to succeed
        bool prev = LibArbBridge.getShouldRegisterGateway();
        LibArbBridge.setShouldRegisterGateway(true);

        IL1CustomGateway(LibArbBridge.getL1CustomGatewayAddress())
            .registerTokenToL2(
                l2CustomTokenAddress,
                maxGasForCustomBridge,
                gasPriceBid,
                maxSubmissionCostForCustomBridge,
                creditBackAddress,
                valueForGateway
            );

        IL1GatewayRouter(LibArbBridge.getL1RouterAddress()).setGateway(
            LibArbBridge.getL1CustomGatewayAddress(),
            maxGasForRouter,
            gasPriceBid,
            maxSubmissionCostForRouter,
            creditBackAddress,
            valueForRouter
        );

        LibArbBridge.setShouldRegisterGateway(prev);
    }
}
