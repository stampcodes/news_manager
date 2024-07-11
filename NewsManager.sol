// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract NewsManager {
    address public admin;
    address[] public validators;
    mapping(address => uint256) public rewards;
    uint256 public totalRewards;

    struct News {
        address newsAddress;
        string name;
        uint256 deadline;
        uint256 minValidations;
        bool validated;
        uint256 validationCount;
    }

    News[] public newsList;
    mapping(uint256 => mapping(address => bool)) public newsValidations;

    constructor() {
        admin = msg.sender;
    }

    receive() external payable {}

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function addValidator(address _validator) public onlyAdmin {
        for (uint256 i = 0; i < validators.length; i++) {
            require(validators[i] != _validator, "Address already added.");
        }
        validators.push(_validator);
    }

    function removeValidator(address _validator) public onlyAdmin {
        for (uint256 i = 0; i < validators.length; i++) {
            if (_validator == validators[i]) {
                validators[i] = validators[validators.length - 1];
                validators.pop();
                return;
            }
        }
        revert("The validator does not exist.");
    }

    function assignReward(address _validator, uint256 _amount)
        public
        onlyAdmin
    {
        require(isValidator(_validator), "Address is not a validator.");
        require(
            address(this).balance >= _amount,
            "Not enough balance in contract."
        );
        rewards[_validator] += _amount;
        totalRewards += _amount;
        payable(_validator).transfer(_amount);
    }

    function isValidator(address _validator) public view returns (bool) {
        for (uint256 i = 0; i < validators.length; i++) {
            if (validators[i] == _validator) {
                return true;
            }
        }
        return false;
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
            News({
                newsAddress: _newsAddress,
                name: _name,
                deadline: _deadline,
                minValidations: _minValidations,
                validated: false,
                validationCount: 0
            })
        );
    }

    function getNews(uint256 _index)
        public
        view
        returns (
            address,
            string memory,
            uint256,
            uint256,
            bool
        )
    {
        News storage n = newsList[_index];
        return (
            n.newsAddress,
            n.name,
            n.deadline,
            n.minValidations,
            n.validated
        );
    }

    function validateNews(uint256 _newsIndex) public {
        require(isValidator(msg.sender), "Only validators can validate news.");
        News storage n = newsList[_newsIndex];
        require(block.timestamp <= n.deadline, "Validation period has ended.");
        require(
            !newsValidations[_newsIndex][msg.sender],
            "Validator has already validated this news."
        );

        newsValidations[_newsIndex][msg.sender] = true;
        n.validationCount += 1;

        if (n.validationCount >= n.minValidations) {
            n.validated = true;
            assignReward(msg.sender, 1 ether);
        }
    }

    function isNewsValidated(uint256 _newsIndex) public view returns (bool) {
        News storage n = newsList[_newsIndex];
        return n.validated;
    }

    function emergencyWithdraw(address payable _to) public onlyAdmin {
        require(address(this).balance > 0, "No balance to withdraw.");
        _to.transfer(address(this).balance);
    }

    function addFunds() public payable onlyAdmin {}
}
