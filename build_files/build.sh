#!/usr/bin/env bash
set -euo pipefail

# LunnaOS Polaris is intentionally a thin customization layer over Bazzite GNOME.
# Keep the upstream system intact; only add packages/defaults that belong to LunnaOS.

dnf5 -y install \
  wine \
  wine-core \
  wine-desktop \
  wine-dxvk \
  wine-opencl \
  wine-systemd

# Apply system files from the scratch build context.
cp -a /ctx/system_files/. /

# Prevent systemd-oomd from proactively killing user workloads because of memory
# pressure. The kernel's normal OOM handling remains available as a last resort.
mkdir -p /etc/systemd/system
ln -sfn /dev/null /etc/systemd/system/systemd-oomd.service
ln -sfn /dev/null /etc/systemd/system/systemd-oomd.socket

# Compile GNOME schemas and rebuild the dconf database used for system defaults.
if [[ -d /usr/share/glib-2.0/schemas ]]; then
  glib-compile-schemas /usr/share/glib-2.0/schemas
fi
if command -v dconf >/dev/null 2>&1; then
  dconf update
fi

# Make the LunnaOS identity available without replacing Bazzite's kernel/userspace
# implementation. A real uname/kernel-version change will be handled only by a
# dedicated kernel build once its driver/akmods compatibility matrix is validated.
mkdir -p /etc/lunnaos
cat > /etc/lunnaos/release <<'EOF_RELEASE'
NAME=LunnaOS Polaris
VERSION=1.0-dev
BASE=Bazzite GNOME
ARCH=x86_64
EOF_RELEASE

# Keep the image immutable-friendly: no package-manager caches or temporary state.
dnf5 clean all
rm -rf /var/cache/dnf5 /var/cache/yum /tmp/*
