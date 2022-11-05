// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Tree {
  bytes32[] public hashes;
  string[4] transactions = [
    "TX1: Alina => Vova",
    "TX2: Vera => Petya",
    "TX3: Masha => Vika",
    "TX4: Eva => Misha"
  ];

  constructor() {
    for (uint i = 0; i < transactions.length; i++) {
      hashes.push(makeHash(transactions[i]));
    }

    uint count = transactions.length;
    uint offset = 0;

    while (count > 0) {
      for (uint i = 0; i < count - 1; i += 2) {
        hashes.push(
          keccak256(
            abi.encodePacked(hashes[offset + i], hashes[offset + i + 1])
          )
        );
      }
      offset += count;
      count = count / 2;
    }
  }

  function verify(
    string memory transaction,
    uint index,
    bytes32 root,
    bytes32[] memory proof
  ) public pure returns (bool) {
    //     ROOT
    // H1-2   H3-4
    //H1  H2  H3  H4
    bytes32 hash = makeHash(transaction);
    for (uint i = 0; i < proof.length; i++) {
      bytes32 element = proof[i];
      if (index % 2 == 0) {
        hash = keccak256(abi.encodePacked(hash, element));
      } else {
        hash = keccak256(abi.encodePacked(element, hash));
      }
      index = index / 2;
    }
    return hash == root;
  }

  //verify(h3, 2, root, [H3-4, H1-2])
  function encode(string memory input) public pure returns (bytes memory) {
    return abi.encodePacked(input);
  }

  function makeHash(string memory input) public pure returns (bytes32) {
    return keccak256(encode(input));
  }
}
