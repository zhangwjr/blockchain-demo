// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Callee {
    uint256 public value;

    function getValue() public view returns (uint256) {
        return value;
    }

    function setValue(uint256 value_) public payable {
        require(msg.value > 0);
        value = value_;
    }

    function getData() public pure returns (uint256) {
        return 42;
    }
}

contract Caller {
    uint256 public value;
    function callGetData(address callee) public view returns (uint256 data) {
        bytes memory payload = abi.encodeWithSignature("getData()");

        (bool success, bytes memory returnData) = callee.staticcall(payload);
        require(success, "staticcall function failed");

        data = abi.decode(returnData, (uint256));
    }

    function callSetValue(address callee, uint256 value_) public returns (bool) {
        bytes memory payload = abi.encodeWithSignature("setValue(uint256)", value_);

        (bool success, ) = callee.call{value: 1 ether}(payload);
        require(success, "call function failed");

        return true;
    }

    function delegateSetValue(address callee, uint256 _newValue) public payable {
        bytes memory payload = abi.encodeWithSignature("setValue(uint256)", _newValue);

        (bool success, ) = callee.delegatecall(payload);
        require(success, "delegate call failed");
    }

    function sendEther(address to, uint256 value) public returns (bool) {
        (bool success, ) = to.call{value: value}("");
        require(success, "sendEther failed");
        return true;
    }

    receive() external payable {}
}
