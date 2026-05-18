.PHONY: all bootstrap deploy test lint cleanup

CLUSTER := clusters/rtx

all: bootstrap deploy

bootstrap:
	curl -s https://fluxcd.io/install.sh | sudo bash
	flux check || flux install
	kubectl apply -k infrastructure/networking/gateway-api/crds

deploy:
	kubectl apply -k $(CLUSTER)

test:
	kubectl delete pod gpu-pod --ignore-not-found=true
	kubectl apply -f rtx/tests/gpu-pod.yaml
	kubectl wait --for=condition=Ready pod/gpu-pod --timeout=120s
	kubectl logs -f gpu-pod

lint:
	yamllint .
	kubectl apply -k $(CLUSTER) --dry-run=client > /dev/null

cleanup:
	kubectl delete -k $(CLUSTER) --ignore-not-found=true
