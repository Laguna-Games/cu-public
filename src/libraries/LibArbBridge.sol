// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

/// @custom:storage-location erc7201:games.laguna.CU.ArbBridge
library LibArbBridge {
    bytes32 constant ARBBRIDGE_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('games.laguna.CU.ArbBridge')) - 1)) & ~bytes32(uint256(0xff));

    struct ARBBridgeStorage {
        address l1CustomGatewayAddress;
        address l1RouterAddress;
        bool shouldRegisterGateway;
        address l2Gateway;
        address l1TokenAddress;
    }

    function arbBridgeStorage() internal pure returns (ARBBridgeStorage storage arbbs) {
        bytes32 position = ARBBRIDGE_STORAGE_POSITION;
        assembly {
            arbbs.slot := position
        }
    }

    function enforceIsL2Gateway() internal view {
        require(msg.sender == LibArbBridge.getL2Gateway(), "NOT_GATEWAY");
    }

    function setL1CustomGatewayAddress(address _l1CustomGatewayAddress) internal {
        arbBridgeStorage().l1CustomGatewayAddress = _l1CustomGatewayAddress;
    }

    function getL1CustomGatewayAddress() internal view returns (address) {
        return arbBridgeStorage().l1CustomGatewayAddress;
    }

    function setL1RouterAddress(address _l1RouterAddress) internal {
        arbBridgeStorage().l1RouterAddress = _l1RouterAddress;
    }

    function getL1RouterAddress() internal view returns (address) {
        return arbBridgeStorage().l1RouterAddress;
    }

    function setShouldRegisterGateway(bool _shouldRegisterGateway) internal {
        arbBridgeStorage().shouldRegisterGateway = _shouldRegisterGateway;
    }

    function getShouldRegisterGateway() internal view returns (bool) {
        return arbBridgeStorage().shouldRegisterGateway;
    }

    function setL2Gateway(address _l2Gateway) internal {
        arbBridgeStorage().l2Gateway = _l2Gateway;
    }

    function getL2Gateway() internal view returns (address) {
        return arbBridgeStorage().l2Gateway;
    }

    function setL1TokenAddress(address _l1TokenAddress) internal {
        arbBridgeStorage().l1TokenAddress = _l1TokenAddress;
    }

    function getL1TokenAddress() internal view returns (address) {
        return arbBridgeStorage().l1TokenAddress;
    }
}