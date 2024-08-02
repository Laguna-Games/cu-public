// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IERC721Receiver} from '../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol';
import {Address} from '../../lib/openzeppelin-contracts/contracts/utils/Address.sol';

/// @custom:storage-location erc7201:CryptoUnicorns.ERC721.storage
library LibERC721 {
    using Address for address;

    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /// @dev This event emits when the metadata of a token is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFT.
    event MetadataUpdate(uint256 _tokenId);

    /// @dev This event emits when the metadata of a range of tokens is changed.
    /// So that the third-party platforms such as NFT market could
    /// timely update the images and related attributes of the NFTs.
    event BatchMetadataUpdate(uint256 _fromTokenId, uint256 _toTokenId);

    bytes32 constant ERC721_STORAGE_POSITION =
        keccak256(abi.encode(uint256(keccak256('CryptoUnicorns.ERC721.storage')) - 1)) & ~bytes32(uint256(0xff));

    // DO NOT RE-ORGANIZE THIS STRUCT!
    struct ERC721Storage {
        // Mapping from token ID to owner address
        mapping(uint256 => address) owners;
        // Mapping owner address to token count
        mapping(address => uint256) balances;
        // Mapping of owners to owned token IDs
        mapping(address => mapping(uint256 => uint256)) ownedTokens;
        // Mapping of tokens to their index in their owners ownedTokens array.
        mapping(uint256 => uint256) ownedTokensIndex;
        // Array with all token ids, used for enumeration
        uint256[] allTokens;
        // Mapping from token id to position in the allTokens array
        mapping(uint256 => uint256) allTokensIndex;
        // Mapping from token ID to approved address
        mapping(uint256 => address) tokenApprovals;
        // Mapping from owner to operator approvals
        mapping(address => mapping(address => bool)) operatorApprovals;
        string name;
        // Token symbol
        string symbol;
        // Token contractURI - permaweb location of the contract json file
        string contractURI;
        // Token licenseURI - permaweb location of the license.txt file
        string licenseURI;
        mapping(uint256 => string) tokenURIs;
        //  TokenId of the last minted token
        uint256 currentTokenId;
        // Mapping tokenIds to soulbound flags
        mapping(uint256 => bool) soulboundedTokens;
    }

    function erc721Storage() internal pure returns (ERC721Storage storage es) {
        bytes32 position = ERC721_STORAGE_POSITION;
        assembly {
            es.slot := position
        }
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal {
        transfer(from, to, tokenId);
        require(checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`mint`),
     * and stop existing when they are burned (`burn`).
     */
    function exists(uint256 tokenId) internal view returns (bool) {
        return erc721Storage().owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        require(exists(tokenId), 'ERC721: operator query for nonexistent token');
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeMint(address to, uint256 tokenId) internal {
        safeMint(to, tokenId, '', false);
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeMint(address to, uint256 tokenId, bool soulbound) internal {
        safeMint(to, tokenId, '', soulbound);
    }

    /**
     * @dev Same as {xref-ERC721-safeMint-address-uint256-}[`safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function safeMint(address to, uint256 tokenId, bytes memory _data, bool soulbound) internal {
        mint(to, tokenId, soulbound);
        require(
            checkOnERC721Received(address(0), to, tokenId, _data),
            'ERC721: transfer to non ERC721Receiver implementer'
        );
    }

    /**
     * @dev Same as {xref-ERC721-safeMint-address-uint256-}[`safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function safeMint(address to, uint256 tokenId, bytes memory _data) internal {
        mint(to, tokenId, false);
        require(
            checkOnERC721Received(address(0), to, tokenId, _data),
            'ERC721: transfer to non ERC721Receiver implementer'
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function mint(address to, uint256 tokenId) internal {
        require(to != address(0), 'ERC721: mint to the zero address');
        require(!exists(tokenId), 'ERC721: token already minted');

        beforeTokenTransfer(address(0), to, tokenId);
        ERC721Storage storage ds = erc721Storage();
        ds.balances[to] += 1;
        ds.owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function mint(address to, uint256 tokenId, bool soulbound) internal {
        mint(to, tokenId);
        erc721Storage().soulboundedTokens[tokenId] = soulbound;
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     * Emits a {MetadataUpdate} event.
     */
    function burn(uint256 tokenId) internal {
        address owner = ownerOf(tokenId);

        beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        approve(address(0), tokenId);
        ERC721Storage storage ds = erc721Storage();
        ds.balances[owner] -= 1;
        delete ds.owners[tokenId];
        delete ds.soulboundedTokens[tokenId];

        if (bytes(ds.tokenURIs[tokenId]).length != 0) {
            delete ds.tokenURIs[tokenId];
            emit MetadataUpdate(tokenId);
        }

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address from, address to, uint256 tokenId) internal {
        require(ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
        require(to != address(0), 'ERC721: transfer to the zero address');

        // Enforce token is not soulbound
        enforceTokenIsNotSoulbound(tokenId);

        beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        approve(address(0), tokenId);
        ERC721Storage storage ds = erc721Storage();
        ds.balances[from] -= 1;
        ds.balances[to] += 1;
        ds.owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function approve(address to, uint256 tokenId) internal {
        ERC721Storage storage ds = erc721Storage();
        ds.tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits a {ApprovalForAll} event.
     */
    function setApprovalForAll(address owner, address operator, bool approved) internal {
        require(owner != operator, 'ERC721: approve to caller');
        ERC721Storage storage ds = erc721Storage();
        ds.operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert('ERC721: transfer to non ERC721Receiver implementer');
                } else {
                    // solhint-disable-next-line no-inline-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function beforeTokenTransfer(address from, address to, uint256 tokenId) internal {
        if (from == address(0)) {
            addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function addTokenToOwnerEnumeration(address to, uint256 tokenId) internal {
        ERC721Storage storage ds = erc721Storage();
        uint256 length = balanceOf(to);
        ds.ownedTokens[to][length] = tokenId;
        ds.ownedTokensIndex[tokenId] = length;
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function removeTokenFromOwnerEnumeration(address from, uint256 tokenId) internal {
        ERC721Storage storage ds = erc721Storage();

        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).
        uint256 lastTokenIndex = balanceOf(from) - 1;
        uint256 tokenIndex = ds.ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = ds.ownedTokens[from][lastTokenIndex];

            ds.ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            ds.ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete ds.ownedTokensIndex[tokenId];
        delete ds.ownedTokens[from][lastTokenIndex];
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function addTokenToAllTokensEnumeration(uint256 tokenId) internal {
        ERC721Storage storage ds = erc721Storage();

        ds.allTokensIndex[tokenId] = ds.allTokens.length;
        ds.allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function removeTokenFromAllTokensEnumeration(uint256 tokenId) internal {
        ERC721Storage storage ds = erc721Storage();

        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = ds.allTokens.length - 1;
        uint256 tokenIndex = ds.allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = ds.allTokens[lastTokenIndex];

        ds.allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        ds.allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete ds.allTokensIndex[tokenId];
        ds.allTokens.pop();
    }

    function ownerOf(uint256 tokenId) internal view returns (address) {
        address owner = erc721Storage().owners[tokenId];
        require(owner != address(0), 'ERC721: owner query for nonexistent token');
        return owner;
    }

    function getApproved(uint256 tokenId) internal view returns (address) {
        require(exists(tokenId), 'ERC721: approved query for nonexistent token');

        return erc721Storage().tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner, address operator) internal view returns (bool) {
        return erc721Storage().operatorApprovals[owner][operator];
    }

    function balanceOf(address owner) internal view returns (uint256) {
        require(owner != address(0), 'ERC721: balance query for the zero address');
        return erc721Storage().balances[owner];
    }

    function enforceCallerOwnsNFT(uint256 tokenId) internal view {
        require(ownerOf(tokenId) == msg.sender, 'ERC721: Caller must own NFT');
    }

    function mintNextToken(address _to) internal returns (uint256 nextTokenId) {
        ERC721Storage storage ds = erc721Storage();
        nextTokenId = ds.currentTokenId + 1;
        mint(_to, nextTokenId);
        ds.currentTokenId = nextTokenId;
        return nextTokenId;
    }

    function mintNextToken(address _to, bool soulbound) internal returns (uint256 nextTokenId) {
        ERC721Storage storage ds = erc721Storage();
        nextTokenId = ds.currentTokenId + 1;
        mint(_to, nextTokenId, soulbound);
        ds.currentTokenId = nextTokenId;
        return nextTokenId;
    }

    /// @notice Enforces tokenid is not soulbound
    /// @dev This should be used before any transfer
    /// @param tokenId The token id
    function enforceTokenIsNotSoulbound(uint256 tokenId) internal view {
        require(!isSoulbound(tokenId), 'ERC721: Token is soulbound');
    }

    /// @notice Returns if tokenid is soulbound
    /// @param tokenId The token id
    function isSoulbound(uint256 tokenId) internal view returns (bool) {
        return erc721Storage().soulboundedTokens[tokenId];
    }

    /// @notice gets all tokens owned by a given address
    /// @param owner address to query
    /// @return tokens tokens owned by the address
    function getAllTokensByOwner(address owner) internal view returns (uint256[] memory tokens) {
        uint256 i = 0;
        tokens = new uint256[](balanceOf(owner));
        mapping(uint256 => uint256) storage ownedTokens = erc721Storage().ownedTokens[owner];
        while (ownedTokens[i] > 0) {
            tokens[i] = ownedTokens[i];
            ++i;
        }
    }

    /// @notice gets token owned by a given address on a certain index
    /// @param owner address to query
    /// @param index index of the token
    /// @return tokens tokens owned by the address
    function tokenOfOwnerByIndex(address owner, uint256 index) internal view returns (uint256) {
        require(index < balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
        return erc721Storage().ownedTokens[owner][index];
    }

    /// @notice gets a token by index in the global tokens array
    /// @param index index of the token
    /// @return tokenId token id at the index
    function tokenByIndex(uint256 index) internal view returns (uint256) {
        require(index < totalSupply(), 'ERC721Enumerable: global index out of bounds');
        return erc721Storage().allTokens[index];
    }

    /// @notice gets the total supply of tokens
    /// @return totalSupply total supply of tokens
    function totalSupply() internal view returns (uint256) {
        return erc721Storage().allTokens.length;
    }

    /// @notice Associates a tokenURI string with a token
    /// @param tokenId id of the token
    /// @param tokenURI uri of the token
    /// @custom:emits MetadataUpdate
    function setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        erc721Storage().tokenURIs[tokenId] = tokenURI;
        emit MetadataUpdate(tokenId);
    }

    /// @notice Return the tokenURI of a token
    /// @param tokenId id of the token
    /// @return tokenURI uri of the token
    function getTokenURI(uint256 tokenId) internal view returns (string memory) {
        return erc721Storage().tokenURIs[tokenId];
    }
}
