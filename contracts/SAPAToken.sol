// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";


contract SAPAToken is Ownable{

  using SafeMath for uint256;

  mapping(address => uint256) balances;
  uint256 totalSupply_;
  mapping(address => mapping(address => uint256)) internal allowed;
  mapping(address => uint256) locked;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Locked(address indexed owner, uint256 indexed amount);

  string public name;
  string public symbol;
  uint8 public decimals;

  constructor() {
    name = "SAPA INU TOKEN";
    symbol = "SAPA";
    decimals = 18;
    totalSupply_ = 100 * 10**6 * 10**18;

    balances[msg.sender] = totalSupply_;
  }

  function balanceOf(address _owner) public view returns (uint256) {
    return balances[_owner];
  }

  function totalSupply() public view returns (uint256) {
    return totalSupply_;
  }

  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(_value <= balances[msg.sender].sub(locked[msg.sender]));

    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    emit Transfer(msg.sender, _to, _value);

    return true;
  }

  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }

  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }

  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));
    require(balances[_from] >= _value);
    require(allowed[_from][msg.sender].sub(locked[_from]) >= _value);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);

    emit Transfer(_from, _to, _value);
    return true;
  }

  function increaseAllowance(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_value);
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseAllowance(address _spender, uint256 _value) public returns (bool) {

    uint oldValue = allowed[msg.sender][_spender];
    if (oldValue <= _value) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_value);
    }

    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function increaseLockedAmount(address _owner, uint256 _amount) onlyOwner public returns (uint256) {
    uint256 lockingAmount = locked[_owner].add(_amount);
    require(balanceOf(_owner) >= lockingAmount, "Locking amount must not exceed balance");
    locked[_owner] = lockingAmount;
    emit Locked(_owner, lockingAmount);
    return lockingAmount;
  }

  function decreaseLockedAmount(address _owner, uint256 _amount) onlyOwner public returns (uint256) {
    uint256 amt = _amount;
    require(locked[_owner] > 0, "Cannot go negative. Already at 0 locked tokens.");
    if (amt > locked[_owner]) {
      amt = locked[_owner];
    }
    uint256 lockingAmount = locked[_owner].sub(amt);
    locked[_owner] = lockingAmount;
    emit Locked(_owner, lockingAmount);
    return lockingAmount;
  }

  function getLockedAmount(address _owner) view public returns (uint256) {
    return locked[_owner];
  }

  function getUnlockedAmount(address _owner) view public returns (uint256) {
    return balances[_owner].sub(locked[_owner]);
  }
}
