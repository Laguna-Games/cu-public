// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library LibEnvironment {
    function chainIsArbitrum(uint256 chainId) internal pure returns (bool) {
        return chainIsArbitrumMainnet(chainId) || chainIsArbitrumSepolia(chainId);
    }

    function chainIsArbitrumMainnet(uint256 chainId) internal pure returns (bool) {
        return chainId == 42161;
    }

    function chainIsArbitrumSepolia(uint256 chainId) internal pure returns (bool) {
        return chainId == 421614;
    }

    function chainIsXai(uint256 chainId) internal pure returns (bool) {
        return chainIsXaiMainnet(chainId) || chainIsXaiSepolia(chainId);
    }

    function chainIsXaiMainnet(uint256 chainId) internal pure returns (bool) {
        return chainId == 660279;
    }

    function chainIsXaiSepolia(uint256 chainId) internal pure returns (bool) {
        return chainId == 37714555429;
    }
}