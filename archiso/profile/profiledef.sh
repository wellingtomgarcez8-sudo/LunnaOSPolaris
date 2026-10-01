#!/usr/bin/env bash
iso_name="lunnaos-selienne"
iso_label="LUNNAOS_SEL_10"
iso_publisher="LunnaOS Project"
iso_application="LunnaOS Selienne 1.0 Live Installer"
iso_version="1.0"
install_dir="lunna"
buildmodes=('iso')
bootmodes=('uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '19' '-b' '1M')
file_permissions=(
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/usr/local/bin/lunna-session"]="0:0:755"
  ["/usr/local/bin/lunna-launcher"]="0:0:755"
  ["/usr/bin/lunna-shell"]="0:0:755"
  ["/usr/bin/lunna-store"]="0:0:755"
  ["/usr/bin/lunna-monitor"]="0:0:755"
)