// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "./NewsManagerLib.sol";

contract NewsManager {
    using NewsManagerLib for mapping(uint256 => address);
    using NewsManagerLib for uint256;

    struct News {
        address whoMadeTheNews;
        string newsName;
        uint256 expirationDate;
        uint256 minValidations;
        uint256 validationsCount;
        bool validated;
    }

    address public admin;
    mapping(uint256 => address) private validators;
    mapping(address => uint256) private rewards;
    mapping(uint256 => News) private news;
    mapping(address => bool) private isAddressAdded;
    uint256 public totalRewards;
    uint256 public rewardAmount = 1 ether;

    event ValidatorAdded(uint256 indexed validatorId, address validatorAddress);
    event ValidatorRemoved(uint256 indexed validatorId);
    event NewsAdded(
        uint256 indexed newsId,
        address whoMadeTheNews,
        string newsName,
        uint256 expirationDate
    );
    event NewsValidated(uint256 indexed newsId, address validator);
    event RewardDistributed(address indexed validator, uint256 amount);
    event RewardAmountSet(uint256 newRewardAmount);
    event FundsReceived(address from, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "You are not the admin");
        _;
    }

    modifier validatorNotRegistered(uint256 _validatorId) {
        require(
            validators[_validatorId] == address(0),
            "The validator Id is already taken"
        );
        _;
    }

    modifier idNotRegistered(uint256 _newsId) {
        require(
            news[_newsId].whoMadeTheNews == address(0),
            "The news Id is already taken"
        );
        _;
    }

    function addValidator(
        uint256 _validatorId,
        address _validatorAddress
    ) public onlyAdmin validatorNotRegistered(_validatorId) {
        require(!isAddressAdded[_validatorAddress], "Address already added");
        validators[_validatorId] = _validatorAddress;
        isAddressAdded[_validatorAddress] = true;
        emit ValidatorAdded(_validatorId, _validatorAddress);
    }

    function removeValidator(uint256 _validatorId) public onlyAdmin {
        require(
            validators[_validatorId] != address(0),
            "The validator does not exist"
        );
        isAddressAdded[validators[_validatorId]] = false;
        delete validators[_validatorId];
        emit ValidatorRemoved(_validatorId);
    }

    function addNews(
        uint256 _newsId,
        string memory _newsName,
        uint256 _expirationDate
    ) public idNotRegistered(_newsId) {
        news[_newsId] = News(
            msg.sender,
            _newsName,
            _expirationDate,
            3,
            0,
            false
        );
        emit NewsAdded(_newsId, msg.sender, _newsName, _expirationDate);
    }

    function getNewsDetails(uint256 _newsId) public view returns (News memory) {
        return news[_newsId];
    }

    function validateNews(uint256 _newsId) public {
        require(
            isAddressAdded[msg.sender],
            "You are not a registered validator"
        );
        require(
            block.timestamp <= news[_newsId].expirationDate,
            "Validation period expired"
        );
        require(!news[_newsId].validated, "News already validated");

        news[_newsId].validationsCount += 1;
        if (
            news[_newsId].validationsCount.isNewsValidated(
                news[_newsId].minValidations
            )
        ) {
            news[_newsId].validated = true;
            rewards[msg.sender] += rewardAmount;
            totalRewards += rewardAmount;
            emit NewsValidated(_newsId, msg.sender);
        }
    }

    function distributeRewards(
        address payable _validator,
        uint256 _amount
    ) public payable onlyAdmin {
        require(rewards[_validator] >= _amount, "Not enough rewards");
        rewards[_validator] -= _amount;
        totalRewards -= _amount;
        _validator.transfer(_amount);
        emit RewardDistributed(_validator, _amount);
    }

    function getContractBalance() public view onlyAdmin returns (uint256) {
        return address(this).balance;
    }

    function addFund() public payable onlyAdmin {
        emit FundsReceived(msg.sender, msg.value);
    }

    function setRewardAmount(uint256 _newRewardAmount) public onlyAdmin {
        rewardAmount = _newRewardAmount;
        emit RewardAmountSet(_newRewardAmount);
    }

    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    function getValidatorCount() public view returns (uint256) {
        return validators.getValidatorCount();
    }

    function isValidator(address _validator) public view returns (bool) {
        return validators.isValidator(_validator);
    }
}
