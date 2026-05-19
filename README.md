# Jenkins CI/CD — TP1 à TP4 (ENI Master 2 - 2026)

Implémentation complète des TPs Jenkins via Docker + Configuration as Code (CasC).

## Structure du projet

```
tp-devops/
├── Dockerfile              # Image Jenkins LTS + JDK17 + Maven
├── docker-compose.yml      # Orchestration (monte calculatrice & HelloWorld)
├── plugins.txt             # Plugins pré-installés (role-strategy, job-dsl…)
├── casc.yaml               # Config automatique : users, rôles, jobs, outils
├── Jenkinsfile             # Pipeline CI avec paramètres (TP4)
├── HelloWorld/
│   └── HelloWorld.java     # Classe Java TP1/TP2
└── calculatrice/           # Projet Maven — TP4
    ├── pom.xml
    └── src/
        ├── main/java/com/dev1/jenkins/Calculatrice.java
        └── test/java/com/dev1/jenkins/CalculatriceTest.java
```

## Prérequis

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) démarré
- Ports `8080` et `50000` libres

## Démarrage

```bash
docker-compose up --build -d
```

> La première build prend ~5 min (téléchargement plugins). Suivre avec :
> ```bash
> docker logs -f jenkins-tp
> ```

Ouvrir **http://localhost:8080**

| Utilisateur  | Mot de passe   | Rôle              |
|--------------|----------------|-------------------|
| `admin`      | `admin123`     | Administrateur    |
| `developer`  | `developer123` | Employé / java-developer |
| `developer1` | `developer123` | Employé / java-developer |
| `tester`     | `tester123`    | Employé / tester  |

---

## TP1 — Job Freestyle HelloWorld

Job **`HelloWorld`** créé automatiquement au démarrage.

**Ce qu'il fait :**
1. Compile `/opt/HelloWorld/HelloWorld.java`
2. Exécute la classe et affiche `Hello, World` dans la console

**Lancer manuellement :**
Jenkins → `HelloWorld` → *Lancer un build*

---

## TP2 — Déclenchement à distance

Le job `HelloWorld` possède le token `1010`.

Déclencher via URL (remplacer `USER:PASSWORD`) :

```
http://USER:PASSWORD@localhost:8080/job/HelloWorld/build?token=1010
```

Ou sans authentification si configuré :

```
http://localhost:8080/job/HelloWorld/build?token=1010
```

---

## TP3 — Gestion des utilisateurs et des rôles

Configuré automatiquement dans `casc.yaml` via le plugin **Role-based Authorization Strategy**.

### Rôles globaux

| Rôle      | Permissions        | Utilisateurs               |
|-----------|--------------------|----------------------------|
| `admin`   | Tout faire         | `admin`                    |
| `employe` | Lecture globale    | `developer`, `developer1`, `tester` |

### Rôles par item (projets)

| Rôle             | Pattern regex | Permissions      | Utilisateurs            |
|------------------|---------------|------------------|-------------------------|
| `java-developer` | `Java.*`      | Build/Read/…     | `developer`, `developer1` |
| `tester`         | `Test.*`      | Build/Read/…     | `tester`                |

> Nommer vos projets `Java-...` pour que `developer` puisse y accéder,
> et `Test-...` pour `tester`.

### Gérer les rôles manuellement

*Administrer Jenkins → Gérer et assigner les rôles*

---

## TP4 — Jenkins Pipeline

Job **`Calculatrice-Pipeline`** créé automatiquement au démarrage.

### Stages

| Stage              | Commande Maven                          |
|--------------------|-----------------------------------------|
| Compilation        | `mvn clean compile`                     |
| Tests Unitaires    | `mvn test` + rapport JUnit              |
| Couverture JaCoCo  | `mvn jacoco:report` + rapport HTML      |
| Package            | `mvn package` + archivage du JAR        |

### Build avec paramètres

Le `Jenkinsfile` expose deux paramètres :

| Paramètre    | Type   | Défaut  | Valeurs possibles     |
|--------------|--------|---------|-----------------------|
| `plateforme` | String | `Linux` | Texte libre           |
| `choix`      | Choice | `Linux` | Linux, Windows, Mac   |

*Lancer un build avec des paramètres* → renseigner les valeurs → *Build*

### Notifications email

En cas de build **instable** ou en **échec**, un email est envoyé à `admin@jenkins.local`.
Configurer le serveur SMTP dans *Administrer Jenkins → Configurer le système*.

---

## Arrêter Jenkins

```bash
docker-compose down
```

Supprimer aussi les données persistantes :

```bash
docker-compose down -v
```

---

## Correspondance avec le TP PDF

| TP PDF                              | Implémentation Docker                         |
|-------------------------------------|-----------------------------------------------|
| Télécharger `jenkins.war`           | Image `jenkins/jenkins:lts-jdk17`             |
| `java -jar jenkins.war`             | `docker-compose up --build`                   |
| Installer plugins manuellement      | `plugins.txt` + `jenkins-plugin-cli`          |
| Configurer JDK & Maven via UI       | `casc.yaml` (automatique)                     |
| Créer job HelloWorld freestyle      | Job-DSL dans `casc.yaml` (auto-créé)          |
| Déclencher à distance (token 1010)  | `authToken` configuré dans le job             |
| Créer utilisateurs + rôles          | `casc.yaml` — role-strategy plugin            |
| Pipeline avec stages                | `casc.yaml` + `Jenkinsfile`                   |
| Build avec paramètres               | `parameters { }` dans le Jenkinsfile          |
| Notification email                  | `mail()` dans le bloc `post`                  |
