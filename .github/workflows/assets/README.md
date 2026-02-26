# Workflow Assets

This folder contains workflow template files that are copied into individual Boost library
submodule documentation repositories during the add-submodules process.

## create-tag.yml

**Purpose:** Tags a CppDigest lib repo whenever a Weblate translation PR is merged into a
`local-{lang_code}` branch.

**How it works:**

1. Triggers on any `pull_request` closed event targeting a `local-*` branch.
2. If the PR was merged and its head branch matches `translation-*`
   (e.g. `translation-zh_Hans-1.89.0`):
   - Extracts `lang_code` from the base branch: `local-zh_Hans` → `zh_Hans`.
   - Extracts `version` from the head branch: `translation-zh_Hans-boost-1.89.0` → `1.89.0`.
   - Builds the tag: `boost-{repo}-translation-{version}-{lang_code}`
     (e.g. `boost-algorithm-translation-1.89.0-zh_Hans`).
3. Checks out the `local-{lang_code}` branch with full tag history.
4. Creates and pushes the tag unless it already exists.

**How it gets there:**

`add-submodules.yml` and `start-translation.yml` (`add_create_tag_workflow`) copy this file
directly into each CppDigest lib repo at `.github/workflows/create-tag.yml`. No placeholder
substitution is needed; the repo name is read at runtime from `github.event.repository.name`.
