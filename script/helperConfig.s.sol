// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import {Script} from "forge-std/Script.sol";
import {DummyToken} from "../test/mocks/token.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    address public TREASURY = makeAddr("treasury"); // not a constant

    struct NetworkConfig {
        address tokenAddress; // token address
        uint128 airdropTime;
        uint256 registrationFee;
        address treasury;
    }

    constructor() {
        if (block.chainid == 80001) {
            activeNetworkConfig = getMumbaiEthConfig();
        } else if (block.chainid == 43113) {
            activeNetworkConfig = getFujiEthConfig();
        } else if (block.chainid == 1287) {
            activeNetworkConfig = getMoonbaseEthConfig();
        } else if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getMumbaiEthConfig() public view returns (NetworkConfig memory) {
        // token address
        NetworkConfig memory mumbaiConfig = NetworkConfig({
            tokenAddress: 0x0715A7794a1dc8e42615F059dD6e406A6594651A,
            airdropTime: uint128(block.timestamp) + 14 days,
            registrationFee: 1 ether,
            treasury: TREASURY
        });
        return mumbaiConfig;
    }

    function getFujiEthConfig() public view returns (NetworkConfig memory) {
        // token address
        NetworkConfig memory fujiConfig = NetworkConfig({
            tokenAddress: 0x86d67c3D38D2bCeE722E601025C25a575021c6EA,
            airdropTime: uint128(block.timestamp) + 14 days,
            registrationFee: 1 ether,
            treasury: TREASURY
        });
        return fujiConfig;
    }

    function getMoonbaseEthConfig() public view returns (NetworkConfig memory) {
        // token address
        NetworkConfig memory moonbaseConfig = NetworkConfig({
            tokenAddress: 0xbF452599F041330266f2C302604F9E0c6D980E92,
            airdropTime: uint128(block.timestamp) + 2 hours,
            registrationFee: 0.01 ether,
            treasury: 0xc096a34cFC2094D360373CC631eB28f353F4498e
        });
        return moonbaseConfig;
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        // token address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            tokenAddress: 0x867BfAD7b420c0eddE667dD92d06aE1efcd65f81,
            airdropTime: uint128(block.timestamp) + 2 hours,
            registrationFee: 0.01 ether,
            treasury: 0xc096a34cFC2094D360373CC631eB28f353F4498e
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.tokenAddress != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        DummyToken token = new DummyToken(INITIAL_SUPPLY);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            tokenAddress: address(token),
            airdropTime: uint128(block.timestamp) + 14 days,
            registrationFee: 1 ether,
            treasury: TREASURY
        });
        return anvilConfig;
    }
}
