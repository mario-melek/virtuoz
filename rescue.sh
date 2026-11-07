#!/bin/bash
# Virtuoz rescue for macOS: for a Virtuoz window that stays dark or empty (or won't open at all).
#   curl -fsSL https://raw.githubusercontent.com/mario-melek/virtuoz/main/rescue.sh | bash
# Quits Virtuoz, updates it if a newer version is out, then starts it with software graphics (the window always
# shows; 3D previews and exports are slower: switch back in Settings > System > Graphics once your Mac is updated).
# Projects, settings and the Skool login are not touched.
# Source: installer/rescue.sh in the Virtuoz code repo (published by scripts/publish-installer.mjs).
set -euo pipefail

main() {
OWNER="mario-melek"
MAC_REPO="virtuoz-mac-releases"
APP="/Applications/Virtuoz.app"
DRY="${CZ_INSTALL_DRY:-}"

bold=$'\033[1m'; dim=$'\033[2m'; green=$'\033[32m'; yellow=$'\033[33m'; red=$'\033[31m'; off=$'\033[0m'
step() { printf '\n%s==> %s%s\n' "$bold" "$1" "$off"; }
ok()   { printf '    %s[ok]%s %s\n' "$green" "$off" "$1"; }
note() { printf '    %s%s%s\n' "$dim" "$1" "$off"; }
warn() { printf '    %s[!]%s %s\n' "$yellow" "$off" "$1"; }
die()  { printf '\n%sRescue stopped:%s %s\n' "$red" "$off" "$1" >&2; exit 1; }
# 1 when version $1 is older than $2 (plain x.y.z)
older() { [ "$1" != "$2" ] && [ "$(printf '%s\n%s\n' "${1%%-*}" "${2%%-*}" | sort -t. -k1,1n -k2,2n -k3,3n | head -1)" = "${1%%-*}" ]; }

printf '%sVirtuoz rescue (macOS)%s\n' "$bold" "$off"
note "Your projects, settings and Skool login stay as they are."
[ -n "$DRY" ] && warn "Test mode (CZ_INSTALL_DRY): nothing is closed, installed or changed."
if [ ! -d "$APP" ] && [ -z "$DRY" ]; then
  die "Virtuoz is not installed in Applications. Install it with:  curl -fsSL https://raw.githubusercontent.com/$OWNER/virtuoz/main/install.sh | bash"
fi

step "Quitting Virtuoz"
if ! pgrep -xq "Virtuoz"; then ok "it was not running"
elif [ -n "$DRY" ]; then note "(test mode) would quit Virtuoz"
else
  pkill -x "Virtuoz" || true
  for _ in $(seq 1 20); do pgrep -xq "Virtuoz" || break; sleep 0.5; done
  pgrep -xq "Virtuoz" && pkill -9 -x "Virtuoz" || true
  ok "closed"
fi

step "Updating Virtuoz"
case "$(uname -m)" in arm64) CHIP="arm64" ;; *) CHIP="x64" ;; esac
CURRENT=""
[ -d "$APP" ] && CURRENT=$(defaults read "$APP/Contents/Info" CFBundleShortVersionString 2>/dev/null || true)
RELEASES="https://github.com/$OWNER/$MAC_REPO/releases"
LATEST_URL=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$RELEASES/latest" 2>/dev/null || true)
case "$LATEST_URL" in
  */releases/tag/v*) TAG="${LATEST_URL##*/tag/}"; LATEST="${TAG#v}" ;;
  *) TAG=""; LATEST=""; warn "could not reach the Virtuoz releases, so it was not updated (it is started anyway)" ;;
esac
if [ -n "$LATEST" ]; then
  if [ -n "$CURRENT" ] && ! older "$CURRENT" "$LATEST"; then ok "Virtuoz $CURRENT is up to date"
  elif [ -n "$DRY" ]; then note "(test mode) would install Virtuoz $LATEST (installed: ${CURRENT:-none})"
  else
    URL="$RELEASES/download/$TAG/Virtuoz-$LATEST-Mac-$CHIP.dmg"   # name set in .github/workflows/mac-build.yml
    note "Downloading Virtuoz $LATEST ..."
    TMP=$(mktemp -d); trap 'hdiutil detach -quiet "$TMP/mnt" >/dev/null 2>&1 || true; rm -rf "$TMP"' EXIT
    if curl -fL --progress-bar -o "$TMP/suite.dmg" "$URL" && hdiutil attach -quiet -nobrowse -readonly -mountpoint "$TMP/mnt" "$TMP/suite.dmg" && [ -d "$TMP/mnt/Virtuoz.app" ]; then
      rm -rf "$APP"
      ditto "$TMP/mnt/Virtuoz.app" "$APP" || die "could not copy the app into Applications."
      hdiutil detach -quiet "$TMP/mnt" || true
      xattr -dr com.apple.quarantine "$APP" 2>/dev/null || true
      CURRENT="$LATEST"; ok "Virtuoz $LATEST installed"
    else warn "the update did not finish; starting the installed version"; fi
  fi
fi

step "Starting Virtuoz"
# software graphics (--software-graphics) exists from 0.15.0
if [ -n "$CURRENT" ] && older "$CURRENT" "0.15.0"; then
  warn "this version ($CURRENT) is too old for the rescue start: run this again when you are online to update it"
  [ -z "$DRY" ] && open "$APP"
else
  if [ -n "$DRY" ]; then note "(test mode) would start Virtuoz --software-graphics"
  else open -a "$APP" --args --software-graphics; ok "Started in software graphics (switch back in Settings > System > Graphics)"; fi
fi
printf '\n%sDone.%s Still not showing? Ask in the community and include a screenshot.\n' "$bold" "$off"
}

main "$@"
