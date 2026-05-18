.PHONY: bootstrap crds deploy test-deploy lint diff cleanup cleanup-crds test validate
.DEFAULT_GOAL := deploy

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

KUBECTL := kubectl

CLUSTER := clusters/rtx
CLUSTER_TEST := clusters/rtx-test
TEST_NS := default
FLUX_NS := flux-system

bootstrap:
	command -v flux >/dev/null || \
		(curl -sSf https://fluxcd.io/install.sh | sudo bash)
	flux check --pre
	flux install

crds:
	$(KUBECTL) apply -k infrastructure/networking/gateway-api/crds

deploy: bootstrap crds
	$(KUBECTL) apply -k $(CLUSTER)

test-deploy: bootstrap crds
	$(KUBECTL) apply -k $(CLUSTER_TEST)

lint:
	yamllint .
	$(KUBECTL) kustomize $(CLUSTER) > /dev/null
	$(KUBECTL) kustomize $(CLUSTER_TEST) > /dev/null

diff:
	$(KUBECTL) diff -k $(CLUSTER)

cleanup:
	-$(KUBECTL) delete -k $(CLUSTER) --ignore-not-found=true
	-$(KUBECTL) delete -k $(CLUSTER_TEST) --ignore-not-found=true

cleanup-crds:
	-$(KUBECTL) delete -k infrastructure/networking/gateway-api/crds --ignore-not-found=true

test: cleanup test-deploy
	$(KUBECTL) wait \
		--for=condition=Ready \
		pod/gpu-pod \
		-n $(TEST_NS) \
		--timeout=120s
	$(KUBECTL) logs pod/gpu-pod -n $(TEST_NS) --tail=100

validate: bootstrap crds
	$(KUBECTL) apply -k $(CLUSTER) --dry-run=server --validate=true
	$(KUBECTL) apply -k $(CLUSTER_TEST) --dry-run=server --validate=true
