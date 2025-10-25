---

## ☸️ Deploy în Kubernetes 
Aplicația de monitorizare și backup rulează complet containerizată într-un cluster **Minikube**, organizată în namespace-ul `monitoring`.  
Sunt folosite 3 containere în același pod: `monitor`, `backup` și `nginx`, cu **scalare automată (HPA)** configurată pentru CPU și memorie.

---

### 🧱 Arhitectură generală

| Componentă | Rol | Imagine | Observații |
|-------------|------|----------|-------------|
| 🖥️ **monitor** | Rulează scriptul [`monitoring.sh`](../scripts/monitoring.sh) care colectează informații despre CPU, memorie, procese și disk | `system-monitor` | scrie în `system-state.log` |
| 💾 **backup** | Rulează [`backup.py`](../scripts/backup.py) și face backup la loguri doar când acestea se modifică | `system-backup` | salvează în directorul `/backup` |
| 🌐 **nginx** | Expune logurile prin HTTP | `nginx:latest` | montează volumul `logdata` la `/usr/share/nginx/html/logs` |

---

### ⚙️ Fișiere Kubernetes

| Fișier | Descriere |
|--------|------------|
| [`k8s/deployment.yaml`](../k8s/deployment.yaml) | Creează un **Deployment** cu 2 replici care rulează cele 3 containere în același Pod |
| [`k8s/service.yaml`](../k8s/service.yaml) | Creează un **Service (NodePort)** pentru acces la containerul Nginx |
| [`k8s/hpa.yaml`](../k8s/hpa.yaml) | Configurează un **Horizontal Pod Autoscaler (HPA)** cu 2–10 replici în funcție de CPU și memorie |

---

### 🚀 Comenzi rapide de rulare

```bash
# 1. Pornește Minikube
minikube start --driver=docker

# 2. Creează namespace-ul
kubectl create namespace monitoring

# 3. Construiește imaginile local
eval $(minikube docker-env)
docker build -t system-monitor -f docker/Dockerfile.monitoring .
docker build -t system-backup -f docker/Dockerfile.backup .

# 4. Aplică manifestele Kubernetes
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml

# 5. Accesează aplicația
minikube service monitoring-service -n monitoring --url
