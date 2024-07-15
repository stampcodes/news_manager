// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./NewsLibrary.sol";

contract NewsManager {
    using NewsLibrary for address[];
    using NewsLibrary for NewsLibrary.News;

    address public admin;
    address[] public validators;
    mapping(address => uint256) public rewards;
    uint256 public totalRewards;

    NewsLibrary.News[] public newsList;
    mapping(uint256 => mapping(address => bool)) public newsValidations;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function addValidator(address _validator) public onlyAdmin {
        require(!validators.isValidator(_validator), "Address already added.");
        validators.push(_validator);
    }

    function removeValidator(address _validator) public onlyAdmin {
        require(
            validators.isValidator(_validator),
            "The validator does not exist."
        );
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i] == _validator) {
                validators[i] = validators[validators.length - 1];
                validators.pop();
                return;
            }
        }
    }

    function assignReward(address _validator, uint256 _amount) internal {
        require(
            address(this).balance >= _amount,
            "Not enough balance in contract."
        );
        rewards[_validator] += _amount;
        totalRewards += _amount;
        payable(_validator).transfer(_amount);
    }

    function getReward(address _validator) public view returns (uint256) {
        return rewards[_validator];
    }

    function addNews(
        address _newsAddress,
        string memory _name,
        uint256 _deadline,
        uint256 _minValidations
    ) public onlyAdmin {
        newsList.push(
            NewsLibrary.News({
                newsAddress: _newsAddress,
                name: _name,
                deadline: _deadline,
                minValidations: _minValidations,
                validated: false,
                validationCount: 0
            })
        );
    }

    function getNews(
        uint _index
    )
        public
        view
        returns (address, string memory, uint256, uint256, bool, uint256)
    {
        NewsLibrary.News storage n = newsList[_index];
        return (
            n.newsAddress,
            n.name,
            n.deadline,
            n.minValidations,
            n.validated,
            n.validationCount
        );
    }

    function validateNews(uint _newsIndex) public {
        require(
            validators.isValidator(msg.sender),
            "Only validators can validate news."
        );
        NewsLibrary.News storage n = newsList[_newsIndex];
        require(block.timestamp <= n.deadline, "Validation period has ended.");
        require(
            !newsValidations[_newsIndex][msg.sender],
            "Validator has already validated this news."
        );

        newsValidations[_newsIndex][msg.sender] = true;
        n.validationCount += 1;

        if (n.isNewsValidated()) {
            n.validated = true;
            assignReward(msg.sender, 1 ether);
        }
    }

    function isNewsValidated(uint _newsIndex) public view returns (bool) {
        NewsLibrary.News storage n = newsList[_newsIndex];
        return n.isNewsValidated();
    }

    function emergencyWithdraw(address payable _to) public onlyAdmin {
        require(address(this).balance > 0, "No balance to withdraw.");
        _to.transfer(address(this).balance);
    }

    function addFunds() public payable onlyAdmin {}

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getValidatorCount() public view returns (uint256) {
        return validators.getValidatorCount();
    }
}
