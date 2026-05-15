.PHONY: bootstrap apply test

all: bootstrap apply

bootstrap:
	curl -s https://fluxcd.io/install.sh | sudo bash
	flux install
	kubectl apply -k infrastructure/networking/gateway-api/crds

apply:
	kubectl apply -k clusters/rtx

test:
	kubectl delete pod gpu-pod --ignore-not-found
	kubectl apply -f rtx/tests/gpu-pod.yaml
	kubectl wait --for=condition=Ready pod/gpu-pod --timeout=120s
	kubectl logs -f gpu-pod

lint:
	yamllint .
