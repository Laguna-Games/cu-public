// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Address} from '../../lib/openzeppelin-contracts/contracts/utils/Address.sol';
import {Context} from '../../lib/openzeppelin-contracts/contracts/utils/Context.sol';
// import {IERC721} from '../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol';
// import {IERC721Enumerable} from '../../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol';
// import {IERC721Metadata} from '../../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol';
import {LibERC721} from '../libraries/LibERC721.sol';
import {Strings} from '../../lib/openzeppelin-contracts/contracts/utils/Strings.sol';
import {LibContractOwner} from '../../lib/@lagunagames/lg-diamond-template/src/libraries/LibContractOwner.sol';

/// NOTE: This contract implements ERC721, ERC721Enumerable, and ERC721Metadata.
/// However, ERC165 is automatically part of all of our Diamonds, so the interface
//  is disabled here in favor of SupportsInterfaceFacet.
contract ERC721Facet is Context /*, IERC721, IERC721Metadata, IERC721Enumerable */ {
    using Address for address;
    using Strings for uint256;

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance) {
        return LibERC721.balanceOf(owner);
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner) {
        return LibERC721.ownerOf(tokenId);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external virtual {
        require(
            LibERC721.isApprovedOrOwner(_msgSender(), tokenId),
            'ERC721: transfer caller is not owner nor approved'
        );
        LibERC721.safeTransfer(from, to, tokenId, data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC-721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external virtual {
        require(
            LibERC721.isApprovedOrOwner(_msgSender(), tokenId),
            'ERC721: transfer caller is not owner nor approved'
        );
        LibERC721.safeTransfer(from, to, tokenId, '');
    }

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC-721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external virtual {
        require(
            LibERC721.isApprovedOrOwner(_msgSender(), tokenId),
            'ERC721: transfer caller is not owner nor approved'
        );

        LibERC721.transfer(from, to, tokenId);
    }

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external {
        address owner = LibERC721.ownerOf(tokenId);
        require(to != owner, 'ERC721: approval to current owner');

        require(
            _msgSender() == owner || LibERC721.isApprovedForAll(owner, _msgSender()),
            'ERC721: approve caller is not owner nor approved for all'
        );

        LibERC721.approve(to, tokenId);
    }

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external {
        LibERC721.setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator) {
        return LibERC721.getApproved(tokenId);
    }

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool) {
        return LibERC721.isApprovedForAll(owner, operator);
    }

    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory) {
        return LibERC721.erc721Storage().name;
    }

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory) {
        return LibERC721.erc721Storage().symbol;
    }

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        return LibERC721.erc721Storage().tokenURIs[tokenId];
    }

    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256) {
        return LibERC721.erc721Storage().allTokens.length;
    }

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256) {
        require(index < LibERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
        return LibERC721.erc721Storage().ownedTokens[owner][index];
    }

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256) {
        require(index < LibERC721.erc721Storage().allTokens.length, 'ERC721Enumerable: global index out of bounds');
        return LibERC721.erc721Storage().allTokens[index];
    }

    /**
     * @dev Returns the URI for the contract level collection.
     * @dev See https://docs.opensea.io/docs/contract-level-metadata
     */
    function contractURI() external view returns (string memory) {
        return LibERC721.erc721Storage().contractURI;
    }

    /**
     * @dev Reference URI for the NFT license file hosted on Arweave permaweb.
     */
    function license() external view returns (string memory) {
        return LibERC721.erc721Storage().licenseURI;
    }
}
