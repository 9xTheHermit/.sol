// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract lottery {
    address public manager;
    address[] public players;

    constructor() {
        manager = msg.sender;
    }

    function join() public payable {
        require(msg.value >= 1 ether, "Must send 1 ETH to join game");
        players.push(msg.sender);
    }
    
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(blockhash(block.number-1), block.timestamp, players)));
    }

    function pickWinner() public restricted {
        uint businessFee = address(this).balance * 1 / 100;
        uint prize = address(this).balance - businessFee;

        payable(manager).transfer(businessFee);

        uint index = random() % players.length;

        payable(players[index]).transfer(prize);
        players = new address[](0);
    }

    modifier restricted() {
        require(msg.sender == manager, "This function can only be called by the manager");
        _;
    }

    function getPlayers() public view returns (address[] memory) {
        return players;
    }
}