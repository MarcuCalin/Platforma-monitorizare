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
📂 proiect-monitoring
├── /scripts
│ ├── system_monitor.sh # Script Shell care monitorizează sistemul și generează system-state.log
│ └── backup_script.py # Script Python care creează backup pentru loguri
│
├── /docker
│ ├── Dockerfile.monitoring # Imagine Docker pentru scriptul de monitorizare
│ ├── Dockerfile.backup # Imagine Docker pentru scriptul de backup
│ ├── docker-compose.yml # Definește și pornește containerele monitor și backup
│
├── /kubernetes
│ ├── namespace.yaml # Creează namespace-ul "monitoring"
│ ├── deployment.yaml # Deployment cu 2 replici și 3 containere (monitor, backup, nginx)
│ ├── hpa.yaml # Configurare HPA (Horizontal Pod Autoscaler)
│
└── /ansible
├── install_docker.yml # Instalează Docker pe mașina nouă
└── run_compose.yml # Rulează docker-compose.yml pe mașina nouă
```
## Directorul `/scripts`

Acest director conține scripturile folosite pentru colectarea informațiilor despre sistem și realizarea backup-ului automat.

 **`monitoring.sh'**

Monitorizează în timp real sistemul (CPU, memorie, disk, procese active, hostname etc.);

Scrie rezultatele în fișierul system-state.log;

Este rulat periodic printr-un container dedicat.

Exemplu rulare manuală:

bash scripts/monitoring.sh
 
 **`backup.py '**

Verifică existența fișierului system-state.log;

Creează un backup într-un fișier cu timestamp;

Este declanșat automat din containerul backup.

Rulare manuală:

python3 scripts/backup.py

- **`system-state.log`**  
  Fișierul generat de `monitoring.sh` care conține informații detaliate despre starea sistemului.

**Rol general:**  
Directorul `scripts` centralizează logica aplicației, oferind fișiere independente care pot fi testate local sau containerizate ulterior.

---

## Directorul `/docker`

Directorul **`docker`** conține fișierele necesare pentru containerizarea scripturilor și orchestrarea lor cu Docker Compose.

- **`Dockerfile.monitoring`**  
  Definește imaginea Docker pentru scriptul de monitorizare Bash:
  - Pornește de la Debian Bookworm.
  - Instalează pachetele necesare (`sysstat`, `procps`) pentru colectarea informațiilor de sistem.
  - Copiază scriptul `monitoring.sh` din `/scripts` în container și îl face executabil.
  - CMD-ul pornește automat scriptul la rularea containerului.

- **`Dockerfile.backup`**  
  Definește imaginea Docker pentru scriptul Python de backup:
  - Pornește de la `python:3.11-slim`.
  - Copiază `backup.py` din `/scripts` în container.
  - CMD-ul pornește scriptul automat la rularea containerului.

- **`docker-compose.yml`**  
  Orchestrarea ambelor containere, configurând:
  - Serviciile `monitor` și `backup`.
  - Volume pentru persistarea fișierului `system-state.log` și a backup-urilor.
  - Variabile de mediu pentru intervale și directoare.
  - Rețea implicită pentru comunicarea între containere (backup poate accesa fișierul generat de monitor).

**Legătura dintre Dockerfile-uri și scripturi:**  
Fiecare Dockerfile pornește un script din `/scripts` și configurează mediul necesar pentru ca acesta să funcționeze independent în container. Docker Compose conectează containerele între ele prin volume, astfel încât:
- `monitor` scrie log-ul într-un volum partajat.
- `backup` citește log-ul și generează backup-uri automat.

- `/ansible`: [Descriere rolurilor playbook-urilor și inventory]
- `/jenkins`: [Descrierea rolului acestui director si a subdirectoarelor. Unde sunt folosite fisierele din acest subdirector.]
- `/terraform`: [Descriere rol fiecare fisier Terraform folosit]

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
```bash
git clone https://github.com/MarcuCalin/Platforma-monitorizare/
cd monitoring-platform


cd docker
docker-compose up --build -d
docker ps
Ar trebui să vezi două containere:

system-monitor

system-backup

Verifică logurile generate:

bash
Copy code
docker logs system-monitor
docker logs system-backup
Verifică existența backup-urilor:

bash
Copy code
ls scripts/backup/

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
```bash
ubectl apply -f k8s/namespace.yaml
kubectl get ns
Aplicați deployment-ul cu 2 replici:

bash
Copy code
kubectl apply -f k8s/deployment.yaml
kubectl get pods -n monitoring
Fiecare pod conține 3 containere: monitor, backup și nginx.

nginx expune fișierul de log generat de containerul monitor.

Aplicați HPA (Horizontal Pod Autoscaler):

bash
Copy code
kubectl apply -f k8s/hpa.yaml
kubectl get hpa -n monitoring
HPA ajustează numărul de replici între 2 și 10 pe baza utilizării CPU și memoriei.

Verificați logurile și starea containerelor:

bash
Copy code
kubectl logs <pod_name> -c monitor -n monitoring
kubectl logs <pod_name> -c backup -n monitoring
kubectl get pods -n monitoring
Accesați fișierul de log prin Nginx:

Dacă Minikube rulează pe mașina locală:

bash
Copy code
minikube service nginx-service -n monitoring
Aceasta va deschide în browser fișierul de log partajat între containere.

🖼️ Diagrama arhitecturii în Kubernetes
sql
Copy code
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


# Resurse utile pentru Jenkins, Docker, Ansible și CI/CD

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


