// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ICTERC20} from "./ICTERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract CTErc20 is ERC20, Ownable, ICTERC20 {
    uint256 public immutable ctId;
    constructor(uint256 _ctId) ERC20(Strings.toString(_ctId), Strings.toString(_ctId)) Ownable(msg.sender) {
        ctId = _ctId;
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
    function burn(address from, uint256 amount) external onlyOwner {
        _burn(from, amount);
    }
}
