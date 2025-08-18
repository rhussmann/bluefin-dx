ARG FEDORA_VERSION="42"

# Import akmods from bazzite to use system76 firmware
# Not sure about all this...
# https://github.com/ublue-os/bluefin/issues/2361
# https://github.com/coadkins/cory-os/blob/main/Containerfile

FROM ghcr.io/ublue-os/akmods-extra:bazzite-${FEDORA_VERSION} AS akmods-extra
# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Base Image
FROM ghcr.io/ublue-os/bluefin-dx:latest
COPY system_files /

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:stable
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=akmods-extra,src=/rpms,dst=/var/tmp/akmods-extra-rpms \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/install_kernel_mods.sh

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=bind,from=akmods-extra,src=/rpms,dst=/var/tmp/akmods-extra-rpms \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/install_kernel_akmods.sh

### add 1password
COPY --from=ghcr.io/blue-build/modules/bling:latest /modules/bling/installers/1password.sh /tmp/1password.sh
RUN chmod +x /tmp/1password.sh && \
    ONEPASSWORD_RELEASE_CHANNEL=stable \
    GID_ONEPASSWORD=1500 \
    GID_ONEPASSWORDCLI=1600 \
        /tmp/1password.sh

COPY build.sh /tmp/build.sh

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
    
