FROM ghcr.io/ublue-os/bluefin-dx:latest

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
    
