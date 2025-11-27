// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";
import {CTErc20} from "./CTERC20.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {ICTERC20} from "./ICTERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract CTWrapper is IERC1155Receiver, ReentrancyGuard {
    address public immutable ctAddress;
    mapping(uint256 ctId => address erc20) public ctIdToErc20;

    constructor(address _ctAddress) {
        ctAddress = _ctAddress;
    }

    function computeBytecode(uint256 ctId) public pure returns (bytes memory) {
        return abi.encodePacked(type(CTErc20).creationCode, abi.encode(ctId));
    }
    function computeAddress(uint256 ctId, bytes32 salt) public view returns (address predicted) {
        predicted = Create2.computeAddress(salt, keccak256(computeBytecode(ctId)), address(this));
    }
    function wrap(uint256 ctId, uint256 amount) external nonReentrant {
        address ctErc20 = ctIdToErc20[ctId];
        if (ctErc20 == address(0)) {
            ctIdToErc20[ctId] = Create2.deploy(0, bytes32(ctId), computeBytecode(ctId));
            ctErc20 = ctIdToErc20[ctId];
        }
        IERC1155(ctAddress).safeTransferFrom(msg.sender, address(this), ctId, amount, "");
        ICTERC20(ctErc20).mint(msg.sender, amount);
    }

    function unwrap(uint256 ctId, uint256 amount) external nonReentrant {
        address ctErc20 = ctIdToErc20[ctId];
        require(ctErc20 != address(0), "CTWrapper: CT not found");
        ICTERC20(ctErc20).burn(msg.sender, amount);
        IERC1155(ctAddress).safeTransferFrom(address(this), msg.sender, ctId, amount, "");
    }

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override returns (bytes4) {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId;
    }
}
