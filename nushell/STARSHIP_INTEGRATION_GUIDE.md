# Starship 集成指南 for Nushell

## 📋 概述

Starship 是一个快速、可定制且跨 shell 的提示符工具。本文档介绍如何在 Nushell 中集成 Starship。

---

## 🔧 安装步骤

### 1. 安装 Starship

#### Windows 安装方法

**方法 1: 使用 Scoop（推荐）**

```powershell
scoop install starship
```

**方法 2: 使用 Winget**

```powershell
winget install starship
```

**方法 3: 手动安装**

1. 从 [GitHub Releases](https://github.com/starship/starship/releases) 下载最新版本
2. 解压到合适目录（如 `C:\Program Files\starship\`）
3. 将目录添加到 PATH 环境变量

#### 验证安装

```nushell
starship --version
```

---

## ⚙️ 配置 Nushell（推荐方法）

### 方法 1: 自动初始化（推荐）⭐

**要求**: Nushell v0.96+

在 Nushell 中运行以下命令：

```nushell
# 创建 vendor/autoload 目录并初始化 Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
```

Pastel Powerline Preset

```shell
starship preset pastel-powerline -o ~/.config/starship.toml
```

**优点**:

- ✅ 自动化配置，无需手动编辑 config.nu
- ✅ Starship 会自动加载
- ✅ 符合 Nushell 最佳实践
- ✅ 易于维护和更新

**验证**:

```nushell
# 检查文件是否创建成功
ls ($nu.data-dir | path join "vendor/autoload/starship.nu")

# 重启 Nushell 后应该能看到 Starship prompt
```

---

### 方法 2: 手动配置（旧方法）

> **注意**: 仅在你使用 Nushell < v0.96 或需要自定义配置时使用此方法。

在 `C:\Users\Administrator\AppData\Roaming\nushell\config.nu` 中找到 PROMPT 配置部分，替换为：

```nushell
# ========================================= Starship Prompt =========================================
# 启用 Starship 提示符
$env.PROMPT_COMMAND = {|| (starship prompt)
$env.PROMPT_COMMAND_RIGHT = {|| (starship prompt --right)}
```

**完整示例**:

```nushell
# config.nu

# ... 其他配置 ...

# ========================================= Starship Prompt =========================================
# 启用 Starship 提示符
$env.PROMPT_COMMAND = {|| (starship prompt)
$env.PROMPT_COMMAND_RIGHT = {|| (starship prompt --right)}

# 不显示启动信息
$env.config.show_banner = false

# 避免输入回车出现位移情况
$env.config.shell_integration.osc133 = false

# ... 其他配置 ...
```

---

## 🎨 Starship 配置

### 创建配置文件

Starship 配置文件位置：

- **Windows**: `~/.config/starship.toml` 或 `%USERPROFILE%\.config\starship.toml`

创建配置文件：

```powershell
# 创建配置目录
mkdir $env:USERPROFILE\.config

# 创建配置文件
notepad $env:USERPROFILE\.config\starship.toml
```

### 基础配置示例

```toml
# ~/.config/starship.toml

# 插入空白行
add_newline = true

# 命令超时时间（毫秒）
command_timeout = 500

# 持续显示符号
continuation_prompt = "▶▶ "

# 自定义格式
format = """
$directory\
$git_branch\
$git_status\
$character"""

# 禁用某些模块
[directory]
truncation_length = 3
truncate_to_repo = false

[git_branch]
format = "[$symbol$branch]($style) "
symbol = "🌱 "
style = "bold purple"

[git_status]
format = '([$all_status$ahead_behind]($style) )'
style = "bold red"

[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
```

### 高级配置示例

```toml
# ~/.config/starship.toml

# 整体格式
format = """
$username\
$hostname\
$localip\
$shlvl\
$singularity\
$kubernetes\
$directory\
$vcsh\
$git_branch\
$git_commit\
$git_state\
$git_metrics\
$git_status\
$hg_branch\
$docker_context\
$package\
$c\
$cmake\
$cobol\
$container\
$dart\
$deno\
$dotnet\
$elixir\
$elm\
$erlang\
$fennel\
$golang\
$guix_shell\
$haskell\
$haxe\
$helm\
$java\
$julia\
$kotlin\
$gradle\
$lua\
$nim\
$nodejs\
$ocaml\
$opa\
$perl\
$php\
$pulumi\
$purescript\
$python\
$raku\
$rlang\
$red\
$ruby\
$rust\
$scala\
$solidity\
$swift\
$terraform\
$vlang\
$vagrant\
$zig\
$buf\
$nix_shell\
$conda\
$meson\
$spack\
$memory_usage\
$aws\
$gcloud\
$openstack\
$azure\
$direnv\
$env_var\
$crystal\
$custom\
$sudo\
$cmd_duration\
$line_break\
$jobs\
$battery\
$time\
$status\
$os\
$container\
$shell\
$character"""

# Git 配置
[git_branch]
format = "[$symbol$branch(:$remote_branch)]($style) "
symbol = " "
style = "bold purple"

[git_status]
format = '([\( $all_status$ahead_behind \)]($style) )'
style = "bold red"
conflicted = "="
ahead = "⇡${count}"
behind = "⇣${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
untracked = "?${count}"
stashed = "$"
modified = "!${count}"
staged = "+${count}"
renamed = "»${count}"
deleted = "✘${count}"

# Node.js 配置
[nodejs]
format = "via [🤖 $version](bold green) "
detect_files = ["package.json", ".node-version"]
detect_folders = ["node_modules"]

# Python 配置
[python]
format = "via [🐍 $version](bold yellow) "
style = "bold yellow"
symbol = "🐍 "
pyenv_version_name = true
pyenv_prefix = ""
python_binary = ["python", "python3", "python2"]
detect_extensions = ["py"]
detect_files = [".python-version", "Pipfile", "__init__.py", "pyproject.toml", "requirements.txt", "setup.py", "tox.ini"]
detect_folders = []

# Rust 配置
[rust]
format = "via [🦀 $version](bold red) "
symbol = "🦀 "

# 命令执行时间
[cmd_duration]
min_time = 2000
format = "took [$duration](bold yellow) "
show_milliseconds = false
disabled = false

# 电池状态
[battery]
full_symbol = "🔋 "
charging_symbol = "⚡️ "
discharging_symbol = "💀 "

[[battery.display]]
threshold = 30
style = "bold red"

# 自定义模块
[custom.git_email]
description = "Show current git user email"
when = "git rev-parse --is-inside-work-tree 2>/dev/null"
command = "git config user.email"
format = "[$output]($style) "
style = "bold blue"
```

---

## 🔄 应用配置

### 重新加载配置

**如果你使用方法 1（自动初始化）**:

```nushell
# 只需重启 Nushell
exit
# 然后重新打开终端
```

**如果你使用方法 2（手动配置）**:

```nushell
# 重新加载配置文件
source-env $env.NU_LIB_DIRS.0/config.nu

# 或者重启 Nushell
exit
```

### 测试 Starship

```nushell
# 测试 prompt 输出
starship prompt

# 测试 right prompt
starship prompt --right

# 查看当前配置
starship config
```

---

## 🎯 常用模块配置

### Git 增强

```toml
[git_branch]
format = "[$symbol$branch(:$remote_branch)]($style) "
symbol = "🌿 "
truncation_length = 4
truncation_symbol = ""

[git_status]
format = '([\( $all_status$ahead_behind \)]($style) )'
style = "bold red"
conflicted = "🔀 "
ahead = "⇡${count} "
behind = "⇣${count} "
diverged = "⇕ "
untracked = "?${count} "
stashed = "📦 "
modified = "✏️ ${count} "
staged = "➕ ${count} "
renamed = "📝 ${count} "
deleted = "🗑️ ${count} "
```

### 语言版本显示

```toml
[nodejs]
format = "via [⬢ $version](bold green) "

[python]
format = "via [🐍 $version](bold yellow) "

[rust]
format = "via [🦀 $version](bold red) "

[golang]
format = "via [🐹 $version](bold cyan) "
```

### 目录缩短

```toml
[directory]
truncation_length = 3
truncate_to_repo = false
truncation_symbol = "…/"
fish_style_pwd_dir_length = 1
use_os_path_sep = true
```

---

## 🐛 故障排除

### 问题 1: Starship 未找到

**症状**: `starship: command not found`

**解决方案**:

```powershell
# 检查是否已安装
where starship

# 如果未安装，重新安装
scoop install starship

# 确保 PATH 包含 Starship
$env:PATH | Select-String starship
```

### 问题 2: Prompt 不更新

**症状**: 修改配置后 prompt 没有变化

**解决方案**:

```nushell
# 重新加载配置
source-env $env.NU_LIB_DIRS.0/config.nu

# 或者重启 Nushell
exit
```

### 问题 3: 性能问题

**症状**: Prompt 显示缓慢

**解决方案**:

```toml
# ~/.config/starship.toml

# 增加超时时间
command_timeout = 1000

# 禁用不必要的模块
[package]
disabled = true

[docker_context]
disabled = true
```

### 问题 4: 编码问题

**症状**: 特殊字符显示异常

**解决方案**:

1. 确保终端支持 UTF-8
2. 安装 nerd fonts 字体
3. 配置 WezTerm 使用支持 emoji 的字体

```lua
-- wezterm.lua
config.font = wezterm.font('JetBrainsMono Nerd Font')
```

---

## 📚 参考资源

- [Starship 官方文档](https://starship.rs/zh-CN/)
- [Starship GitHub](https://github.com/starship/starship)
- [Starship 配置参考](https://starship.rs/zh-CN/config/)
- [Nushell 官方文档](https://www.nushell.sh/)

---

## 💡 提示

> **最佳实践**:
> 1. 先使用默认配置，再逐步自定义
> 2. 每次修改后测试 prompt 输出
> 3. 保持配置文件简洁，禁用不需要的模块
> 4. 使用 `starship explain` 调试 prompt 渲染

> **性能优化**:
> - 禁用不常用的模块
> - 设置合理的 `command_timeout`
> - 避免复杂的自定义命令

---

## 📝 更新日志

### 2026-06-07

- 初始版本
- 添加安装指南
- 添加配置示例
- 添加故障排除
