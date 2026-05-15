# RTX AI Platform

GitOps-managed single-node Kubernetes platform for local AI workloads on NVIDIA RTX GPU.

Includes:
- vLLM inference serving
- MLflow tracking
- GPU monitoring
- Gateway API networking
- FluxCD GitOps management
- NVIDIA GPU runtime integration

---

## ⚙️ Setup

### 1. Prerequisites

* GPU visible (`nvidia-smi`)
* NVIDIA container runtime configured (e.g. nvidia-container-toolkit with containerd)
* Kubernetes with StorageClass (local path)

---

### 2. Install FluxCD (GitOps mode)

```bash
curl -s https://fluxcd.io/install.sh | sudo bash
```

```bash
flux bootstrap <provider>
```
This installs FluxCD and links the cluster to this repository.

---

### 3. Manual / no Git sync (optional)

FluxCD is used as the GitOps engine, but the repository can also be applied manually for local development.

```
flux install
```
This installs Flux w/o repo sync.

```bash
kubectl apply -k infrastructure/ingress/crds
```

CRDs are also included in cluster kustomizations, but applying them separately speeds up first install.

Then:

```bash
kubectl apply -k clusters/rtx
```

---

## 🧪 GPU Validation - RTX

```bash
kubectl apply -f rtx/tests/gpu-pod.yaml
```

```bash
kubectl logs gpu-pod
```

Expected: CUDA sample executes successfully.

---

## 🌐 Access Services

WebUI:

* MLflow → `/mlflow`
* Grafana → `/grafana`
* Prometheus → `/prometheus`
* Alertmanager → `/alertmanager`

and LLM API with `llm` prefix

---

## 📄 License

TBD
