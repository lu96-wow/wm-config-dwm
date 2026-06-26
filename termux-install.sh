#!/bin/bash
# termux-install.sh — 安装 dwm + st 到 Termux
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-${HOME}/../usr}"
BIN="${PREFIX}/bin"

echo "=== 安装 dwm + st → Termux (${BIN}) ==="

[ -f "$BASE/dwm-build/dwm" ] || { echo "请先运行 ./build.sh"; exit 1; }
[ -f "$BASE/st-build/st" ]   || { echo "请先运行 ./build.sh"; exit 1; }

mkdir -p "$BIN"

cp -f "$BASE/dwm-build/dwm" "$BIN/"
chmod 755 "$BIN/dwm"

cp -f "$BASE/st-build/st" "$BIN/"
chmod 755 "$BIN/st"

echo "安装完成"
echo "启动: startx dwm 或在 .xinitrc 添加 exec dwm"
