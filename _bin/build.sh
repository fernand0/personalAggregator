#!/bin/sh

# 1. Exit immediately if a command exits with a non-zero status.
set -e
# set -x

LOG_FILE=/tmp/build.log

# --- User Configuration ---
# Path to your personalAggregator.py script.
# This script is responsible for generating your posts.
# Example: PERSONAL_AGGREGATOR_SCRIPT="/path/to/your/personalAggregator.py"
# If it's located in the '_bin' folder at the project root:
PERSONAL_AGGREGATOR_SCRIPT="${PROJECT_ROOT}/_bin/personalAggregator.py" # Default: Update this to your path
PERSONAL_AGGREGATOR_SCRIPT="${HOME}/usr/src/web/deGitHub/personalAggregator/_bin/personalAggregator.py" # Default: Update this to your path
#PERSONAL_AGGREGATOR_SCRIPT="${HOME}/usr/src/scripts/personalAggregator.py" # Default: Update this to your path

# --- Internal Variables (Do not modify below this line) ---
# Derive PROJECT_ROOT from the script's location for portability.
SCRIPT_DIR=$(dirname -- "$(realpath -- "$0")")
PROJECT_ROOT=$(dirname -- "$SCRIPT_DIR") # Assumes _bin is in the project root

cd $PROJECT_ROOT > $LOG_FILE 2>&1


POSTS_DIR="${PROJECT_ROOT}/_posts"
SITE_DIR="${PROJECT_ROOT}/_site"

# Virtual environment setup
VENV_DIR="${PROJECT_ROOT}/.personalAggregator"
PYTHON_VENV_BIN="${VENV_DIR}/bin"

# --- Git Branch Logic ---
ORIGINAL_BRANCH=$(git symbolic-ref --short HEAD)
TARGET_BRANCH="gh-pages"

if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
  git checkout "$TARGET_BRANCH" >> $LOG_FILE 2>&1
  # Ensure the local branch is updated with the remote
  git pull origin "$TARGET_BRANCH" >> $LOG_FILE 2>&1
fi

# --- Execution ---
cd "$PROJECT_ROOT" >> $LOG_FILE 2>&1 # Use PROJECT_ROOT

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
  python3 -m venv "$VENV_DIR" >> $LOG_FILE 2>&1
fi

# Check if the activate script exists before sourcing
if [ ! -f "${PYTHON_VENV_BIN}/activate" ]; then
  echo "Error: Virtual environment activation script not found at ${PYTHON_VENV_BIN}/activate." >> $LOG_FILE 2>&1
  echo "Please ensure 'python3 -m venv' was successful or check your Python installation." >> $LOG_FILE 2>&1
  exit 1
fi

. "${PYTHON_VENV_BIN}/activate" # Use PYTHON_VENV_BIN

pip install -r "${PROJECT_ROOT}/requirements.txt" >> $LOG_FILE 2>&1

BACKUP_DIR="/tmp/posts_backup_$(date +%s)"
mkdir -p "$BACKUP_DIR"
if [ -n "$(ls -A "$POSTS_DIR" 2>/dev/null)" ]; then # Use POSTS_DIR
    cp "$POSTS_DIR"/*.md "$BACKUP_DIR/" >> $LOG_FILE 2>&1 # Use POSTS_DIR
    git rm "$POSTS_DIR"/*.md >> $LOG_FILE 2>&1
    git add "$POSTS_DIR" >> $LOG_FILE 2>&1
    git commit -m "Moved posts to $BACKUP_DIR and removed from repo" >> $LOG_FILE 2>&1 
fi

"${PYTHON_VENV_BIN}/python" "$PERSONAL_AGGREGATOR_SCRIPT" \
	--config-file $HOME/.mySocial/config/.rssElmundo \
	--output-dir "$POSTS_DIR" \
       	>> $HOME/usr/var/log/personal.log 2>&1 # Use PYTHON_VENV_BIN, PERSONAL_AGGREGATOR_SCRIPT, POSTS_DIR

# export GEM_HOME="$HOME/gems"
# export PATH="$HOME/gems/bin:$PATH"

# bundle exec jekyll build >> $LOG_FILE 2>&1

git add "$POSTS_DIR"/* >> $LOG_FILE 2>&1 # Use POSTS_DIR
git commit -m "Publication: $(date "+%Y-%m-%d %H:%M:%S")" >> $LOG_FILE 2>&1
git push >> $LOG_FILE 2>&1

rm -rf "$BACKUP_DIR"

# --- Git Branch Logic (Return) ---
if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
  git checkout "$ORIGINAL_BRANCH" >> $LOG_FILE 2>&1
fi
