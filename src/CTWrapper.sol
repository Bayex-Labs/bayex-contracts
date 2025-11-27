// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {CTErc20} from "./CTERC20.sol";
contract CTWrapper {
    address public immutable ctAddress;
    mapping(uint256 ctId => address erc20) public ctIdToErc20;

    constructor(address _ctAddress) {
        ctAddress = _ctAddress;
    }

    function wrap(uint256 ctId, uint256 amount) external {
        if (ctIdToErc20[ctId] == address(0)) {
            ctIdToErc20[ctId] = address(new CTErc20(ctId));
        }
    }

    function unwrap(uint256 ctId) external {
        address erc20 = ctIdToErc20[ctId];
        require(erc20 != address(0), "CTWrapper: CT not found");
        IERC20(erc20).transfer(msg.sender, IERC20(erc20).balanceOf(address(this)));
    }
}
