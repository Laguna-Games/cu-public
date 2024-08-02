// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {CutERC721Diamond} from './CutERC721Diamond.sol';
import {ERC721AdminFragment} from './ERC721AdminFragment.sol';

/// @title Dummy "implementation" contract for LG Diamond interface for ERC-1967 compatibility
/// @dev adapted from https://github.com/zdenham/diamond-etherscan?tab=readme-ov-file
/// @dev This interface is used internally to call endpoints on a deployed diamond cluster.
contract CutERC721AdminDiamond is CutERC721Diamond, ERC721AdminFragment {

}
