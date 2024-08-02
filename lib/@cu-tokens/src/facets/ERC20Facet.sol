// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

import '@openzeppelin-contracts/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol';
import '@openzeppelin-contracts/contracts/utils/Context.sol';
import '../libraries/LibERC20.sol';

/**
 * @title ERC20Facet
 * @dev This contract is the ERC20 facet of the diamond. It is responsible for handling all ERC20 related functionality.
 * Should be implemented and overriden as needed on other projects.
 */
contract ERC20Facet is Context, IERC20, IERC20Metadata {
    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return LibERC20.name();
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return LibERC20.symbol();
    }

    /**
     * @dev Returns the address of the contract that is the controller of this token.
     */
    function contractController() external view returns (address) {
        return LibERC20.getController();
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return LibERC20.allowance(owner, spender);
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        return LibERC20.approve(spender, amount);
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return LibERC20.totalSupply();
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return LibERC20.balanceOf(account);
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public pure virtual override returns (uint8) {
        return LibERC20.decimals();
    }

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        if (recipient == address(this)) {
            revert LibERC20.ERC20InvalidBurnMethod();
        }
        LibERC20.transferFrom(sender, recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        if (recipient == address(this)) {
            revert LibERC20.ERC20InvalidBurnMethod();
        }
        LibERC20.transfer(recipient, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        LibERC20.increaseAllowance(spender, addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        LibERC20.decreaseAllowance(spender, subtractedValue);
        return true;
    }
}
