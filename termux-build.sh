#!/bin/bash
# termux-build.sh — Termux 环境手动编译 dwm + st
# Termux 路径与桌面 Linux 不同，需覆盖 config.mk 中的 X11 路径
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-${HOME}/../usr}"
DWM_VER=6.8; ST_VER=0.9.3

echo "=== Termux 编译 dwm ${DWM_VER} + st ${ST_VER} ==="

# ---- 检查 ----
echo ""
echo "[0/6] 检查依赖 ..."
for pkg in xorgproto libx11 libxft libxinerama fontconfig freetype pkg-config gcc make patch; do
    pkg list-installed "$pkg" > /dev/null 2>&1 || echo "  警告: 建议 pkg install $pkg"
done

# ---- 解压 + 补丁 (复用 build.sh 前 5 步) ----
echo ""
echo "[1/5] 准备源码 ..."
cd "$BASE"
rm -rf dwm-build st-build
tar xzf "dwm-${DWM_VER}.tar.gz" && mv "dwm-${DWM_VER}" dwm-build
tar xzf "st-${ST_VER}.tar.gz"     && mv "st-${ST_VER}" st-build

echo "[2/5] 应用补丁 ..."
cd "$BASE/dwm-build"
cp "$BASE/dwm-pertag_with_sel-20231003-9f88553.diff" pertag-sel.diff
patch -p1 < pertag-sel.diff
patch -p0 < "$BASE/my-dwm-config.patch"

cd "$BASE/st-build"
cp "$BASE/st-scrollback-ringbuffer-0.9.2.diff" scrollback-ringbuffer.diff
patch -p1 < scrollback-ringbuffer.diff
patch -p0 < "$BASE/my-st-config.patch"

# ---- 覆盖 config.mk 为 Termux 路径 ----
echo "[3/5] 适配 Termux 路径 ..."

cd "$BASE/dwm-build"
sed -i "s|^X11INC = .*|X11INC = ${PREFIX}/include|" config.mk
sed -i "s|^X11LIB = .*|X11LIB = ${PREFIX}/lib|"   config.mk
sed -i "s|^CC = .*|CC = gcc|"                      config.mk

cd "$BASE/st-build"
sed -i "s|^X11INC = .*|X11INC = ${PREFIX}/include|" config.mk
sed -i "s|^X11LIB = .*|X11LIB = ${PREFIX}/lib|"   config.mk
sed -i "s|^# CC = .*|CC = gcc|"                     config.mk

# ---- 手动编译 dwm ----
echo "[4/5] 编译 dwm ..."
cd "$BASE/dwm-build"
gcc -std=c99 -pedantic -Wall -Os \
    -I${PREFIX}/include \
    -I${PREFIX}/include/freetype2 \
    -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=700L \
    -DVERSION=\"${DWM_VER}\" -DXINERAMA \
    -c drw.c -c dwm.c -c util.c
gcc -o dwm drw.o dwm.o util.o \
    -L${PREFIX}/lib -lX11 -lXinerama -lfontconfig -lXft
echo "  dwm: $(file dwm | cut -d, -f1)"

# ---- 手动编译 st ----
echo "[5/5] 编译 st ..."
cd "$BASE/st-build"
gcc -O1 \
    -I${PREFIX}/include \
    $(pkg-config --cflags fontconfig freetype2 2>/dev/null) \
    -DVERSION=\"${ST_VER}\" -D_XOPEN_SOURCE=600 \
    -c st.c -c x.c
gcc -o st st.o x.o \
    -L${PREFIX}/lib -lm -lrt -lX11 -lutil -lXft \
    $(pkg-config --libs fontconfig freetype2 2>/dev/null)
echo "  st:  $(file st | cut -d, -f1)"

echo ""
echo "============================================"
echo " Termux 编译完成"
echo " dwm: $BASE/dwm-build/dwm"
echo " st:  $BASE/st-build/st"
echo " 安装: ./termux-install.sh"
echo "============================================"
