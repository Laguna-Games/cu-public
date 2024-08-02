// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {AccessBadgeFacet} from '../src/facets/AccessBadgeFacet.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutDiamond} from '../lib/@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';

/// @title Helper script to attach AccessBadgeFacet to a Diamond
/// @author rsampson@laguna.games
contract AccessBadgeUtil is Script {
    /// @notice Attach the AccessBadgeFacet to a diamond
    /// @param diamond The diamond to attach the AccessBadgeFacet to
    function attachAccessBadgeFacetToDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));
        console.logString('Deploying new AccessBadgeFacet at...');
        address accessBadgeFacetAddress = address(new AccessBadgeFacet());
        console.logAddress(accessBadgeFacetAddress);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: accessBadgeFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](6)
        });

        cuts[0].functionSelectors[0] = AccessBadgeFacet.getPoolByName.selector;
        cuts[0].functionSelectors[1] = AccessBadgeFacet.setPoolName.selector;
        cuts[0].functionSelectors[2] = AccessBadgeFacet.requireBadge.selector;
        cuts[0].functionSelectors[3] = AccessBadgeFacet.requireBadgeById.selector;
        cuts[0].functionSelectors[4] = AccessBadgeFacet.hasBadge.selector;
        cuts[0].functionSelectors[5] = AccessBadgeFacet.hasBadgeById.selector;

        CutDiamond(diamond).diamondCut(cuts);
        vm.stopBroadcast();
    }
}
