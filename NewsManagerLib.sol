// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

library NewsManagerLib {
    function getValidatorCount(
        mapping(uint256 => address) storage validators
    ) external view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < 2 ** 256 - 1; i++) {
            if (validators[i] != address(0)) {
                count++;
            }
        }
        return count;
    }

    function isValidator(
        mapping(uint256 => address) storage validators,
        address validator
    ) external view returns (bool) {
        for (uint256 i = 0; i < 2 ** 256 - 1; i++) {
            if (validators[i] == validator) {
                return true;
            }
        }
        return false;
    }

    function isNewsValidated(
        uint256 validationsCount,
        uint256 minValidations
    ) external pure returns (bool) {
        return validationsCount >= minValidations;
    }
}
