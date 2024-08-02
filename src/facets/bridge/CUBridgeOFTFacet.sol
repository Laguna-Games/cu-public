// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {ERC20LZReceiverFacet} from "../../../lib/@lg-layerzero/src/ERC20LZReceiverFacet.sol";
import {LibContractOwner} from "../../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol";
import {ILayerZeroEndpoint} from "../../../lib/@layerzerolabs/solidity-examples/contracts/lzApp/interfaces/ILayerZeroEndpoint.sol";
import {LibERC20} from "../../../lib/@cu-tokens/src/libraries/LibERC20.sol";
import {LibLZBridge} from "../../libraries/LibLZBridge.sol";

contract CUBridgeOFTFacet is ERC20LZReceiverFacet {
    constructor() ERC20LZReceiverFacet(address(1)) {} // the constructor is required but not used because it's called before existing on the diamond. So we put a placeholder.
    function initLZOFTV2(
        uint8 _sharedDecimals,
        address _lzEndpoint
    ) external virtual override {
        LibContractOwner.enforceIsContractOwner();

        uint8 _decimals = 18;
        if (_sharedDecimals > _decimals) {
            revert LibLZBridge.LZBridgeInvalidSharedDecimals(_sharedDecimals, _decimals);
        }

        ld2sdRate = 10**(_decimals - _sharedDecimals);

        // From OFTCoreV2.sol
        sharedDecimals = _sharedDecimals;

        // From LzApp.sol
        lzEndpoint = ILayerZeroEndpoint(_lzEndpoint);

        // Since the LZ contracts use Ownable, set the owner
        _transferOwnership(LibContractOwner.contractOwner());
    }

    function _creditTo(
        uint16, //_srcChainId
        address _toAddress,
        uint _amount
    ) internal virtual override returns (uint) {
        uint convertedAmount = _amount / 10;
        LibERC20.mint(_toAddress, convertedAmount);
        return convertedAmount;
    }

    function _debitFrom(
        address _from,
        uint16 _dstChainId,
        bytes32 _toAddress,
        uint _amount
    ) internal virtual override returns (uint) {
        revert LibLZBridge.LZBridgeDebitDisabled(_from, _dstChainId, _toAddress, _amount);
    }

    function _transferFrom(
        address _from,
        address _to,
        uint _amount
    ) internal virtual override returns (uint) {
        LibERC20.transferFrom(_from, _to, _amount);
        return _amount;
    }

    function circulatingSupply() public view override returns (uint) {
        return LibERC20.totalSupply();
    } 
}
