// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutDiamond} from '../lib/@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';
import {SupraVRFAdminFacet} from '../src/facets/SupraVRFAdminFacet.sol';

/// @title Helper script to attach SupraVRFAdminFacet to a Diamond
/// @author rsampson@laguna.games
contract SupraVRFAdminUtil is Script {
    /// @notice Attach the SupraVRFAdminFacet to a diamond
    /// @param diamond The diamond to attach the SupraVRFAdminFacet to
    function attachSupraVRFAdminFacetToDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));
        console.logString('Deploying new SupraVRFAdminFacet at...');
        address supraVRFAdminFacetAddress = address(new SupraVRFAdminFacet());
        console.logAddress(supraVRFAdminFacetAddress);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: supraVRFAdminFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](5)
        });
        cuts[0].functionSelectors[0] = SupraVRFAdminFacet.getVRFBlocksToRespond.selector;
        cuts[0].functionSelectors[1] = SupraVRFAdminFacet.setVRFBlocksToRespond.selector;
        cuts[0].functionSelectors[2] = SupraVRFAdminFacet.vrfClientWallet.selector;
        cuts[0].functionSelectors[3] = SupraVRFAdminFacet.setVRFClientWallet.selector;
        cuts[0].functionSelectors[4] = SupraVRFAdminFacet.vrfRequestBlock.selector;

        CutDiamond(diamond).diamondCut(cuts);
        vm.stopBroadcast();
    }
}
