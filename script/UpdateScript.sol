// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/Script.sol";

interface Agent {
    function initialize() external;
    function execute(address, uint256, bytes memory) external;
    function EXECUTE_ROLE() external view returns (bytes32);
}

interface GaugeController {
    function add_gauge(address, uint256) external;
    function change_gauge_weight(address, uint256) external;
    function get_gauge_weight(address) external view returns (uint256);
}

contract UpdateScript is Script, Test {
    address internal constant DEPLOYER = 0x0dE5199779b43E13B3Bec21e91117E18736BC1A8;

    address internal constant AGENT = 0x30f9fFF0f55d21D666E28E650d0Eb989cA44e339;
    address internal constant GAUGE_CONTROLLER = 0x3F3F0776D411eb97Cfa4E3eb25F33c01ca4e7Ca8;

    // Gauge to update
    address internal constant SETH_GAUGE = 0x087143dDEc7e00028AA0e446f486eAB8071b1f53;

    function run() public {
        vm.startBroadcast(DEPLOYER);
        // ACL
        Agent(AGENT).execute(
            GAUGE_CONTROLLER, 0, abi.encodeWithSignature("change_gauge_weight(address,uint256)", SETH_GAUGE, 0)
        );
        if (GaugeController(GAUGE_CONTROLLER).get_gauge_weight(SETH_GAUGE) > 0) revert("Gauge weight should be 0");

        vm.stopBroadcast();
    }

    function deployBytecode(bytes memory bytecode, bytes memory args) internal returns (address deployed) {
        bytecode = abi.encodePacked(bytecode, args);
        assembly {
            deployed := create(0, add(bytecode, 0x20), mload(bytecode))
        }
        require(deployed != address(0), "DEPLOYMENT_FAILED");
    }
}
