// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
// forge-ignore: 5574

import 'forge-std/Script.sol';
import '@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';
import {CUArbBridgeSenderFacet} from '../src/facets/bridge/CUArbBridgeSenderFacet.sol';

contract RegisterTokenOnL2 is Script {

    function setUp() public {}

    function run() public {
        address deployerAddress = vm.envAddress('DEPLOYER_ADDRESS');

        vm.startBroadcast(deployerAddress);

        address diamondAddress = vm.envAddress('DIAMOND');

        CUArbBridgeSenderFacet cuArbBridgeSenderFacet = CUArbBridgeSenderFacet(diamondAddress);

        address l2CustomTokenAddress = vm.envAddress('ERC20_DIAMOND_ADDRESS_ON_XAI');
        uint256 maxSubmissionCostForCustomBridge = 0;
        uint256 maxSubmissionCostForRouter = 0;
        uint256 maxGasForCustomBridge = 0;
        uint256 maxGasForRouter = 0;
        uint256 gasPriceBid = 0;
        uint256 valueForGateway = 0;
        uint256 valueForRouter = 0;
        address creditBackAddress = vm.envAddress('CREDIT_BACK_ADDRESS');

        cuArbBridgeSenderFacet.registerTokenOnL2(l2CustomTokenAddress,maxSubmissionCostForCustomBridge, maxSubmissionCostForRouter, maxGasForCustomBridge, maxGasForRouter, gasPriceBid, valueForGateway, valueForRouter, creditBackAddress);

        vm.stopBroadcast();
    }
}