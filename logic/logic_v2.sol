// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Logic_V2 {
    uint256 private data;

    function initialize(uint256 _initialValue) external {
        data = _initialValue * 2; // Example modification
    }

    function set(uint256 _value) public {
        data = _value * 2; // Example modification
    }

    function get() public view returns (uint256) {
        return data;
    }
}
