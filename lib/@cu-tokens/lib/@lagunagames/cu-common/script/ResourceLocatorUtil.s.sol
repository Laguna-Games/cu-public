// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {ResourceLocatorFacet} from '../src/facets/ResourceLocatorFacet.sol';
import {IResourceLocator} from '../src/interfaces/IResourceLocator.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutDiamond} from '../lib/@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';

/// @title Helper script to attach ResourceLocatorFacet to a Diamond
/// @author rsampson@laguna.games
contract ResourceLocatorUtil is Script {
    address public facet;

    /// @notice Returns a ResourceLocatorFacet instance, either defined by
    ///  the CLI or .env parameters, or if none is found, a new facet is deployed
    /// @return address The ResourceLocatorFacet address
    function getResourceLocatorFacet() public returns (address) {
        address resourceLocatorFacet = vm.envOr('RESOURCE_LOCATOR_FACET', address(0));
        if (resourceLocatorFacet == address(0)) {
            vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));
            console.logString('Deploying new ResourceLocatorFacet at...');
            resourceLocatorFacet = deployNewResourceLocatorFacet();
            console.logAddress(resourceLocatorFacet);
            vm.stopBroadcast();
        } else if (resourceLocatorFacet.code.length == 0) {
            revert(string.concat('ResourceLocatorFacet has no code: ', vm.toString(resourceLocatorFacet)));
        } else {
            console.logString(
                string.concat('Using pre-deployed ResourceLocatorFacet: ', vm.toString(resourceLocatorFacet))
            );
        }
        return resourceLocatorFacet;
    }

    /// @notice Attach the ResourceLocatorFacet to a diamond, and set supportsInterface for IResourceLocator
    /// @param diamond The diamond to attach the ResourceLocatorFacet to
    function attachResourceLocatorToDiamond(address diamond) public {
        facet = getResourceLocatorFacet();
        console.logAddress(facet);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: facet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](45)
        });
        cuts[0].functionSelectors[0] = ResourceLocatorFacet.unicornNFTAddress.selector;
        cuts[0].functionSelectors[1] = ResourceLocatorFacet.setUnicornNFTAddress.selector;
        cuts[0].functionSelectors[2] = ResourceLocatorFacet.landNFTAddress.selector;
        cuts[0].functionSelectors[3] = ResourceLocatorFacet.setLandNFTAddress.selector;
        cuts[0].functionSelectors[4] = ResourceLocatorFacet.shadowcornNFTAddress.selector;
        cuts[0].functionSelectors[5] = ResourceLocatorFacet.setShadowcornNFTAddress.selector;
        cuts[0].functionSelectors[6] = ResourceLocatorFacet.gemNFTAddress.selector;
        cuts[0].functionSelectors[7] = ResourceLocatorFacet.setGemNFTAddress.selector;
        cuts[0].functionSelectors[8] = ResourceLocatorFacet.ritualNFTAddress.selector;
        cuts[0].functionSelectors[9] = ResourceLocatorFacet.setRitualNFTAddress.selector;
        cuts[0].functionSelectors[10] = ResourceLocatorFacet.rbwTokenAddress.selector;
        cuts[0].functionSelectors[11] = ResourceLocatorFacet.setRBWTokenAddress.selector;
        cuts[0].functionSelectors[12] = ResourceLocatorFacet.cuTokenAddress.selector;
        cuts[0].functionSelectors[13] = ResourceLocatorFacet.setCUTokenAddress.selector;
        cuts[0].functionSelectors[14] = ResourceLocatorFacet.unimTokenAddress.selector;
        cuts[0].functionSelectors[15] = ResourceLocatorFacet.setUNIMTokenAddress.selector;
        cuts[0].functionSelectors[16] = ResourceLocatorFacet.wethTokenAddress.selector;
        cuts[0].functionSelectors[17] = ResourceLocatorFacet.setWETHTokenAddress.selector;
        cuts[0].functionSelectors[18] = ResourceLocatorFacet.darkMarkTokenAddress.selector;
        cuts[0].functionSelectors[19] = ResourceLocatorFacet.setDarkMarkTokenAddress.selector;
        cuts[0].functionSelectors[20] = ResourceLocatorFacet.unicornItemsAddress.selector;
        cuts[0].functionSelectors[21] = ResourceLocatorFacet.setUnicornItemsAddress.selector;
        cuts[0].functionSelectors[22] = ResourceLocatorFacet.shadowcornItemsAddress.selector;
        cuts[0].functionSelectors[23] = ResourceLocatorFacet.setShadowcornItemsAddress.selector;
        cuts[0].functionSelectors[24] = ResourceLocatorFacet.accessControlBadgeAddress.selector;
        cuts[0].functionSelectors[25] = ResourceLocatorFacet.setAccessControlBadgeAddress.selector;
        cuts[0].functionSelectors[26] = ResourceLocatorFacet.gameBankAddress.selector;
        cuts[0].functionSelectors[27] = ResourceLocatorFacet.setGameBankAddress.selector;
        cuts[0].functionSelectors[28] = ResourceLocatorFacet.satelliteBankAddress.selector;
        cuts[0].functionSelectors[29] = ResourceLocatorFacet.setSatelliteBankAddress.selector;
        cuts[0].functionSelectors[30] = ResourceLocatorFacet.playerProfileAddress.selector;
        cuts[0].functionSelectors[31] = ResourceLocatorFacet.setPlayerProfileAddress.selector;
        cuts[0].functionSelectors[32] = ResourceLocatorFacet.shadowForgeAddress.selector;
        cuts[0].functionSelectors[33] = ResourceLocatorFacet.setShadowForgeAddress.selector;
        cuts[0].functionSelectors[34] = ResourceLocatorFacet.darkForestAddress.selector;
        cuts[0].functionSelectors[35] = ResourceLocatorFacet.setDarkForestAddress.selector;
        cuts[0].functionSelectors[36] = ResourceLocatorFacet.gameServerSSSAddress.selector;
        cuts[0].functionSelectors[37] = ResourceLocatorFacet.setGameServerSSSAddress.selector;
        cuts[0].functionSelectors[38] = ResourceLocatorFacet.gameServerOracleAddress.selector;
        cuts[0].functionSelectors[39] = ResourceLocatorFacet.setGameServerOracleAddress.selector;
        cuts[0].functionSelectors[40] = ResourceLocatorFacet.testnetDebugRegistryAddress.selector;
        cuts[0].functionSelectors[41] = ResourceLocatorFacet.setTestnetDebugRegistryAddress.selector;
        cuts[0].functionSelectors[42] = ResourceLocatorFacet.vrfOracleAddress.selector;
        cuts[0].functionSelectors[43] = ResourceLocatorFacet.setVRFOracleAddress.selector;
        cuts[0].functionSelectors[44] = ResourceLocatorFacet.importResourcesFromDiamond.selector;

        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));
        CutDiamond(diamond).diamondCut(cuts);
        CutDiamond(diamond).setSupportsInterface(type(IResourceLocator).interfaceId, true);
        vm.stopBroadcast();
    }

    /// @notice Deploy a new ResourceLocatorFacet
    /// @return address The address of the new ResourceLocatorFacet
    function deployNewResourceLocatorFacet() public returns (address) {
        return address(new ResourceLocatorFacet());
    }
}
