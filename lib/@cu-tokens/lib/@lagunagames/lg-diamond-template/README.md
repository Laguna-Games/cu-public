# Laguna Games Diamond Template
Reference implementation for LG's ERC-2535 "Diamond" smart contracts

---

## Setup

1. Install [Foundry](https://book.getfoundry.sh/getting-started/installation):
2. Install project dependencies: `forge install`
3. Make a copy of [dotenv.example](dotenv.example) and rename it to `.env`
   1. Edit [.env](.env)
   2. Fill in the `PRIVATE_KEY` for a deploy wallet (ex. the pkey for `0x513cC39E4782A2df83f6fC8998D11E0c1CA29ACb`)
      - Alternatively, you can utilize `cast` to manage wallets.
      - Run `cast wallet import <wallet_name> --private-key <private_key>
      - You will be prompted to save a passcode for this account
      - After success, you will be able to run `cast` and `foundry` commands using this account
      - Use any `cast` or `foundry` command with the option `--acount <account_name>. You will be prompted for your passcode for every tx
      - Fill in `DEPLOYER_ADDRESS` for a deployer wallet address you will use, and validate it with the `--account <account_name>` option in commands
   3. Fill in any API keys for Etherscan, Polygonscan, Arbiscan, etc.
4. Compile and test the project: `forge test`


---

## Docs

[docs/src/SUMMARY.md](docs/src/SUMMARY.md)

---

## Build
Compile the smart contracts.

```shell
$ forge build
```

## Test
Run unit tests.

```shell
$ forge test
```

Run unit tests with forking.
```shell
$ forge test
```
Notes:
- Any Test file that needs forked testing should inherit from `TestSnapshotFactory.t.sol`
- Make sure to set your $TEST_FORK_RPC_URL env var, $DEPLOYER_ADDRESS, as well as your facet addresses:
```shell
DEPLOYER_ADDRESS="<wallet_address>"
TEST_FORK_RPC_URL="https://testnet-v2.xai-chain.net/rpc"
DIAMOND_CUT_FACET="0x7e2765d3D9ed15E8745320b729c666dAE71a19bb"
DIAMOND_LOUPE_FACET="0x2cA844b96c3Ef044C626d2D30b2FcbD675EA30DC"
DIAMOND_PROXY_FACET="0xCe53e97461401D7c34a72b1555A4904Fb5c97e88"
DIAMOND_OWNER_FACET="0x48420aeE07a3728ABF872958Dc011965E5B56291"
SUPPORTS_INTERFACE_FACET="0x630457Db4D186df9A58b50070039e913df58aB04"
DUMMY_INTERFACE_CONTRACT="0xAefB304AA342586DEC338a344AaDc21bc6468528"
```


## Deploy
Deploy and configure the diamond.

```shell
$ forge script script/Gogogo.s.sol --chain-id 47279324479 --rpc-url https://testnet.xai-chain.net/rpc --broadcast --verify --verifier blockscout --verifier-url https://testnet-explorer.xai-chain.net/api
```

Common facets can be shared between diamonds by specifying the facet addresses in .env:

```shell
# PRE-DEPLOYED FACETS - Arbitrum Sepolia chainId 421614
DIAMOND_CUT_FACET="0x7e2765d3D9ed15E8745320b729c666dAE71a19bb"
DIAMOND_LOUPE_FACET="0x2cA844b96c3Ef044C626d2D30b2FcbD675EA30DC"
DIAMOND_PROXY_FACET="0xCe53e97461401D7c34a72b1555A4904Fb5c97e88"
DIAMOND_OWNER_FACET="0x48420aeE07a3728ABF872958Dc011965E5B56291"
SUPPORTS_INTERFACE_FACET="0x630457Db4D186df9A58b50070039e913df58aB04"
DUMMY_INTERFACE_CONTRACT="0xAefB304AA342586DEC338a344AaDc21bc6468528"
```


## Facet Cut
Add, replace, or remove an existing facet on the diamond.

First identify any functions you would like to filter out, or only include (toggled with `FILTER_IGNORE`). 
`SELECTORS` can either be a pipe-delimited list of function selectors.
`SIGNATURES` can either be a pipe-delimited list of function signatures.
When using signatures, ensure to only include the function names without the argument list (i.e. "functionName|functionName2|functionName3")
If you want to include all functions of the facet, you can leave `SELECTORS`, `SIGNATURES`, and `FILTER_IGNORE` empty.

To easily clear out these variables, run the script:
```shell
source script/prepareFacetCut.sh
```

Now run the generate script to save your full list of functions to cut:

Signatures
```shell
# To ignore signatures, pass `--filter-ignore "true"
$ export SELECTORS=$(bash script/generateSelectors.sh "ERC20Facet" --filter-signatures "owner" --filter-ignore "true")
```

OR selectors

```shell
# To only include the given selectors, pass `--filter-ignore "false"`
$ export SELECTORS=$(bash script/generateSelectors.sh "ERC20Facet" --filter-selectors "f2fde38b|8da5cb5b" --filter-ignore "false")
```

Finally prepare your environment variables either with a .env:
```shell
FACET_ACTION="add"
FACET_NAME="ERC20Facet"
# Facet address will be set to address(0) for FACET_ACTION="replace" 
FACET_ADDRESS="0x610178dA211FEF7D417bC0e6FeD39F05609AD788"
DIAMOND="0x0165878A594ca255338adfa4d48449f69242Eb8F"
```
```bash
$ source .env
```

Or in-line directly with the script:
```shell
$ FACET_ACTION="replace" FACET_NAME="ERC20Facet" FACET_ADDRESS="$ERC20_FACET" DIAMOND="$DIAMOND" forge script lib/@lagunagames/lg-diamond-template/script/FacetCut.s.sol --rpc-url $RPC_URL --account $ACCOUNT_NAME --chain-id $CHAIN_ID --gas-price $GAS --broadcast
```

---

## Help
Foundry consists of:
-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

> [https://book.getfoundry.sh/](https://book.getfoundry.sh/)

```shell
$ forge --help
$ anvil --help
$ cast --help
$ chisel --help
```
