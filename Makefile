include .env

.EXPORT_ALL_VARIABLES:
FOUNDRY_ETH_RPC_URL=$(RPC_URL)
PRIVATE_KEY=$(PRIVATEKEY)
ETHERSCAN_API_KEY=$(ETHERSCAN_KEY)

default:; @forge fmt && forge build
start:; @forge script script/UpdateScript.sol --fork-url ${RPC_URL} # --private-key ${PRIVATEKEY} --broadcast --etherscan-api-key ${ETHERSCAN_KEY} --verify # --resume

.PHONY: test deploy 