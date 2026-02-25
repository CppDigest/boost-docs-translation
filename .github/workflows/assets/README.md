# Workflow Assets

This folder contains workflow template files that are copied into individual Boost library
submodule documentation repositories during the add-submodules process.

## create-tag.yml

**Purpose:** Tags a submodule repository with a Boost version string whenever a Weblate
translation PR is merged into the `local` branch.

**How it works:**

1. Triggers on any `pull_request` closed event targeting the `local` branch.
2. If the PR was merged and its head branch matches `boost-<repo>-translation-*`
   (e.g. `boost-algorithm-translation-boost-1.89.0`), extracts the version suffix
   (e.g. `boost-1.89.0`).
3. Checks out the `local` branch with full tag history.
4. Creates and pushes a tag named after the version (e.g. `boost-1.89.0`) unless it
   already exists.

**How it gets there:**

`add-submodules.yml` (`add_create_tag_workflow`) copies this file into each newly created
submodule repo at `.github/workflows/create-tag.yml`, replacing the placeholder prefix
`boost-SUBMODULE-translation-` with `boost-<submodule-name>-translation-` so the trigger
matches that specific library's translation branches.

**Do not edit the placeholder name** (`boost-SUBMODULE-translation-`) directly — it is the
sed target used by `add_create_tag_workflow` during submodule setup.
