#!/bin/bash
# build.sh — 解压、打补丁、编译 dwm + st (不安装)
# build 目录已存在 → 只编译；不存在 → 解压 + 打补丁 + 编译
set -e
BASE="$(cd "$(dirname "$0")" && pwd)"
DWM_VER=6.8; ST_VER=0.9.3
DWM_TGZ="dwm-${DWM_VER}.tar.gz"
ST_TGZ="st-${ST_VER}.tar.gz"
PERTAG="dwm-pertag_with_sel-20231003-9f88553.diff"
SCROLL="st-scrollback-ringbuffer-0.9.2.diff"

echo "============================================"
echo " dwm ${DWM_VER} + st ${ST_VER} 编译"
echo "============================================"

cd "$BASE"

# ==================== dwm ====================
if [ -d "$BASE/dwm-build" ]; then
    echo ""
    echo "[dwm] dwm-build 已存在 → 只编译，不覆盖"
else
    echo ""
    echo "[dwm] 检查文件 ..."
    for f in "$DWM_TGZ" "$PERTAG" "my-dwm-config.patch"; do
        [ -f "$BASE/$f" ] || { echo "  缺失: $f"; exit 1; }
    done
    echo "  就绪"

    echo "[dwm] 解压 ..."
    tar xzf "$DWM_TGZ" && mv "dwm-${DWM_VER}" dwm-build

    echo "[dwm] pertag 补丁 ..."
    cd "$BASE/dwm-build"
    cp "$BASE/$PERTAG" pertag-sel.diff
    patch -p1 < pertag-sel.diff

    echo "[dwm] 配置补丁 ..."
    patch -p0 < "$BASE/my-dwm-config.patch"
fi

# ==================== st ====================
if [ -d "$BASE/st-build" ]; then
    echo ""
    echo "[st] st-build 已存在 → 只编译，不覆盖"
else
    echo ""
    echo "[st] 检查文件 ..."
    for f in "$ST_TGZ" "$SCROLL" "my-st-config.patch"; do
        [ -f "$BASE/$f" ] || { echo "  缺失: $f"; exit 1; }
    done
    echo "  就绪"

    echo "[st] 解压 ..."
    cd "$BASE"
    tar xzf "$ST_TGZ" && mv "st-${ST_VER}" st-build

    echo "[st] scrollback 补丁 ..."
    cd "$BASE/st-build"
    cp "$BASE/$SCROLL" scrollback-ringbuffer.diff
    patch -p1 < scrollback-ringbuffer.diff

    echo "[st] 配置补丁 ..."
    patch -p0 < "$BASE/my-st-config.patch"
fi

# ==================== 编译 ====================
echo ""
echo "============================================"
echo " 编译 ..."
echo "============================================"
cd "$BASE/dwm-build" && make clean && make
cd "$BASE/st-build"   && make clean && make

echo ""
echo "============================================"
echo " 编译完成"
echo " dwm: $BASE/dwm-build/dwm"
echo " st:  $BASE/st-build/st"
echo " 下一步: ./install.sh"
echo "============================================"
