# rasylhan-aldiyar-devops

DevOps Fundamentals laboratory work: **Linux → Git → GitHub → Docker → Jenkins**.

| | |
|---|---|
| Student | Rasylhan Aldiyar |
| Group | IT2-2309 |
| Student ID | 37838 |
| Course | DevOps |

## Project structure

```
rasylhan_aldiyar/
├── Rasylhan_Aldiyar_info.txt        # student information
├── app/                       # Python application + unit tests
├── scripts/Rasylhan_Aldiyar_system.sh    # Bash script: student + system info
├── config/app.conf            # application configuration
├── logs/                      # runtime logs (*.log ignored by Git)
├── backup/                    # local backups (ignored by Git)
├── tests/check_project.sh     # checks for the Jenkins Test stage
├── Dockerfile                 # image rasylhan-aldiyar-devops
├── docker-compose.yml         # start the app with Docker Compose
├── Jenkinsfile                # CI pipeline for job Rasylhan_Aldiyar_DevOps
└── jenkins/                   # local Jenkins (Docker) for the lab
```

## Run

```bash
# Bash script
./scripts/Rasylhan_Aldiyar_system.sh

# Docker
docker build -t rasylhan-aldiyar-devops .
docker run --name rasylhan-aldiyar-container rasylhan-aldiyar-devops

# Docker Compose (http://localhost:8000)
docker compose up -d
docker compose down
```

## CI/CD

Jenkins job `Rasylhan_Aldiyar_DevOps` takes this repository from GitHub and runs the stages
**Checkout → Build → Test → Docker Build → Docker Run**.
