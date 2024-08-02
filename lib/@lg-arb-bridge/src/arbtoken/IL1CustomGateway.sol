// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title Interface needed to call function registerTokenToL2 of the L1CustomGateway
 */
interface IL1CustomGateway {
    /**
     * @notice Allows L1 Token contract to trustlessly register its custom L2 counterpart, in an ERC20-based rollup. Retryable costs are paid in native token.
     * @param _l2Address counterpart address of L1 token
     * @param _maxGas max gas for L2 retryable execution
     * @param _gasPriceBid gas price for L2 retryable ticket
     * @param _maxSubmissionCost base submission cost for L2 retryable ticket
     * @param _creditBackAddress address for crediting back overpayment of _maxSubmissionCost
     * @param _feeAmount total amount of fees in native token to cover for retryable ticket costs. This amount will be transferred from user to bridge.
     * @return Retryable ticket ID
    **/
    function registerTokenToL2(
        address _l2Address,
        uint256 _maxGas,
        uint256 _gasPriceBid,
        uint256 _maxSubmissionCost,
        address _creditBackAddress,
        uint256 _feeAmount
    ) external payable returns (uint256);
}