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
- `id`: The token’s smart contract address.

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
