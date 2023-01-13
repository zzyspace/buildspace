// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves; // 状态变量

    constructor() {
        console.log("New Contract");
    }

    function wave() public {
        totalWaves++;
        console.log("%s is waved!", msg.sender);
    }

    function getTotalWaves () public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}