.PHONY: bootstrap apply test

bootstrap:
	curl -s https://fluxcd.io/install.sh | sudo bash
	flux install
	kubectl apply -k infrastructure/networking/gateway-api/crds
	kubectl apply -k clusters/rtx

apply:
	kubectl apply -k clusters/rtx

test:
	kubectl apply -f rtx/tests/gpu-pod.yaml
	kubectl logs -f gpu-pod
