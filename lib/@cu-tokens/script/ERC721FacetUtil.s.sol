// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from '../lib/forge-std/src/Script.sol';
import {console} from '../lib/forge-std/src/console.sol';
import {ERC721Facet} from '../src/facets/ERC721Facet.sol';
import {IDiamondCut} from '../lib/@lagunagames/lg-diamond-template/src/interfaces/IDiamondCut.sol';
import {CutDiamond} from '../lib/@lagunagames/lg-diamond-template/src/diamond/CutDiamond.sol';
import {ERC721AdminFacetUtil} from './ERC721AdminFacetUtil.s.sol';
import {ERC721AdminFacet} from '../src/facets/ERC721AdminFacet.sol';
import {IERC721} from '../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol';
import {IERC721Metadata} from '../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol';
import {IERC721Enumerable} from '../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol';

/// @title Helper script to attach ERC721Facet to a Diamond
/// @author rsampson@laguna.games
contract ERC721FacetUtil is Script {
    address public facetAddress;

    /// @notice Attach the ERC721Facet to a diamond
    /// @param diamond The diamond to attach the ERC721Facet to
    function attachERC721FacetToDiamond(address diamond) public {
        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        if (!vm.envOr('QUIET_MODE', false)) console.logString('Deploying new ERC721Facet at...');
        facetAddress = address(new ERC721Facet());
        if (!vm.envOr('QUIET_MODE', false)) console.logAddress(facetAddress);

        IDiamondCut.FacetCut[] memory cuts = new IDiamondCut.FacetCut[](1);
        cuts[0] = IDiamondCut.FacetCut({
            facetAddress: facetAddress,
            action: IDiamondCut.FacetCutAction.Add,
            functionSelectors: new bytes4[](17)
        });
        cuts[0].functionSelectors[0] = ERC721Facet.balanceOf.selector;
        cuts[0].functionSelectors[1] = ERC721Facet.ownerOf.selector;
        cuts[0].functionSelectors[2] = 0x42842e0e; // bytes4(keccak256('safeTransferFrom(address,address,uint256)'))
        cuts[0].functionSelectors[3] = 0xb88d4fde; // bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
        cuts[0].functionSelectors[4] = ERC721Facet.transferFrom.selector;
        cuts[0].functionSelectors[5] = ERC721Facet.approve.selector;
        cuts[0].functionSelectors[6] = ERC721Facet.setApprovalForAll.selector;
        cuts[0].functionSelectors[7] = ERC721Facet.getApproved.selector;
        cuts[0].functionSelectors[8] = ERC721Facet.isApprovedForAll.selector;
        cuts[0].functionSelectors[9] = ERC721Facet.name.selector;
        cuts[0].functionSelectors[10] = ERC721Facet.symbol.selector;
        cuts[0].functionSelectors[11] = ERC721Facet.tokenURI.selector;
        cuts[0].functionSelectors[12] = ERC721Facet.totalSupply.selector;
        cuts[0].functionSelectors[13] = ERC721Facet.tokenOfOwnerByIndex.selector;
        cuts[0].functionSelectors[14] = ERC721Facet.tokenByIndex.selector;
        cuts[0].functionSelectors[15] = ERC721Facet.contractURI.selector;
        cuts[0].functionSelectors[16] = ERC721Facet.license.selector;
        CutDiamond(diamond).diamondCut(cuts);

        CutDiamond(diamond).setSupportsInterface(type(IERC721).interfaceId, true); // 0x80ac58cd
        CutDiamond(diamond).setSupportsInterface(type(IERC721Metadata).interfaceId, true); // 0x5b5e139f
        CutDiamond(diamond).setSupportsInterface(type(IERC721Enumerable).interfaceId, true); // 0x780e9d63

        vm.stopBroadcast();
    }

    /// @notice Configure the metadata for a diamond
    /// @param diamond The diamond to configure
    /// @param name The name of the diamond (ex. "Crypto Unicorns")
    /// @param symbol The symbol of the diamond (ex. "UNICORNS")
    /// @param contractURI The URI for the contract level metadata
    /// @param licenseURI The URI for the license
    function configureERC721Diamond(
        address diamond,
        string memory name,
        string memory symbol,
        string memory contractURI,
        string memory licenseURI
    ) public {
        ERC721AdminFacetUtil util = new ERC721AdminFacetUtil();
        util.attachERC721AdminFacetToDiamond(diamond);

        vm.startBroadcast(vm.envAddress('DEPLOYER_ADDRESS'));

        ERC721AdminFacet(diamond).setName(name);
        ERC721AdminFacet(diamond).setSymbol(symbol);
        ERC721AdminFacet(diamond).setContractURI(contractURI);
        ERC721AdminFacet(diamond).setLicense(licenseURI);

        if (!vm.envOr('QUIET_MODE', false)) {
            console.log(string.concat('Deployed name: ', ERC721Facet(diamond).name()));
            console.log(string.concat('Deployed symbol: ', ERC721Facet(diamond).symbol()));
            console.log(string.concat('Deployed contractURI: ', ERC721Facet(diamond).contractURI()));
            console.log(string.concat('Deployed licenseURI: ', ERC721Facet(diamond).license()));
        }
        vm.stopBroadcast();

        util.detachERC721AdminFacetFromDiamond(diamond);
    }

    // add this to be excluded from coverage report
    function test() public {}
}
