# Deployment Scripts

This directory contains deployment scripts for the Bayex contracts.

## Deploy.sol

Deploys the PoolManager (AMM) and CTWrapper contracts.

### Prerequisites

1. Create a `.env` file in the project root (copy from `.env.example`):

   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and fill in your values:

   ```bash
   PRIVATE_KEY=your_private_key_here
   CT_ADDRESS=0x...  # Address of the ERC1155 CT contract
   # POOL_MANAGER_OWNER=0x...  # Optional: Owner address (defaults to deployer)
   ```

   **Note:** The `.env` file is already in `.gitignore` and will not be committed to version control.

### Usage

#### Deploy to a local network (Anvil)

```bash
# Start Anvil in a separate terminal
anvil

# Load .env file and deploy to local network
source .env && forge script script/Deploy.sol:Deploy --rpc-url http://localhost:8545 --broadcast
```

#### Deploy to a testnet/mainnet

```bash
# Load .env file and deploy to Sepolia testnet
source .env && forge script script/Deploy.sol:Deploy \
  --rpc-url $SEPOLIA_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY

# Load .env file and deploy to mainnet
source .env && forge script script/Deploy.sol:Deploy \
  --rpc-url $MAINNET_RPC_URL \
  --broadcast \
  --verify \
  --etherscan-api-key $ETHERSCAN_API_KEY
```

**Alternative:** If you prefer not to use `source .env`, you can export variables manually:

```bash
export $(cat .env | xargs) && forge script script/Deploy.sol:Deploy --rpc-url http://localhost:8545 --broadcast
```

### Output

The script will:

1. Deploy both contracts
2. Print deployment addresses to the console
3. Save deployment information to `deployments/{chainId}.json`

The JSON file contains:

- `poolManager`: Address of the deployed PoolManager contract
- `poolManagerOwner`: Owner address of the PoolManager
- `ctWrapper`: Address of the deployed CTWrapper contract
- `ctAddress`: Address of the ERC1155 CT contract used
- `deployer`: Address of the deployer
- `chainId`: Chain ID where contracts were deployed
- `blockNumber`: Block number at deployment time

### Example Output

```
Deploying contracts with deployer: 0x...
Deployer balance: 1000000000000000000
Deploying PoolManager with owner: 0x...
PoolManager deployed at: 0x...
Deploying CTWrapper with CT address: 0x...
CTWrapper deployed at: 0x...

=== Deployment Summary ===
PoolManager: 0x...
PoolManager Owner: 0x...
CTWrapper: 0x...
CT Address: 0x...
Deployer: 0x...
Chain ID: 1
Block Number: 12345678

Deployment addresses saved to: deployments/1.json
```

### Security Notes

- Never commit your `.env` file or private keys to version control
- Use a dedicated deployer account with minimal funds
- Verify contracts after deployment for transparency
- Review all deployment parameters before broadcasting transactions
