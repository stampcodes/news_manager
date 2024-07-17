# News Manager Smart Contract

This project contains a smart contract named "News Manager" developed in Solidity and deployed on the Sepolia test network. The contract allows the management of news, including creating, updating, and viewing articles.

## Overview

The News Manager contract allows users to add, update, and view news articles. It is designed to be efficient and secure, utilizing best practices for smart contract development.

## Contract Address on Sepolia

The contract has been deployed on the Sepolia test network and can be viewed on Etherscan at the following address: [0x48C92668b2dEf2613719f9E98De1204829A55A9F](https://sepolia.etherscan.io/address/0x48C92668b2dEf2613719f9E98De1204829A55A9F)

## Technical Choices

### Language and Tools

- **Solidity**: Solidity was chosen as it is the primary language for developing smart contracts on the Ethereum platform.
- **Remix IDE**: Remix was used to write, test, and deploy the contract. It is an online development environment that offers a wide range of tools to facilitate the development process.

### Contract Architecture

The project is divided into two main files:

1. **NewsManager.sol**: This file contains the main contract that handles the logic of adding, viewing and validating news articles.
2. **NewsManagerLib.sol**: This file contains a support library used by the main contract for auxiliary functions.

### Main Features

- **Adding Articles**: Users can add new articles by specifying the title, content, and author.
- **Viewing Articles**: Anyone can view the published articles, ensuring transparency and accessibility.
- **Validating Articles**: News articles can be validated, and after receiving three validations, an article is approved.

## Project Structure

- **NewsManager.sol**: Contains the main functions for managing news articles.
- **NewsManagerLib.sol**: Contains support functions used by the main contract.

## How to Use

1. Clone the repository:

```sh
git clone https://github.com/stampcodes/NewsManager.git
```

2. Navigate to the project directory:

```sh
cd NewsManager
```

3. Open Remix IDE and import the NewsManager.sol and NewsManagerLib.sol files.

4. Compile the contracts within Remix IDE.

5. Deploy the contract on the Sepolia test network using Remix's deployment option. Make sure to connect to Sepolia via MetaMask or another Web3 provider.

6. Verify the contract on Etherscan:

The deployed contract can be verified and viewed on Etherscan using the provided address.

## License

Distributed under the GPL-3.0 license. See `LICENSE` for more information.

## Contact

For more information, you can contact:

- **Name**: Andrea Fragnelli
- **Project Link**: [https://github.com/stampcodes/NewsManager](https://github.com/stampcodes/NewsManager)
