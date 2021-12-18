build:
	@docker compose build
	@docker compose push

cluster:
	@kind create cluster \
		--config config/cluster-config.yaml \
		--wait 5m
	@kubectl create ns prod --context kind-galaxy
	@kubectl apply -Rf ./charts/devel

registry:
	@echo Setting up local registry
	@chmod 7777 ./scripts/registry.sh
	@./scripts/registry.sh

deploy:
	@kubectl apply -Rf charts/ --context kind-galaxy --force

up:
	@$(MAKE) --no-print-directory cluster || echo "Cluster ready..."
	@$(MAKE) --no-print-directory registry || echo "Registry ready..."
	@$(MAKE) --no-print-directory build
	@$(MAKE) --no-print-directory deploy

down:
	@kind delete cluster --name galaxy
	@docker kill kind-registry
	@docker system prune -af
