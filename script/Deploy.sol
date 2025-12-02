// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {PoolManager} from "../src/PoolManager.sol";
import {CTWrapper} from "../src/ctWrapper/CTWrapper.sol";

contract Deploy is Script {
    using stdJson for string;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        console.log("Deploying contracts with deployer:", deployer);
        console.log("Deployer balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy PoolManager
        // The initialOwner will be set to the deployer by default, but can be overridden via env var
        address poolManagerOwner = vm.envOr("POOL_MANAGER_OWNER", deployer);
        console.log("Deploying PoolManager with owner:", poolManagerOwner);

        PoolManager poolManager = new PoolManager(poolManagerOwner);
        console.log("PoolManager deployed at:", address(poolManager));

        // Deploy CTWrapper
        // CT address must be provided via environment variable
        address ctAddress = vm.envAddress("CT_ADDRESS");
        console.log("Deploying CTWrapper with CT address:", ctAddress);

        CTWrapper ctWrapper = new CTWrapper(ctAddress);
        console.log("CTWrapper deployed at:", address(ctWrapper));

        vm.stopBroadcast();

        // Get chain info
        uint256 chainId = block.chainid;
        uint256 blockNumber = block.number;

        // Log deployment summary
        console.log("\n=== Deployment Summary ===");
        console.log("PoolManager:", address(poolManager));
        console.log("PoolManager Owner:", poolManagerOwner);
        console.log("CTWrapper:", address(ctWrapper));
        console.log("CT Address:", ctAddress);
        console.log("Deployer:", deployer);
        console.log("Chain ID:", chainId);
        console.log("Block Number:", blockNumber);

        // Save deployment addresses to JSON file using stdJson
        string memory json = "deployment";
        json = json.serialize("poolManager", address(poolManager));
        json = json.serialize("poolManagerOwner", poolManagerOwner);
        json = json.serialize("ctWrapper", address(ctWrapper));
        json = json.serialize("ctAddress", ctAddress);
        json = json.serialize("deployer", deployer);
        json = json.serialize("chainId", chainId);
        json = json.serialize("blockNumber", blockNumber);

        string memory filename = string.concat("deployments/", vm.toString(chainId), ".json");
        json.write(filename);
        console.log("\nDeployment addresses saved to:", filename);
    }
}
