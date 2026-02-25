# boost-docs-translation

Mirrors Boost library documentation repositories into the CppDigest org, maintains
submodule links on `master` and `local` branches, and keeps local-branch pointers
up to date on a daily schedule.

---

## Workflows

### `add-submodules.yml` — Add new submodules

**Trigger:** `repository_dispatch` with `event_type: add-submodules`

```json
{"event_type": "add-submodules", "client_payload": {"version": "boost-1.90.0"}}
```

For each Boost library submodule:
1. Skips if the repo already exists in the CppDigest org.
2. Clones the boostorg repo at the given ref; prunes to doc folders only
   (per `meta/libraries.json`).
3. Creates `CppDigest/<submodule>`, pushes doc content to `master` and `local` branches,
   and installs `create-tag.yml` (from `assets/`) into the new repo.
4. Updates submodule links in this repo (`libs/`) on both `master` and `local`.

| `client_payload` field | Required | Description |
|---|---|---|
| `version` | no | Boost ref (e.g. `boost-1.90.0`). Used for both library repos and `.gitmodules` auto-discovery. Defaults to `develop`. |
| `submodules` | no | List-like string (e.g. `[algorithm, system]`). If set, `.gitmodules` is not fetched. |

---

### `start-translation.yml` — Sync existing submodules

**Trigger:** `repository_dispatch` with `event_type: start-translation`

```json
{"event_type": "start-translation", "client_payload": {"version": "boost-1.90.0"}}
```

Reads the submodule list from `.gitmodules` of this repo (only `libs/` entries).
For each submodule, updates the CppDigest doc repo content and the submodule pointers
on `master` and `local`. Optionally triggers a Weblate add-or-update at the end.

| `client_payload` field | Required | Description |
|---|---|---|
| `version` | no | Boost ref (e.g. `boost-1.90.0`). Defaults to `develop`. |
| `lang_code` | no | Language code for Weblate (e.g. `zh_Hans`). |
| `extensions` | no | File extensions for Weblate (e.g. `[.adoc, .md]`). |

---

### `sync-translation.yml` — Sync local-branch pointers

**Trigger:** `repository_dispatch` with `event_type: sync-translation`, or daily schedule (`0 0 * * *`)

```json
{"event_type": "sync-translation"}
```

Checks out this repo's `local` branch (with submodules), then for each submodule
advances the pointer to the tip of that submodule's own `local` branch, commits,
and force-pushes.

No `client_payload` fields.

---

## Assets

### `.github/workflows/assets/create-tag.yml`

A workflow template copied into each newly created submodule repo by `add-submodules.yml`.
Creates a versioned tag (e.g. `boost-1.89.0`) when a Weblate translation PR is merged
into `local`. See [`assets/README.md`](.github/workflows/assets/README.md) for details.

---

## Required secrets

| Secret | Used by | Description |
|---|---|---|
| `SYNC_TOKEN` | all workflows | PAT with `repo` scope (and org repo-create permission for `add-submodules`). |
| `WEBLATE_URL` | `start-translation` | Optional. Weblate instance URL. |
| `WEBLATE_TOKEN` | `start-translation` | Optional. Weblate API token. |

---

## Local dev scripts

These files are listed in `.gitignore` and are not committed.

| Script | Description |
|---|---|
| `trigger_add_submodules.py` | Trigger `add-submodules` workflow via API. |
| `trigger_start_translation.py` | Trigger `start-translation` workflow via API. |
| `trigger-sync-translation.ps1` | Trigger `sync-translation` workflow via API. |
| `update-add-submodules.ps1` | Full add flow: delete org repos → clean local → push → trigger → pull. |
| `update-start-translation.ps1` | Trigger `start-translation`, wait, then pull. |
| `reset_and_redeploy.ps1` | Delete specific org repos, clean, push, trigger add, pull. |
| `delete_cppdigest_lib_repos.py` | Delete CppDigest org repos (dry-run supported). |
| `push_project.py` | `git add -A`, commit, and push this repo. |

All scripts read `GITHUB_TOKEN` from the environment or from a local `.env` file.

```sh
export GITHUB_TOKEN=ghp_...
python trigger_add_submodules.py --version boost-1.90.0 --submodules algorithm system
python trigger_start_translation.py --version boost-1.90.0
```
