// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.7.0;

import {CrossDomainMessenger} from "./CrossDomainMessenger.sol";

abstract contract CrossDomainEnabled {
    /// @notice Messenger contract used to send and receive messages from the other domain.
    CrossDomainMessenger public immutable CROSS_DOMAIN_MESSENGER;

    /// @param _CROSS_DOMAIN_MESSENGER Address of the CrossDomainMessenger on the current layer.
    constructor(CrossDomainMessenger _CROSS_DOMAIN_MESSENGER) {
        CROSS_DOMAIN_MESSENGER = _CROSS_DOMAIN_MESSENGER;
    }

    /// @dev Enforces that the modified function is only callable by a specific cross-domain account.
    /// @param sourceDomainAccount The only account on the originating domain which is authenticated to call this function.
    modifier onlyFromCrossDomainAccount(address sourceDomainAccount) {
        require(msg.sender == address(CROSS_DOMAIN_MESSENGER), "NOT_CROSS_DOMAIN_MESSENGER");

        require(CROSS_DOMAIN_MESSENGER.xDomainMessageSender() == sourceDomainAccount, "WRONG_CROSS_DOMAIN_SENDER");

        _;
    }
}
