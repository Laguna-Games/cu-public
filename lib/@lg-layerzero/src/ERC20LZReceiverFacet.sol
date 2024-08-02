// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {BaseOFTV2} from "@layerzerolabs/solidity-examples/contracts/token/oft/v2/BaseOFTV2.sol";
import {ILayerZeroEndpoint} from "@layerzerolabs/solidity-examples/contracts/lzApp/interfaces/ILayerZeroEndpoint.sol";

abstract contract ERC20LZReceiverFacet is BaseOFTV2 {
    uint internal ld2sdRate;
    // Can't initialize these values as empty, because the tx reverts.
    // since the diamond storage won't be used when creating the facet, we'll need to call initLZOFTV2() to set these values on the diamond instead.
    constructor(
        address _lzEndpoint) BaseOFTV2(0, _lzEndpoint) {
    }

    /************************************************************************
     * public and external functions
     ************************************************************************/
    function token() public view virtual override returns (address) {
        return address(this);
    }


    function initLZOFTV2(
        uint8 _sharedDecimals,
        address _lzEndpoint
    ) external virtual;

    function _ld2sdRate() internal view virtual override returns (uint) {
        return ld2sdRate;
    }
}
