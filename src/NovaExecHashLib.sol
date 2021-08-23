// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.7.0;

library NovaExecHashLib {
    function compute(
        uint256 nonce,
        address strategy,
        bytes memory l1Calldata,
        uint256 gasPrice,
        uint256 gasLimit
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(nonce, strategy, l1Calldata, gasPrice, gasLimit));
    }
}
