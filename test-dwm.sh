#!/bin/sh
# dwm 测试脚本 — 在嵌套 X server (Xephyr) 中运行 dwm
# 用法: ./test-dwm.sh

BUILD_DWM="$(dirname "$0")/dwm-build/dwm"
DWM_BIN="$(which dwm 2>/dev/null || echo /usr/local/bin/dwm)"
[ -x "$BUILD_DWM" ] && DWM_BIN="$BUILD_DWM"
XEPHYR_DISPLAY=":1"
XEPHYR_GEOM="800x600"

echo "=== dwm 测试脚本 ==="

# 1. 清理残留
echo "[1/3] 清理残留 Xephyr..."
killall Xephyr 2>/dev/null
sleep 0.5

# 2. 启动嵌套 X server
echo "[2/3] 启动 Xephyr ${XEPHYR_DISPLAY} (${XEPHYR_GEOM})..."
Xephyr ${XEPHYR_DISPLAY} -screen ${XEPHYR_GEOM} -ac -reset &
XEPHYR_PID=$!
sleep 1

# 检查 Xephyr 是否启动成功
if ! kill -0 $XEPHYR_PID 2>/dev/null; then
    echo "错误: Xephyr 启动失败！"
    exit 1
fi

# 3. 在 Xephyr 中运行 dwm
echo "[3/3] 在 Xephyr 中启动 dwm..."
echo "  按键提示:"
echo "    Alt+数字    → 切换工作区"
echo "    Alt+方向键  → 切换焦点窗口"
echo "    Alt+Enter   → 打开终端 (st)"
echo "    Alt+BackSpace → 关闭窗口"
echo "    Alt+Shift+数字 → 移动窗口到工作区"
echo "    Alt+Shift+q → 退出 dwm"
echo ""

export DISPLAY=${XEPHYR_DISPLAY}
exec ${DWM_BIN}
