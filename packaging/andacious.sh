#!/usr/bin/env bash
set -euo pipefail

# Andacious invokes this script from its Debian Linux environment.
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
sudo rm -f "$SCRIPT_PATH"

# Expose common Android shared-storage folders in the Linux home directory.
for folder in sdcard Documents Downloads Music Pictures Videos DCIM; do
  if [ -d "/$folder" ] && [ ! -e "$HOME/$folder" ]; then
    ln -s "/$folder" "$HOME/$folder"
  fi
done

# Keep the existing Andacious desktop/session setup.
xterm &

if [ ! -f /support/gdk_fix ]; then
  update-mime-database /usr/share/mime
  find /usr/lib -name gdk-pixbuf-query-loaders -exec {} --update-cache \;
  touch /support/gdk_fix
fi

if [ ! -f /support/full_screen_fix ]; then
  sed -i 's#</applications>#<application title="Audacity"> <position force="yes"> <x>0</x> <y>0</y> </position> <size> <width>100%</width> <height>100%</height> </size> </application> </applications>#g' /etc/xdg/openbox/rc.xml
  openbox --reconfigure
  touch /support/full_screen_fix
fi

# Official Audacity 4.0.2 Linux ARM64 AppImage.
VERSION="4.0.2"
APPIMAGE_NAME="audacity-linux-4.0.2-aarch64.AppImage"
APPIMAGE_URL="https://github.com/audacity/audacity/releases/download/Audacity-4.0.2/$APPIMAGE_NAME"
APPIMAGE_SHA256="88b1e16dd40a5b7d36bec5789b03f66bda34a7b964e19f338951bf6034d9db9c"

CACHE_DIR="$HOME/.cache/audacity-$VERSION"
APP_DIR="$HOME/.local/opt/audacity-$VERSION"
APPIMAGE_PATH="$CACHE_DIR/$APPIMAGE_NAME"

mkdir -p "$CACHE_DIR" "$HOME/.local/opt"

if [ ! -x "$APP_DIR/AppRun" ]; then
  if ! command -v wget >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y wget ca-certificates
  fi

  echo "Downloading official Audacity $VERSION for ARM64..."
  wget -q --show-progress -O "$APPIMAGE_PATH.part" "$APPIMAGE_URL"
  mv "$APPIMAGE_PATH.part" "$APPIMAGE_PATH"

  echo "$APPIMAGE_SHA256  $APPIMAGE_PATH" | sha256sum --check --status || {
    echo "ERROR: Audacity AppImage SHA-256 verification failed." >&2
    rm -f "$APPIMAGE_PATH"
    exit 1
  }

  chmod +x "$APPIMAGE_PATH"
  EXTRACT_DIR="$CACHE_DIR/squashfs-root"
  rm -rf "$EXTRACT_DIR"
  (
    cd "$CACHE_DIR"
    "$APPIMAGE_PATH" --appimage-extract >/dev/null
  )

  test -x "$EXTRACT_DIR/AppRun"
  rm -rf "$APP_DIR"
  mv "$EXTRACT_DIR" "$APP_DIR"
fi

cd "$APP_DIR"
exec "$APP_DIR/AppRun"
