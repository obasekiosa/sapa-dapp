// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "openzeppelin-solidity/contracts/utils/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract StoryDao is Ownable {
  using SafeMath for uint256;


  mapping(address => bool) whitelist;
  uint256 public whitelistedNumber = 0;
  mapping(address => bool) blacklist;
  uint256 public daoFee = 100; // hundredths of a percent, i.e. 100 is 1%
  uint256 public whitelistFee = 10000000000000000; // in Wei, this is 0.01 ether
  uint256 public durationDays = 21; // durationof story's chapter in days
  uint256 public durationSubmissions = 1000; //duration of story's chapter in entries
  uint256 public submissionZeroFee = 10;


  event Whitelisted(address addr, bool status);
  event Blacklisted(address addr, bool status);
  event SubmissionCommissionChanged(uint256 newFee);
  event WhitelistFeeChanged(uint256 newFee);
  event SubmissionFeeChanged(uint256 newFee);

  constructor() {
  }

  function() external payable {
    if (!whitelist[msg.sender]) {
      whitelistAddress(msg.sender);
    } else {
      // buyTokens(msg.sender, msg.value);
    }
  }
  
  function changeDaoFee(uint256 _fee) onlyOwner external {
    require(_fee < daoFee, "New fee must be lower than old fee.");
    daoFee = _fee;
    emit SubmissionCommissionChanged(_fee);
  }

  function changeWhitelistFee(uint256 _fee) onlyOwner external {
    require(_fee < whitelistFee, "New fee must be lower than old fee.");
    whitelistFee = _fee;
    emit WhitelistFeeChanged(_fee);
  }

  function lowerSubmissionFee(uint256 _fee) onlyOwner external {
    require(_fee < submissionZeroFee, "New fee must be lower than old fee.");
    submissionZeroFee = _fee;
    emit SubmissionFeeChanged(_fee);
  }

  function changeDurationDays(uint256 _days) onlyOwner external {
    require(_days >= 1);
    durationDays = _days;
  }

  function changeDurationSubmissions(uint256 _subs) onlyOwner external {
    require(_subs > 99);
    durationSubmissions = _subs;
  }

  function whitelistAddress(address _add) public payable {
    require(!whitelist[_add], "Candidate must notbe whitelisted.");
    require(!blacklist[_add], "Candidate must not be blacklisted.");
    require(msg.value >= whitelistFee, "Sendermust send enough ether to cover the whitelisting fee.");
    
    whitelist[_add] = true;
    whitelistedNumber++;
    emit Whitelisted(_add, true);

    if (msg.value > whitelistFee) {
      // buyTokens(_add, msg.value.sub(whitelistfee));
    }
  }

}
