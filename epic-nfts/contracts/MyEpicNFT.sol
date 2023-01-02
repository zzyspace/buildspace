// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract MyEpicNFT is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // NFT name & symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract!");
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId); // msg.sender 调用合约的人的地址
        tokenURI(newItemId);
        _tokenIds.increment();
    }
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId));
        console.log("An NFT w/ ID %s has been minted by %s", _tokenId, msg.sender);
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                "ewogICAgIm5hbWUiOiAiRXBpY0RhdGVORlQiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0OGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaTgrUEhSbGVIUWdlRDBpTlRBbElpQjVQU0kxTUNVaUlHUnZiV2x1WVc1MExXSmhjMlZzYVc1bFBTSnRhV1JrYkdVaUlIUmxlSFF0WVc1amFHOXlQU0p0YVdSa2JHVWlJSE4wZVd4bFBTSm1hV3hzT2lObVptWTdabTl1ZEMxbVlXMXBiSGs2YzJWeWFXWTdabTl1ZEMxemFYcGxPakUwY0hnaVBqSXdNak11TVM0eVBDOTBaWGgwUGp3dmMzWm5QZz09Igp9"
            )
        );
    }
}