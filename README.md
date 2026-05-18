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
* NVIDIA container runtime configured (`nvidia-container-toolkit`)
* Kubernetes cluster with a default StorageClass

---

## Quickstart

```bash
make deploy
```

Then open:
- MLflow - `http://<node-ip>:<node-port>/mlflow`
- Grafana - `http://<node-ip>:<node-port>/grafana`
- Prometheus - `http://<node-ip>:<node-port>/prometheus`
- vLLM - `http://<node-ip>:<node-port>/llm/v1/models`

---

## License

MIT — see [LICENSE](LICENSE)
