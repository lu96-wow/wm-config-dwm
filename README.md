# wm-config-dwm

个人 dwm 6.8 + st 0.9.3 最小可用配置，纯离线一键构建。

## 包含

| 组件 | 版本 | 补丁 |
|------|------|------|
| dwm | 6.8 | pertag with sel (每工作区独立布局 + 记住焦点窗口) |
| st  | 0.9.3 | scrollback ringbuffer (环形缓冲区回滚) |

## 快速开始

```bash
./setup.sh
```

或分步：

```bash
./build.sh              # 编译
sudo ./install.sh       # 安装到 /usr/local
```

Termux：

```bash
./build.sh
./termux-install.sh
```

## dwm 按键

| 按键 | 功能 |
|------|------|
| `Alt` + `Enter` | 打开终端 (st) |
| `Alt` + `BackSpace` | 关闭焦点窗口 |
| `Alt` + `←↑→↓` | 移动焦点 (窗口间切换) |
| `Alt` + `j/k` | 移动焦点 (备用) |
| `Alt` + `a` | 主区域减小 |
| `Alt` + `d` | 主区域加大 |
| `Alt` + `h/l` | 主区域大小微调 (备用) |
| `Alt` + `z` | 主窗口数 -1 |
| `Alt` + `c` | 主窗口数 +1 |
| `Alt` + `i` | 主窗口数 +1 (备用) |
| `Alt` + `m` | 全屏切换 |
| `Alt` + `p` | 平铺布局 (tile) |
| `Alt` + `o` | 浮动布局 (floating) |
| `Alt` + `t` | 平铺布局 (备用) |
| `Alt` + `f` | 启动 dmenu |
| `Alt` + `Space` | 循环切换布局 |
| `Alt` + `Shift+Space` | 切换浮动/平铺 |
| `Alt` + `b` | 显示/隐藏状态栏 |
| `Alt` + `1~9` | 切换工作区 |
| `Alt` + `Shift+1~9` | 移动窗口到工作区 |
| `Alt` + `0` | 显示所有工作区 |
| `Alt` + `Shift+0` | 窗口设为所有工作区 |
| `Alt` + `Tab` | 切换到上一个工作区 |
| `Alt` + `,/.` | 切换显示器 |
| `Alt` + `Shift+,/.` | 移动窗口到其他显示器 |
| `Alt` + `Shift+q` | 退出 dwm |

### 鼠标操作

| 操作 | 功能 |
|------|------|
| `Alt` + 左键拖拽 | 移动浮动窗口 |
| `Alt` + 右键拖拽 | 调整浮动窗口大小 |
| `Alt` + 中键点击 | 切换浮动/平铺 |

## st 按键

| 按键 | 功能 |
|------|------|
| `Shift` + `↑/↓` | 滚动回滚缓冲区 (每次 3 行) |
| `Ctrl` + `Shift+e` | 增大字号 |
| `Ctrl` + `Shift+q` | 减小字号 |
| `Ctrl` + `Shift+PageUp` | 增大字号 (备用) |
| `Ctrl` + `Shift+PageDown` | 减小字号 (备用) |
| `Ctrl` + `Shift+Home` | 重置字号 |
| `Ctrl` + `Shift+c` | 复制 |
| `Ctrl` + `Shift+v` | 粘贴 |
| `Ctrl` + `Shift+y` | 粘贴选中内容 |

## 文件说明

```
├── dwm-6.8.tar.gz         # dwm 原始源码
├── st-0.9.3.tar.gz        # st  原始源码
├── *.diff                 # suckless 官方补丁
├── my-*.patch             # 个人配置补丁
├── build.sh               # 编译脚本
├── install.sh             # 安装 (桌面 Linux)
├── uninstall.sh           # 卸载
├── setup.sh               # 一键构建安装
├── termux-install.sh      # Termux 安装
├── termux-uninstall.sh    # Termux 卸载
├── test-dwm.sh            # Xephyr 测试
├── LICENSE                # MIT
└── README.md
```

## 许可

- dwm, st 及官方补丁：MIT/X Consortium
- 本项目配置及脚本：MIT
