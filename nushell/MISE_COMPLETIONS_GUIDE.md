# Mise Nushell 补全开发指南

## 📋 概述

本文档记录了为 mise 创建 Nushell 静态补全文件时的经验教训和最佳实践。

## ⚠️ 常见错误与解决方案

### 1. 重复命令定义错误

**错误信息**:
```
Error: nu::parser::duplicate_command_def
Duplicate command definition within a block.
```

**原因**: 
在同一个文件中多次定义了相同的 `export extern` 命令。

**示例**:
```nushell
# ❌ 错误 - 重复定义
export extern "mise generate" [
    --help(-h)
]

# ... 其他代码 ...

export extern "mise generate" [  # 第二次定义，报错！
    --help(-h)
]
```

**解决方案**:
- 确保每个命令只定义一次
- 对于有子命令的情况，只定义父命令或子命令，不要都定义
- 使用搜索功能检查是否有重复定义

```nushell
# ✅ 正确 - 只定义子命令
export extern "mise generate bootstrap" [
    --help(-h)
]

export extern "mise generate config" [
    path?: path
    --help(-h)
]
```

---

### 2. 参数命名错误

**错误信息**:
```
Error: nu::parser::parse_mismatch
Parse mismatch during operation.
expected valid variable name for this parameter
```

**原因**: 
Nushell extern 参数命名规则要求：
- 位置参数：直接使用名称（如 `tool: string`）
- 短选项：单个短横线（如 `-j: int`）
- 长选项：必须使用双短横线（如 `--dir: path`）

**示例**:
```nushell
# ❌ 错误 - 缺少双短横线
export extern "mise generate task-stubs" [
    dir(-d): path          # 错误！应该是 --dir
    mise-bin: string       # 错误！应该是 --mise-bin
]

# ✅ 正确
export extern "mise generate task-stubs" [
    --dir(-d): path        # 正确的长选项格式
    --mise-bin: string     # 正确的长选项格式
]
```

**规则总结**:
| 类型 | 格式 | 示例 |
|------|------|------|
| 位置参数 | `name: type` | `tool: string` |
| 短选项 | `-s: type` | `-j: int` |
| 长选项 | `--long: type` | `--help: nothing` |
| 长短结合 | `--long(-s): type` | `--dir(-d): path` |

---

### 3. 补全文件未加载

**问题**: 
创建了补全文件但 Nushell 中没有自动补全。

**原因**: 
- 未在 `config.nu` 中使用 `use` 语句加载
- 文件路径不正确
- 文件名不符合规范

**解决方案**:

1. **在 config.nu 中添加 use 语句**:
```nushell
# C:\Users\Administrator\AppData\Roaming\nushell\config.nu
use ~/AppData/Roaming/nushell/custom-completions/mise/mise-completions.nu *
```

2. **确保文件结构正确**:
```
C:\Users\Administrator\AppData\Roaming\nushell\
├── config.nu
└── custom-completions\
    └── mise\
        └── mise-completions.nu
```

3. **重启 Nushell 或重新加载配置**:
```nushell
source-env $env.NU_LIB_DIRS.0/config.nu
```

---

## 🛠️ 最佳实践

### 1. 文件组织结构

```
nushell/
├── config.nu                          # 主配置文件
├── custom-completions/                # 自定义补全目录
│   ├── git/
│   │   └── git-completions.nu
│   ├── claude/
│   │   └── claude-completions.nu
│   └── mise/
│       └── mise-completions.nu
└── sync_nushell_config.bat           # 同步脚本
```

### 2. 补全文件模板

```nushell
# nu-version: 0.102.0
# <工具名称> CLI completions for Nushell
# Based on <文档来源>

# 自定义补全函数
def "nu-complete <tool> <name>" [] {
    [<value1> <value2> <value3>]
}

# 主命令
export extern <tool> [
    --help(-h)                                              # Show help
    --version(-V)                                           # Show version
    ...args: string                                         # Subcommand
]

# 子命令
export extern "<tool> <subcommand>" [
    arg?: string                                            # Argument description
    --flag                                                  # Flag description
    --option: string                                        # Option description
    --help(-h)                                              # Show help
]
```

### 3. 注释规范

- 每行注释对齐到相同列（通常第 60 列）
- 使用简洁的英文描述
- 包含必要的示例

```nushell
export extern "mise install" [
    tool?: string                                           # Tool name (e.g., node@20)
    --force                                                 # Force reinstall
    --jobs(-j): int                                         # Parallel jobs (default: 4)
    --help(-h)                                              # Show help
]
```

### 4. 同步脚本

创建批处理脚本自动同步配置：

```batch
@echo off
set SOURCE=F:\learn-front\learn_cmd\wezterm\nushell
set TARGET=C:\Users\Administrator\AppData\Roaming\nushell

REM 同步补全文件
robocopy "%SOURCE%\custom-completions\mise" "%TARGET%\custom-completions\mise" /E /NFL /NDL /NJH /NJS

REM 同步配置文件
copy /Y "%SOURCE%\config.nu" "%TARGET%\config.nu" >nul

echo Sync complete!
pause
```

---

## 🔍 调试技巧

### 1. 检查语法错误

```nushell
# 在 Nushell 中测试加载
source ~/AppData/Roaming/nushell/custom-completions/mise/mise-completions.nu
```

### 2. 查看已加载的命令

```nushell
# 列出所有 mise 相关命令
scope commands | where name =~ "mise"
```

### 3. 测试补全

```nushell
# 手动触发补全测试
mise <TAB>
mise install <TAB>
mise ls-remote <TAB>
```

### 4. 验证文件路径

```nushell
# 检查文件是否存在
ls ~/AppData/Roaming/nushell/custom-completions/mise/

# 检查 config.nu 中的 use 语句
open ~/AppData/Roaming/nushell/config.nu | lines | find "mise"
```

---

## 📚 参考资源

- [Nushell 官方文档 - External Commands](https://www.nushell.sh/book/external_commands.html)
- [Mise CLI 文档](https://mise.jdx.dev/cli/)
- [Nushell Custom Completions](https://www.nushell.sh/book/custom_completions.html)

---

## 📝 更新日志

### 2026-06-07
- 初始版本
- 记录重复定义错误及解决方案
- 记录参数命名错误及解决方案
- 添加最佳实践和调试技巧

---

## 💡 提示

> **重要**: 每次修改补全文件后，务必：
> 1. 运行同步脚本 `sync_nushell_config.bat`
> 2. 重启 Nushell 或重新加载配置
> 3. 测试补全是否正常工作

> **建议**: 在开发过程中，保持项目目录和用户配置目录的同步，避免混淆。
