# Xone Economic Assets Info

## Overview

The repository is a comprehensive, up-to-date collection of information about several thousands (!) of crypto tokens.

The repository contains token info from several blockchains, info on dApps, staking validators, etc.
For every token a logo and optional additional information is available (such data is not available on-chain).

Such a large collection can be maintained only through a community effort, so _feel free to add your token_.

## How to Submit a Token to This Repository

Follow the steps below to submit your token information to be listed:

### 1. Fork the Repository

Fork this repository: [https://github.com/hello-xone/xone_assets](https://github.com/hello-xone/xone_assets)

### 2. Clone the Forked Repository

```bash
git clone https://github.com/YOUR_USERNAME/xone_assets.git
```

### 3. Navigate to the Token Directory

```bash
cd xone_assets/blockchains/xone/assets/
```

### 4. Add Your Token Information

Create a **new folder** named after your token’s **contract address** (all lowercase). Inside this folder, include the following two files:

#### 📄 `info.json`

Create a JSON file with the following structure:

```json
{
  "name": "example",                     
  "website": "https://example.com/",     
  "description": "example",              
  "explorer": "https://xonecan.com/",    
  "type": "ERC20",                       
  "symbol": "ZRO",                       
  "decimals": 18,                         
  "status": "active",                    
  "id": "0x000000000000000000000000"     
}
```

**Field Descriptions:**

- `name`: The full name of your token (e.g., "ZeroToken").
- `website`: The official website URL for your token or project.
- `description`: A short description of your token’s purpose or functionality.
- `explorer`: A blockchain explorer URL where users can view token data (e.g., transactions, holders).
- `type`: Token standard, such as `ERC20`.
- `symbol`: The ticker or abbreviation of your token (e.g., `ZRO`).
- `decimals`: The number of decimal places the token uses (typically 18).
- `status`: Listing status of the token. Can be:
  - `active`: Publicly available and valid.
  - `negative`: Inactive or has issues.
  - `prohibited`: Not allowed or blacklisted.
- `id`: The token’s smart contract address (must be lowercase).

#### 🖼 `logo.png`

- Format: **PNG**
- Recommended size: **88x88 pixels**
- File name: `logo.png`

### 5. Commit and Push Your Changes

```bash
git add .
git commit -m "Add {{token name}} info"
git push origin main
```

### 6. Submit a Pull Request

Go to your forked repository on GitHub and submit a **Pull Request** (PR) to the original repository.

---

After review and approval, your token will be visible in projects that support this repository.

## Additional Information

### Please note:
- **Brand new tokens are not accepted.**
- Projects must be sound, with available information and **non-minimal circulation**.

### Assets App

The Assets web app can be used for most new token additions (GitHub account is needed).

### Quick starter

_You can also use scripts below to help with token submission and validation._

## Scripts

There are several scripts available for maintainers:

- `make check` -- Execute validation checks; also used in continuous integration.
- `make fix` -- Perform automatic fixes where possible
- `make update-auto` -- Run automatic updates from external sources, executed regularly (GitHub action)
- `make add-token asset_id=c60_t0x4Fabb145d64652a948d72533023f6E7A623C7C53` -- Create `info.json` file as asset template.
- `make add-tokenlist asset_id=c60_t0x4Fabb145d64652a948d72533023f6E7A623C7C53` -- Adds a token to tokenlist.json.
- `make add-tokenlist-extended asset_id=c60_t0x4Fabb145d64652a948d72533023f6E7A623C7C53` -- Adds a token to tokenlist-extended.json.

## On Checks

This repo contains a set of scripts for verification of all the information. Implemented as Golang scripts, available through `make check`, and executed in CI build; checks the whole repo.

There are similar check logic implemented:

- in assets-management app; for checking changed token files in PRs, or when creating a PR. Checks diffs, can be run from browser environment.
- in merge-fee-bot, which runs as a GitHub app and shows result in PR comment. Executes in a non-browser environment.

## Disclaimer

Xone team allows anyone to submit new assets to this repository. However, this does not mean that we are in direct partnership with all of the projects.

Xone team will reject projects that are deemed as scam or fraudulent after careful review.
Xone team reserves the right to change the terms of asset submissions at any time due to changing market conditions, risk of fraud, or any other factors we deem relevant.

Additionally, spam-like behavior, including but not limited to mass distribution of tokens to random addresses will result in the asset being flagged as spam and possible removal from the repository.

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE)