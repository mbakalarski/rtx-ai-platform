# RTX AI Platform

GitOps-managed single-node Kubernetes platform for local AI workloads on NVIDIA RTX GPUs.

Includes:
- vLLM inference serving
- MLflow tracking
- GPU monitoring
- Gateway API networking
- FluxCD GitOps management
- NVIDIA GPU runtime integration

---

## Prerequisites

* GPU visible (`nvidia-smi`)
* NVIDIA container runtime configured (e.g. `nvidia-container-toolkit`)
* Kubernetes cluster with a default StorageClass

---

## Quickstart

```bash
make bootstrap
```

Then open:
- MLflow - `http://<node-ip>/mlflow`
- Grafana - `http://<node-ip>/grafana`
- vLLM - `http://<node-ip>/llm`

---

## GPU Validation

```bash
make test
```

Expected:
- CUDA sample executes successfully
- GPU allocation works correctly

---

## License

MIT — see [LICENSE](LICENSE)
