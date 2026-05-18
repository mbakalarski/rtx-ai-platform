.PHONY: bootstrap crds apply test lint diff cleanup deploy

.DEFAULT_GOAL := deploy

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

CLUSTER := clusters/rtx

bootstrap:
	curl -sSf https://fluxcd.io/install.sh | sudo bash
	flux check --pre
	flux install

crds:
	kubectl apply -k infrastructure/networking/gateway-api/crds

apply: crds
	kubectl apply -k $(CLUSTER)

test:
	kubectl delete pod gpu-pod --ignore-not-found=true
	kubectl apply -f rtx/tests/gpu-pod.yaml
	kubectl wait --for=condition=Ready pod/gpu-pod --timeout=120s
	kubectl logs -f gpu-pod --tail=100

lint:
	yamllint .
	kubectl kustomize $(CLUSTER) > /dev/null

diff:
	kubectl diff -k $(CLUSTER)

cleanup:
	kubectl delete -k $(CLUSTER) --ignore-not-found=true
	kubectl delete -k infrastructure/networking/gateway-api/crds --ignore-not-found=true

deploy: bootstrap apply
