#!/bin/sh

# 1. Exit immediately if a command exits with a non-zero status.
set -e

# --- User Configuration ---
# Path to your personalAggregator.py script.
# This script is responsible for generating your posts.
# Example: PERSONAL_AGGREGATOR_SCRIPT="/path/to/your/personalAggregator.py"
# If it's located in a 'scripts' folder at the project root, you can use:
# PERSONAL_AGGREGATOR_SCRIPT="${PROJECT_ROOT}/scripts/personalAggregator.py"
PERSONAL_AGGREGATOR_SCRIPT="{HOME}/usr/src/scripts/personalAggregator.py" # Default: Update this to your path

# Path to your Python virtual environment's 'bin' directory.
# This is where the 'activate' script and 'python' executable are located.
# Example: PYTHON_VENV_BIN="/home/youruser/.socialBots/bin"
PYTHON_VENV_BIN="$HOME/.socialBots/bin" # Default: Update this to your path

# --- Internal Variables (Do not modify below this line) ---
# Derive PROJECT_ROOT from the script's location for portability.
SCRIPT_DIR=$(dirname -- "$(realpath -- "$0")")
PROJECT_ROOT=$(dirname -- "$SCRIPT_DIR") # Assumes _bin is in the project root

POSTS_DIR="${PROJECT_ROOT}/_posts"
SITE_DIR="${PROJECT_ROOT}/_site"

# --- Git Branch Logic ---
ORIGINAL_BRANCH=$(git symbolic-ref --short HEAD)
TARGET_BRANCH="gh-pages"

if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
  echo "Current branch is '$ORIGINAL_BRANCH'. Switching to '$TARGET_BRANCH'வதற்கான"
  git checkout "$TARGET_BRANCH"
  # Ensure the local branch is updated with the remote
  git pull origin "$TARGET_BRANCH"
fi

# --- Execution ---
cd "$PROJECT_ROOT" # Use PROJECT_ROOT
echo "Working directory: $(pwd)"

echo "Activating Python virtual environment..."
. "${PYTHON_VENV_BIN}/activate" # Use PYTHON_VENV_BIN

echo "Backing up old posts..."
BACKUP_DIR="/tmp/posts_backup_$(date +%s)"
mkdir -p "$BACKUP_DIR"
if [ -n "$(ls -A \"$POSTS_DIR\" 2>/dev/null)" ]; then # Use POSTS_DIR
    mv "$POSTS_DIR"/* "$BACKUP_DIR/" # Use POSTS_DIR
fi

echo "Generating new posts..."
"${PYTHON_VENV_BIN}/python" "$PERSONAL_AGGREGATOR_SCRIPT" \
    "$POSTS_DIR" > /tmp/personal.log # Use PYTHON_VENV_BIN, PERSONAL_AGGREGATOR_SCRIPT, POSTS_DIR

echo "Configuring Ruby environment..."
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

echo "Building Jekyll site..."
bundle exec jekyll build > /tmp/build.log

echo "Adding and committing new posts..."
git add "$POSTS_DIR"/* # Use POSTS_DIR
git commit -m "Publication: $(date +'%%Y-%%m-%%d %%H:%%M:%%S')"
git push

echo "Cleaning up backup..."
rm -rf "$BACKUP_DIR"

echo "Build finished successfully."

# --- Git Branch Logic (Return) ---
if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
  echo "Build complete. Switching back to '$ORIGINAL_BRANCH'வதற்கான"
  git checkout "$ORIGINAL_BRANCH"
fi

echo "Script finished."
