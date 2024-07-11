// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract NewsManager {
    address[] public validators;

    function addValidator(address _validator) public {
        for (uint i = 0; i < validators.length; i++) {
            require(validators[i] != _validator, "Address already added.");
        }
        validators.push(_validator);
    }




    function removeValidator(address _validator) public {
        for (uint i = 0; i < validators.length; i++ ){
            if(_validator == validators[i]){
                validators[i] = validators[validators.length - 1];
                validators.pop();
                return;
            }
        }
        revert("The validator does not exist.");
    }


}