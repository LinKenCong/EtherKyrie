# EtherKyrie

## Run Project

清理-运行hardhat节点网络-部署-测试

```shell
yarn hardhat clean
yarn hardhat clear-abi
yarn hardhat node
yarn hardhat compile
yarn hardhat run --network localhost scripts/deploy.ts
yarn hardhat test
```

## Hardhat Use

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

hardhat run --network ropsten scripts/deploy.ts
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```

## Hardhat ABI Exporter

```shell
yarn hardhat export-abi
yarn hardhat clear-abi
yarn hardhat export-abi --no-compile
```
