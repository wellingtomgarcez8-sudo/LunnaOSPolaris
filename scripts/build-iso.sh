#!/usr/bin/env bash
set -euo pipefail

IMAGE_REF="${1:-localhost/lunnaos-polaris:dev}"
BIB_IMAGE="${BIB_IMAGE:-quay.io/centos-bootc/bootc-image-builder:latest}"
OUT="$(pwd)/output/iso"
mkdir -p "$OUT"

echo "[LunnaOS] building installer ISO from ${IMAGE_REF}"
echo "[LunnaOS] image-builder: ${BIB_IMAGE}"

sudo podman run --rm --privileged --pull=newer \
  --security-opt label=type:unconfined_t \
  -v "$(pwd)/disk_config/iso.toml:/config.toml:ro,Z" \
  -v "${OUT}:/output:Z" \
  -v "/var/lib/containers/storage:/var/lib/containers/storage" \
  "${BIB_IMAGE}" \
  --type bootc-generic-iso \
  --rootfs=btrfs \
  --config /config.toml \
  "${IMAGE_REF}"

echo "[LunnaOS] ISO output: ${OUT}"
