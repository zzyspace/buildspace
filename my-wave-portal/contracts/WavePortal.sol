// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves; // 状态变量
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        uint256 timestamp;
        string message;
    }

    Wave[] waves;

    mapping(address => uint256) public lastWaveTime;

    constructor() payable {
        console.log("New Contract!");
        seed = calculateSeed(0);
    }

    function wave(string memory _message) public {
        require(lastWaveTime[msg.sender] + 15 minutes < block.timestamp, "Wait 15m");
        lastWaveTime[msg.sender] = block.timestamp;

        totalWaves++;
        console.log("%s waved w/ message %s!", msg.sender, _message);
        
        waves.push(Wave(msg.sender, block.timestamp, _message));
        emit NewWave(msg.sender, block.timestamp, _message);

        // wave 奖励
        seed = calculateSeed(seed);
        console.log("Random # generated: %d", seed);
        if (seed < 50) {
            console.log("%s won!", msg.sender); 
            uint256 prize = 0.0001 ether;
            require(prize <= address(this).balance,
                "Trying to withdraw more money than the contract has");
            (bool success, ) = (msg.sender).call{value: prize}(""); // 转账
            require(success, "Failed to withdraw money from contract");
        }
    }

    function getAllWaves () public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves () public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function calculateSeed (uint256 _seed) private view returns (uint256) {
        return (block.timestamp + block.difficulty + _seed) % 100;
    }
}