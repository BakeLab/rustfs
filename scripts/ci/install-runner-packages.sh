#!/usr/bin/env bash
set -euo pipefail

group=${1:?usage: install-runner-packages.sh core|packaging|iptables|wget|fakeroot|fpm|pyvenv|iproute2}
os_id=$(
  . /etc/os-release
  printf '%s' "${ID:-unknown}"
)

case "$group:$os_id" in
  core:ubuntu|core:debian)
    packages=(build-essential cmake pkg-config libssl-dev ripgrep)
    ;;
  core:arch)
    packages=(base-devel cmake pkgconf openssl ripgrep)
    ;;
  core:fedora|core:rocky|core:almalinux|core:rhel)
    packages=(gcc gcc-c++ make cmake pkgconf-pkg-config openssl-devel ripgrep)
    ;;
  core:opensuse*|core:sles)
    packages=(gcc gcc-c++ make cmake pkg-config libopenssl-devel ripgrep)
    ;;
  core:alpine)
    packages=(build-base cmake pkgconf openssl-dev ripgrep)
    ;;
  packaging:ubuntu|packaging:debian)
    packages=(musl-tools zip unzip)
    ;;
  packaging:arch)
    packages=(musl zip unzip)
    ;;
  packaging:fedora|packaging:rocky|packaging:almalinux|packaging:rhel|packaging:opensuse*|packaging:sles)
    packages=(musl-gcc zip unzip)
    ;;
  packaging:alpine)
    packages=(musl-dev zip unzip)
    ;;
  iptables:*)
    packages=(iptables)
    ;;
  wget:*)
    packages=(wget)
    ;;
  fakeroot:*)
    packages=(fakeroot)
    ;;
  fpm:ubuntu|fpm:debian)
    packages=(ruby ruby-dev build-essential rpm)
    ;;
  fpm:arch)
    packages=(ruby rpm base-devel)
    ;;
  fpm:fedora|fpm:rocky|fpm:almalinux|fpm:rhel)
    packages=(ruby ruby-devel rpm-build gcc make)
    ;;
  fpm:opensuse*|fpm:sles)
    packages=(ruby-devel rpm-build gcc make)
    ;;
  fpm:alpine)
    packages=(ruby ruby-dev rpm build-base)
    ;;
  pyvenv:ubuntu|pyvenv:debian)
    packages=(python3-venv)
    ;;
  pyvenv:arch)
    packages=(python)
    ;;
  pyvenv:fedora|pyvenv:rocky|pyvenv:almalinux|pyvenv:rhel|pyvenv:opensuse*|pyvenv:sles)
    packages=(python3)
    ;;
  pyvenv:alpine)
    packages=(python3)
    ;;
  iproute2:ubuntu|iproute2:debian|iproute2:arch|iproute2:opensuse*|iproute2:sles|iproute2:alpine)
    packages=(iproute2)
    ;;
  iproute2:fedora|iproute2:rocky|iproute2:almalinux|iproute2:rhel)
    packages=(iproute)
    ;;
  *)
    echo "Unsupported package group or Linux distribution: $group ($os_id)" >&2
    exit 2
    ;;
esac

case "$os_id" in
  ubuntu|debian)
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends "${packages[@]}"
    ;;
  arch)
    sudo pacman -S --needed --noconfirm "${packages[@]}"
    ;;
  fedora|rocky|almalinux|rhel)
    sudo dnf install -y "${packages[@]}"
    ;;
  opensuse*|sles)
    sudo zypper --non-interactive install --no-recommends "${packages[@]}"
    ;;
  alpine)
    sudo apk add --no-cache "${packages[@]}"
    ;;
  *)
    echo "No supported package manager for Linux distribution: $os_id" >&2
    exit 2
    ;;
esac
