// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./myToken.sol";

contract tokenSender {
    
    using ECDSA for bytes32;

    mapping(bytes32 => bool) executed;

    function getHash(
        address from,
        uint amount,
        address to,
        address token,
        uint nonce
    ) public pure returns (bytes32 hash) {
        hash = keccak256(abi.encodePacked(
            from,
            amount,
            to,
            token,
            nonce
        ));
    }

    function transfer(
        address from,
        uint amount,
        address to,
        address token,
        uint nonce,
        bytes memory signature
    ) public {

        bytes32 hash = getHash(from, amount, to, token, nonce);

        bytes32 ethSignedHash = hash.toEthSignedMessageHash();

        require(!executed[ethSignedHash], "Already executed!");

        require(ethSignedHash.recover(signature) == from, "Signature does not come from sender");
        executed[ethSignedHash] = true;
        bool success = IERC20(token).transferFrom(from, to, amount);
        require(success, "Transfer Failed");
    }
}
