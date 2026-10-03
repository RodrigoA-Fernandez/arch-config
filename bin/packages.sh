#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

MANAGED_FILE="$REPO_ROOT/packages/managed.txt"
AUR_FILE="$REPO_ROOT/packages/aur.txt"

die() {
    echo "Error: $*" >&2
    exit 1
}

require_file() {
    [[ -f "$1" ]] || die "No existe: $1"
}

read_packages() {
    local file="$1"

    grep -vE '^[[:space:]]*(#|$)' "$file" \
        | sed 's/[[:space:]]*#.*$//' \
        | awk 'NF'
}

check_dependencies() {
    command -v pacman >/dev/null ||
        die "pacman no está instalado"

    command -v yay >/dev/null ||
        die "yay no está instalado"
}

check_files() {
    require_file "$MANAGED_FILE"
    require_file "$AUR_FILE"
}

install_official() {
    mapfile -t packages < <(read_packages "$MANAGED_FILE")

    if ((${#packages[@]} == 0)); then
        return
    fi

    echo "==> Instalando paquetes oficiales..."
    sudo pacman -S --needed "${packages[@]}"
}

install_aur() {
    mapfile -t packages < <(read_packages "$AUR_FILE")

    if ((${#packages[@]} == 0)); then
        return
    fi

    echo "==> Instalando paquetes AUR..."
    yay -S --needed "${packages[@]}"
}

check_official() {
    mapfile -t packages < <(read_packages "$MANAGED_FILE")

    echo "==> Paquetes oficiales que faltan:"

    local missing=()

    for package in "${packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            missing+=("$package")
        fi
    done

    if ((${#missing[@]} == 0)); then
        echo "    Ninguno."
    else
        printf '    %s\n' "${missing[@]}"
    fi
}

check_aur() {
    mapfile -t packages < <(read_packages "$AUR_FILE")

    echo "==> Paquetes AUR que faltan:"

    local missing=()

    for package in "${packages[@]}"; do
        if ! pacman -Q "$package" &>/dev/null; then
            missing+=("$package")
        fi
    done

    if ((${#missing[@]} == 0)); then
        echo "    Ninguno."
    else
        printf '    %s\n' "${missing[@]}"
    fi
}

check() {
    check_official
    echo
    check_aur
}

install() {
    install_official
    echo
    install_aur
}

update() {
    echo "==> Actualizando sistema y paquetes gestionados..."
    yay -Syu
}

usage() {
    cat <<EOF
Uso:
  $0 install    Instala los paquetes declarados que falten
  $0 check      Comprueba qué paquetes declarados faltan
  $0 update     Actualiza el sistema mediante yay

Archivos:
  $MANAGED_FILE
  $AUR_FILE
EOF
}

main() {
    check_dependencies
    check_files

    case "${1:-}" in
        install)
            install
            ;;
        check)
            check
            ;;
        update)
            update
            ;;
        *)
            usage
            exit 1
            ;;
    esac
}

main "$@"
