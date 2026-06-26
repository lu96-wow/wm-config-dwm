#!/bin/bash
# termux-uninstall.sh — 卸载 Termux 中的 dwm + st
set -e
PREFIX="${PREFIX:-${HOME}/../usr}"
BIN="${PREFIX}/bin"

echo "=== 卸载 dwm + st (Termux: ${BIN}) ==="

for f in "$BIN/dwm" "$BIN/st"; do
    [ -f "$f" ] && { echo "  删除 $f"; rm -f "$f"; }
done

echo "卸载完成"
