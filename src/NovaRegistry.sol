// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.7.0;

import {ERC20} from "solmate/erc20/ERC20.sol";
import {Authority} from "solmate/auth/Auth.sol";

import {CrossDomainMessenger} from "./CrossDomainMessenger.sol";

interface NovaRegistry {
    /*///////////////////////////////////////////////////////////////
                                CONSTANTS
    //////////////////////////////////////////////////////////////*/

    function CROSS_DOMAIN_MESSENGER() external pure returns (CrossDomainMessenger);

    function MAX_INPUT_TOKENS() external pure returns (uint256);

    function MIN_UNLOCK_DELAY_SECONDS() external pure returns (uint256);

    /*///////////////////////////////////////////////////////////////
                    EXECUTION MANAGER ADDRESS STORAGE
    //////////////////////////////////////////////////////////////*/

    function L1_NovaExecutionManagerAddress() external view returns (address);

    function connectExecutionManager(address newExecutionManagerAddress) external;

    /*///////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event ExecutionManagerConnected(address newExecutionManagerAddress);

    event RequestExec(bytes32 indexed execHash, address indexed strategy);

    event ExecCompleted(bytes32 indexed execHash, address indexed rewardRecipient, bool reverted, uint256 gasUsed);

    event ClaimInputTokens(bytes32 indexed execHash);

    event WithdrawTokens(bytes32 indexed execHash);

    event UnlockTokens(bytes32 indexed execHash, uint256 unlockTimestamp);

    event RelockTokens(bytes32 indexed execHash);

    event SpeedUpRequest(bytes32 indexed execHash, bytes32 indexed newExecHash, uint256 newNonce, uint256 switchTimestamp);

    /*///////////////////////////////////////////////////////////////
                       GLOBAL NONCE COUNTER STORAGE
    //////////////////////////////////////////////////////////////*/

    function systemNonce() external view returns (uint256);

    /*///////////////////////////////////////////////////////////////
                           PER REQUEST STORAGE
    //////////////////////////////////////////////////////////////*/

    function getRequestCreator(bytes32 execHash) external view returns (address);

    function getRequestStrategy(bytes32 execHash) external view returns (address);

    function getRequestCalldata(bytes32 execHash) external view returns (bytes memory);

    function getRequestGasLimit(bytes32 execHash) external view returns (uint256);

    function getRequestGasPrice(bytes32 execHash) external view returns (uint256);

    function getRequestTip(bytes32 execHash) external view returns (uint256);

    function getRequestNonce(bytes32 execHash) external view returns (uint256);

    struct InputToken {
        ERC20 l2Token;
        uint256 amount;
    }

    function getRequestInputTokens(bytes32 execHash) external view returns (InputToken[] memory);

    struct InputTokenRecipientData {
        address recipient;
        bool isClaimed;
    }

    function getRequestInputTokenRecipientData(bytes32 execHash) external view returns (InputTokenRecipientData memory);

    function getRequestUnlockTimestamp(bytes32 execHash) external view returns (uint256);

    function getRequestUncle(bytes32 execHash) external view returns (bytes32);

    function getResubmittedRequest(bytes32 execHash) external view returns (bytes32);

    function getRequestDeathTimestamp(bytes32 execHash) external view returns (uint256);

    /*///////////////////////////////////////////////////////////////
                           STATEFUL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function requestExec(
        address strategy,
        bytes calldata l1Calldata,
        uint256 gasLimit,
        uint256 gasPrice,
        uint256 tip,
        InputToken[] calldata inputTokens
    ) external returns (bytes32 execHash);

    function requestExecWithTimeout(
        address strategy,
        bytes calldata l1Calldata,
        uint256 gasLimit,
        uint256 gasPrice,
        uint256 tip,
        InputToken[] calldata inputTokens,
        uint256 autoUnlockDelaySeconds
    ) external returns (bytes32 execHash);

    function unlockTokens(bytes32 execHash, uint256 unlockDelaySeconds) external;

    function withdrawTokens(bytes32 execHash) external;

    function relockTokens(bytes32 execHash) external;

    function speedUpRequest(bytes32 execHash, uint256 gasPrice) external returns (bytes32 newExecHash);

    function claimInputTokens(bytes32 execHash) external;

    function execCompleted(
        bytes32 execHash,
        address rewardRecipient,
        bool reverted,
        uint256 gasUsed
    ) external;

    /*///////////////////////////////////////////////////////////////
                             VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function areTokensUnlocked(bytes32 execHash) external view returns (bool unlocked, uint256 changeTimestamp);

    function hasTokens(bytes32 execHash) external view returns (bool requestHasTokens, uint256 changeTimestamp);

    /*///////////////////////////////////////////////////////////////
                          AUTHENTICATION LOGIC
    //////////////////////////////////////////////////////////////*/

    function authority() external view returns (Authority);

    function owner() external view returns (address);

    function setAuthority(Authority newAuthority) external;

    function setOwner(address newOwner) external;
}
