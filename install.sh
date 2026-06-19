#!/bin/bash
set -e

echo "🚀 NetSpeed - macOS Menu Bar Network Speed Monitor"
echo "===================================================="
echo ""

BIN_DIR="${HOME}/.local/bin"
LAUNCH_DIR="${HOME}/Library/LaunchAgents"
PLIST="com.netspeed.menubar.plist"
INSTALL_DIR="${HOME}/.netspeed"
SRC="NetSpeed.swift"
BIN="NetSpeed"

# Create directories
mkdir -p "$BIN_DIR" "$LAUNCH_DIR" "$INSTALL_DIR"

# Compile
echo "📦 Compiling..."
swiftc -o "${INSTALL_DIR}/${BIN}" "$SRC"
echo "   ✓ Compiled to ${INSTALL_DIR}/${BIN}"

# Create symlink
ln -sf "${INSTALL_DIR}/${BIN}" "${BIN_DIR}/${BIN}"
echo "   ✓ Linked to ${BIN_DIR}/${BIN}"

# Install LaunchAgent for auto-start
sed "s|/path/to/NetSpeed|${INSTALL_DIR}/${BIN}|g" "$PLIST" > "${LAUNCH_DIR}/${PLIST}"
launchctl unload "${LAUNCH_DIR}/${PLIST}" 2>/dev/null || true
launchctl load "${LAUNCH_DIR}/${PLIST}"
echo "   ✓ Auto-start enabled (LaunchAgent)"

# Run now
killall NetSpeed 2>/dev/null || true
nohup "${INSTALL_DIR}/${BIN}" > /dev/null 2>&1 &
echo "   ✓ Running in menu bar now!"

echo ""
echo "✅ Done! Look for '↓ xx  ↑ xx' in your menu bar."
echo "   It will auto-start on every login."
echo ""
echo "🛑 To stop: click the menu bar icon → 退出"
echo "🗑  To uninstall: launchctl unload ${LAUNCH_DIR}/${PLIST} && rm -rf ${INSTALL_DIR}"
