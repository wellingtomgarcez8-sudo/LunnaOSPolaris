#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/output/selienne"
WORK="$ROOT/work/archiso"
ARCH_CONTAINER_IMAGE="${ARCH_CONTAINER_IMAGE:-archlinux:latest}"
mkdir -p "$OUT" "$ROOT/work"

podman run --rm --privileged --security-opt label=disable \
  -v "$ROOT:/workspace:Z" "$ARCH_CONTAINER_IMAGE" \
  bash -euo pipefail -c '
    pacman -Syu --noconfirm --needed archiso base-devel git
    cd /workspace
    if grep -Eiq "^(gnome|gnome-extra|plasma|plasma-meta|xfce4|xfce4-goodies|cinnamon|mate|lxqt|lxde)$" archiso/profile/packages.x86_64; then
      echo "ERROR: forbidden desktop meta-package detected" >&2
      exit 10
    fi
    rm -rf /workspace/output/selienne/* /workspace/work/archiso
    mkarchiso -v -r -w /workspace/work/archiso -o /workspace/output/selienne /workspace/archiso/profile
  '
echo "[Selienne] ISO generated under $OUT"
