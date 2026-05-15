GPU Validation (manual or CI)
smoke test
NOT applied by Flux

Run:

kubectl apply -f rtx/tests/gpu-pod.yaml
kubectl logs gpu-pod

Expected:

CUDA sample executes successfully
GPU is allocated

