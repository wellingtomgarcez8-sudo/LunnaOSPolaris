# LunnaOS Polaris — Bazzite GNOME customization layer
#
# We deliberately derive from the published Bazzite GNOME image instead of
# copying/forking the entire Bazzite build. This keeps upstream drivers,
# gaming stack, updates, rollback support and hardware enablement intact.

FROM scratch AS ctx
COPY build_files /
COPY system_files /system_files

FROM ghcr.io/ublue-os/bazzite-gnome:stable

ARG LUNNAOS_VERSION=1.0-dev

LABEL org.opencontainers.image.title="LunnaOS Polaris" \
      org.opencontainers.image.description="LunnaOS desktop image based on Bazzite GNOME" \
      org.opencontainers.image.vendor="LunnaOS" \
      org.opencontainers.image.version="${LUNNAOS_VERSION}"

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

RUN bootc container lint
