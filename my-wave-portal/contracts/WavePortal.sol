// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves; // 状态变量

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        uint256 timestamp;
        string message;
    }

    Wave[] waves;

    constructor() payable {
        console.log("New Contract!");
    }

    function wave(string memory _message) public {
        totalWaves++;
        console.log("%s waved w/ message %s!", msg.sender, _message);
        
        waves.push(Wave(msg.sender, block.timestamp, _message));
        emit NewWave(msg.sender, block.timestamp, _message);

        // wave 奖励
        uint256 prize = 0.0001 ether;
        require(prize <= address(this).balance,
            "Trying to withdraw more money than the contract has");
        (bool success, ) = (msg.sender).call{value: prize}(""); // 转账
        require(success, "Failed to withdraw money from contract");
    }

    function getAllWaves () public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves () public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}