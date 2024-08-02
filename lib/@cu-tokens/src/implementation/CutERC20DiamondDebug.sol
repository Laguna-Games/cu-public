// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CutERC20Diamond} from './CutERC20Diamond.sol';
import {ERC20DebugFragment} from './ERC20DebugFragment.sol';

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract CutERC20DiamondDebug is CutERC20Diamond, ERC20DebugFragment {

}
