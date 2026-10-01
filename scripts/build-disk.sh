#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:-localhost/lunnaos-polaris:dev}"
TYPE="${2:-qcow2}"
BIB_IMAGE="${BIB_IMAGE:-quay.io/centos-bootc/bootc-image-builder:latest}"
OUT="$(pwd)/output/${TYPE}"

case "$TYPE" in
  qcow2|raw) ;;
  *) echo "unsupported image type: $TYPE" >&2; exit 2 ;;
esac

mkdir -p "$OUT"

sudo podman run --rm --privileged --pull=newer \
  --security-opt label=type:unconfined_t \
  -v "$(pwd)/disk_config/disk.toml:/config.toml:ro,Z" \
  -v "${OUT}:/output:Z" \
  -v "/var/lib/containers/storage:/var/lib/containers/storage" \
  "${BIB_IMAGE}" \
  --type "$TYPE" \
  --rootfs=btrfs \
  --config /config.toml \
  "${IMAGE_REF}"

echo "[LunnaOS] ${TYPE} output: ${OUT}"
