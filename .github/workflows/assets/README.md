# Workflow Assets

This folder contains workflow template files that are copied into individual CppDigest
Boost library documentation repositories.

## create-tag.yml

**Purpose:** Creates a versioned tag in a CppDigest lib repo whenever a Weblate translation
PR is merged into a `local-{lang_code}` branch.

**Trigger:** `pull_request` closed event on branches matching `local-*`.

**Condition:** PR must be merged (`github.event.pull_request.merged == true`) and the head
branch must start with `translation-` (Weblate-created branches).

**How it works:**

1. Extracts `lang_code` from the base branch: `local-zh_Hans` → `zh_Hans`.
2. Extracts `version` from the head branch:
   `translation-zh_Hans-boost-1.89.0` → strips `translation-zh_Hans-boost-` → `1.89.0`.
3. Builds the tag name: `boost-{version}-{lang_code}-{repo}-translation`
   (e.g. `boost-1.89.0-zh_Hans-algorithm-translation`).
4. Checks out the `local-{lang_code}` branch with full tag history.
5. Creates and pushes the tag. Skips silently if the tag already exists.

**Tag format:**

```
boost-{version}-{lang_code}-{repo}-translation
```

| Component | Source | Example |
|---|---|---|
| `version` | Head branch (`translation-zh_Hans-boost-1.89.0`) | `1.89.0` |
| `lang_code` | Base branch (`local-zh_Hans`) | `zh_Hans` |
| `repo` | `github.event.repository.name` | `algorithm` |

**How it gets installed:**

`add-submodules.yml` and `start-translation.yml` copy this file directly into each
CppDigest lib repo at `.github/workflows/create-tag.yml` when creating or updating a
`local-{lang_code}` branch. No placeholder substitution is needed; the repo name is
resolved at runtime from `github.event.repository.name`.

The workflow must exist on the repo's default branch (`master`) to be triggered by PR events.
