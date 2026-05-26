# Deploying to Dev

## How it works

Merging a PR into the `dev` branch triggers a GitHub Actions workflow that builds and pushes Docker images to GHCR. FluxCD detects the new image tags and automatically updates the deployment within a couple of minutes.

PRs are used instead of direct pushes to avoid conflicts with FluxCD's automated commits (which update image tags on the `dev` branch).

## Steps

1. **Create a branch from the latest dev**

   ```bash
   git checkout dev
   git pull origin dev
   git checkout -B deploy/dev
   ```

   The `-B` flag creates the branch or resets it to the current `dev` if it already exists.

2. **Update submodules to the latest from the `saferworld` branch**

   Each submodule (`platform` and `platform-client-mzima`) uses `saferworld` as its main branch.

   ```bash
   git submodule update --remote
   ```

   To verify the submodules picked up new changes:

   ```bash
   git submodule foreach 'git log --oneline -1'
   ```

3. **Commit and push**

   ```bash
   git add platform platform-client-mzima
   git commit -m "Update submodules"
   git push origin deploy/dev
   ```

4. **Open a PR to dev and merge**

   ```bash
   gh pr create --base dev --title "Update submodules"
   ```

   Or create the PR via the GitHub UI. Once merged, the deployment pipeline starts automatically.

5. **Wait for deployment**

   - GitHub Actions builds and pushes new Docker images to `ghcr.io/howtobuildup/platform` and `ghcr.io/howtobuildup/platform-client`.
   - FluxCD detects the new image tags, updates `helm/dev/helmrelease-api.yaml` and `helm/dev/helmrelease-client.yaml`, and commits the tag changes back to the `dev` branch.
   - The updated HelmReleases are applied to the cluster automatically.

   This typically completes within a couple of minutes. You can check the status at https://github.com/howtobuildup/saferworld-ushahidi/actions.
