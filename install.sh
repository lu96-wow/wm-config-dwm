#!/bin/bash
# install.sh — 安装 dwm + st 到 /usr/local (桌面 Linux)
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-/usr/local}"
MANPREFIX="${MANPREFIX:-${PREFIX}/share/man}"

echo "=== 安装 dwm + st → ${PREFIX} ==="

[ -f "$BASE/dwm-build/dwm" ] || { echo "请先运行 ./build.sh"; exit 1; }
[ -f "$BASE/st-build/st" ]   || { echo "请先运行 ./build.sh"; exit 1; }

echo "安装 dwm ..."
sudo mkdir -p "${PREFIX}/bin"
sudo cp -f "$BASE/dwm-build/dwm" "${PREFIX}/bin/"
sudo chmod 755 "${PREFIX}/bin/dwm"
sudo mkdir -p "${MANPREFIX}/man1"
sudo sed "s/VERSION/6.8/g" "$BASE/dwm-build/dwm.1" > /tmp/dwm.1
sudo cp -f /tmp/dwm.1 "${MANPREFIX}/man1/dwm.1"
sudo chmod 644 "${MANPREFIX}/man1/dwm.1"
rm -f /tmp/dwm.1

echo "安装 st ..."
sudo cp -f "$BASE/st-build/st" "${PREFIX}/bin/"
sudo chmod 755 "${PREFIX}/bin/st"
sudo sed "s/VERSION/0.9.3/g" "$BASE/st-build/st.1" > /tmp/st.1
sudo cp -f /tmp/st.1 "${MANPREFIX}/man1/st.1"
sudo chmod 644 "${MANPREFIX}/man1/st.1"
rm -f /tmp/st.1

# 桌面入口
if [ ! -f /usr/share/xsessions/dwm.desktop ]; then
    echo "创建 dwm 桌面入口 ..."
    sudo tee /usr/share/xsessions/dwm.desktop > /dev/null << 'XEOF'
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic window manager
Exec=dwm
Type=XSession
XEOF
fi

echo "安装完成"
