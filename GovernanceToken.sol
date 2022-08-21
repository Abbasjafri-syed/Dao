// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract GovernanceToken is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimal;
    address private Deployer;

constructor(string memory name_, string memory symbol_, uint8 decimal_) {
    _name = name_;
    _symbol = symbol_;
    _decimal = decimal_;
    Deployer = msg.sender;
    }

function checkAddress(address _addr) public view returns (bool) {
        uint256 length;
        assembly {
        length := extcodesize(_addr)
        }
        if (length > 0) {
            return true;
        }
        return false;
    }

modifier Verifyaddress(){
       require(!checkAddress(msg.sender), 'Contract not allowed to interact');
       _;
    }

receive () external payable Verifyaddress{
    require(msg.value >= 1 ether, 'Amount needed to transfer');
    uint256 amount = msg.value/ 1 ether;
       _mint(msg.sender, amount * 10 ** decimals());
       }

function burn_token(uint256 amount) external Verifyaddress{
    require(_balances[_msgSender()] >= amount,"Amount more than current balance");
            _burn(msg.sender, amount);}

function withdrawfunds(address account) external {
    require(msg.sender == Deployer, "Only Owner is allowed to mint Tokens");
    payable(account).transfer(address(this).balance);
    }

function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        unchecked {_balances[account] += amount;}
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);}
function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), "ERC20: burn from the zero address");
    _beforeTokenTransfer(account, address(0), amount);
    uint256 accountBalance = _balances[account];
    require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
    unchecked {
    _balances[account] = accountBalance - amount;
    _totalSupply -= amount;}
    emit Transfer(account, address(0), amount);
    _afterTokenTransfer(account, address(0), amount);}
   
function name() public view virtual override returns (string memory) {
    return _name;}
function symbol() public view virtual override returns (string memory) {
    return _symbol;}
function decimals() public view virtual override returns (uint8) {
    return _decimal;}
function totalSupply() public view virtual override returns (uint256) {
    return _totalSupply;}
function balanceOf(address account) public view virtual override returns (uint256) {
    return _balances[account];}
function transfer(address to, uint256 amount) public virtual override returns (bool) {
    address owner = _msgSender();
    _transfer(owner, to, amount);
    return true;}
function allowance(address owner, address spender) public view virtual override returns (uint256) {
    return _allowances[owner][spender];}
function approve(address spender, uint256 amount) public virtual override returns (bool) {
    address owner = _msgSender();
    _approve(owner, spender, amount);
    return true;}
function transferFrom(
    address from,
    address to,
    uint256 amount
    ) public virtual override returns (bool) {
    address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;}
function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;}
function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
        _approve(owner, spender, currentAllowance - subtractedValue);}
        return true;}
function _transfer(
    address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(from, to, amount);
        unchecked {
            _balances[from] -= amount;
            _balances[to] += amount;}
        emit Transfer(from, to, amount);
        _afterTokenTransfer(from, to, amount);}

function _approve(
    address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);}

function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);}}}

function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}
