#!/bin/sh

# 1. Exit immediately if a command exits with a non-zero status.
set -e
set -x

LOG_FILE=/tmp/build.log
=======
>>>>>>> 768931dee07ff018ac2072360d03653584960c41
>>>>>>> master
=======
set -x

LOG_FILE=/tmp/build.log
>>>>>>> master

# --- User Configuration ---
# Path to your personalAggregator.py script.
# This script is responsible for generating your posts.
# Example: PERSONAL_AGGREGATOR_SCRIPT="/path/to/your/personalAggregator.py"
# If it's located in the '_bin' folder at the project root:
PERSONAL_AGGREGATOR_SCRIPT="${PROJECT_ROOT}/_bin/personalAggregator.py" # Default: Update this to your path
PERSONAL_AGGREGATOR_SCRIPT="${HOME}/usr/src/web/deGitHub/personalAggregator/_bin/personalAggregator.py" # Default: Update this to your path
#PERSONAL_AGGREGATOR_SCRIPT="${HOME}/usr/src/scripts/personalAggregator.py" # Default: Update this to your path
<<<<<<< HEAD
=======
<<<<<<< HEAD
PERSONAL_AGGREGATOR_SCRIPT="${HOME}/usr/src/web/deGitHub/personalAggregator/_bin/personalAggregator.py" # Default: Update this to your path
#PERSONAL_AGGREGATOR_SCRIPT="${HOME}/usr/src/scripts/personalAggregator.py" # Default: Update this to your path
=======
>>>>>>> 768931dee07ff018ac2072360d03653584960c41
>>>>>>> master
=======
>>>>>>> master

# --- Internal Variables (Do not modify below this line) ---
# Derive PROJECT_ROOT from the script's location for portability.
SCRIPT_DIR=$(dirname -- "$(realpath -- "$0")")
PROJECT_ROOT=$(dirname -- "$SCRIPT_DIR") # Assumes _bin is in the project root

cd $PROJECT_ROOT >> $LOG_FILE 2>&1


<<<<<<< HEAD
=======
<<<<<<< HEAD
cd $PROJECT_ROOT >> $LOG_FILE 2>&1


=======
>>>>>>> 768931dee07ff018ac2072360d03653584960c41
>>>>>>> master
=======
>>>>>>> master
POSTS_DIR="${PROJECT_ROOT}/_posts"
SITE_DIR="${PROJECT_ROOT}/_site"

# Virtual environment setup
VENV_DIR="${PROJECT_ROOT}/.personalAggregator"
PYTHON_VENV_BIN="${VENV_DIR}/bin"

# --- Git Branch Logic ---
ORIGINAL_BRANCH=$(git symbolic-ref --short HEAD)
TARGET_BRANCH="gh-pages"

if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
<<<<<<< HEAD
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> master
=======
>>>>>>> master
  git checkout "$TARGET_BRANCH" >> $LOG_FILE 2>&1
  # Ensure the local branch is updated with the remote
  git pull origin "$TARGET_BRANCH" >> $LOG_FILE 2>&1
fi

# --- Execution ---
cd "$PROJECT_ROOT" >> $LOG_FILE 2>&1 # Use PROJECT_ROOT

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
  python3 -m venv "$VENV_DIR" >> $LOG_FILE 2>&1
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
  echo "Current branch is '$ORIGINAL_BRANCH'. Switching to '$TARGET_BRANCH'வதற்கான"
  git checkout "$TARGET_BRANCH"
  # Ensure the local branch is updated with the remote
  git pull origin "$TARGET_BRANCH"
fi

# --- Execution ---
cd "$PROJECT_ROOT" # Use PROJECT_ROOT
echo "Working directory: $(pwd)"

# Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
  echo "Creating Python virtual environment at $VENV_DIR..."
  python3 -m venv "$VENV_DIR"
>>>>>>> 768931dee07ff018ac2072360d03653584960c41
>>>>>>> master
=======
>>>>>>> master
fi

# Check if the activate script exists before sourcing
if [ ! -f "${PYTHON_VENV_BIN}/activate" ]; then
<<<<<<< HEAD
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> master
=======
>>>>>>> master
  echo "Error: Virtual environment activation script not found at ${PYTHON_VENV_BIN}/activate." >> $LOG_FILE 2>&1
  echo "Please ensure 'python3 -m venv' was successful or check your Python installation." >> $LOG_FILE 2>&1
  exit 1
fi

. "${PYTHON_VENV_BIN}/activate" # Use PYTHON_VENV_BIN

pip install -r "${PROJECT_ROOT}/requirements.txt" >> $LOG_FILE 2>&1

BACKUP_DIR="/tmp/posts_backup_$(date +%s)"
mkdir -p "$BACKUP_DIR"
if [ -n "$(ls -A "$POSTS_DIR" 2>/dev/null)" ]; then # Use POSTS_DIR
    mv "$POSTS_DIR"/* "$BACKUP_DIR/" >> $LOG_FILE 2>&1 # Use POSTS_DIR
fi

"${PYTHON_VENV_BIN}/python" "$PERSONAL_AGGREGATOR_SCRIPT" \
	--config-file $HOME/.mySocial/config/.rssElmundo \
	--output-dir "$POSTS_DIR" \
       	>> /tmp/personal.log 2>&1 # Use PYTHON_VENV_BIN, PERSONAL_AGGREGATOR_SCRIPT, POSTS_DIR

export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

bundle exec jekyll build >> /tmp/build.log 2>&1

git add "$POSTS_DIR"/* >> $LOG_FILE 2>&1 # Use POSTS_DIR
git commit -m "Publication: $(date +'%%Y-%%m-%%d %%H:%%M:%%S')" >> $LOG_FILE 2>&1
git push >> $LOG_FILE 2>&1

rm -rf "$BACKUP_DIR"

# --- Git Branch Logic (Return) ---
if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
  git checkout "$ORIGINAL_BRANCH" >> $LOG_FILE 2>&1
fi
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
  echo "Error: Virtual environment activation script not found at ${PYTHON_VENV_BIN}/activate."
  echo "Please ensure 'python3 -m venv' was successful or check your Python installation."
  exit 1
fi

echo "Activating Python virtual environment..."
. "${PYTHON_VENV_BIN}/activate" # Use PYTHON_VENV_BIN

echo "Installing Python dependencies..."
pip install -r "${PROJECT_ROOT}/requirements.txt"

echo "Backing up old posts..."
BACKUP_DIR="/tmp/posts_backup_$(date +%s)"
mkdir -p "$BACKUP_DIR"
if [ -n "$(ls -A "$POSTS_DIR" 2>/dev/null)" ]; then # Use POSTS_DIR
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
>>>>>>> 768931dee07ff018ac2072360d03653584960c41
>>>>>>> master
=======
>>>>>>> master
