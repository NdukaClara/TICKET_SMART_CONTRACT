// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

/**
 * @title Ticket
 * @dev use this smart contract in place of ERC20 because ERC20 is bulky for this use case
 */

contract Ticket {
    uint256 ticketPrice = 0.01 ether; // price of ticket
    address owner;
    mapping(address => uint256) public ticketHolders; // stores who owns a ticket

    /**
     * @dev set contract deployer as owner
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev allows _user to buy a ticket
     */
    function buyTickets(address _user, uint256 _amount) public payable {
        require(msg.value >= ticketPrice * _amount, "Insufficient funds!");
        addTickets(_user, _amount);
    }

    function useTickets(address _user, uint256 _amount) public {
        subTickets(_user, _amount);
    }

    /**
     * @dev add ticket
     * @param _user address of user
     * @param _amount of ticket allocated to user
     */
    function addTickets(address _user, uint256 _amount) internal {
        ticketHolders[_user] += _amount;
    }

    /**
     * @dev subtract ticket
     */
    function subTickets(address _user, uint256 _amount) internal {
        require(
            ticketHolders[_user] >= _amount,
            "You do not have enough tickets."
        ); // makes sure the user has enough tickets in order to subtract
        ticketHolders[_user] -= _amount;
    }

    /**
     * @dev implement a withdraw method to get ether out again
     */
    function withdraw() public {
        require(msg.sender == owner, "You are not the owner.");
        (bool success, ) = payable(owner).call{value: address(this).balance}(
            ""
        );
        require(success);
    }
}
