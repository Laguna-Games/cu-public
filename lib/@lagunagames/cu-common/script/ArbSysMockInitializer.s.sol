// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {ArbSysMock} from '../src/mocks/ArbSysMock.sol';

/// @title Helper script that initializes the ArbSysMock on address(64) for the Foundry EVM to be able to execute methods from that contract on simulations and tests.
/// @author facundo@laguna.games
contract ArbSysMockInitializer is Script {
    function initializeArbSysMock() internal {
        console.logString(
            'Deploying ArbSysMock locally to retrieve its bytecode and initialize it on address(64) for the Foundry EVM...'
        );
        ArbSysMock arbSysMock = new ArbSysMock();
        vm.etch(address(0x0000000000000000000000000000000000000064), address(arbSysMock).code);
        console.logString(
            'ArbSysMock initialized on address(64) for the Foundry EVM. Make sure to not broadcast the initializeArbSysMock() execution.'
        );
    }
}
