// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import {LibERC20} from '../libraries/LibERC20.sol';
import {LibContractOwner} from '../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol';

contract ERC20InitializerFacet {
    function initERC20Attributes(string memory _name, string memory _symbol) external virtual {
        LibContractOwner.enforceIsContractOwner();

        LibERC20.ERC20Storage storage es = LibERC20.erc20Storage();
        es.controller = msg.sender;
        es.name = _name;
        es.symbol = _symbol;
    }
}
