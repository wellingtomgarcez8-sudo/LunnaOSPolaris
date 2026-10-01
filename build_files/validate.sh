#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

fail=0

require_file() {
  [[ -f "$1" ]] || { echo "MISSING: $1" >&2; fail=1; }
}

for f in Containerfile Justfile disk_config/disk.toml disk_config/iso.toml build_files/build.sh scripts/build-iso.sh scripts/build-disk.sh; do
  require_file "$f"
done

if ! grep -q 'ghcr.io/ublue-os/bazzite-gnome:stable' Containerfile; then
  echo "ERROR: Containerfile is not based on Bazzite GNOME stable" >&2
  fail=1
fi

if ! grep -q "accent-color='purple'" system_files/etc/dconf/db/local.d/00-lunnaos; then
  echo "ERROR: purple GNOME accent default is missing" >&2
  fail=1
fi

if ! grep -q "color-scheme='prefer-dark'" system_files/etc/dconf/db/local.d/00-lunnaos; then
  echo "ERROR: dark GNOME default is missing" >&2
  fail=1
fi

if grep -RniE 'rpm-ostree rebase|ostree-unverified-registry|systemctl reboot|podman push' build_files scripts Justfile --exclude=validate.sh; then
  echo "ERROR: build source contains an unsafe/remote mutation command" >&2
  fail=1
fi

while IFS= read -r -d '' f; do
  bash -n "$f" || fail=1
done < <(find build_files scripts -type f -name '*.sh' -print0)

python3 - <<'PY'
from pathlib import Path
import tomllib
for path in (Path('disk_config/disk.toml'), Path('disk_config/iso.toml')):
    tomllib.loads(path.read_text())
PY

if (( fail != 0 )); then
  exit 1
fi

echo "LunnaOS Polaris validation: OK"
