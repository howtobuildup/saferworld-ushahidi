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

### Useful commands

```bash
make logs        # tail all service logs
make migrate     # run database migrations
make enter-api   # shell into the API container
make stop        # stop containers (preserves volumes)
make down        # stop and remove containers
make clean       # stop, remove containers, volumes, and locally built images
```
