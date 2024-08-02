// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {ServerSideSigningInitializerFacet} from '../src/facets/ServerSideSigningInitializerFacet.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutDiamond} from '../lib/@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';

/// @title Helper script to attach ServerSideSigningInitializerFacet to a Diamond
/// @author rsampson@laguna.games
contract ServerSideSigningInitializerUtil is Script {
    /// @notice Attach the ServerSideSigningInitializerFacet to a diamond
    /// @param diamond The diamond to attach the ServerSideSigningInitializerFacet to
    function attachServerSideSigningInitializerFacetToDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));
        console.logString('Deploying new ServerSideSigningInitializerFacet at...');
        address serverSideSigningInitializerFacetAddress = address(new ServerSideSigningInitializerFacet());
        console.logAddress(serverSideSigningInitializerFacetAddress);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: serverSideSigningInitializerFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](1)
        });
        cuts[0].functionSelectors[0] = ServerSideSigningInitializerFacet.initializeSSS.selector;

        CutDiamond(diamond).diamondCut(cuts);
        vm.stopBroadcast();
    }

    /// @notice Execute the SSS initializer
    /// @dev Requires the environment var SSS_PROJECT_NAME (usually "Crypto Unicorns")
    /// @dev Requres the environment var SSS_DOMAIN_SEPARATOR_VERSION (usually "0.0.1")
    function initializeSSS(address diamond) public {
        require(
            vm.envOr('SSS_PROJECT_NAME', address(0)) != address(0),
            'Environment variable not set: SSS_PROJECT_NAME'
        );

        require(
            vm.envOr('SSS_DOMAIN_SEPARATOR_VERSION', address(0)) != address(0),
            'Environment variable not set: SSS_DOMAIN_SEPARATOR_VERSION'
        );

        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        ServerSideSigningInitializerFacet(diamond).initializeSSS(
            vm.envString('SSS_PROJECT_NAME'),
            vm.envString('SSS_DOMAIN_SEPARATOR_VERSION')
        );

        vm.stopBroadcast();
    }
}
