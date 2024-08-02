// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {LibERC721} from '../libraries/LibERC721.sol';
import {LibContractOwner} from '../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol';

contract ERC721AdminFacet {
    function setName(string calldata name) external {
        LibContractOwner.enforceIsContractOwner();
        LibERC721.erc721Storage().name = name;
    }

    function setSymbol(string calldata symbol) external {
        LibContractOwner.enforceIsContractOwner();
        LibERC721.erc721Storage().symbol = symbol;
    }

    function setContractURI(string memory uri) external {
        LibContractOwner.enforceIsContractOwner();
        LibERC721.erc721Storage().contractURI = uri;
    }

    function setLicense(string memory uri) external {
        LibContractOwner.enforceIsContractOwner();
        LibERC721.erc721Storage().licenseURI = uri;
    }
}
