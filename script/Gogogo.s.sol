// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
// forge-ignore: 5574

import 'lib/forge-std/src/Script.sol';
import {DeployProject} from 'lib/@cu-tokens/Script/Gogogo.s.sol';
import {CutDiamond} from '@lg-diamond-template/src/diamond/CutDiamond.sol';

import {IDiamondCut} from '@lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CUBridgeOFTFacet} from '../src/facets/bridge/CUBridgeOFTFacet.sol';
import {CUArbBridgeSenderFacet} from '../src/facets/bridge/CUArbBridgeSenderFacet.sol';
import {CUArbBridgeReceiverFacet} from '../src/facets/bridge/CUArbBridgeReceiverFacet.sol';
import {LzApp} from 'lib/@layerzerolabs/solidity-examples/contracts/lzApp/LzApp.sol';
import {NonblockingLzApp} from 'lib/@layerzerolabs/solidity-examples/contracts/lzApp/NonblockingLzApp.sol';
import {LibEnvironment} from 'lib/@lagunagames/cu-common/src/libraries/LibEnvironment.sol';
import {CUTokenImplementation} from '../src/implementation/CUTokenImplementation.sol';
import {wCUTokenImplementation} from '../src/implementation/wCUTokenImplementation.sol';

/// @title Deploy CU Diamond
/// @notice Deploys and initializes the diamond
/// @author Facundo Vidal
contract DeployCUProject is Script {
    //  @see https://layerzero.gitbook.io/docs/evm-guides/contract-standards/oft-overview/ierc165-oft-interface-ids
    bytes4 public constant OFTV2_INTERFACE_ID = 0x1f7ecdf7;

    address public deployedDiamond;

    function setUp() public {}

    function gogogoCreateCUBridgeOFT(
        address diamond
    )
        private
        returns (
            address cuBridgeOFTFacetAddress,
            CUBridgeOFTFacet cuBridgeOFTFacet,
            IDiamondCut.FacetCut memory cuBridgeOFTFacetCut
        )
    {
        console.logString('Deploying new CUBridgeOFTFacet at...');

        cuBridgeOFTFacetAddress = address(new CUBridgeOFTFacet());
        console.logAddress(cuBridgeOFTFacetAddress);

        console.logString('Attaching CUBridgeOFTFacet...');
        cuBridgeOFTFacetCut = IDiamondCut.FacetCut({
            facetAddress: cuBridgeOFTFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](7)
        });
        cuBridgeOFTFacetCut.functionSelectors[0] = CUBridgeOFTFacet.initLZOFTV2.selector;
        cuBridgeOFTFacetCut.functionSelectors[1] = LzApp.setMinDstGas.selector;
        cuBridgeOFTFacetCut.functionSelectors[2] = LzApp.getTrustedRemoteAddress.selector;
        cuBridgeOFTFacetCut.functionSelectors[3] = NonblockingLzApp.retryMessage.selector;
        cuBridgeOFTFacetCut.functionSelectors[4] = LzApp.lzReceive.selector;
        cuBridgeOFTFacetCut.functionSelectors[5] = NonblockingLzApp.nonblockingLzReceive.selector;
        cuBridgeOFTFacetCut.functionSelectors[6] = LzApp.setTrustedRemoteAddress.selector;

        cuBridgeOFTFacet = CUBridgeOFTFacet(diamond);
    }

    function gogogoCreateCUArbBridgeSender(
        address diamond
    )
        private
        returns (
            address cuArbBridgeSenderFacetAddress,
            CUArbBridgeSenderFacet cuArbBridgeSenderFacet,
            IDiamondCut.FacetCut memory cuArbBridgeSenderFacetCut
        )
    {
        console.logString('Deploying new CUArbBridgeSenderFacet at...');

        cuArbBridgeSenderFacetAddress = address(new CUArbBridgeSenderFacet());
        console.logAddress(cuArbBridgeSenderFacetAddress);

        console.logString('Attaching CUArbBridgeSenderFacet...');
        cuArbBridgeSenderFacetCut = IDiamondCut.FacetCut({
            facetAddress: cuArbBridgeSenderFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](4)
        });
        cuArbBridgeSenderFacetCut.functionSelectors[0] = CUArbBridgeSenderFacet.isArbitrumEnabled.selector;
        cuArbBridgeSenderFacetCut.functionSelectors[1] = CUArbBridgeSenderFacet.registerTokenOnL2.selector;
        cuArbBridgeSenderFacetCut.functionSelectors[2] = CUArbBridgeSenderFacet.setL1CustomGatewayAddress.selector;
        cuArbBridgeSenderFacetCut.functionSelectors[3] = CUArbBridgeSenderFacet.setL1RouterAddress.selector;

        cuArbBridgeSenderFacet = CUArbBridgeSenderFacet(diamond);
    }

    function gogogoCreateCUArbBridgeReceiver(
        address diamond
    )
        private
        returns (
            address cuArbBridgeReceiverFacetAddress,
            CUArbBridgeReceiverFacet cuArbBridgeReceiverFacet,
            IDiamondCut.FacetCut memory cuArbBridgeReceiverFacetCut
        )
    {
        console.logString('Deploying new CUArbBridgeReceiverFacet at...');

        cuArbBridgeReceiverFacetAddress = address(new CUArbBridgeReceiverFacet());
        console.logAddress(cuArbBridgeReceiverFacetAddress);

        console.logString('Attaching CUArbBridgeReceiverFacet...');
        cuArbBridgeReceiverFacetCut = IDiamondCut.FacetCut({
            facetAddress: cuArbBridgeReceiverFacetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](6)
        });
        cuArbBridgeReceiverFacetCut.functionSelectors[0] = CUArbBridgeReceiverFacet.l1Address.selector;
        cuArbBridgeReceiverFacetCut.functionSelectors[1] = CUArbBridgeReceiverFacet.bridgeBurn.selector;
        cuArbBridgeReceiverFacetCut.functionSelectors[2] = CUArbBridgeReceiverFacet.bridgeMint.selector;
        cuArbBridgeReceiverFacetCut.functionSelectors[3] = CUArbBridgeReceiverFacet.setL2Gateway.selector;
        cuArbBridgeReceiverFacetCut.functionSelectors[4] = CUArbBridgeReceiverFacet.setL1TokenAddress.selector;
        cuArbBridgeReceiverFacetCut.functionSelectors[5] = CUArbBridgeReceiverFacet.getL2Gateway.selector;

        cuArbBridgeReceiverFacet = CUArbBridgeReceiverFacet(diamond);
    }

    function run() public {
        uint256 chainId = vm.envUint('CHAIN_ID');
        address deployerAddress = vm.envAddress('DEPLOYER_ADDRESS');
        // string memory name = vm.envString('ERC20_NAME');     //  required by @cu-tokens/Gogogo
        // string memory symbol = vm.envString('ERC20_SYMBOL'); //  required by @cu-tokens/Gogogo

        DeployProject gogogo = new DeployProject();
        gogogo.run();
        deployedDiamond = gogogo.deployedDiamond();
        CutDiamond cutDiamond = CutDiamond(address(deployedDiamond));

        vm.startBroadcast(deployerAddress);

        IDiamondCut.FacetCut[] memory cuts;

        // If chain is Arbitrum
        if (LibEnvironment.chainIsArbitrum(chainId)) {
            // Deploy CUBridgeOFTFacet
            (
                ,
                CUBridgeOFTFacet cuBridgeOFTFacet,
                IDiamondCut.FacetCut memory cuBridgeOFTFacetCut
            ) = gogogoCreateCUBridgeOFT(deployedDiamond);

            // Deploy CUArbBridgeSenderFacet
            (
                ,
                CUArbBridgeSenderFacet cuArbBridgeSenderFacet,
                IDiamondCut.FacetCut memory cuArbBridgeSenderFacetCut
            ) = gogogoCreateCUArbBridgeSender(deployedDiamond);

            //  Deploy Arb specific Implementation contract
            console.log('Deploying CUTokenImplementation interface contract at...');
            address implementation = address(new CUTokenImplementation());
            console.logAddress(implementation);

            // Attach facets to diamond
            cuts = new IDiamondCut.FacetCut[](2);
            cuts[0] = cuBridgeOFTFacetCut;
            cuts[1] = cuArbBridgeSenderFacetCut;
            cutDiamond.diamondCut(cuts, address(0), '');

            cutDiamond.setImplementation(implementation);

            cutDiamond.setSupportsInterface(OFTV2_INTERFACE_ID, true);

            // Init LayerZero OFTV2
            address lzEndpoint = vm.envAddress('LZ_ENDPOINT_ARG');
            uint8 sharedDecimals = 8; // 8 shared decimals is used if the token has 18 decimals. See: https://layerzero.gitbook.io/docs/evm-guides/oft-walkthrough#what-should-i-set-as-shared-decimals
            cuBridgeOFTFacet.initLZOFTV2(sharedDecimals, lzEndpoint);

            // Set minimum destination gas
            uint16 polygonChainId = uint16(vm.envUint('LZ_POLYGON_REMOTE_CHAIN_ID'));
            cuBridgeOFTFacet.setMinDstGas(polygonChainId, 0, 200000); // 200K is recommended for EVM chains that are not Arbitrum

            console.logString('LayerZero bridge configured correctly on Arbitrum.');

            // Set L1 custom gateway address
            address l1CustomGatewayAddress = vm.envAddress('L1_CUSTOM_GATEWAY_ADDRESS');
            cuArbBridgeSenderFacet.setL1CustomGatewayAddress(l1CustomGatewayAddress);

            // Set L1 router address
            address l1RouterAddress = vm.envAddress('L1_ROUTER_ADDRESS');
            cuArbBridgeSenderFacet.setL1RouterAddress(l1RouterAddress);

            console.logString(
                'Native Arbitrum bridge configured correctly. Please, remember to call CUArbBridgeSenderFacet.registerTokenOnL2 once the token is deployed on Xai.'
            );
        } else if (LibEnvironment.chainIsXai(chainId)) {
            // If chain is Xai
            // Deploy and attach CUArbBridgeReceiverFacet
            (
                ,
                CUArbBridgeReceiverFacet cuArbBridgeReceiverFacet,
                IDiamondCut.FacetCut memory cuArbBridgeReceiverFacetCut
            ) = gogogoCreateCUArbBridgeReceiver(deployedDiamond);

            //  Deploy Arb specific Implementation contract
            console.log('Deploying wCUTokenImplementation interface contract at...');
            address implementation = address(new wCUTokenImplementation());
            console.logAddress(implementation);

            // Attach facets to diamond
            cuts = new IDiamondCut.FacetCut[](1);
            cuts[0] = cuArbBridgeReceiverFacetCut;
            cutDiamond.diamondCut(cuts, address(0), '');

            cutDiamond.setImplementation(implementation);

            cutDiamond.setSupportsInterface(OFTV2_INTERFACE_ID, true);

            // Set l2 gateway address
            address l2GatewayAddress = vm.envAddress('L2_GATEWAY_ADDRESS');
            cuArbBridgeReceiverFacet.setL2Gateway(l2GatewayAddress);

            // Set l1 token address
            address l1TokenAddress = vm.envAddress('L1_TOKEN_ADDRESS'); // Address of the token on Arbitrum
            cuArbBridgeReceiverFacet.setL1TokenAddress(l1TokenAddress);

            console.logString(
                'Native Arbitrum bridge configured correctly on Xai. Please, remember to manually approve the 2 retryable orbit tickets.'
            );
        }

        vm.stopBroadcast();
    }
}
