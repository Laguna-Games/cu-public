// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/*
 * @dev ArbSysMock is a mock contract for the ArbSys interface that exists on all the Arbitrum chains.
 * It's used to mock the pre-compiled stateless contract on the Foundry EVM while running scripts and tests.
 */
contract ArbSysMock {
    function arbChainID() external view returns (uint256) {
        return block.chainid;
    }

    function arbBlockNumber() external view returns (uint256) {
        return block.number;
    }
}
