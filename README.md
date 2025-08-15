# multi-site-hetz-cicd
Multiple site workflows for hetzner ci/cd 
# multi-site-hetz-cicd

GitHub Actions receiver for Hetzner multi-site deployments.

## How it works
1. Listens for `repository_dispatch` events with type `deploy`.
2. Checks out the sender repo + branch.
3. Reads `.cicd-config.yml` for:
   - `slug` (container & Traefik name)
   - `port` (internal port in container)
   - `domains.prod` (live domain for Traefik)
4. Builds the site as a Docker image and pushes to GHCR.
5. SSHes to Hetzner host, creates `/opt/sites/<slug>` with `.env` + `docker-compose.yml`.
6. Runs `docker compose up -d` (Traefik auto-routes by labels).
7. Runs a health check to ensure the site responds over HTTPS.

## Required secrets in this repo
- `HZ_HOST` → Hetzner server IP/hostname
- `HZ_SSH_KEY` → private key with access to Hetzner
- `HZ_USER` (optional) → SSH username (default `root`)
- `GHCR_READ_TOKEN` (optional) → for private GHCR pulls
- `SITE_ENV__<REPO_NAME>` → one per site, multiline `.env` content

## Expected on Hetzner server
- Docker + docker compose plugin installed
- `proxy` network: `docker network create proxy`
- Traefik container running with:
  - `--providers.docker=true`
  - `--providers.docker.exposedbydefault=false`
  - entrypoints `web` (80) and `websecure` (443)
  - TLS resolver named `le`
