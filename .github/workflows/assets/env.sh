# Common variables for all workflows. Source this file before lib.sh.
# In GitHub Actions, GITHUB_REPOSITORY is set; we derive ORG and TRANSLATIONS_REPO.
# For local trigger scripts, set GITHUB_REPOSITORY (e.g. in .env) to the repo to trigger (owner/name).

ORG="${ORG:-${GITHUB_REPOSITORY%%/*}}"
TRANSLATIONS_REPO="${TRANSLATIONS_REPO:-${GITHUB_REPOSITORY##*/}}"

BOT_NAME="Boost-Translation-CI-Bot"
BOT_EMAIL="Boost-Translation-CI-Bot@$ORG.local"

BOOST_ORG="boostorg"
MASTER_BRANCH="master"
