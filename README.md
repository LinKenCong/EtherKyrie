# EtherKyrie

运行命令启动前端 如：

```shell
yarn f
# or
npm run f
```

所有命令及作用：

```shell
yarn i-all: "cd ./frontend && yarn install && cd .. && cd ./hardhat && npm i && cd ..",
yarn f: "cd ./frontend && yarn next dev && cd ..",
yarn hh: "cd ./hardhat && yarn hardhat node && cd ..",
yarn hh-compile: "cd ./hardhat && yarn hardhat compile && cd ..",
yarn hh-dev-l: "cd ./hardhat && yarn hardhat run --network localhost scripts/deploy.ts && cd ..",
yarn hh-clear: "cd ./hardhat && yarn hardhat clean && yarn hardhat clear-abi && cd ..",
yarn hh-test: "cd ./hardhat && yarn hardhat test && cd .."
```

如果不起作用可以到相应目录下使用原来的命令。