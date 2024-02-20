// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract Logic_V1 {
    uint256 private data;

    function initialize(uint256 _initialValue) external {
        data = _initialValue;
    }

    function set(uint256 _value) public {
        data = _value;
    }

    function get() public view returns (uint256) {
        return data;
    }
}
