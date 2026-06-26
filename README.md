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
| `Alt` + `←↑→↓` | 移动焦点 |
| `Alt` + `Enter` | 终端 |
| `Alt` + `BackSpace` | 关闭窗口 |
| `Alt` + `a/d` | 主区域大小 ± |
| `Alt` + `z/c` | 主窗口数 ± |
| `Alt` + `p/o` | 平铺 / 浮动布局 |
| `Alt` + `f` | dmenu |
| `Alt` + `1~9` | 切换工作区 |
| `Alt` + `Shift+1~9` | 移动窗口 |
| `Alt` + `Shift+q` | 退出 |

## st 按键

| 按键 | 功能 |
|------|------|
| `Shift` + `↑/↓` | 滚动回滚 (每次 3 行) |

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
