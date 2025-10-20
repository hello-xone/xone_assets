# Xone Economic Assets Info

## Overview

The repository is a comprehensive, up-to-date collection of information about several thousands (!) of crypto tokens.

The repository contains token info from several blockchains, info on dApps, staking validators, etc.
For every token a logo and optional additional information is available (such data is not available on-chain).

Such a large collection can be maintained only through a community effort, so feel free to add your token or dapp and tool.

## Prerequisites

### 1. Fork the Repository

Fork this repository: [https://github.com/hello-xone/xone_assets](https://github.com/hello-xone/xone_assets/fork)

### 2. Clone the Forked Repository

```bash
git clone https://github.com/YOUR_USERNAME/xone_assets.git
```

## How to Submit a Token to This Repository

Follow the steps below to submit your token information to be listed:

### 1. Navigate to the Token Directory

```bash
cd xone_assets/blockchains/xone/assets/
```

### 2. Add Your Token Information

Create a **new folder** named after your token’s **contract address** (all lowercase). Inside this folder, include the following two files:

#### 📄 `info.json`

Create a JSON file with the following structure. **All fields in "Basic_Information" are required and must have non-empty values.** Fields in "Social_Profiles" and "Price_Data" are optional.

```json
{
  "Basic_Information": {
    "name": "USD Coin",
    "website": "https://www.usdc.com/",
    "description": "Circle Internet Group",
    "whitepaper": "https://usdc.com/whitepaper",
    "explorer": "https://xonescan.com/",
    "type": "ERC20",
    "symbol": "USDC",
    "decimals": 18,
    "status": "active",
    "email": "support@example.com",
    "id": "0x02D45d684A233F3bA0C55fE941854FC0E5235fE1"
  },
  "Social_Profiles": {
    "twitter": "https://twitter.com/USDC",
    "telegram": "https://t.me/usdcofficial",
    "reddit": "https://www.reddit.com/r/USDC/",
    "discord": "https://discord.com/invite/usdc",
    "slack": "https://circleci.com/slack",
    "instagram": "https://www.instagram.com/usdcofficial/",
    "wechat": "https://www.usdc.com/en-us/wechat",
    "facebook": "https://www.facebook.com/usdcofficial",
    "medium": "https://medium.com/usdc",
    "github": "https://medium.com/usdc",
    "blog": "https://www.circle.com/en/blog",
    "bitcointalk": "https://bitcointalk.org/index.php?topic=5243801.0",
    "youtube": "https://www.youtube.com/c/USDc",
    "tiktok": "https://www.tiktok.com/@usdcofficial",
    "forum": "https://community.circle.com/",
    "linkedin": "https://www.linkedin.com/company/usd-coin/",
    "opensea": "https://opensea.io/collection/usdc"
  },
  "Price_Data": {
    "coinMarketCap": "https://opensea.io/collection/usdc",
    "coinGecko": "https://opensea.io/collection/usdc",
    "ave": "https://opensea.io/collection/usdc"
  }
}
```

**Field Descriptions:**

**Basic_Information (All Required):**

- `name`: The full name of your token (e.g., "USD Coin").
- `website`: The official website URL for your token or project.
- `description`: A short description of your token's purpose or functionality.
- `whitepaper`: URL to the project's whitepaper document.
- `explorer`: A blockchain explorer URL where users can view token data (e.g., transactions, holders).
- `type`: Token standard, such as `ERC20`.
- `symbol`: The ticker or abbreviation of your token (e.g., `USDC`).
- `decimals`: The number of decimal places the token uses (typically 18).
- `status`: Listing status of the token. Can be:
  - `active`: Publicly available and valid.
  - `negative`: Inactive or has issues.
  - `prohibited`: Not allowed or blacklisted.
- `email`: Contact email for the project.
- `id`: The token's smart contract address (must be lowercase).

**Social_Profiles (Optional):**
All social profile fields are optional. Leave empty strings for unavailable profiles.

**Price_Data (Optional):**
All Price_Data fields are optional. Leave empty strings for unavailable sources.

#### 🖼 `logo.png`

- Format: **PNG**
- Recommended size: **88x88 pixels**
- File name: `logo.png`

### 3. Commit and Push Your Changes

```bash
git add .
git commit -m "Add {{token name & tool name}} info"
git push origin main
```

### 4. Submit a Pull Request

Go to your forked repository on GitHub and submit a **Pull Request** (PR) to the original repository.

---

After review and approval, your token will be visible in projects that support this repository.

## How to Submit a Tool to This Repository

### 1. Navigate to the Token Directory

```bash
cd xone_assets/blockchains/xone/tools/
```

### 2. Use your IDE to edit the `ToolList.json` file in this directory.

### 3. Add tool information according to the existing tool type grouping and format.

1. Locate the appropriate category array (or create a new category key if needed).
2. Add a new JSON object with the following fields:
   ```json
   {
     "logo": "https://example.com/favicon.ico",
     "name": "YourToolName",
     "description": "Short, clear description of the tool's purpose.",
     "url": "https://yourtool.website/"
   }
   ```
3. **Maintain alphabetical order** within the category array by the `name` field.
4. Ensure all JSON syntax is valid (commas, brackets, quotes).

### 4. Existing group types and descriptions

```
  SDK = "SDK",    // SDK 服务
  RPC = "RPC",    // RPC 服务
  IDE = "IDE",    // IDE
  EXPLORER = "Explorer",    // 区块浏览器
  FAUCET = "Faucet",    // 水龙头
  ANALYTICS = "Analytics",    // 数据分析
  NODE ="Node Services",    // 节点服务
  NFT = "NFT Related",    // NFT 相关
  DATA = "Data Processing",   // 数据处理
  BRIDGES = "Bridges",    // 桥
  DAO = "DAO Related",    // DAO 相关
  QUALITY = "Code Quality",   // 代码质量
  FRONT = "Front-End",    // 前端
  BACK= "Back-End",   // 后端
  FRAMEWORK = "Framework",    // 框架
  MPC = "MPC",    // MPC
  ORACLE = "Oracle",  // 甲骨文
  WALLET = "Wallet",    // 钱包
  PAYMENT = "Payment Gateway",    // 支付网关
  AUDIT = "Security Audit",   // 安全审计
  STORAGE = "Storage"   // 存储
```

## Additional Information

### Please note:

- **Brand new tokens and new tools are not accepted.**
- Projects must be sound, with available information and **non-minimal circulation**.

### Assets App

The Assets web app can be used for most new token additions (GitHub account is needed).

### Quick starter

_You can also use scripts below to help with token submission and validation._

### Validation Script

Before submitting your token, you can validate all `info.json` files using the provided validation script:

```bash
bash validate_info_json.sh
```

This script will:

- Scan all `info.json` files in `blockchains/xone` and `blockchains/xone_testnet` directories
- Validate that all required fields in "Basic_Information" are present and have non-empty values
- Check for unexpected fields or sections not in the standard format
- Report any validation errors

**Requirements:**

- The script requires `jq` to be installed on your system
- All fields in "Basic_Information" must be present and have non-empty values
- "Social_Profiles" and "Price_Data" sections are optional, but if present, should only contain the allowed fields

## About display

The token information, tools and DApps information of this repository will be displayed in the following projects because they rely on the relevant information of this repository as the display source.

- [Xone official website](https://xone.org)
- [Xone Scan](https://xonescan.com)
- [SwapX](https://swapx.exchange/en)
- [RainLink](https://rainlink.co/)
- [TokenUp](https://tokenup.org/en)

## Scripts

There are several scripts available for maintainers:

- `make check` -- Execute validation checks; also used in continuous integration.
- `make fix` -- Perform automatic fixes where possible
- `make update-auto` -- Run automatic updates from external sources, executed regularly (GitHub action)

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
