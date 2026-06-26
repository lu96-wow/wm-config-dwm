#!/bin/bash
# setup.sh — 一键构建并安装 (调用 build.sh && install.sh)
BASE="$(cd "$(dirname "$0")" && pwd)"
"$BASE/build.sh" && sudo "$BASE/install.sh"
