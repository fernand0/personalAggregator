#!/bin/sh

# 1. Salir inmediatamente si un comando falla
set -e

# --- Lógica de Ramas de Git ---
ORIGINAL_BRANCH=$(git symbolic-ref --short HEAD)
TARGET_BRANCH="gh-pages"

if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
  echo "La rama actual es '$ORIGINAL_BRANCH'. Cambiando a '$TARGET_BRANCH'..."
  git checkout "$TARGET_BRANCH"
  # Asegurarse de que la rama local está actualizada con la remota
  git pull origin "$TARGET_BRANCH"
fi

# --- Configuración ---
PERSONAL_AGGREGATOR="/usr/src/scripts/personalAggregator.py"
PERSONAL_AGGREGATOR_HOME="$HOME/usr/src/web/deGitHub/personalAggregator"
PERSONAL_AGGREGATOR_POSTS="$PERSONAL_AGGREGATOR_HOME/_posts"
# ... (el resto de la configuración no cambia)
BACKUP_DIR="/tmp/posts_backup_$(date +%s)"

# --- Ejecución ---
cd "$PERSONAL_AGGREGATOR_HOME"
echo "Directorio de trabajo: $(pwd)"

echo "Activando entorno virtual de Python..."
myPATH="$HOME/.socialBots/bin"
. "$myPATH/activate"

echo "Haciendo copia de seguridad de los posts antiguos..."
mkdir -p "$BACKUP_DIR"
if [ -n "$(ls -A $PERSONAL_AGGREGATOR_POSTS 2>/dev/null)" ]; then
    mv $PERSONAL_AGGREGATOR_POSTS/* "$BACKUP_DIR/"
fi

echo "Generando nuevos posts..."
"$myPATH/python" "$HOME$PERSONAL_AGGREGATOR" \
    "$PERSONAL_AGGREGATOR_POSTS" > /tmp/personal.log

echo "Configurando entorno de Ruby..."
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"

echo "Construyendo el sitio con Jekyll..."
bundle exec jekyll build > /tmp/build.log

echo "Añadiendo y haciendo commit de los nuevos posts..."
git add "$PERSONAL_AGGREGATOR_POSTS"/*
git commit -m "Publication: $(date +'%%Y-%%m-%%d %%H:%%M:%%S')"
git push

echo "Limpiando copia de seguridad..."
rm -rf "$BACKUP_DIR"

echo "Build finalizado con éxito."

# --- Lógica de Ramas de Git (Retorno) ---
if [ "$ORIGINAL_BRANCH" != "$TARGET_BRANCH" ]; then
  echo "Build completo. Regresando a la rama '$ORIGINAL_BRANCH'..."
  git checkout "$ORIGINAL_BRANCH"
fi

echo "Script finalizado."
