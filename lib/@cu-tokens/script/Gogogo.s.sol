// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

// forge-ignore: 5574

import {console} from '../lib/forge-std/src/console.sol';
import {Gogogo} from '../lib/@lagunagames/lg-diamond-template/script/Gogogo.s.sol';
import {Script} from '../lib/forge-std/src/Script.sol';
import {ERC20Facet} from '../src/facets/ERC20Facet.sol';
import {ERC20InitializerFacet} from '../src/facets/ERC20InitializerFacet.sol';
import {CutERC20Diamond} from '../src/implementation/CutERC20Diamond.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {IERC20} from '../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import {IERC20Metadata} from '../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';

/// @title Deploy A Terminus Diamond
/// @notice Deploys and initializes the diamond
contract DeployProject is Script {
    address public deployedDiamond;

    function setUp() public {}

    function addERC20ToDiamond(address diamond, string memory tokenName, string memory tokenSymbol) public {
        address deployerAddress = vm.envAddress('DEPLOYER_ADDRESS');
        vm.startBroadcast(deployerAddress);

        CutERC20Diamond cutDiamond = CutERC20Diamond(address(diamond));

        console.logString('Deploying new ERC20Facet...');
        address erc20Facet = address(new ERC20Facet());
        console.logAddress(erc20Facet);

        IDiamondCut.FacetCut memory erc20FacetCut = IDiamondCut.FacetCut({
            facetAddress: erc20Facet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](12)
        });
        erc20FacetCut.functionSelectors[0] = ERC20Facet.name.selector;
        erc20FacetCut.functionSelectors[1] = ERC20Facet.symbol.selector;
        erc20FacetCut.functionSelectors[2] = ERC20Facet.contractController.selector;
        erc20FacetCut.functionSelectors[3] = ERC20Facet.allowance.selector;
        erc20FacetCut.functionSelectors[4] = ERC20Facet.approve.selector;
        erc20FacetCut.functionSelectors[5] = ERC20Facet.totalSupply.selector;
        erc20FacetCut.functionSelectors[6] = ERC20Facet.balanceOf.selector;
        erc20FacetCut.functionSelectors[7] = ERC20Facet.decimals.selector;
        erc20FacetCut.functionSelectors[8] = ERC20Facet.transferFrom.selector;
        erc20FacetCut.functionSelectors[9] = ERC20Facet.transfer.selector;
        erc20FacetCut.functionSelectors[10] = ERC20Facet.increaseAllowance.selector;
        erc20FacetCut.functionSelectors[11] = ERC20Facet.decreaseAllowance.selector;

        console.log('Deploying new ERC20InitializerFacet...');
        address erc20InitializerFacet = address(new ERC20InitializerFacet());
        console.logAddress(erc20InitializerFacet);

        IDiamondCut.FacetCut memory erc20InitializerFacetCut = IDiamondCut.FacetCut({
            facetAddress: erc20InitializerFacet,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](1)
        });
        erc20InitializerFacetCut.functionSelectors[0] = ERC20InitializerFacet.initERC20Attributes.selector;

        console.log('Cutting facets into the diamond...');
        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](2);
        cuts[0] = erc20FacetCut;
        cuts[1] = erc20InitializerFacetCut;
        cutDiamond.diamondCut(cuts);

        console.logString('Calling ERC20 initializer...');
        ERC20InitializerFacet initializer = ERC20InitializerFacet(address(cutDiamond));
        initializer.initERC20Attributes(tokenName, tokenSymbol);

        console.logString('Detaching initializer...');
        cutDiamond.cutFacet(erc20InitializerFacet);

        console.logString('Setting supportsInterface selectors...');
        cutDiamond.setSupportsInterface(type(IERC20).interfaceId, true);
        cutDiamond.setSupportsInterface(type(IERC20Metadata).interfaceId, true);

        vm.stopBroadcast();
    }

    function run() public {
        address deployerAddress = vm.envAddress('DEPLOYER_ADDRESS');
        string memory name = vm.envString('ERC20_NAME');
        string memory symbol = vm.envString('ERC20_SYMBOL');

        //  Deploy a basic LG diamond
        Gogogo gogogo = new Gogogo();
        gogogo.run();
        deployedDiamond = gogogo.deployedDiamond();
        CutERC20Diamond cutDiamond = CutERC20Diamond(address(deployedDiamond));

        addERC20ToDiamond(address(deployedDiamond), name, symbol);

        vm.startBroadcast(deployerAddress);

        console.logString('Deploying new CutERC20Diamond interface contract at...');
        address implementation = address(new CutERC20Diamond());
        console.logAddress(implementation);

        console.logString('Setting implementation address...');
        cutDiamond.setImplementation(implementation);

        vm.stopBroadcast();
    }
}
