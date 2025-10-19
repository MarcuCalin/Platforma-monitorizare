**Acest schelet de proiect si acest README.MD sunt orientative.** 
**Aveti libertatea de a aduga alte fisiere si a modifica acest schelet cum doriti. Important este sa implementati proiectul conform cerintelor primite.**
**Acest text si tot textul ajutator de mai jos trebuiesc sterse inainte de a preda proiectul.**

**Pentru a clona acest proiect creati propriul vostru proiect EMPTY in gihub si rulati:**
```bash
git clone git@github.com:amihai/platforma-monitorizare.git
cd platforma-monitorizar
git remote -v
git remote remove origin
git remote add origin:<USERUL_VOSTRU>/platforma-monitorizare.git
git branch -M main
git push -u origin main
```


# Platforma de Monitorizare a Starii unui Sistem

## Scopul Proiectului
- [Descriere detaliata a scopului proiectului. ]

### Arhitectura proiectului

├── ansible
│   ├── inventory.ini
│   └── playbooks
│       ├── deploy_platform.yml
│       └── install_docker.yml
├── docker
│   ├── docker-compose.yml
│   ├── Dockerfile.backup
│   └── Dockerfile.monitoring
├── imagini
│   └── jenkins-logo.png
├── jenkins
│   └── pipelines
│       ├── backup
│       │   └── Jenkinsfile
│       └── monitoring
│           └── Jenkinsfile
├── k8s
│   ├── deployment.yaml
│   └── hpa.yaml
├── README.md
├── scripts
│   ├── backup
│   │   ├── system-state_20250928_093258.log
│   │   ├── system-state_20250928_093328.log
│   │   ├── system-state_20250928_093333.log
│   │   ├── system-state_20250928_093338.log
│   │   ├── system-state_20250928_093343.log
│   │   ├── system-state_20250928_093348.log
│   │   ├── system-state_20251018_170505.log
│   │   ├── system-state_20251019_110244.log
│   │   └── system-state_20251019_112402.log
│   ├── backup.py
│   ├── monitoring.sh
│   └── system-state.log
└── terraform
    ├── backend.tf
    └── main.tf

Acest subpunct este BONUS.
- [Desenati in excalidraw sau in orice tool doriti arhitectura generala a proiectului si includeti aici poza cu descrierea pasilor]

- Acesta este un exemplu de inserare de imagine in README.MD. Puneti imagine in directorul de imagini si o inserati asa:

![Jenkins Logo](imagini/jenkins-logo.png)

Consultati si [Sintaxa Markdown](https://www.markdownguide.org/cheat-sheet/)

## Structura Proiectului
[Aici descriem rolul fiecarui director al proiectului. Descrierea trebuie sa fie foarte pe scurt la acest pas. O sa intrati in detalii la pasii urmatori.]
## Directorul `/scripts`

Directorul **`scripts`** conține toate scripturile necesare pentru monitorizarea sistemului și realizarea backup-urilor logurilor generate.

- **`monitoring.sh`**  
  Script Bash care monitorizează resursele sistemului:
  - CPU, memorie, disk, rețea, uptime, număr de procese etc.
  - Generează periodic fișierul `system-state.log`.
  - Intervalul de actualizare este configurabil prin variabila de mediu `INTERVAL`.

- **`backup.py`**  
  Script Python care realizează backup automat al fișierului `system-state.log`:
  - Creează backup doar dacă fișierul s-a modificat.
  - Salvează fișierele cu timestamp în directorul specificat prin `BACKUP_DIR`.
  - Intervalul de verificare se configurează prin `BACKUP_INTERVAL`.

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

## Setup și Rulare
- [Instrucțiuni de setup local și remote. Aici trebuiesc puse absolut toate informatiile necesare pentru a putea instala si rula proiectul. De exemplu listati aici si ce tool-uri trebuiesc instalate (Ansible, SSH config, useri, masini virtuale noi daca este cazul, etc) pasii de instal si comenzi].
- [Cand includeti instructiuni folositi blocul de code markdown cu limbajul specific codului ]

```bash
ls -al
docker run my-app
```

```python
import time
print("Hello World")
time.sleep(4)
```

- [Descrieti cum ati pornit containerele si cum ati verificat ca aplicatia ruleaza corect.] 
- [Includeti aici pasii detaliati de configurat si rulat Ansible pe masina noua]
- [Descrieti cum verificam ca totul a rulat cu succes? Cateva comenzi prin care verificam ca Ansible a instalat ce trebuia]

## Setup și Rulare in Kubernetes
- [Adaugati aici cateva detalii despre cum se poate rula in Kubernetes aplicatia]
- [Bonus: Adaugati si o diagrama cu containerele si setupul de Kubernetes] 

## CI/CD și Automatizari
- [Descriere pipeline-uri Jenkins. Puneti aici cat mai detaliat ce face fiecare pipeline de jenkins cu poze facute la pipeline in Blue Ocean. Detaliati cat puteti de mult procesul de CI/CD folosit.]
- [Detalii cu restul cerintelor de CI/CD (cum ati creat userul nou ce are access doar la resursele proiectului, cum ati creat un View now pentru proiect, etc)]
- [Daca ati implementat si punctul E optional atunci detaliati si setupul de minikube.]


## Terraform și AWS
- [Prerequiste]
- [Instrucțiuni pentru rularea Terraform și configurarea AWS]
- [Daca o sa folositi pentru testare localstack in loc de AWS real puneti aici toti pasii pentru install localstack.]
- [Adaugati instructiunile pentru ca verifica faptul ca Terraform a creat corect infrastructura]

## Depanare si investigarea erorilor
- [Descrieti cum putem accesa logurile aplicatiei si cum ne logam pe fiecare container pentru eventualele depanari de probleme]
- [Descrieti cum ati gandit logurile (formatul logurilor, levelul de log)]


## Resurse
- [Listati aici orice link catre o resursa externa il considerti relevant]
- Exemplu de URL:
- [Sintaxa Markdown](https://www.markdownguide.org/cheat-sheet/)
- [Schelet Proiect](https://github.com/amihai/platforma-monitorizare)
