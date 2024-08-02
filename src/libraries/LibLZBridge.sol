// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

library LibLZBridge {
    error LZBridgeDebitDisabled(
        address _from,
        uint16 _dstChainId,
        bytes32 _toAddress,
        uint _amount);
    error LZBridgeInvalidSharedDecimals(uint8 _sharedDecimals, uint8 _decimals);
}