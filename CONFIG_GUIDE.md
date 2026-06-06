# ⚙️ WezTerm 配置定制指南

本文档详细介绍如何自定义 WezTerm 配置。

---

## 📋 目录

- [快速开始](#快速开始)
- [配置偏好系统](#配置偏好系统)
- [主题定制](#主题定制)
- [字体配置](#字体配置)
- [窗口启动模式](#窗口启动模式)
- [WSL 配置](#wsl-配置)
- [快捷键定制](#快捷键定制)
- [高级配置](#高级配置)

---

## 🚀 快速开始

所有用户级配置集中在 [`config/user_preferences.lua`](config/user_preferences.lua) 文件中。

### 第一步: 打开配置文件

```bash
# Windows
notepad %USERPROFILE%\.config\wezterm\config\user_preferences.lua

# macOS/Linux
nano ~/.config/wezterm/config/user_preferences.lua
```

### 第二步: 修改配置项

修改后保存,WezTerm 会**自动热重载**,无需重启!

---

## 🎨 配置偏好系统

### 核心配置文件结构

```lua
return {
   theme = "gruvbox",           -- 主题选择
   font_family = "jetbrains",   -- 字体选择
   font_size = 11,              -- 字体大小
   keybinding_style = "vim_like", -- 快捷键风格
   window_startup = "default",  -- 窗口启动模式
   wsl_distros = {...},         -- WSL 发行版配置
   use_fancy_tab_bar = true,    -- Fancy 标签栏
   window_opacity = 0.95,       -- 窗口透明度
}
```

---

## 🌈 主题定制

### 可用主题

| 主题名 | 说明 | 特点 |
|--------|------|------|
| `gruvbox` | Gruvbox Dark Medium (默认) | 暖色调,护眼,复古风格 |
| `catppuccin` | Catppuccin Mocha | 冷色调,现代感,柔和 |
| `dracula` | Dracula Official | 紫色系,高对比度,流行 |
| `one_dark` | Atom One Dark | VSCode风格,专业,舒适 |

### 切换主题

编辑 `config/user_preferences.lua`:

```lua
return {
   theme = "catppuccin",  -- 改为 "gruvbox" | "catppuccin" | "dracula" | "one_dark"
}
```

### 添加新主题

1. 在 [`config/themes.lua`](config/themes.lua) 中添加新主题:

```lua
return {
   gruvbox = {...},
   catppuccin = {...},
   
   -- 添加你的主题
   my_theme = {
      color_scheme = "Your Color Scheme Name",
      colors = {
         foreground = "#ffffff",
         background = "#000000",
         -- ... 更多颜色配置
      },
      tab_bar_colors = {...},
   },
}
```

2. 在 `user_preferences.lua` 中使用:

```lua
return {
   theme = "my_theme",
}
```

---

## 🔤 字体配置

### 可用字体

| 字体名 | 说明 | 需要安装 |
|--------|------|----------|
| `jetbrains` | JetBrains Mono (默认) | ✅ |
| `caskaydia` | CaskaydiaCove Nerd Font | ✅ |
| `fira_code` | Fira Code | ✅ |

### 切换字体

```
return {
   font_family = "caskaydia",  -- 改为 "jetbrains", "caskaydia", 或 "fira_code"
   font_size = 12,              -- 调整字体大小
}
```

### 添加新字体

1. 安装字体到系统
2. 在 [`config/fonts.lua`](config/fonts.lua) 中添加:

```lua
local font_map = {
   jetbrains = 'JetBrains Mono',
   caskaydia = 'CaskaydiaCove Nerd Font',
   fira_code = 'Fira Code',
   my_font = 'Your Font Name',  -- 添加新字体
}
```

3. 在 `user_preferences.lua` 中使用:

```lua
return {
   font_family = "my_font",
}
```

---

## 🪟 窗口启动模式

### 可用模式

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| `default` | 默认位置 (默认) | 日常使用 |
| `centered` | 屏幕居中 | 专注工作 |
| `maximized` | 最大化启动 | 全屏终端 |
| `fullscreen` | 全屏模式 | 演示/展示 |

### 配置示例

#### 居中启动

```
return {
   window_startup = "centered",
   centered_window = {
      width_ratio = 0.6,   -- 宽度占屏幕 60%
      height_ratio = 0.7,  -- 高度占屏幕 70%
   },
}
```

#### 最大化启动

```
return {
   window_startup = "maximized",
}
```

---

## 🐧 WSL 配置

### 配置多个 WSL 发行版

```
return {
   wsl_distros = {
      { label = "Ubuntu", name = "Ubuntu" },
      { label = "Ubuntu 20.04", name = "Ubuntu-20.04" },
      { label = "Kali Linux", name = "kali-linux" },
      { label = "Debian", name = "Debian" },
   },
}
```

### 查看已安装的 WSL 发行版

```bash
wsl --list --verbose
```

### 使用方式

配置后,可通过以下方式启动:

1. **启动菜单**: 点击标签栏的 "+" 按钮,选择对应的 WSL
2. **快捷键**: 后续可绑定快捷键快速启动 (见高级配置)

---

## ⌨️ 快捷键定制

### 当前快捷键体系

项目支持两套快捷键:

#### 1. Vim-like 风格 (默认)

```
ALT + h/j/k/l  → 窗格导航
ALT + 方向键   → 调整窗格大小
Ctrl+Shift+Space → Leader 键
```

#### 2. Traditional 风格

```
Ctrl + 1-8     → 切换标签页 (来自 Blog 文档)
方向键         → 窗格导航
```

**两种风格已同时启用**,可根据习惯使用!

### 自定义快捷键

编辑 [`config/bindings.lua`](config/bindings.lua):

```lua
local keys = {
   -- 添加你的快捷键
   { 
      key = 't', 
      mods = 'CTRL|SHIFT', 
      action = act.SpawnTab('DefaultDomain') 
   },
   
   -- 更多快捷键...
}
```

参考 [WezTerm 官方文档](https://wezterm.org/config/lua/keyassignment/index.html) 了解更多动作。

---

## 🎯 高级配置

### 外观定制

#### 窗口透明度

```
return {
   window_opacity = 0.9,  -- 0.0 (完全透明) - 1.0 (不透明)
}
```

#### Fancy 标签栏

```
return {
   use_fancy_tab_bar = false,  -- 使用原生标签栏
}
```

#### 滚动条

```
return {
   show_scrollbar = false,  -- 隐藏滚动条
}
```

### 背景图片

1. 将图片放入 `backdrops/` 目录
2. 编辑 [`config/appearance.lua`](config/appearance.lua),取消注释背景配置:

```
background = {
   {
      source = { File = wezterm.config_dir .. '/backdrops/your-image.jpg' },
   },
   {
      source = { Color = '#000000' },
      opacity = 0.85,
   },
},
```

### 添加快速启动快捷键

在 [`config/bindings.lua`](config/bindings.lua) 中添加:

```
local keys = {
   -- Ctrl+Shift+U → 启动 Ubuntu
   {
      key = 'U',
      mods = 'CTRL|SHIFT',
      action = act.SpawnCommandInNewTab({
         args = {'wsl', '-d', 'Ubuntu'},
      }),
   },
   
   -- Ctrl+Shift+K → 启动 Kali
   {
      key = 'K',
      mods = 'CTRL|SHIFT',
      action = act.SpawnCommandInNewTab({
         args = {'wsl', '-d', 'kali-linux'},
      }),
   },
}
```

---

## 🔧 故障排查

### 配置出错怎么办?

1. **检查语法错误**: Lua 文件必须有正确的语法
2. **查看日志**: WezTerm 会在控制台输出错误信息
3. **回滚配置**: 使用 Git 恢复到之前的版本

### 恢复默认配置

```
git checkout HEAD -- config/user_preferences.lua
```

### 测试配置

修改配置后,观察 WezTerm 是否有错误提示。如无错误,配置会自动生效。

---

## 📚 相关资源

- [WezTerm 官方文档](https://wezterm.org/)
- [WezTerm 配置参考](https://wezterm.org/config/reference.html)
- [Catppuccin 主题](https://github.com/catppuccin/wezterm)
- [Gruvbox 主题](https://github.com/morhetz/gruvbox)
- [Nerd Fonts](https://www.nerdfonts.com/)

---

## 💡 最佳实践

1. **小步迭代**: 每次只修改一个配置项,测试通过后再改下一个
2. **版本控制**: 使用 Git 管理配置,便于回滚
3. **备份配置**: 定期备份 `user_preferences.lua`
4. **阅读文档**: 修改前查阅相关文档
5. **社区交流**: 遇到问题可在 GitHub Issues 中提问

---

## 🎉 结语

通过本配置系统,你可以轻松定制属于自己的终端环境!

如有问题或建议,欢迎提交 Issue 或 PR。

Happy Terminal! 🚀
