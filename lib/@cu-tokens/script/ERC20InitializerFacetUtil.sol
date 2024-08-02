// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {ERC20InitializerFacet} from '../src/facets/ERC20InitializerFacet.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutDiamond} from '../lib/@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';

/// @title Helper script to attach ERC20InitializerFacet to a Diamond
/// @author rsampson@laguna.games
contract ERC20InitializerFacetUtil is Script {
    address public facetAddress;

    /// @notice Attach the ERC20InitializerFacet to a diamond
    /// @param diamond The diamond to attach the ERC20InitializerFacet to
    function attachERC20InitializerFacetToDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        if (!vm.envOr('QUIET_MODE', false)) console.logString('Deploying new ERC20InitializerFacet at...');
        facetAddress = address(new ERC20InitializerFacet());
        if (!vm.envOr('QUIET_MODE', false)) console.logAddress(facetAddress);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: facetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](1)
        });
        cuts[0].functionSelectors[0] = ERC20InitializerFacet.initERC20Attributes.selector;

        CutDiamond(diamond).diamondCut(cuts);
        vm.stopBroadcast();
    }

    function initialize(address diamond, string memory name, string memory symbol) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));
        ERC20InitializerFacet(diamond).initERC20Attributes(name, symbol);
        vm.stopBroadcast();
    }

    // @notice Remove the ERC20InitializerFacet from a diamond
    // @param diamond The diamond to remove the ERC20InitializerFacet from
    function detachERC20InitializerFacetFromDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        address facet = CutDiamond(diamond).facetAddress(ERC20InitializerFacet.initERC20Attributes.selector);

        if (facet == address(0)) {
            if (!vm.envOr('QUIET_MODE', false))
                console.logString('No ERC20InitializerFacet found on diamond - nothing to detach');
            return;
        }

        CutDiamond(diamond).cutFacet(facet);
        vm.stopBroadcast();
    }

    // add this to be excluded from coverage report
    function test() public {}
}
