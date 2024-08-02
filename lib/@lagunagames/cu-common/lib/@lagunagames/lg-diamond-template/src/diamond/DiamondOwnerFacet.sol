// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '../libraries/LibContractOwner.sol';
import '../interfaces/IERC173.sol';

/// @title LG implementation of ERC-173 Contract Ownership Standard
/// @author rsampson@laguna.games
contract DiamondOwnerFacet is ERC173 {
    /// @notice Get the address of the owner
    /// @return The address of the owner.
    function owner() external view returns (address) {
        return LibContractOwner.contractOwner();
    }

    /// @notice Set the address of the new owner of the contract
    /// @dev Set _newOwner to address(0) to renounce any ownership.
    /// @param _newOwner The address of the new owner of the contract
    function transferOwnership(address _newOwner) external {
        LibContractOwner.enforceIsContractOwner();
        LibContractOwner.setContractOwner(_newOwner);
    }
}