pragma solidity ^0.8.6;

import "ds-test/test.sol";

import "./nova-interfaces.sol";

contract nova-interfacesTest is DSTest {
    nova-interfaces interfaces;

    function setUp() public {
        interfaces = new nova-interfaces();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
