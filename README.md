# HealthTracker-infra
Infrastruktúra a PRF-es HealthTracker egészségügyi adatkezelő alkalmazáshoz, amely frontend-ből és backend-ből áll.

Részei:
- Terraform az infrastruktúra létrehozásához
- Jenkins CI/CD pipeline
- MongoDB
- nginx alapú proxy
- Zabbix a rendszerszinű monitorozáshoz
- Graylog a logok gyűjtéséhez
- Docker hálózat a kommunikációhoz

A frontend nginx, a backend pedig pm2 segítségével konténerizált formában fut. A hozzájuk tartozó Dockerfile a HealthTracker repoban található.

A Terraform csak az infrát hozza létre, az alkalmazás elindítása a Docker compose fájl segítségével történik, így új verzió kitelepítése esetén nem kell az egész infrát újrahúzni. Az alkalmazás konténerei bekapcsolódnak az infrához tartozó hálózatba és így kommunikálnak a többi konténerrel.

A jenkins pipeline első lépésben leklónozza a HealthTracker repot. Utánna a frontend csomagjait feltelepíti, majd fordítja és teszteli a frontendet. Ezután a backend csomagjainak a telepítése jön, amit a fordítás követ. A következő lépés a frontend és a backend Docker image-ek fordítása és feltöltése a Github container repoba. Utolsó lépésként a kitelepítés történik meg. Mivel az infra és az alkalmazás is a saját szerveremen fut, ezért oda ssh-val belép. Letölti a friss Docker image-et és újraindítja a konténereket a compose segítségével.

Az adatbázis feltöltése az infra létrehozásakor egy erre készített konténer segíségével valósul meg.

A proxy a backendet a `/api` a frontendet pedig a `/healthtracker` végponthoz köti hozzá.

Elndítás:
- `docker volume create health-tracker-jenkins`
- A Docker beállítása úgy, hogy sudo nélkül lehessen használni. `Dockerfile-jenkins` fájlban a docker csoport számának módosítása a `getent group docker` parancs által visszaadott számra.
- Szükséges Jenkins pluginok: `Docker Pipeline`, `SSH Pipeline Steps`
- `terraform init, plan, apply`
- Az alkalmazás futtatása jenkins pipeline nélkül: `docker compose up`
- Az alkalmazása elérhetó a `localhost/healthtracker` címen
