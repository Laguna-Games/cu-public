// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
// forge-ignore: 5574

import 'forge-std/Script.sol';
import '@lagunagames/lg-diamond-template/script/Gogogo.s.sol';
import '@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';

import {CUBridgeOFTFacet} from '../src/facets/bridge/CUBridgeOFTFacet.sol';

contract SetTrustedRemoteAddress is Script {
    
    function setUp() public {}

    function run() public {
        address deployerAddress = vm.envAddress('DEPLOYER_ADDRESS');

        vm.startBroadcast(deployerAddress);

        address deployedDiamond = vm.envAddress('DIAMOND');

        CUBridgeOFTFacet cuBridgeOFTFacet = CUBridgeOFTFacet(deployedDiamond);

        uint16 polygonChainId = 109;
        address rbwBridgeContract = vm.envAddress('RBW_BRIDGE_POLYGON_CONTRACT');

        cuBridgeOFTFacet.setTrustedRemoteAddress(polygonChainId, abi.encodePacked(rbwBridgeContract));

        vm.stopBroadcast();
    }
}