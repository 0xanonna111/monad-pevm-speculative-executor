// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SpeculativeCacheRegistry
 * @dev On-chain diagnostic ledger capturing historical prediction accurate ratings from validation operations.
 */
contract SpeculativeCacheRegistry is Ownable {

    struct CacheDiagnosticReport {
        uint32 blocksOptimizedCount;
        uint32 absoluteCacheHits;
        bool isAudited;
    }

    mapping(address => CacheDiagnosticReport) public performanceLogs;
    address public infrastructureManager;

    event TelemetryLogged(address indexed validationNode, uint32 cacheHits, uint32 blocks);

    constructor() Ownable(msg.sender) {
        infrastructureManager = msg.sender;
    }

    /**
     * @notice Registers verified node caching metrics to help profile system health metrics.
     */
    function recordCachePerformance(
        address validationNode, 
        uint32 cacheHits, 
        uint32 blocks
    ) external {
        require(msg.sender == infrastructureManager, "AuthError: Caller identity matches no whitelisted manager profiles");
        
        performanceLogs[validationNode] = CacheDiagnosticReport({
            blocksOptimizedCount: blocks,
            absoluteCacheHits: cacheHits,
            isAudited: true
        });

        emit TelemetryLogged(validationNode, cacheHits, blocks);
    }
}
