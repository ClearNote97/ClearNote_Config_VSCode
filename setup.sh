#!/usr/bin/env bash
# setup.sh — Configura VS Code de forma portable.
#   - Windows: ejecutar dentro de Git Bash.
#   - Linux y macOS: ejecutar en la terminal normal.
#
# Instala las extensiones esenciales, pregunta por las opcionales y aplica
# settings.json haciendo antes un respaldo del que ya tuvieras.

set -uo pipefail

# --- Helper: convertir rutas de Windows a formato Unix cuando haga falta ---
winpath() {
  if command -v cygpath >/dev/null 2>&1; then cygpath -u "$1"; else echo "$1"; fi
}

# --- 1. Detectar el directorio de usuario de VS Code segun el sistema ---
detect_vscode_dir() {
  case "$(uname -s)" in
    Linux*)  echo "$HOME/.config/Code/User" ;;
    Darwin*) echo "$HOME/Library/Application Support/Code/User" ;;
    MINGW*|MSYS*|CYGWIN*) echo "$(winpath "${APPDATA:-}")/Code/User" ;;
    *) echo "" ;;
  esac
}

VSCODE_DIR="$(detect_vscode_dir)"
if [ -z "$VSCODE_DIR" ]; then
  echo "No pude reconocer tu sistema operativo. Abortando."
  exit 1
fi

# --- 2. Verificar que el comando 'code' este disponible ---
if ! command -v code >/dev/null 2>&1; then
  echo "No encuentro el comando 'code' (la CLI de VS Code)."
  echo "Abre VS Code, presiona Ctrl+Shift+P y ejecuta:"
  echo "  Shell Command: Install 'code' command in PATH"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- 3. Instalar extensiones esenciales (siempre) ---
echo "Instalando extensiones esenciales..."
while IFS= read -r ext || [ -n "$ext" ]; do
  [ -z "$ext" ] && continue
  case "$ext" in \#*) continue ;; esac
  echo "  -> $ext"
  code --install-extension "$ext" --force || echo "     (no se pudo instalar $ext)"
done < "$SCRIPT_DIR/extensions-core.txt"

# --- 4. Preguntar por las extensiones opcionales (una por una) ---
if [ -f "$SCRIPT_DIR/extensions-optional.txt" ]; then
  echo ""
  echo "Extensiones opcionales:"
  while IFS= read -r ext || [ -n "$ext" ]; do
    [ -z "$ext" ] && continue
    case "$ext" in \#*) continue ;; esac
    printf "  Instalar '%s'? [s/N] " "$ext"
    read -r answer </dev/tty 2>/dev/null || answer="n"
    case "$answer" in
      [sS]|[sS][iI]) code --install-extension "$ext" --force || echo "     (no se pudo instalar $ext)" ;;
      *) echo "     (omitida)" ;;
    esac
  done < "$SCRIPT_DIR/extensions-optional.txt"
fi

# --- 5. Respaldar settings.json existente antes de sobrescribir ---
mkdir -p "$VSCODE_DIR"
TARGET="$VSCODE_DIR/settings.json"
if [ -f "$TARGET" ]; then
  BACKUP="$TARGET.backup-$(date +%Y%m%d-%H%M%S)"
  cp "$TARGET" "$BACKUP"
  echo ""
  echo "Respaldo de tu settings.json anterior en:"
  echo "  $BACKUP"
fi

# --- 6. Copiar la nueva configuracion ---
cp "$SCRIPT_DIR/settings.json" "$TARGET"
echo "settings.json aplicado en:"
echo "  $TARGET"

# --- 7. keybindings.json opcional, si existe en el repo ---
if [ -f "$SCRIPT_DIR/keybindings.json" ]; then
  KTARGET="$VSCODE_DIR/keybindings.json"
  [ -f "$KTARGET" ] && cp "$KTARGET" "$KTARGET.backup-$(date +%Y%m%d-%H%M%S)"
  cp "$SCRIPT_DIR/keybindings.json" "$KTARGET"
  echo "keybindings.json aplicado."
fi

echo ""
echo "VS Code configurado correctamente."
