// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
// forge-ignore: 5574

import 'forge-std/Script.sol';
import '../src/diamond/DiamondCutFacet.sol';
import '../src/diamond/LGDiamond.sol';
import '../src/diamond/DiamondLoupeFacet.sol';
import '../src/diamond/CutDiamond.sol';
import '../src/diamond/DiamondOwnerFacet.sol';
import '../src/diamond/DiamondProxyFacet.sol';
import '../src/diamond/SupportsInterfaceFacet.sol';
import '../src/interfaces/IERC173.sol';
import 'forge-std/console.sol';

/// @title Gogogo
/// @notice Deploys and initializes a Diamond
contract Gogogo is Script {
    address public deployedDiamond;

    function setUp() public {}

    function gogogo() public returns (address diamondAddress) {
        //  Get DIAMOND_CUT_FACET from .env or --diamond-cut-facet from CLI
        address diamondCutFacetAddress = vm.envOr('DIAMOND_CUT_FACET', address(0));
        if (diamondCutFacetAddress == address(0)) diamondCutFacetAddress = vm.envOr('diamond-cut-facet', address(0));
        if (diamondCutFacetAddress == address(0)) {
            //  no diamondCutFacetAddress specified, deploy a new facet
            console.logString('Deploying new DiamondCutFacet at...');
            diamondCutFacetAddress = address(new DiamondCutFacet());
            console.logAddress(diamondCutFacetAddress);
        } else if (diamondCutFacetAddress.code.length == 0) {
            revert(string.concat('DiamondCutFacet has no code: ', vm.toString(diamondCutFacetAddress)));
        } else {
            console.logString(
                string.concat('Using pre-deployed DiamondCutFacet: ', vm.toString(diamondCutFacetAddress))
            );
        }
        IDiamondCut.FacetCut memory diamondCutFacetCut = IDiamondCut.FacetCut({
            facetAddress: diamondCutFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](6)
        });
        // NOTE: IDiamondCut.diamondCut.selector (0x1f931c1c) is injected automatically by the diamond constructor
        diamondCutFacetCut.functionSelectors[0] = 0xe57e69c6; // bytes4(keccak256("diamondCut((address,uint8,bytes4[])[])"))
        diamondCutFacetCut.functionSelectors[1] = DiamondCutFacet.cutSelector.selector;
        diamondCutFacetCut.functionSelectors[2] = DiamondCutFacet.deleteSelector.selector;
        diamondCutFacetCut.functionSelectors[3] = DiamondCutFacet.cutSelectors.selector;
        diamondCutFacetCut.functionSelectors[4] = DiamondCutFacet.deleteSelectors.selector;
        diamondCutFacetCut.functionSelectors[5] = DiamondCutFacet.cutFacet.selector;

        //  Get DIAMOND_LOUPE_FACET from .env or --diamond-loupe-facet from CLI
        address diamondLoupeFacetAddress = vm.envOr('DIAMOND_LOUPE_FACET', address(0));
        if (diamondLoupeFacetAddress == address(0))
            diamondLoupeFacetAddress = vm.envOr('diamond-loupe-facet', address(0));
        if (diamondLoupeFacetAddress == address(0)) {
            //  no diamondLoupeFacetAddress specified, deploy a new facet
            console.logString('Deploying new DiamondLoupeFacet at...');
            diamondLoupeFacetAddress = address(new DiamondLoupeFacet());
            console.logAddress(diamondLoupeFacetAddress);
        } else if (diamondLoupeFacetAddress.code.length == 0) {
            revert(string.concat('DiamondLoupeFacet has no code: ', vm.toString(diamondLoupeFacetAddress)));
        } else {
            console.logString(
                string.concat('Using pre-deployed DiamondLoupeFacet: ', vm.toString(diamondLoupeFacetAddress))
            );
        }
        IDiamondCut.FacetCut memory diamondLoupeFacetCut = IDiamondCut.FacetCut({
            facetAddress: diamondLoupeFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](4)
        });
        diamondLoupeFacetCut.functionSelectors[0] = DiamondLoupeFacet.facets.selector;
        diamondLoupeFacetCut.functionSelectors[1] = DiamondLoupeFacet.facetFunctionSelectors.selector;
        diamondLoupeFacetCut.functionSelectors[2] = DiamondLoupeFacet.facetAddresses.selector;
        diamondLoupeFacetCut.functionSelectors[3] = DiamondLoupeFacet.facetAddress.selector;

        //  Get DIAMOND_PROXY_FACET from .env or --diamond-proxy-facet from CLI
        address diamondProxyFacetAddress = vm.envOr('DIAMOND_PROXY_FACET', address(0));
        if (diamondProxyFacetAddress == address(0))
            diamondProxyFacetAddress = vm.envOr('diamond-proxy-facet', address(0));
        if (diamondProxyFacetAddress == address(0)) {
            //  no diamondProxyFacetAddress specified, deploy a new facet
            console.logString('Deploying new DiamondProxyFacet at...');
            diamondProxyFacetAddress = address(new DiamondProxyFacet());
            console.logAddress(diamondProxyFacetAddress);
        } else if (diamondProxyFacetAddress.code.length == 0) {
            revert(string.concat('DiamondProxyFacet has no code: ', vm.toString(diamondProxyFacetAddress)));
        } else {
            console.logString(
                string.concat('Using pre-deployed DiamondProxyFacet: ', vm.toString(diamondProxyFacetAddress))
            );
        }
        IDiamondCut.FacetCut memory diamondProxyFacetCut = IDiamondCut.FacetCut({
            facetAddress: diamondProxyFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](2)
        });
        diamondProxyFacetCut.functionSelectors[0] = DiamondProxyFacet.setImplementation.selector;
        diamondProxyFacetCut.functionSelectors[1] = DiamondProxyFacet.implementation.selector;

        //  Get DIAMOND_OWNER_FACET from .env or --diamond-owner-facet from CLI
        address diamondOwnerFacetAddress = vm.envOr('DIAMOND_OWNER_FACET', address(0));
        if (diamondOwnerFacetAddress == address(0))
            diamondOwnerFacetAddress = vm.envOr('diamond-owner-facet', address(0));
        if (diamondOwnerFacetAddress == address(0)) {
            //  no diamondOwnerFacetAddress specified, deploy a new facet
            console.logString('Deploying new DiamondOwnerFacet at...');
            diamondOwnerFacetAddress = address(new DiamondOwnerFacet());
            console.logAddress(diamondOwnerFacetAddress);
        } else if (diamondOwnerFacetAddress.code.length == 0) {
            revert(string.concat('DiamondOwnerFacet has no code: ', vm.toString(diamondOwnerFacetAddress)));
        } else {
            console.logString(
                string.concat('Using pre-deployed DiamondOwnerFacet: ', vm.toString(diamondOwnerFacetAddress))
            );
        }
        IDiamondCut.FacetCut memory diamondOwnerFacetCut = IDiamondCut.FacetCut({
            facetAddress: diamondOwnerFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](2)
        });
        diamondOwnerFacetCut.functionSelectors[0] = DiamondOwnerFacet.owner.selector;
        diamondOwnerFacetCut.functionSelectors[1] = DiamondOwnerFacet.transferOwnership.selector;

        //  Get SUPPORTS_INTERFACE_FACET from .env or --supports-interface-facet from CLI
        address supportsInterfaceFacetAddress = vm.envOr('SUPPORTS_INTERFACE_FACET', address(0));
        if (supportsInterfaceFacetAddress == address(0))
            supportsInterfaceFacetAddress = vm.envOr('supports-interface-facet', address(0));
        if (supportsInterfaceFacetAddress == address(0)) {
            //  no supportsInterfaceFacetAddress specified, deploy a new facet
            console.logString('Deploying new SupportsInterfaceFacet at...');
            supportsInterfaceFacetAddress = address(new SupportsInterfaceFacet());
            console.logAddress(supportsInterfaceFacetAddress);
        } else if (supportsInterfaceFacetAddress.code.length == 0) {
            revert(string.concat('SupportsInterfaceFacet has no code: ', vm.toString(supportsInterfaceFacetAddress)));
        } else {
            console.logString(
                string.concat('Using pre-deployed SupportsInterfaceFacet: ', vm.toString(supportsInterfaceFacetAddress))
            );
        }
        IDiamondCut.FacetCut memory supportsInterfaceFacetCut = IDiamondCut.FacetCut({
            facetAddress: supportsInterfaceFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](4)
        });
        supportsInterfaceFacetCut.functionSelectors[0] = SupportsInterfaceFacet.supportsInterface.selector;
        supportsInterfaceFacetCut.functionSelectors[1] = SupportsInterfaceFacet.setSupportsInterface.selector;
        supportsInterfaceFacetCut.functionSelectors[2] = SupportsInterfaceFacet.setSupportsInterfaces.selector;
        supportsInterfaceFacetCut.functionSelectors[3] = SupportsInterfaceFacet.interfaces.selector;

        //  Get DUMMY_INTERFACE_CONTRACT from .env or --dummy-interface-contract from CLI
        address implementation = vm.envOr('DUMMY_INTERFACE_CONTRACT', address(0));
        if (implementation == address(0)) implementation = vm.envOr('dummy-interface-contract', address(0));
        if (implementation == address(0)) {
            //  no dummyInterfaceContractAddress specified, deploy a new facet
            console.logString('Deploying new CutDiamond interface contract at...');
            implementation = address(new CutDiamond());
            console.logAddress(implementation);
        } else if (implementation.code.length == 0) {
            revert(string.concat('DummyInterfaceContract has no code: ', vm.toString(implementation)));
        } else {
            console.logString(
                string.concat('Using pre-deployed DummyInterfaceContract: ', vm.toString(implementation))
            );
        }

        // Deploy Diamond
        Diamond diamond = new Diamond(diamondCutFacetAddress);
        diamondAddress = address(diamond);
        console.logString(string.concat('Deployed new Diamond at: ', vm.toString(address(diamond))));

        // Cast the diamond to use the CutDiamond interface
        CutDiamond cutDiamond = CutDiamond(address(diamond));

        console.logString('Cutting facets into the diamond...');
        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](5);
        cuts[0] = diamondCutFacetCut;
        cuts[1] = diamondLoupeFacetCut;
        cuts[2] = diamondProxyFacetCut;
        cuts[3] = diamondOwnerFacetCut;
        cuts[4] = supportsInterfaceFacetCut;
        cutDiamond.diamondCut(cuts, address(0), '');

        console.logString('Setting supportsInterface selectors...');
        bytes4[] memory interfaceIds = new bytes4[](4);
        interfaceIds[0] = type(IERC165).interfaceId;
        interfaceIds[1] = type(IDiamondCut).interfaceId;
        interfaceIds[2] = type(IDiamondLoupe).interfaceId;
        interfaceIds[3] = type(ERC173).interfaceId;
        cutDiamond.setSupportsInterfaces(interfaceIds, true);

        console.logString('Setting implementation address...');
        cutDiamond.setImplementation(implementation);

        //  TODO: Use vm.ffi to send a CURL command to Etherscan API: verifyproxycontract()

        return diamondAddress;
    }

    function run() public {
        address deployerAddress = vm.envAddress('DEPLOYER_ADDRESS');
        vm.startBroadcast(deployerAddress);

        address diamond = gogogo();
        deployedDiamond = address(diamond);

        vm.stopBroadcast();
    }

    // add this to be excluded from coverage report
    function test() public {}
}
