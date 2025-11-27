// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract CTErc20 is ERC20 {
    constructor(uint256 ctId) ERC20(Strings.toString(ctId), Strings.toString(ctId)) {}
}
