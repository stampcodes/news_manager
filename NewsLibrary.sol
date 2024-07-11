// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library NewsLibrary {
    struct News {
        address newsAddress;
        string name;
        uint256 deadline;
        uint256 minValidations;
        bool validated;
        uint256 validationCount;
    }

    function getValidatorCount(
        address[] storage validators
    ) public view returns (uint256) {
        return validators.length;
    }

    function isValidator(
        address[] storage validators,
        address _validator
    ) public view returns (bool) {
        for (uint i = 0; i < validators.length; i++) {
            if (validators[i] == _validator) {
                return true;
            }
        }
        return false;
    }

    function isNewsValidated(News storage newsItem) public view returns (bool) {
        return newsItem.validationCount >= newsItem.minValidations;
    }
}
