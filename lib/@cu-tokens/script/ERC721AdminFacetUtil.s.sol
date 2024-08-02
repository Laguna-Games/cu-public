// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {ERC721AdminFacet} from '../src/facets/ERC721AdminFacet.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutDiamond} from '../lib/@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';

/// @title Helper script to attach ERC721AdminFacet to a Diamond
/// @author rsampson@laguna.games
contract ERC721AdminFacetUtil is Script {
    address public facetAddress;

    /// @notice Attach the ERC721AdminFacet to a diamond
    /// @param diamond The diamond to attach the ERC721AdminFacet to
    function attachERC721AdminFacetToDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        if (!vm.envOr('QUIET_MODE', false)) console.logString('Deploying new ERC721AdminFacet at...');
        facetAddress = address(new ERC721AdminFacet());
        if (!vm.envOr('QUIET_MODE', false)) console.logAddress(facetAddress);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: facetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](4)
        });
        cuts[0].functionSelectors[0] = ERC721AdminFacet.setName.selector;
        cuts[0].functionSelectors[1] = ERC721AdminFacet.setSymbol.selector;
        cuts[0].functionSelectors[2] = ERC721AdminFacet.setContractURI.selector;
        cuts[0].functionSelectors[3] = ERC721AdminFacet.setLicense.selector;

        CutDiamond(diamond).diamondCut(cuts);
        vm.stopBroadcast();
    }

    // @notice Remove the ERC721AdminFacet from a diamond
    // @param diamond The diamond to remove the ERC721AdminFacet from
    function detachERC721AdminFacetFromDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        address facet = CutDiamond(diamond).facetAddress(ERC721AdminFacet.setName.selector);
        if (facet == address(0)) facet = CutDiamond(diamond).facetAddress(ERC721AdminFacet.setSymbol.selector);
        if (facet == address(0)) facet = CutDiamond(diamond).facetAddress(ERC721AdminFacet.setContractURI.selector);
        if (facet == address(0)) facet = CutDiamond(diamond).facetAddress(ERC721AdminFacet.setLicense.selector);

        if (facet == address(0)) {
            if (!vm.envOr('QUIET_MODE', false))
                console.logString('No ERC721AdminFacet found on diamond - nothing to detach');
            return;
        }

        CutDiamond(diamond).cutFacet(facet);
        vm.stopBroadcast();
    }

    // add this to be excluded from coverage report
    function test() public {}
}
