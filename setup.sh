#!/usr/bin/env bash
# setup.sh — Configura VS Code de forma portable.
#   - Windows: ejecutar dentro de Git Bash.
#   - Linux (cualquier distro) y macOS: ejecutar en la terminal normal.
#   - WSL: NO. VS Code guarda su configuración en Windows → usar Git Bash en Windows.
#
# Instala las extensiones esenciales, pregunta por las opcionales y aplica
# settings.json haciendo antes un respaldo del que ya tuvieras.

set -uo pipefail

# --- Helper: convertir rutas de Windows a formato Unix cuando haga falta ---
winpath() {
  if command -v cygpath >/dev/null 2>&1; then cygpath -u "$1"; else echo "$1"; fi
}

# --- Helper: ¿estamos dentro de WSL? (cualquier distro, WSL1 o WSL2) ---
is_wsl() {
  [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ] \
    || [ -e /proc/sys/fs/binfmt_misc/WSLInterop ] \
    || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}

# --- 1. Detectar el directorio de usuario de VS Code y su CLI segun el sistema ---
# CODE es un arreglo: "code" en casi todos los casos, "flatpak run ..." en Flatpak.
CODE=(code)
detect_vscode_dir() {
  case "$(uname -s)" in
    Linux*)
      if ! command -v code >/dev/null 2>&1 && command -v flatpak >/dev/null 2>&1 \
         && flatpak info com.visualstudio.code >/dev/null 2>&1; then
        CODE=(flatpak run com.visualstudio.code)
        VSCODE_DIR="$HOME/.var/app/com.visualstudio.code/config/Code/User"
      else
        VSCODE_DIR="$HOME/.config/Code/User"   # .deb, .rpm, Snap, tarball
      fi ;;
    Darwin*) VSCODE_DIR="$HOME/Library/Application Support/Code/User" ;;
    MINGW*|MSYS*|CYGWIN*)
      if [ -z "${APPDATA:-}" ]; then
        echo "La variable APPDATA está vacía: no sé dónde vive tu configuración. Abortando."
        exit 1
      fi
      VSCODE_DIR="$(winpath "$APPDATA")/Code/User" ;;
    *) VSCODE_DIR="" ;;
  esac
}

if is_wsl; then
  echo "Estás dentro de WSL (${WSL_DISTRO_NAME:-distro Linux})."
  echo "VS Code guarda tu configuración y tus extensiones en Windows, no aquí: desde WSL"
  echo "este script escribiría en un lugar que VS Code no lee."
  echo ""
  echo "Ábrelo desde Git Bash en Windows (clona el repo en una carpeta de Windows) y corre:"
  echo "  bash setup.sh"
  exit 1
fi

detect_vscode_dir
if [ -z "$VSCODE_DIR" ]; then
  echo "No pude reconocer tu sistema operativo. Abortando."
  exit 1
fi

# --- 2. Verificar que la CLI de VS Code este disponible ---
if ! command -v "${CODE[0]}" >/dev/null 2>&1; then
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
  "${CODE[@]}" --install-extension "$ext" --force || echo "     (no se pudo instalar $ext)"
done < "$SCRIPT_DIR/extensions-core.txt"

# --- 4. Preguntar por las extensiones opcionales (una por una) ---
if [ -f "$SCRIPT_DIR/extensions-optional.txt" ]; then
  echo ""
  echo "Extensiones opcionales:"
  while IFS= read -r ext || [ -n "$ext" ]; do
    [ -z "$ext" ] && continue
    case "$ext" in \#*) continue ;; esac
    printf "  Instalar '%s'? [s/N] " "$ext"
    read -r answer 2>/dev/null </dev/tty || answer="n"
    case "$answer" in
      [sS]|[sS][iI]) "${CODE[@]}" --install-extension "$ext" --force || echo "     (no se pudo instalar $ext)" ;;
      *) echo "     (omitida)" ;;
    esac
  done < "$SCRIPT_DIR/extensions-optional.txt"
fi

# --- 5. Aplicar un archivo de configuracion con respaldo del anterior ---
# Si el destino ya es identico, no lo toca ni deja otro respaldo.
mkdir -p "$VSCODE_DIR"
apply_config() {
  local name="$1" src="$SCRIPT_DIR/$1" dst="$VSCODE_DIR/$1"
  [ -f "$src" ] || return 0
  echo ""
  if [ -f "$dst" ] && cmp -s "$src" "$dst"; then
    echo "$name ya está al día en:"
    echo "  $dst"
    return 0
  fi
  if [ -f "$dst" ]; then
    local backup
    backup="$dst.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$dst" "$backup"
    echo "Respaldo de tu $name anterior en:"
    echo "  $backup"
  fi
  cp "$src" "$dst"
  echo "$name aplicado en:"
  echo "  $dst"
}

apply_config settings.json
apply_config keybindings.json   # opcional: solo si el repo lo trae

echo ""
echo "VS Code configurado correctamente."
