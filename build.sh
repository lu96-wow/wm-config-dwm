#!/bin/bash
# build.sh — 解压、打补丁、编译 dwm + st (不安装)
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

echo ""
echo "[0/6] 检查本地文件 ..."
MISSING=""
for f in "$DWM_TGZ" "$ST_TGZ" "$PERTAG" "$SCROLL" \
         "my-dwm-config.patch" "my-st-config.patch"; do
    [ -f "$BASE/$f" ] || { echo "  缺失: $f"; MISSING=1; }
done
[ -n "$MISSING" ] && { echo "请将上述文件放到 $BASE"; exit 1; }
echo "  全部就绪"

echo ""
echo "[1/6] 解压 dwm ..."
cd "$BASE"
rm -rf dwm-build st-build
tar xzf "$DWM_TGZ" && mv "dwm-${DWM_VER}" dwm-build

echo "[2/6] 解压 st ..."
tar xzf "$ST_TGZ" && mv "st-${ST_VER}" st-build

echo "[3/6] dwm: pertag with sel ..."
cd "$BASE/dwm-build"
cp "$BASE/$PERTAG" pertag-sel.diff
patch -p1 < pertag-sel.diff

echo "[4/6] st: scrollback ringbuffer ..."
cd "$BASE/st-build"
cp "$BASE/$SCROLL" scrollback-ringbuffer.diff
patch -p1 < scrollback-ringbuffer.diff

echo "[5/6] 应用配置补丁 ..."
cd "$BASE/dwm-build" && patch -p0 < "$BASE/my-dwm-config.patch"
cd "$BASE/st-build" && patch -p0 < "$BASE/my-st-config.patch"

echo "[6/6] 编译 ..."
cd "$BASE/dwm-build" && make clean && make
cd "$BASE/st-build" && make clean && make

echo ""
echo "============================================"
echo " 编译完成"
echo " dwm: $BASE/dwm-build/dwm"
echo " st:  $BASE/st-build/st"
echo " 下一步: ./install.sh"
echo "============================================"
