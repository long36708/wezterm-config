# 我的WezTerm配置

## 📖 项目简介

这是一个**高度模块化**的 WezTerm
终端配置项目,基于 [QianSong1/wezterm-config](https://github.com/QianSong1/wezterm-config) 修改优化而来。

### ✨ 核心特性

- 🎨 **美观的 UI**: Gruvbox 主题 + Catppuccin 配色方案
- ⌨️ **丰富的快捷键**: 支持窗格管理、标签切换、字体调整等
- 🔧 **模块化设计**: 清晰的配置分离,易于维护和扩展
- 💻 **跨平台支持**: 自动适配 Windows/macOS/Linux
- 🎯 **自定义标签栏**: 显示进程名、管理员标识、未读提醒
- 🚀 **WebGPU 渲染**: 高性能图形加速

![screenshot](./screenshots/screenshot-1.png)

## 📂 项目结构

```
wezterm/
├── wezterm.lua              # 主入口文件 - 组装所有配置模块
├── config/                  # 核心配置目录
│   ├── init.lua            # Config 类 - 模块化配置管理器
│   ├── appearance.lua      # 外观配置(主题、窗口、标签栏)
│   ├── bindings.lua        # 键盘/鼠标绑定
│   ├── domains.lua         # 域配置(WSL、SSH等)
│   ├── fonts.lua           # 字体配置
│   ├── general.lua         # 通用行为配置
│   └── launch.lua          # 启动配置
├── events/                  # 事件处理目录
│   ├── tab-title.lua       # 自定义标签标题格式化
│   ├── right-status.lua    # 右侧状态栏
│   └── new-tab-button.lua  # 新建标签按钮
├── colors/                  # 颜色主题
│   └── custom.lua          # 自定义 Catppuccin Mocha 配色
├── utils/                   # 工具函数
│   ├── math.lua            # 数学工具
│   └── platform.lua        # 平台检测(Win/Mac/Linux)
└── backdrops/              # 背景图片
```

## 相关链接

- <https://github.com/rxi/lume>
- <https://github.com/catppuccin/wezterm>
- <https://github.com/wez/wezterm/discussions/628#discussioncomment-1874614>
- <https://github.com/wez/wezterm/discussions/628#discussioncomment-5942139>

## 🛠️ 技术栈

- **配置语言**: Lua (WezTerm 原生配置语言)
- **字体**: JetBrains Mono
- **主题**: Gruvbox dark, medium (base16)
- **配色**: Catppuccin Mocha (定制版)
- **图标**: Nerd Fonts (Unicode 特殊字符)
- **渲染后端**: WebGPU / OpenGL

## 📦 安装方法

### 前提条件

1. 安装 [WezTerm 终端](https://github.com/wez/wezterm/releases)
2. 安装 [Nerd Fonts](https://www.nerdfonts.com/) (推荐 JetBrains Mono Nerd Font)

### 安装步骤

#### Windows

```powershell
# 1. 克隆或下载本仓库
# 2. 将配置文件复制到以下目录
$HOME\.config\wezterm
# 例如: C:\Users\YourName\.config\wezterm
```

#### macOS / Linux

```bash
# 1. 克隆仓库
git clone https://github.com/your-username/wezterm-config.git ~/.config/wezterm

# 2. WezTerm 会自动加载配置
```

### 配置说明

- 配置文件修改后**自动热重载**,无需重启 WezTerm
- **主要配置入口**: [`config/user_preferences.lua`](config/user_preferences.lua)
- 可在其中快速切换主题、字体、快捷键风格等

#### 🎨 快速定制

编辑 [`config/user_preferences.lua`](config/user_preferences.lua):

```lua
return {
   theme = "gruvbox",          -- 或 "catppuccin"
   font_family = "jetbrains",  -- 或 "caskaydia", "fira_code"
   window_startup = "default", -- 或 "centered", "maximized"
   wsl_distros = {             -- 自定义 WSL 发行版
      { label = "Ubuntu", name = "Ubuntu" },
      { label = "Kali", name = "kali-linux" },
   },
}
```

详细说明请查看 [CONFIG_GUIDE.md](CONFIG_GUIDE.md)

## ⌨️ 快捷键指南

### 基础操作

| 快捷键            | 功能    |
|----------------|-------|
| `Ctrl+C`       | 复制    |
| `Ctrl+V`       | 粘贴    |
| `Shift+Insert` | 粘贴    |
| `F11`          | 全屏切换  |
| `Ctrl+Shift+R` | 重命名标签 |

### 标签页管理

| 快捷键                         | 功能                 |
|-----------------------------|--------------------|
| `Alt+T`                     | 新建标签页 (WSL:Ubuntu) |
| `Alt+Ctrl+W`                | 关闭当前标签页            |
| `Alt+[` 或 `Alt+h` 或 `Alt+←` | 切换到上一个标签           |
| `Alt+]` 或 `Alt+l` 或 `Alt+→` | 切换到下一个标签           |
| `Alt+Ctrl+[`                | 向左移动标签             |
| `Alt+Ctrl+]`                | 向右移动标签             |

### 窗格管理

| 快捷键          | 功能          |
|--------------|-------------|
| `Alt+\`      | 水平拆分窗格 (左右) |
| `Alt+/`      | 垂直拆分窗格 (上下) |
| `Alt+-`      | 关闭当前窗格      |
| `Alt+Z`      | 最大化/还原当前窗格  |
| `Alt+Ctrl+k` | 激活上方窗格      |
| `Alt+Ctrl+j` | 激活下方窗格      |
| `Alt+Ctrl+h` | 激活左侧窗格      |
| `Alt+Ctrl+l` | 激活右侧窗格      |
| `Alt+Ctrl+↑` | 向上扩展窗格      |
| `Alt+Ctrl+↓` | 向下扩展窗格      |
| `Alt+Ctrl+←` | 向左扩展窗格      |
| `Alt+Ctrl+→` | 向右扩展窗格      |

### 字体调整

| 快捷键     | 功能     |
|---------|--------|
| `Alt+↑` | 放大字体   |
| `Alt+↓` | 缩小字体   |
| `Alt+R` | 重置字体大小 |

### Leader 键模式

**激活方式**: `Ctrl+Shift+Space`

激活后可使用组合键:

| 按键                | 功能                   |
|-------------------|----------------------|
| `f` → `k/j/r/q`   | 字体调整模式 (放大/缩小/重置/退出) |
| `p` → `h/j/k/l/q` | 窗格调整模式 (左/下/上/右/退出)  |

### 其他功能键

| 按键      | 功能     |
|---------|--------|
| `F1`    | 进入复制模式 |
| `F2`    | 命令面板   |
| `F3`    | 启动器    |
| `F4`    | 标签导航器  |
| `F12`   | 调试控制台  |
| `Alt+F` | 搜索文本   |
| `Alt+N` | 新建窗口   |

### 鼠标操作

| 操作          | 功能   |
|-------------|------|
| `Ctrl+点击链接` | 打开链接 |
| `双击左键`      | 选择单词 |
| `三击左键`      | 选择整行 |
| `Alt+拖动`    | 窗口拖动 |
| `滚轮`        | 滚动屏幕 |
