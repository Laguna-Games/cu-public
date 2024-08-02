// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Interface needed to call function setGateway of the L2GatewayRouter
 */
interface IL1GatewayRouter {
    /**
     * @notice Allows L1 Token contract to trustlessly register its gateway.
     * @dev Other setGateway method allows excess eth recovery from _maxSubmissionCost and is recommended.
     * @param _gateway l1 gateway address
     * @param _maxGas max gas for L2 retryable execution
     * @param _gasPriceBid gas price for L2 retryable ticket
     * @param _maxSubmissionCost base submission cost  L2 retryable tick3et
     * @param _creditBackAddress address for crediting back overpayment of _maxSubmissionCost
     * @param _feeAmount total amount of fees in native token to cover for retryable ticket costs. This amount will be transferred from user to bridge.
     * @return Retryable ticket ID
    **/
    function setGateway(
        address _gateway,
        uint256 _maxGas,
        uint256 _gasPriceBid,
        uint256 _maxSubmissionCost,
        address _creditBackAddress,
        uint256 _feeAmount
    ) external payable returns (uint256);
}