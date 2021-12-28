CLUSTER:="galaxy"

all: cluster registry build-installers build deploy

build-installers: registry
	@COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 \
	    docker compose -f installers/docker-compose.yaml build
	@COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 \
	    docker compose -f installers/docker-compose.yaml push

build: registry
	@COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 \
		docker compose build
	@COMPOSE_DOCKER_CLI_BUILD=1 DOCKER_BUILDKIT=1 \
		docker compose push

cluster: registry
	@kind create cluster \
		--config config/cluster-config.yaml \
		--wait 5m || echo "Cluster ready..."
	@kubectl --context kind-$(CLUSTER) create ns prod --context kind-galaxy \
		|| echo "prod namespace exists..."
	@$(MAKE) -C devel/registry join
	@kubectl --context kind-$(CLUSTER) apply -f ./devel/registry/registry.yaml

registry:
	@$(MAKE) -C devel/registry up

deploy:
	@helm uninstall juno-galaxy || echo "Doesn't exist"
	@helm install --values .values.yaml juno-galaxy charts/

down:
	@kind delete cluster --name $(CLUSTER)
	@$(MAKE) -C devel/registry down
