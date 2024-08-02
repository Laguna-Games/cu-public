// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ProxyOFTV2} from "@layerzerolabs/solidity-examples/contracts/token/oft/v2/ProxyOFTV2.sol";
import {ILayerZeroEndpoint} from "@layerzerolabs/solidity-examples/contracts/lzApp/interfaces/ILayerZeroEndpoint.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

abstract contract ERC20LZSenderFacet is ProxyOFTV2 {
    using SafeERC20 for IERC20;

    // Can't initialize these values as empty, because the tx reverts.
    // since the diamond storage won't be used when creating the facet, we'll need to call initLZProxyOFTV2() to set these values on the diamond instead.
    constructor(
        address _token,
        uint8 _sharedDecimals,
        address _lzEndpoint) ProxyOFTV2(_token, _sharedDecimals, _lzEndpoint) {

    }

    function initLZProxyOFTV2(
        address _token,
        uint8 _sharedDecimals,
        address _lzEndpoint
    ) external virtual;

    function erc20Owner() external view returns(address) {
      return super.owner();
    }
}
