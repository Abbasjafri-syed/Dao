// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";


contract GovernanceToken is ERC20, ERC20Burnable, Ownable, ERC20Permit, ERC20Votes {
    address Deployer;
    uint8 private _decimal;

constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_) ERC20Permit(symbol_) {
    Deployer = msg.sender;
    _decimal = decimals_;
    _mint(msg.sender, 2 * 10 ** _decimal); // minting Proposal threshold Tokens to Deployer
    }

    function checkAddress(address _addr) public view returns (bool) { // function to identify address as Contract or EOA
        uint256 length;
        assembly {
        length := extcodesize(_addr)
        }
        if (length > 0) {
            return true;
        }
        return false;
    }

    modifier Verifyaddress(){ // modifier to check whether address is a contract or EOA
       require(!checkAddress(msg.sender), 'Contract not allowed to interact');
       _;
    }

    receive () external payable Verifyaddress{ // receive function to give governance token to sender of funds...
    require(msg.value >= 1 ether, 'Amount needed to become governor');
    uint256 amount = msg.value/ 1 ether;
       _mint(msg.sender, amount * 10 ** decimals()); 
       }
    
    function BurnTokens(uint256 amount) public { // burning of token- burn token of sender and amount determined..
        _burn(msg.sender, amount);
    }

    function withdrawfunds(address account) external { //withdraw functions for amount that are sent by users to have governance Rights...
    require(msg.sender == Deployer, "Only Owner is allowed to mint Tokens");
    payable(account).transfer(address(this).balance);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function decimals() public view virtual //determining decimals numbers for token
    override(ERC20)
    returns (uint8) {
        return _decimal;
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(to, amount);
    }
}
