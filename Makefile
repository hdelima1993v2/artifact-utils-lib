PYTHON=python3
TF_DIR=infra

.PHONY: build plan apply output clean version

version:
	@grep '^version' pyproject.toml

build:
	./scripts/build_layer.sh

plan: build
	cd $(TF_DIR) && terraform init -upgrade
	cd $(TF_DIR) && terraform plan

apply: build
	cd $(TF_DIR) && terraform init
	cd $(TF_DIR) && terraform apply -auto-approve

output:
	cd $(TF_DIR) && terraform output

clean:
	rm -rf layer_build layer.zip
	find . -type d -name "__pycache__" -exec rm -rf {} +
