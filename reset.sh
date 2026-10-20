#!/usr/bin/env bash
# reset.sh — Borra TODA la configuracion de VS Code para empezar de cero.
#   - Windows: ejecutar dentro de Git Bash.
#   - Linux (cualquier distro) y macOS: ejecutar en la terminal normal.
#   - WSL: NO. La configuración real vive en Windows → usar Git Bash en Windows.
#
# PELIGRO: borra extensiones, caché y configuración. Pide confirmación explícita y,
# antes de borrar, respalda lo que no se recupera solo: settings.json,
# keybindings.json y snippets/.

set -uo pipefail

winpath() {
  if command -v cygpath >/dev/null 2>&1; then cygpath -u "$1"; else echo "$1"; fi
}

is_wsl() {
  [ -n "${WSL_DISTRO_NAME:-}" ] || [ -n "${WSL_INTEROP:-}" ] \
    || [ -e /proc/sys/fs/binfmt_misc/WSLInterop ] \
    || grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null
}

if is_wsl; then
  echo "Estás dentro de WSL (${WSL_DISTRO_NAME:-distro Linux})."
  echo "Tu configuración de VS Code vive en Windows: desde aquí este script borraría"
  echo "carpetas de Linux y dejaría intacta la configuración real."
  echo "Ábrelo desde Git Bash en Windows y corre:  bash reset.sh"
  exit 1
fi

# --- 1. Qué se borra y dónde está la carpeta User (según el sistema) ---
TARGETS=()
case "$(uname -s)" in
  Linux*)
    USER_DIR="$HOME/.config/Code/User"
    TARGETS=("$HOME/.config/Code" "$HOME/.vscode")
    if [ -d "$HOME/.var/app/com.visualstudio.code" ]; then   # instalación Flatpak
      [ -d "$USER_DIR" ] || USER_DIR="$HOME/.var/app/com.visualstudio.code/config/Code/User"
      TARGETS+=("$HOME/.var/app/com.visualstudio.code")
    fi
    running() { pgrep -x code >/dev/null 2>&1 || pgrep -f com.visualstudio.code >/dev/null 2>&1; }
    ;;
  Darwin*)
    USER_DIR="$HOME/Library/Application Support/Code/User"
    TARGETS=("$HOME/Library/Application Support/Code" "$HOME/.vscode")
    running() { pgrep -f "Visual Studio Code.app" >/dev/null 2>&1; }
    ;;
  MINGW*|MSYS*|CYGWIN*)
    if [ -z "${APPDATA:-}" ] || [ -z "${LOCALAPPDATA:-}" ]; then
      echo "APPDATA o LOCALAPPDATA están vacías: no sé qué borrar con seguridad. Abortando."
      exit 1
    fi
    USER_DIR="$(winpath "$APPDATA")/Code/User"
    TARGETS=("$(winpath "$APPDATA")/Code" "$(winpath "$LOCALAPPDATA")/Code" "$HOME/.vscode")
    running() { tasklist //FI "IMAGENAME eq Code.exe" 2>/dev/null | grep -qi "code.exe"; }
    ;;
  *)
    echo "Sistema no reconocido. Abortando."
    exit 1
    ;;
esac

# --- 2. VS Code debe estar cerrado (con archivos en uso, el borrado queda a medias) ---
if running; then
  echo "VS Code está abierto. Ciérralo (todas sus ventanas) y vuelve a correr este script."
  exit 1
fi

# --- 3. Confirmación explícita ---
echo "=================================================="
echo "  RESET TOTAL DE VS CODE"
echo "=================================================="
echo "Esto borra tu configuracion de usuario, las extensiones"
echo "instaladas y la cache de VS Code:"
for t in "${TARGETS[@]}"; do echo "  - $t"; done
echo ""
echo "Antes se respaldan settings.json, keybindings.json y snippets/."
echo ""
printf "Escribe BORRAR (en mayusculas) para continuar: "
read -r confirm 2>/dev/null </dev/tty || confirm=""
if [ "$confirm" != "BORRAR" ]; then
  echo "Cancelado. No se borro nada."
  exit 0
fi

# --- 4. Respaldo de lo que no se recupera solo ---
BACKUP="$HOME/vscode-reset-backup-$(date +%Y%m%d-%H%M%S)"
saved=0
for item in settings.json keybindings.json snippets; do
  if [ -e "$USER_DIR/$item" ]; then
    mkdir -p "$BACKUP"
    if cp -R "$USER_DIR/$item" "$BACKUP/"; then
      saved=$((saved + 1))
    else
      echo "No pude respaldar $item. Abortando sin borrar nada."
      exit 1
    fi
  fi
done
if [ "$saved" -gt 0 ]; then
  echo "Respaldo en: $BACKUP"
else
  echo "No había settings, atajos ni snippets que respaldar."
fi

# --- 5. Borrado, reportando lo que no se pudo borrar ---
failed=()
for t in "${TARGETS[@]}"; do
  [ -e "$t" ] || continue
  rm -rf "$t" 2>/dev/null
  [ -e "$t" ] && failed+=("$t")
done

if [ ${#failed[@]} -gt 0 ]; then
  echo ""
  echo "No se pudo borrar por completo:"
  for t in "${failed[@]}"; do echo "  - $t"; done
  echo "¿Quedó algún proceso de VS Code abierto? Ciérralo y vuelve a correr el script."
  exit 1
fi

echo "Configuracion de VS Code borrada."
echo "Ejecuta 'bash setup.sh' para reconfigurar desde esta plantilla."
[ "$saved" -gt 0 ] && echo "Para recuperar tus atajos o snippets, cópialos desde $BACKUP."
exit 0
