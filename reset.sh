#!/usr/bin/env bash
# reset.sh — Borra TODA la configuracion de VS Code para empezar de cero.
#   - Windows: ejecutar dentro de Git Bash.
#   - Linux y macOS: ejecutar en la terminal normal.
#
# PELIGRO: esta accion es IRREVERSIBLE. Pide confirmacion explicita.

set -uo pipefail

winpath() {
  if command -v cygpath >/dev/null 2>&1; then cygpath -u "$1"; else echo "$1"; fi
}

echo "=================================================="
echo "  RESET TOTAL DE VS CODE"
echo "=================================================="
echo "Esto borra tu configuracion de usuario, las extensiones"
echo "instaladas y la cache de VS Code. NO se puede deshacer."
echo ""
printf "Escribe BORRAR (en mayusculas) para continuar: "
read -r confirm </dev/tty 2>/dev/null || confirm=""
if [ "$confirm" != "BORRAR" ]; then
  echo "Cancelado. No se borro nada."
  exit 0
fi

case "$(uname -s)" in
  Linux*)
    rm -rf "$HOME/.config/Code" "$HOME/.vscode"
    ;;
  Darwin*)
    rm -rf "$HOME/Library/Application Support/Code" "$HOME/.vscode"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    rm -rf "$(winpath "${APPDATA:-}")/Code" \
           "$(winpath "${LOCALAPPDATA:-}")/Code" \
           "$HOME/.vscode"
    ;;
  *)
    echo "Sistema no reconocido. Abortando."
    exit 1
    ;;
esac

echo "Configuracion de VS Code borrada."
echo "Ejecuta ./setup.sh para reconfigurar desde esta plantilla."
