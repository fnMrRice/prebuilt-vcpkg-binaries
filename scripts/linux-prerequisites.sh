#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  build-essential autoconf autoconf-archive automake bison flex gperf libtool \
  libtool-bin pkg-config ninja-build nasm perl curl zip unzip tar \
  libgl1-mesa-dev libglu1-mesa-dev libegl1-mesa-dev libvulkan-dev \
  libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev \
  libxrandr-dev libxtst-dev libxcursor-dev libxinerama-dev libxcb1-dev \
  libxcb-util-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev \
  libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync-dev libxcb-xfixes0-dev \
  libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxcb-xinerama0-dev \
  libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev libxkbcommon-x11-dev libwayland-dev \
  libwayland-egl-backend-dev wayland-protocols libxft-dev libibus-1.0-dev \
  libinput-dev libudev-dev libasound2-dev \
  libpulse-dev libdbus-1-dev libfontconfig1-dev libfreetype6-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libva-dev libdrm-dev
