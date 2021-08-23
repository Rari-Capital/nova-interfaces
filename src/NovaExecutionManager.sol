// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.7.0;

import {Authority} from "solmate/auth/Auth.sol";

import {CrossDomainMessenger} from "./CrossDomainMessenger.sol";

interface NovaExecutionManager {
    /*///////////////////////////////////////////////////////////////
                              CONSTANTS
    //////////////////////////////////////////////////////////////*/

    function HARD_REVERT_HASH() external pure returns (bytes32);

    function HARD_REVERT_TEXT() external pure returns (string memory);

    function DEFAULT_EXECHASH() external pure returns (bytes32);

    /*///////////////////////////////////////////////////////////////
                              IMMUTABLES
    //////////////////////////////////////////////////////////////*/

    function CROSS_DOMAIN_MESSENGER() external pure returns (CrossDomainMessenger);

    function L1_NOVA_APPROVAL_ESCROW() external pure returns (address);

    function L2_NOVA_REGISTRY_ADDRESS() external pure returns (address);

    /*///////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/

    event Exec(bytes32 indexed execHash, address relayer, bool reverted, uint256 gasUsed);

    event AuthorityUpdated(Authority indexed authority);

    event OwnerUpdated(address indexed owner);

    /*///////////////////////////////////////////////////////////////
                   GAS LIMIT/ESTIMATION CONFIGURATION
    //////////////////////////////////////////////////////////////*/

    struct GasConfig {
        uint32 calldataByteGasEstimate;
        uint96 missingGasEstimate;
        uint96 strategyCallGasBuffer;
        uint32 execCompletedMessageGasLimit;
    }

    function gasConfig() external view returns (GasConfig memory);

    function updateGasConfig(GasConfig calldata newGasConfig) external;

    /*///////////////////////////////////////////////////////////////
                      STRATEGY RISK LEVEL STORAGE
    //////////////////////////////////////////////////////////////*/

    enum StrategyRiskLevel {
        UNKNOWN,
        SAFE,
        UNSAFE
    }

    function getStrategyRiskLevel(address strategy) external view returns (StrategyRiskLevel);

    function registerSelfAsStrategy(StrategyRiskLevel strategyRiskLevel) external;

    /*///////////////////////////////////////////////////////////////
                        EXECUTION CONTEXT STORAGE
    //////////////////////////////////////////////////////////////*/

    function currentExecHash() external view returns (bytes32);

    function currentRelayer() external view returns (address);

    function currentlyExecutingStrategy() external view returns (address);

    /*///////////////////////////////////////////////////////////////
                            EXECUTION LOGIC
    //////////////////////////////////////////////////////////////*/

    function exec(
        uint256 nonce,
        address strategy,
        bytes calldata l1Calldata,
        uint256 gasLimit,
        address l2Recipient,
        uint256 deadline
    ) external;

    /*///////////////////////////////////////////////////////////////
                          STRATEGY UTILITIES
    //////////////////////////////////////////////////////////////*/

    function transferFromRelayer(address token, uint256 amount) external;

    function hardRevert() external pure;

    /*///////////////////////////////////////////////////////////////
                          AUTHENTICATION LOGIC
    //////////////////////////////////////////////////////////////*/

    function authority() external view returns (Authority);

    function owner() external view returns (address);

    function setAuthority(Authority authority) external;

    function setOwner(address owner) external;
}
