// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // 数据源
    string[] firstWords = ["Awesome", "Fantastic", "Well", "Poor", "Terrible", "Crazy", "Funky", "Spooky", "Rocky", "Wild", "Boom", "Running", "Terrifying", "F*cking", "Coding"];
    string[] secondWords = ["Cupcake", "Pizza", "Milkshake", "Curry", "Chicken", "Sandwich", "Salad", "Oil", "Soy", "Galic", "Ori", "Orange", "Radish", "Pancake", "Coffee"];
    string[] thirdWords = ["Naruto", "Sasuke", "Sakura", "Goku", "Garra", "Minato", "Santoshi", "Kakashi", "Itachi", "Madara", "Mina", "Kulama", "Zilaya", "Muya", "Lisa"];

    // NFT name & symbol
    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract!");
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomWord(0, newItemId);
        string memory second = pickRandomWord(1, newItemId);
        string memory third = pickRandomWord(2, newItemId);
        string memory name = string(abi.encodePacked(first, second, third));

        string memory finalSvg = string(abi.encodePacked(baseSvg, name, "</text></svg>"));
        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

        // json
        string memory metadata = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        name,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", metadata)
        );

        console.log("\n--------------------");
        // console.log("https://nftpreview.0xdev.codes/?code=", finalTokenUri);
        console.log(
            string(
                abi.encodePacked("https://nftpreview.0xdev.codes/?code=", finalTokenUri)
            )
        );
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId); // msg.sender 调用合约的人的地址

        // tokenURI(newItemId);
        // _tokenIds.increment();

        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log("An NFT w/ ID %s has been minted by %s", newItemId, msg.sender);
    }

    // function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    //     require(_exists(_tokenId));
    //     console.log("An NFT w/ ID %s has been minted by %s", _tokenId, msg.sender);
    //     return string(
    //         abi.encodePacked(
    //             "data:application/json;base64,",
    //             "ewogICAgIm5hbWUiOiAiRXBpY0RhdGVORlQiLAogICAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MGlhSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY2lJSEJ5WlhObGNuWmxRWE53WldOMFVtRjBhVzg5SW5oTmFXNVpUV2x1SUcxbFpYUWlJSFpwWlhkQ2IzZzlJakFnTUNBek5UQWdNelV3SWo0OGNtVmpkQ0IzYVdSMGFEMGlNVEF3SlNJZ2FHVnBaMmgwUFNJeE1EQWxJaTgrUEhSbGVIUWdlRDBpTlRBbElpQjVQU0kxTUNVaUlHUnZiV2x1WVc1MExXSmhjMlZzYVc1bFBTSnRhV1JrYkdVaUlIUmxlSFF0WVc1amFHOXlQU0p0YVdSa2JHVWlJSE4wZVd4bFBTSm1hV3hzT2lObVptWTdabTl1ZEMxbVlXMXBiSGs2YzJWeWFXWTdabTl1ZEMxemFYcGxPakUwY0hnaVBqSXdNak11TVM0eVBDOTBaWGgwUGp3dmMzWm5QZz09Igp9"
    //         )
    //     );
    // }

    // Tools
    function pickRandomWord(uint256 count, uint256 tokenId) public view returns (string memory) {
        string[] memory words;
        uint result = count % 3;
        if (result == 0) {
            words = firstWords;
        } else if (result == 1) {
            words = secondWords;
        } else {
            words = thirdWords;
        }
        uint256 rand = ramdom(string(abi.encodePacked(Strings.toString(result), Strings.toString(tokenId))));
        rand = rand % words.length;
        return words[rand];
    }

    function ramdom(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }
}