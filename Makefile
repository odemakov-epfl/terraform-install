# Getting started with CEDE terraform
SHELL := /bin/bash

TERRAFORM_VERSION := 0.11.14
PYTHON_OPENSTACKCLIENT_VERSION := 3.19

DIR_VENV := ./venv
DIR_BIN := ${DIR_VENV}/bin

OS := $(shell uname)

# Terraform version to download and install in Terraform's venv
ifeq ($(OS),Darwin)
	TERRAFORM_FILE := ${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_darwin_amd64.zip
else
	TERRAFORM_FILE := ${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
endif
DOWNLOAD_URL := https://releases.hashicorp.com/terraform/${TERRAFORM_FILE}
DOWNLOADED_FILE := ${DIR_BIN}/terraform_${TERRAFORM_VERSION}.zip


default: help


init: clean ## setup virtualenv and terraform
	@virtualenv ${DIR_VENV}
	@curl -o ${DIR_BIN}/terraform.zip $(DOWNLOAD_URL)
	@unzip ${DIR_BIN}/terraform.zip -d ${DIR_BIN}
	@source ${DIR_BIN}/activate && pip install python-openstackclient==$(PYTHON_OPENSTACKCLIENT_VERSION)
.PHONY: init


clean: ## clean virtualenv
	@rm -rf $(DIR_VENV)
.PHONY: clean


help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.PHONY: help
