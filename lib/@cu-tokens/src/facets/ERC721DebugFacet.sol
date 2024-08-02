// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibTestnetDebugInterface} from '../../lib/@lagunagames/cu-common/src/libraries/LibTestnetDebugInterface.sol';
import {LibERC721} from '../libraries/LibERC721.sol';
import {LibValidate} from '../../lib/@lagunagames/cu-common/src/libraries/LibValidate.sol';
import {LibContractOwner} from '../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol';

/// @title Debug Facet for "Access Control Badges" Terminus Diamond
/// @dev This facet is intended to be used on Arbitrum-Sepolia, Xai-Sepolia, and localhost networks ONLY!
contract ERC721DebugFacet {
    function debugMint(address receiver) external {
        LibTestnetDebugInterface.enforceDebugger();
        LibERC721.mintNextToken(receiver);
    }

    function debugBurn(uint256 tokenId) external {
        if (LibContractOwner.contractOwner() != msg.sender && LibERC721.ownerOf(tokenId) != msg.sender) {
            LibTestnetDebugInterface.enforceAdmin();
        }

        LibERC721.burn(tokenId);
    }

    function debugSetTokenURI(uint256 tokenId, string calldata tokenURI) external {
        LibTestnetDebugInterface.enforceAdmin();
        LibERC721.setTokenURI(tokenId, tokenURI);
    }
}
