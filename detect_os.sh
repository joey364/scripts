#!/bin/bash

OS="$(uname -s)"
case "$OS" in
  Linux)
    if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
      echo "arch"
    elif [ -f "/etc/fedora-release" ] || [ -f "/etc/redhat-release" ]; then
      echo "fedora"
    elif [ -f "/etc/gentoo-release" ]; then
      echo "gentoo"
    else # assume debian based
      echo "debian"
    fi
    ;;
  FreeBSD)
    echo "freebsd"
    ;;
  NetBSD)
    echo "netbsd"
    ;;
  OpenBSD)
    echo "openbsd"
    ;;
  Darwin)
    echo "mac os"
    ;;
  *)
    echo "OS $OS is not currently supported."
    exit 1
    ;;
esac

