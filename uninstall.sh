#!/bin/bash
# uninstall.sh — 卸载 dwm + st (桌面 Linux, /usr/local)
set -e
PREFIX="${PREFIX:-/usr/local}"
MANPREFIX="${MANPREFIX:-${PREFIX}/share/man}"

echo "=== 卸载 dwm + st (${PREFIX}) ==="

for f in "${PREFIX}/bin/dwm" "${PREFIX}/bin/st" \
         "${MANPREFIX}/man1/dwm.1" "${MANPREFIX}/man1/st.1"; do
    [ -f "$f" ] && { echo "  删除 $f"; sudo rm -f "$f"; }
done

[ -f /usr/share/xsessions/dwm.desktop ] && { echo "  删除桌面入口"; sudo rm -f /usr/share/xsessions/dwm.desktop; }

echo "卸载完成"
