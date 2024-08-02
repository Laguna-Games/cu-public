// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ICUContract {
    function burnFrom(address account, uint256 amount) external;

    function mint(address account, uint256 amount) external;
}