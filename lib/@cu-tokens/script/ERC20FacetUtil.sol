// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {ERC20Facet} from '../src/facets/ERC20Facet.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutERC20Diamond} from '../src/implementation/CutERC20Diamond.sol';
import {IERC20} from '../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from '../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import {ERC20InitializerFacetUtil} from './ERC20InitializerFacetUtil.sol';
import {ERC20InitializerFacet} from '../src/facets/ERC20InitializerFacet.sol';

/// @title Helper script to attach ERC20Facet to a Diamond
/// @author rsampson@laguna.games
contract ERC20FacetUtil is Script {
    address public facetAddress;

    /// @notice Attach the ERC20Facet to a diamond
    /// @param diamond The diamond to attach the ERC20Facet to
    function attachERC20FacetToDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        if (!vm.envOr('QUIET_MODE', false)) console.logString('Deploying new ERC20Facet at...');
        facetAddress = address(new ERC20Facet());
        if (!vm.envOr('QUIET_MODE', false)) console.logAddress(facetAddress);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: facetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](12)
        });
        cuts[0].functionSelectors[0] = ERC20Facet.name.selector;
        cuts[0].functionSelectors[1] = ERC20Facet.symbol.selector;
        cuts[0].functionSelectors[2] = ERC20Facet.contractController.selector;
        cuts[0].functionSelectors[3] = ERC20Facet.allowance.selector;
        cuts[0].functionSelectors[4] = ERC20Facet.approve.selector;
        cuts[0].functionSelectors[5] = ERC20Facet.totalSupply.selector;
        cuts[0].functionSelectors[6] = ERC20Facet.balanceOf.selector;
        cuts[0].functionSelectors[7] = ERC20Facet.decimals.selector;
        cuts[0].functionSelectors[8] = ERC20Facet.transferFrom.selector;
        cuts[0].functionSelectors[9] = ERC20Facet.transfer.selector;
        cuts[0].functionSelectors[10] = ERC20Facet.increaseAllowance.selector;
        cuts[0].functionSelectors[11] = ERC20Facet.decreaseAllowance.selector;

        CutERC20Diamond(diamond).diamondCut(cuts);

        CutERC20Diamond(diamond).setSupportsInterface(type(IERC20).interfaceId, true);
        CutERC20Diamond(diamond).setSupportsInterface(type(IERC20Metadata).interfaceId, true);

        vm.stopBroadcast();
    }

    /// @notice Configure the metadata for an ERC20 Token
    /// @param diamond The diamond to configure
    /// @param name The name of the diamond (ex. "Crypto Unicorns")
    /// @param symbol The symbol of the diamond (ex. "UNICORNS")
    function configureERC20Diamond(address diamond, string memory name, string memory symbol) public {
        ERC20InitializerFacetUtil util = new ERC20InitializerFacetUtil();
        util.attachERC20InitializerFacetToDiamond(diamond);

        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));
        ERC20InitializerFacet(diamond).initERC20Attributes(name, symbol);
        vm.stopBroadcast();

        if (!vm.envOr('QUIET_MODE', false)) {
            console.log(string.concat('Token name: ', IERC20Metadata(diamond).name()));
            console.log(string.concat('Token symbol: ', IERC20Metadata(diamond).symbol()));
        }

        util.detachERC20InitializerFacetFromDiamond(diamond);
    }

    /// @notice Deploy the ERC-1967 "implementation" contract
    function setDebugImplementation(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        console.logString('Deploying new CutERC20Diamond interface contract at...');
        address implementation = address(new CutERC20Diamond());
        console.logAddress(implementation);

        console.logString('Setting implementation address...');
        CutERC20Diamond(diamond).setImplementation(implementation);
        vm.stopBroadcast();
    }

    // add this to be excluded from coverage report
    function test() public {}
}
