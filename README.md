# saferworld-ushahidi

Deployment repo for the Saferworld Somalia instance of Ushahidi.

## Submodules

| Path | Repo | Branch |
|---|---|---|
| `platform/` | [howtobuildup/ushahidi-platform](https://github.com/howtobuildup/ushahidi-platform) | `saferworld-somalia` |
| `platform-client-mzima/` | [howtobuildup/ushahidi-platform-client-mzima](https://github.com/howtobuildup/ushahidi-platform-client-mzima) | `saferworld-somalia` |

## Setup

```bash
git clone --recurse-submodules git@github.com:howtobuildup/saferworld-ushahidi.git
```

Or if already cloned:

```bash
git submodule update --init --recursive
```

## Development

### Backend

Start the API, worker, database, and cache:

```bash
make start
```

Services:
- API: http://localhost:8080
- MySQL: localhost:33061

### Frontend (hot reload, optional)

For active frontend development, you can run the Angular dev server on the host instead of the client container. This gives hot reload without rebuilding the Docker image.

Stop the client container and run the dev server:

```bash
docker compose stop client
cd platform-client-mzima
npm install
BACKEND_URL=http://localhost:8080 npm run web:serve
```

Client available at http://localhost:4200.

### Run migrations

```bash
make migrate
```

### Default admin login

After running migrations, a default admin account is seeded:

| Field    | Value               |
|----------|---------------------|
| Email    | `admin@example.com` |
| Password | `admin`             |

The login uses an OAuth2 password grant against `POST /oauth/token`. The frontend client handles this automatically when you sign in through the UI at http://localhost:3000.

## Deployments

### Dev (automatic)

Every push to the `dev` branch triggers a CI build that pushes images tagged `0.<run_number>.0-rc.<sha>` to GHCR. FluxCD detects the new tag, commits the updated image reference to `helm/dev/`, and deploys automatically. No manual steps required.

### Prod (manual)

Prod deployments are triggered by updating the image tag in the HelmRelease files on `main`.

1. Build a stable image by tagging a release:
   ```bash
   git tag v<major>.<minor>.<patch>
   git push origin v<major>.<minor>.<patch>
   ```
   CI builds and pushes `ghcr.io/howtobuildup/platform:<major>.<minor>.<patch>` and `ghcr.io/howtobuildup/platform-client:<major>.<minor>.<patch>`.

2. Update the image tags in `helm/prod/helmrelease-api.yaml` and `helm/prod/helmrelease-client.yaml`:
   ```yaml
   image:
     tag: "<major>.<minor>.<patch>"
   ```

3. Commit and push to `main`. FluxCD watches the `main` branch and applies `helm/prod/` automatically.

4. Verify:
   ```bash
   kubectl get helmreleases -n saferworld
   kubectl get pods -n saferworld
   ```

### Useful commands

```bash
make logs        # tail all service logs
make migrate     # run database migrations
make enter-api   # shell into the API container
make stop        # stop containers (preserves volumes)
make down        # stop and remove containers
make clean       # stop, remove containers, volumes, and locally built images
```
