# 🧠 Platforma de Monitorizare a Stării unui Sistem

## 🎯 Scopul Proiectului
Acest proiect demonstrează o soluție completă DevOps care integrează:

- 🔍 Monitorizarea sistemului prin scripturi automate;
- 💾 Backup periodic al logurilor;
- 🐳 Containerizare cu **Docker** și orchestrare cu **Docker Compose**;
- ☸️ Rulare în **Kubernetes** folosind **Minikube**;
- ⚙️ Automatizare completă cu **Ansible**.

---

## 🏗️ Arhitectura Proiectului

### 📘 Structura Generală
```
📂 proiect-monitorizare
├── /scripts
│   ├── monitoring.sh        # Script Shell care monitorizează sistemul și generează system-state.log
│   └── backup.py            # Script Python care creează backup pentru loguri
│
├── /docker
│   ├── Dockerfile.monitoring   # Imagine Docker pentru scriptul de monitorizare
│   ├── Dockerfile.backup       # Imagine Docker pentru scriptul de backup
│   ├── docker-compose.yml      # Definește și pornește containerele monitor și backup
│   └── /data
│       └── logs                # Folder pentru stocarea fișierelor log
│
├── /kubernetes
│   ├── deployment.yaml         # Deployment cu containerele monitor și backup
│   ├── service.yaml            # Service pentru expunerea aplicației
│   └── hpa.yaml                # Configurare HPA (Horizontal Pod Autoscaler)
│
├── /ansible
│   ├── inventory.ini           # Lista de hosturi pentru Ansible
│   ├── deploy_platform.yml     # Playbook care face deploy la containere
│   └── install_docker.yml      # Playbook care instalează Docker pe mașini noi
│
├── /jenkins
│   └── /pipelines
│       ├── monitoring
│       │   └── Jenkinsfile    # Pipeline pentru scriptul de monitorizare (build, push, deploy)
│       └── backup
│           └── Jenkinsfile    # Pipeline pentru scriptul Python de backup (build, push)
│
├── README.md
└── terraform
    ├── main.tf
    └── backend.tf
```
# Documentație directoare proiect

Această documentație descrie structura și funcționalitatea principalelor directoare din proiectul de monitorizare și backup.

---

## 📂 scripts

Directorul `/scripts` conține scripturile care rulează efectiv funcționalitatea platformei.

### Conținut:

- `monitoring.sh`  
  - Script Shell care monitorizează resursele sistemului (CPU, memorie, disk, procese) și generează fișiere `system-state.log`.
  
- `backup.py`  
  - Script Python care creează backup pentru fișierele de log generate de monitorizare.
  - Poate salva fișierele într-un folder dedicat și poate fi rulat periodic.

### Funcționalitate:

- Automatizează colectarea datelor despre sistem.
- Creează backup pentru datele monitorizate.
- Servesc ca bază pentru containerele Docker și pipeline-urile CI/CD.

---

## 📂 docker

Directorul `/docker` conține fișierele necesare pentru **crearea imaginilor Docker** și rularea containerelor.

### Conținut:

- `Dockerfile.monitoring`  
  - Imagine pentru scriptul de monitorizare.
  - Bază: Debian sau alt OS ușor.
  - Instalează utilitare necesare (`sysstat`, `procps`), copiază scriptul `monitoring.sh` și definește CMD pentru rulare.

- `Dockerfile.backup`  
  - Imagine pentru scriptul de backup.
  - Bază: Python slim.
  - Copiază scriptul `backup.py` și folderul de loguri, definește CMD pentru rulare.

- `docker-compose.yml`  
  - Definește și pornește ambele containere (`monitor` și `backup`) cu volume și rețea comună.
  
- `/data/logs`  
  - Folder unde sunt stocate fișierele log persistente generate de containere.

### Funcționalitate:

- Containerizează aplicația pentru portabilitate și consistență între medii.
- Permite rularea izolat a scripturilor fără a afecta sistemul gazdă.
- Docker Compose simplifică orchestrarea și comunicarea între containere.

---

## 📂 kubernetes

Directorul `/kubernetes` conține fișiere pentru rularea aplicației în **cluster Kubernetes**.

### Conținut:

- `deployment.yaml`  
  - Definește Deployment pentru containerele de monitorizare și backup.
  
- `service.yaml`  
  - Configurează accesul la aplicație și comunicația între containere.
  
- `hpa.yaml`  
  - Configurează Horizontal Pod Autoscaler pentru scalare automată pe baza utilizării resurselor.

### Funcționalitate:

- Orchestrarea și scalarea containerelor.
- Gestionarea comunicației între containere.
- Permite deploy repetabil și replicabil pe diferite medii.

---

## 📂 ansible

Directorul `/ansible` conține playbook-uri și fișiere de inventar pentru **automatizarea setup-ului serverelor**.

### Conținut:

- `inventory.ini`  
  - Lista de hosturi/servere pentru care se rulează playbook-urile.
  
- `install_docker.yml`  
  - Playbook care instalează Docker pe mașinile noi.

- `deploy_platform.yml`  
  - Playbook care rulează `docker-compose.yml` pe servere, configurând containerele monitorizare și backup.

### Funcționalitate:

- Automatizează configurarea mediului și deploy-ul aplicației.
- Reduce erorile manuale la instalarea Docker și rularea containerelor.
- Permite deploy rapid și sigur pe medii noi.

---

## 📂 jenkins

Directorul `/jenkins/pipelines` conține **pipeline-urile CI/CD** pentru proiect.

### Conținut:

- `backup/Jenkinsfile`  
  - Pipeline pentru scriptul Python de backup.
  - Etape: verificare sintaxă Python, teste unitare, build Docker, push pe Docker Hub, cleanup.

- `monitoring/Jenkinsfile`  
  - Pipeline pentru scriptul Shell de monitorizare.
  - Etape: build Docker, push pe Docker Hub, eventual deploy.

### Funcționalitate:

- Automatizează procesul CI/CD pentru backup și monitorizare.
- Asigură build și deploy repetabil.
- Integrare cu Docker Hub pentru distribuirea imaginilor.


##  Setup și Rulare

Această secțiune descrie **toți pașii necesari** pentru a instala, configura și rula proiectul, atât local, cât și remote, folosind Ansible.

---

### 🧰 1. Tool-uri necesare

Înainte de a începe, asigură-te că ai instalate următoarele:

| Tool | Versiune recomandată | Scop |
|------|----------------------|------|
| **Docker** | ≥ 24.x | Rularea containerelor |
| **Docker Compose** | ≥ 2.x | Orchestrarea serviciilor |
| **Ansible** | ≥ 2.15.x | Automatizarea instalării și deploy-ului |
| **Python** | ≥ 3.10 | Execuția scriptului de backup |
| **Minikube** | ≥ 1.33 | Cluster Kubernetes local |
| **kubectl** | compatibil cu Minikube | Interacțiune cu Kubernetes |
| **OpenSSH** | latest | Conectare la VM remote |
| **VirtualBox** *(opțional)* | pentru VM-uri locale | Testare în mediu izolat |

---

### 🖥️ 2. Configurare locală

Clonează proiectul și intră în director:
```
git clone https://github.com/MarcuCalin/Platforma-monitorizare/
cd monitoring-platform

# Build imagine backup
docker build -t system-backup -f docker/Dockerfile.backup .

# Build imagine monitor
docker build -t system-monitor -f docker/Dockerfile.monitoring .


cd docker
docker-compose up --build -d
docker ps
Ar trebui să vezi două containere:

backup
monitor

Verifică logurile generate:
docker logs monitor
docker logs backup
Verifică existența backup-urilor:
ls scripts/backup/
```

## 🧩 Setup și rulare în Ansible
```
Pe masina client citim cheia publica a userului curent
cat ~/.ssh/id_rsa.pub

Pe masina remote (masina noua) adaugam un user nou si ii setam cheia de ssh
sudo adduser ansible_user

Adaugam userul ansible in userii cu drept de sudo
sudo usermod -aG sudo ansible_user
groups ansible_user

Adaugam userul de ansible in lista de useri ce nu au nevoie de parola la sudo
cd /etc/sudoers.d/
echo "ansible_user ALL=(ALL) NOPASSWD:ALL" | sudo tee ansible_user-nopasswd
# (ansible este userul pe care il foloseste Ansible sa faca ssh pe masina server)

su - ansible_user

Verificam ca putem face sudo fara parola
sudo ls

Adaugam cheia de ssh a userului ansible in masina remote. Atentie: trebuie sa fiti logati cu userul ansible cand rulati aceste comenzi

mkdir .ssh
touch ~/.ssh/authorized_keys
echo “cheie ssh publica de pe masina client” >> ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys



Install ssh server pe masina remote
sudo apt update
sudo apt install -y openssh-server
service ssh status

Luam IP-ul masinii remote 
ip addr | grep 192.168

Revenim pe masina client (ubuntu2204) si incercam sa facem ssh cu userul ansible
ssh ansible_user@192.168.x.xxx

Configurare fișier inventory Ansible

Creează sau actualizează fișierul ansible/inventory.ini:

[monitoring]
app1 ansible_host=192.168.x.xx ansible_user=ansible_user

Instalare Docker pe VM (playbook install_docker.yml)

Rulăm următoarea comandă:

ansible-playbook -i ansible/inventory.ini ansible/playbooks/install_docker.yml

Ce face acest playbook:

Actualizează lista de pachete;

Instalează docker.io;

Pornește și enablează serviciul Docker.

Deploy aplicație (playbook deploy_platform.yml)
ansible-playbook -i ansible/inventory.ini ansible/playbooks/deploy_platform.yml

Ce face acest playbook:

Copiază fișierele docker/ pe mașina remote;

Rulează docker-compose up -d pentru a porni serviciile.

Verificare succes deploy

Pe mașina remote:

docker ps

Ar trebui să apară:

CONTAINER ID   IMAGE             STATUS          PORTS
a1b2c3d4e5f6   system-monitor    Up 10 seconds   ...
b2c3d4e5f6g7   system-backup     Up 10 seconds   ...

Verifică backup-ul:

ls /home/devops/docker/scripts/backup/

Verifică logurile:

docker logs system-monitor
```
## ☸️ Setup și rulare în Kubernetes

Această aplicație poate fi rulată într-un cluster Kubernetes (de exemplu Minikube) pentru a demonstra orchestrarea și autoscalarea containerelor.

### Pași de rulare

1. **Porniți Minikube**:
```
minikube start
kubectl apply -f k8s/namespace.yaml
kubectl get ns

Aplicați deployment-ul cu 2 replici:
kubectl apply -f k8s/deployment.yaml
kubectl get pods -n monitoring
Fiecare pod conține 3 containere: monitor, backup și nginx.

nginx expune fișierul de log generat de containerul monitor.

Aplicați HPA (Horizontal Pod Autoscaler):

kubectl apply -f k8s/hpa.yaml
kubectl get hpa -n monitoring
HPA ajustează numărul de replici între 2 și 10 pe baza utilizării CPU și memoriei.

Verificați logurile și starea containerelor:
kubectl logs <pod_name> -c monitor -n monitoring
kubectl logs <pod_name> -c backup -n monitoring
kubectl get pods -n monitoring
Accesați fișierul de log prin Nginx:

Dacă Minikube rulează pe mașina locală:

minikube service nginx-service -n monitoring
Aceasta va deschide în browser fișierul de log partajat între containere.

🖼️ Diagrama arhitecturii în Kubernetes

          +--------------------+
          |      User/Client   |
          +---------+----------+
                    |
                    v
          +--------------------+
          |     Nginx Pod      |  <- Expune logurile
          +---------+----------+
                    |
   +----------------+----------------+
   |                                 |
   v                                 v
+--------+                       +--------+
| Monitor|                       | Backup |
|Container|                       |Container|
+--------+                       +--------+

- HPA (Horizontal Pod Autoscaler) gestionează numărul de replici:
  minReplicas = 2, maxReplicas = 10
Note:

Monitorul generează logul de sistem periodic.

Backup-ul verifică modificările și creează copii cu timestamp.

Nginx expune fișierul de log pentru vizualizare externă.

Autoscalarea se face automat pe baza metricilor CPU și memorie.
```

## CI/CD și Automatizari

# 🧩 Platforma Monitorizare — Integrare Jenkins CI/CD

Acest ghid descrie configurarea completă a pipeline-urilor Jenkins pentru proiectul **Platforma Monitorizare**, folosind Jenkinsfile-urile din repository-ul GitHub.

---

## 🚀 Scopul pipeline-urilor

| Pipeline | Scop | Etape principale |
|-----------|------|------------------|
| **backup** | CI/CD pentru scriptul `backup.py` | Verificare sintaxă → Testare → Build imagine Docker → Push în Docker Hub |
| **monitoring** | CI/CD pentru scriptul `monitoring.sh` | Build imagine Docker → Push → Deploy cu Ansible |

---

## ⚙️ 1. Crearea joburilor în Jenkins

### 🔹 1.1. `backup-pipeline`

1. În Jenkins → **Dashboard → New Item**
2. Nume: `backup-pipeline`
3. Tip: **Pipeline**
4. Click **OK**
5. La secțiunea **Pipeline**:
   - **Definition:** `Pipeline script from SCM`
   - **SCM:** `Git`
   - **Repository URL:**  
     ```
     https://github.com/MarcuCalin/Platforma-monitorizare.git
     ```
   - **Branch:**  
     ```
     */main
     ```
   - **Script Path:**  
     ```
     jenkins/pipelines/backup/Jenkinsfile
     ```
6. Click **Save** și **Build Now**

---

### 🔹 1.2. `monitoring-pipeline`

Aceiași pași ca mai sus, doar că:

| Setare | Valoare |
|--------|----------|
| **Job Name** | `monitoring-pipeline` |
| **Script Path** | `jenkins/pipelines/monitoring/Jenkinsfile` |

---

## 🔐 2. Configurare credențiale Docker Hub

1. În Jenkins → **Manage Jenkins → Credentials → Global credentials (unrestricted)**
2. Click **Add Credentials**
3. Completează:
   - **Kind:** Username with password  
   - **Username:** `marcu001`
   - **Password:** *(parola contului Docker Hub)*
   - **ID:** `dockerhub-credentials`
4. Click **Save**

---

## 🧑‍💻 3. Configurare user limitat pentru proiect

1. **Manage Jenkins → Manage and Assign Roles → Manage Roles**
2. Creează un rol nou: `project-limited`
3. Permisiuni minime:
   - **Overall:** Read
   - **Job:** Read, Build, Workspace, Discover
   - **View:** Read
4. **Assign Roles:**  
   Atribuie userului `devops_project_user` acest rol.

---

## 🧱 4. Crearea unui “View” pentru proiect

1. Mergi pe Dashboard (pagina principală Jenkins)
2. Click pe **“+ New View”** sau accesează direct:http://localhost:8080/newView
3. Completează:
- **View name:** `Platforma Monitorizare`
- **Type:** `List View`
4. Click **OK**

### 🔹 Filtrare joburi

- Bifează “Use regular expression”
- În câmpul text introdu:.(monitoring|backup). sau selecteaza jobu-rile pe care le vrei vizibile.




## Terraform și AWS
- [Prerequiste]
- [Instrucțiuni pentru rularea Terraform și configurarea AWS]
- [Daca o sa folositi pentru testare localstack in loc de AWS real puneti aici toti pasii pentru install localstack.]
- [Adaugati instructiunile pentru ca verifica faptul ca Terraform a creat corect infrastructura]

## Depanare si investigarea erorilor
- [Descrieti cum putem accesa logurile aplicatiei si cum ne logam pe fiecare container pentru eventualele depanari de probleme]
- [Descrieti cum ati gandit logurile (formatul logurilor, levelul de log)]


# Resurse utile 
## 1. Jenkins

- **Documentația oficială Jenkins**  
  [https://www.jenkins.io/doc/](https://www.jenkins.io/doc/)

- **Pipeline Syntax (Declarative + Scripted)**  
  [https://www.jenkins.io/doc/book/pipeline/syntax/](https://www.jenkins.io/doc/book/pipeline/syntax/)

- **Managing Jenkins Plugins**  
  [https://www.jenkins.io/doc/book/managing/plugins/](https://www.jenkins.io/doc/book/managing/plugins/)

- **Using Jenkins with GitHub**  
  [https://www.jenkins.io/doc/tutorials/build-a-java-app-with-maven/](https://www.jenkins.io/doc/tutorials/build-a-java-app-with-maven/)

---

## 2. Docker

- **Docker oficial**  
  [https://docs.docker.com/](https://docs.docker.com/)

- **Dockerfile Reference**  
  [https://docs.docker.com/engine/reference/builder/](https://docs.docker.com/engine/reference/builder/)

- **Docker Hub**  
  [https://hub.docker.com/](https://hub.docker.com/)

- **Using Docker in Jenkins**  
  [https://www.jenkins.io/doc/book/pipeline/docker/](https://www.jenkins.io/doc/book/pipeline/docker/)

---

## 3. Ansible

- **Documentația oficială Ansible**  
  [https://docs.ansible.com/ansible/latest/index.html](https://docs.ansible.com/ansible/latest/index.html)

- **Inventories și Playbooks**  
  [https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)  
  [https://docs.ansible.com/ansible/latest/user_guide/playbooks.html](https://docs.ansible.com/ansible/latest/user_guide/playbooks.html)

- **Ansible Galaxy**  
  [https://galaxy.ansible.com/](https://galaxy.ansible.com/)

---

## 4. Python

- **Documentația oficială Python 3**  
  [https://docs.python.org/3/](https://docs.python.org/3/)

- **PEP 8 – Style Guide**  
  [https://www.python.org/dev/peps/pep-0008/](https://www.python.org/dev/peps/pep-0008/)

- **Virtual Environments**  
  [https://docs.python.org/3/tutorial/venv.html](https://docs.python.org/3/tutorial/venv.html)

- **PyPI (Python Packages)**  
  [https://pypi.org/](https://pypi.org/)

---

## 5. CI/CD și bune practici

- **Continuous Integration with Jenkins**  
  [https://www.jenkins.io/doc/book/pipeline/](https://www.jenkins.io/doc/book/pipeline/)

- **CI/CD Concepts**  
  [https://www.redhat.com/en/topics/devops/what-is-ci-cd](https://www.redhat.com/en/topics/devops/what-is-ci-cd)

- **Docker + Jenkins + CI/CD example**  
  [https://www.baeldung.com/ops/jenkins-docker-pipeline](https://www.baeldung.com/ops/jenkins-docker-pipeline)

- **Ansible + CI/CD Pipelines**  
  [https://www.ansible.com/resources/get-started-ci-cd](https://www.ansible.com/resources/get-started-ci-cd)

---

## 6. Git & GitHub

- **Git Official Documentation**  
  [https://git-scm.com/doc](https://git-scm.com/doc)

- **GitHub Docs**  
  [https://docs.github.com/en](https://docs.github.com/en)

- **Git Workflow Cheat Sheet**  
  [https://www.atlassian.com/git/tutorials/comparing-workflows](https://www.atlassian.com/git/tutorials/comparing-workflows)

---


