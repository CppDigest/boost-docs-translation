# Common variables for all workflows. Source this file before lib.sh.

ORG="${GITHUB_REPOSITORY%%/*}"
TRANSLATIONS_REPO="${GITHUB_REPOSITORY##*/}"

BOT_NAME="Boost-Translation-CI-Bot"
BOT_EMAIL="Boost-Translation-CI-Bot@$ORG.local"

BOOST_ORG="boostorg"
MASTER_BRANCH="master"
