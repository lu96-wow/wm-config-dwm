#!/bin/bash
# termux-build.sh — Termux 环境手动编译 dwm + st
# Termux 路径与桌面 Linux 不同，需覆盖 config.mk 中的 X11 路径
# build 目录已存在 → 只编译；不存在 → 解压 + 打补丁 + 编译
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
PREFIX="${PREFIX:-${HOME}/../usr}"
DWM_VER=6.8; ST_VER=0.9.3

echo "=== Termux 编译 dwm ${DWM_VER} + st ${ST_VER} ==="

echo ""
echo "检查依赖 ..."
for pkg in xorgproto libx11 libxft libxinerama fontconfig freetype pkg-config gcc make patch; do
    pkg list-installed "$pkg" > /dev/null 2>&1 || echo "  警告: 建议 pkg install $pkg"
done

# ==================== dwm ====================
if [ -d "$BASE/dwm-build" ]; then
    echo ""
    echo "[dwm] dwm-build 已存在 → 只编译，不覆盖"
else
    echo ""
    echo "[dwm] 解压 ..."
    cd "$BASE"
    tar xzf "dwm-${DWM_VER}.tar.gz" && mv "dwm-${DWM_VER}" dwm-build

    echo "[dwm] 补丁 ..."
    cd "$BASE/dwm-build"
    cp "$BASE/dwm-pertag_with_sel-20231003-9f88553.diff" pertag-sel.diff
    patch -p1 < pertag-sel.diff
    patch -p0 < "$BASE/my-dwm-config.patch"
fi

# ==================== st ====================
if [ -d "$BASE/st-build" ]; then
    echo ""
    echo "[st] st-build 已存在 → 只编译，不覆盖"
else
    echo ""
    echo "[st] 解压 ..."
    cd "$BASE"
    tar xzf "st-${ST_VER}.tar.gz" && mv "st-${ST_VER}" st-build

    echo "[st] 补丁 ..."
    cd "$BASE/st-build"
    cp "$BASE/st-scrollback-ringbuffer-0.9.2.diff" scrollback-ringbuffer.diff
    patch -p1 < scrollback-ringbuffer.diff
    patch -p0 < "$BASE/my-st-config.patch"
fi

# ==================== 适配 Termux 路径 ====================
echo ""
echo "适配 Termux 路径 ..."
cd "$BASE/dwm-build"
sed -i "s|^X11INC = .*|X11INC = ${PREFIX}/include|" config.mk
sed -i "s|^X11LIB = .*|X11LIB = ${PREFIX}/lib|"   config.mk
sed -i "s|^CC = .*|CC = gcc|"                      config.mk

cd "$BASE/st-build"
sed -i "s|^X11INC = .*|X11INC = ${PREFIX}/include|" config.mk
sed -i "s|^X11LIB = .*|X11LIB = ${PREFIX}/lib|"   config.mk
sed -i "s|^# CC = .*|CC = gcc|"                     config.mk

# ==================== 编译 dwm ====================
echo ""
echo "============================================"
echo " 编译 dwm ..."
echo "============================================"
cd "$BASE/dwm-build"
cp config.def.h config.h
gcc -std=c99 -pedantic -Wall -Os \
    -I${PREFIX}/include \
    -I${PREFIX}/include/freetype2 \
    -D_DEFAULT_SOURCE -D_BSD_SOURCE -D_XOPEN_SOURCE=700L \
    -DVERSION=\"${DWM_VER}\" -DXINERAMA \
    -c drw.c -c dwm.c -c util.c
gcc -o dwm drw.o dwm.o util.o \
    -L${PREFIX}/lib -lX11 -lXinerama -lfontconfig -lXft
echo "  dwm: $(file dwm | cut -d, -f1)"

# ==================== 编译 st ====================
echo ""
echo "编译 st ..."
cd "$BASE/st-build"
cp config.def.h config.h
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
