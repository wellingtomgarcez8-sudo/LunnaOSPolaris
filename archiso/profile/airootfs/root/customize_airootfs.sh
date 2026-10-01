#!/usr/bin/env bash
set -euo pipefail

systemctl enable NetworkManager.service
systemctl enable sddm.service

# Audio services run in the user's systemd manager.
systemctl --global enable pipewire.socket pipewire-pulse.socket wireplumber.service

# Do not install or enable a traditional desktop environment.
pacman -Qq | grep -E '^(gnome|gnome-extra|plasma-meta|plasma|xfce4|xfce4-goodies|cinnamon|mate|lxqt|lxde)$' && {
  echo "Forbidden desktop package detected in target root" >&2
  exit 20
} || true

rm -f /root/customize_airootfs.sh
