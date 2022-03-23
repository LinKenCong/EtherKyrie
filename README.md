# EtherKyrie

## Hardhat

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.ts
TS_NODE_FILES=true npx ts-node scripts/deploy.ts
npx eslint '**/*.{js,ts}'
npx eslint '**/*.{js,ts}' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

```shell
hardhat run --network ropsten scripts/deploy.ts
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

```shell
yarn hardhat clean
yarn hardhat clear-abi
yarn hardhat node
yarn hardhat compile
yarn hardhat run --network localhost scripts/deploy.ts
yarn hardhat test
```

## Hardhat ABI Exporter

```shell
yarn hardhat export-abi
yarn hardhat clear-abi
yarn hardhat export-abi --no-compile
```
