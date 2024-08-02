// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import '../interfaces/IDiamondLoupe.sol';
import '../interfaces/IDiamondCut.sol';
import '../interfaces/IERC165.sol';
import '../libraries/LibSupportsInterface.sol';

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract CutDiamond is IERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
        return (interfaceID == type(IERC165).interfaceId);
    }

    /// @notice Add/replace/remove any number of functions and optionally execute
    ///         a function with delegatecall
    /// @param _diamondCut Contains the facet addresses and function selectors
    /// @param _init The address of the contract or facet to execute _calldata
    /// @param _calldata A function call, including function selector and arguments
    ///                  _calldata is executed with delegatecall on _init
    function diamondCut(
        IDiamondCut.FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external {}

    /// @notice Add/replace/remove any number of functions and optionally execute
    ///         a function with delegatecall
    /// @dev This is a convenience implementation of the above
    /// @param _diamondCut Contains the facet addresses and function selectors
    function diamondCut(IDiamondCut.FacetCut[] calldata _diamondCut) external {}

    /// @notice Removes one selector from the Diamond, using DiamondCut
    /// @param selector - The byte4 signature for a method selector to remove
    /// @custom:emits FacetCutAction
    function cutSelector(bytes4 selector) external {}

    /// @notice Removes one selector from the Diamond, using removeFunction()
    /// @param selector - The byte4 signature for a method selector to remove
    function deleteSelector(bytes4 selector) external {}

    /// @notice Removes many selectors from the Diamond, using DiamondCut
    /// @param selectors - Array of byte4 signatures for method selectors to remove
    /// @custom:emits FacetCutAction
    function cutSelectors(bytes4[] memory selectors) external {}

    /// @notice Removes many selectors from the Diamond, using removeFunctions()
    /// @param selectors - Array of byte4 signatures for method selectors to remove
    function deleteSelectors(bytes4[] memory selectors) external {}

    /// @notice Removes any selectors from the Diamond that come from a target
    /// @notice contract address, using DiamondCut.
    /// @param facet - The address of the Facet smart contract to remove
    /// @custom:emits FacetCutAction
    function cutFacet(address facet) external {}

    /// @notice Gets all facets and their selectors.
    /// @return facets_ Facet
    function facets() external view returns (IDiamondLoupe.Facet[] memory facets_) {}

    /// @notice Gets all the function selectors provided by a facet.
    /// @param _facet The facet address.
    /// @return facetFunctionSelectors_
    function facetFunctionSelectors(address _facet) external view returns (bytes4[] memory facetFunctionSelectors_) {}

    /// @notice Get all the facet addresses used by a diamond.
    /// @return facetAddresses_
    function facetAddresses() external view returns (address[] memory facetAddresses_) {}

    /// @notice Gets the facet that supports the given selector.
    /// @dev If facet is not found return address(0).
    /// @param _functionSelector The function selector.
    /// @return facetAddress_ The facet address.
    function facetAddress(bytes4 _functionSelector) external view returns (address facetAddress_) {}

    /// @notice Get the address of the owner
    /// @return The address of the owner.
    function owner() external view returns (address) {}

    /// @notice Set the address of the new owner of the contract
    /// @dev Set _newOwner to address(0) to renounce any ownership.
    /// @param _newOwner The address of the new owner of the contract
    function transferOwnership(address _newOwner) external {}

    /// @notice Set the dummy "implementation" contract address
    /// @custom:emits Upgraded
    function setImplementation(address _implementation) external {}

    /// @notice Get the dummy "implementation" contract address
    /// @return The dummy "implementation" contract address
    function implementation() external view returns (address) {}

    /// @notice Set whether an interface is implemented
    /// @dev Only the contract owner can call this function
    /// @param interfaceID The interface identifier, as specified in ERC-165
    /// @param implemented `true` if the contract implements `interfaceID`
    function setSupportsInterface(bytes4 interfaceID, bool implemented) external {}

    /// @notice Set a list of interfaces as implemented or not
    /// @dev Only the contract owner can call this function
    /// @param interfaceIDs The interface identifiers, as specified in ERC-165
    /// @param allImplemented `true` if the contract implements all interfaces
    function setSupportsInterfaces(bytes4[] calldata interfaceIDs, bool allImplemented) external {}

    /// @notice Returns a list of interfaces that have (ever) been supported
    /// @return The list of interfaces
    function interfaces() external view returns (LibSupportsInterface.KnownInterface[] memory) {}
}
