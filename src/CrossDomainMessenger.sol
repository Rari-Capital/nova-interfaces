// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.7.0;

interface CrossDomainMessenger {
    /*///////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event SentMessage(bytes message);

    event RelayedMessage(bytes32 msgHash);

    event FailedRelayedMessage(bytes32 msgHash);

    /*///////////////////////////////////////////////////////////////
                          STATEFUL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function sendMessage(
        address target,
        bytes calldata message,
        uint32 gasLimit
    ) external;

    /*///////////////////////////////////////////////////////////////
                           VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function xDomainMessageSender() external view returns (address);
}
