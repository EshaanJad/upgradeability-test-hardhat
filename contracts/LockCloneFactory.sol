// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

// This contract creates clones of the UpgradeableLazySeller's proxy
// With this pattern, we achieve upgradeable contracts that can be 
// deployed repeatedly at minimal cost.

import "@openzeppelin/contracts/proxy/Clones.sol";
import "./Lock.sol";

contract LockCloneFactory {
  // admin is the one who deploys SellerCloneFactory
  address payable public admin;

  // implementation address is the address of the Seller contract
  address public implementationProxy;

  // key value pair is created between address of seller and address of cloned contract
  address[] public clonedContracts;
  mapping (address => address) public lockClonedContract;

  constructor(address payable _implementationProxy) {
    admin = payable(msg.sender);
    implementationProxy = _implementationProxy; // this is actually the address of the upgradeable proxy that was created by hardhat
  }

  // should each user be allowed to call this only once?
  function createClone(uint unlockTime)
    external
   returns (address)
  {
    address payable seller = payable(msg.sender);

    // using the clone() method from the Clones.sol from openZeppelin to create the clone
    address clone = Clones.clone(implementationProxy);
    clonedContracts.push(clone);
    lockClonedContract[seller] = clone;

    // initializing the clone contract
    Lock(clone).initialize(unlockTime);

    return clone;
  }

  function getClone(address _seller) public view returns (address) {
    return lockClonedContract[_seller];
  }
}