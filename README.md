# Crypto Unicorns: CU Token

This repo contains code for both CU and wCU tokens, as outlined below.

---

## Crypto Unicorns Token (CU)

**CU Token on Arbitrum One: `0x89C49A3fA372920aC23ce757A029e6936c0b8e02`**
[Arbiscan](https://arbiscan.io/token/0x89C49A3fA372920aC23ce757A029e6936c0b8e02)

The CU token, is an ERC-20 successor to the RBW token on Polygon ([0x431CD3C9AC9Fc73644BF68bF5691f4B83F9E104f](https://polygonscan.com/token/0x431CD3C9AC9Fc73644BF68bF5691f4B83F9E104f))

This smart contract is built on the [ERC-2535 Diamond multi-facet proxy](https://eips.ethereum.org/EIPS/eip-2535) architecture. The proxy contract is deployed at [0x89C49A3fA372920aC23ce757A029e6936c0b8e02](https://arbiscan.io/token/0x89C49A3fA372920aC23ce757A029e6936c0b8e02) on the Arbitrum One blockchain.

CU Tokens may only be minted via the LayerZero cross-chain bridge, which requires a permanent stake of RBW tokens, at a ratio of 10 to 1. This mechanism ensures that CU tokens are locked to 10x the value of RBW tokens, and may never exceed a totalSupply of 100,000,000 CU tokens.

[RBW -> CU Bridge analytics](https://dune.com/lagunagames12_team/rbw-lessgreater-cu-bridge/7d5edfb1-7ce6-4554-b1e4-74af14b861d4)

---

## Wrapped Crypto Unicorns Token (wCU)

**wCU Token address on Xai: `0x89C49A3fA372920aC23ce757A029e6936c0b8e02`**
[Xai-scan](https://explorer.xai-chain.net/token/0x89C49A3fA372920aC23ce757A029e6936c0b8e02/token-transfers)

CU Tokens may be bridged from Arbitrum to the [Xai](https://xai.games/) gaming blockchain at a ratio of 1 to 1. This exchange is bidirectional, and performed by the native [Arbitrum crosschain bridge](https://bridge.arbitrum.io/?destinationChain=xai&sourceChain=arbitrum-one).

Tokens that are staked into the Arbitrum bridge are emitted on Xai as "wrapped" CU tokens (wCU). The balance of CU tokens staked into the Arbitrum bridge must always match the totalSupply of wCU tokens in circulation on Xai. When wCU is returned, the wrapped tokens are burned and corresponding CU supply is released from the bridge on Arbitrum.

---

## Project Setup

1. Install [Foundry](https://book.getfoundry.sh/getting-started/installation)
2. Make a copy of [dotenv.example](dotenv.example) and rename it to `.env`
    1. Edit [.env](.env)
    2. Fill in the `DEPLOYER_ADDRESS` for a deploy wallet address
    3. Load deployer wallet in cast
    4. Fill in any API keys for Etherscan, Polygonscan, Arbiscan, etc.
3. Load dependencies: `git submodule update --init --recursive`
3. Compile and test the project: `forge test`

---

## Docs

[docs/src/SUMMARY.md](docs/src/SUMMARY.md)

---

## Build

```shell
$ forge build
```

```shell
$ forge doc
```

## Test

```shell
$ forge test
```

```shell
$ forge coverage --via-ir
```

---

## Deploy

Deploy and configure the diamond.

```shell
$ source .env

$ forge script script/Gogogo.s.sol --chain-id 37714555429 --rpc-url https://testnet-v2.xai-chain.net/rpc --broadcast --verify --verifier blockscout --verifier-url https://testnet-explorer-v2.xai-chain.net/api
```
