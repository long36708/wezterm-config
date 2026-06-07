# Nushell 配置同步指南

## 📁 文件结构

```
F:\learn-front\learn_cmd\wezterm\nushell\
├── config.nu                              # 主配置文件（已添加 Claude 补全）
├── custom-completions/
│   ├── claude/
│   │   └── claude-completions.nu         # Claude Code 补全定义
│   └── git/
│       └── git-completions.nu            # Git 补全定义
└── CLAUDE_COMPLETIONS_FIX.md             # 修复指南
```

## 🚀 快速开始

### 一键同步所有配置

运行同步脚本：

```bash
F:\learn-front\learn_cmd\wezterm\sync_nushell_config.bat
```

脚本会自动完成以下操作：

1. ✅ **检查并添加** Claude 补全的 `use` 语句到 `config.nu`
2. ✅ **同步** `custom-completions/claude/` 到用户目录
3. ✅ **同步** `custom-completions/git/` 到用户目录
4. ✅ **同步** `config.nu` 到用户目录

### 同步目标

```
C:\Users\Administrator\AppData\Roaming\nushell\
├── config.nu                              # 已更新（包含 Claude 补全）
└── custom-completions/
    ├── claude/
    │   └── claude-completions.nu         # 已同步
    └── git/
        └── git-completions.nu            # 已同步
```

## ✨ 主要改进

### 之前的流程（需要手动操作）

1. ❌ 手动编辑用户目录的 `config.nu`
2. ❌ 手动添加 `use` 语句
3. ❌ 容易忘记或出错

### 现在的流程（自动化）

1. ✅ 在项目目录修改 `config.nu`
2. ✅ 运行 `sync_nushell_config.bat`
3. ✅ 自动同步所有内容

## 🔧 工作流程

### 场景 1：首次设置

```bash
# 1. 运行同步脚本
F:\learn-front\learn_cmd\wezterm\sync_nushell_config.bat

# 2. 重启 Nushell
# 或者在 Nushell 中执行：
source-env $env.NU_LIB_DIRS.0/config.nu

# 3. 测试补全
claude <Tab>
```

### 场景 2：更新补全文件

```bash
# 1. 修改项目目录的补全文件
# F:\learn-front\learn_cmd\wezterm\nushell\custom-completions\claude\claude-completions.nu

# 2. 运行同步脚本
F:\learn-front\learn_cmd\wezterm\sync_nushell_config.bat

# 3. 重启 Nushell
```

### 场景 3：修改 config.nu

```bash
# 1. 修改项目目录的 config.nu
# F:\learn-front\learn_cmd\wezterm\nushell\config.nu

# 2. 运行同步脚本
F:\learn-front\learn_cmd\wezterm\sync_nushell_config.bat

# 3. 重启 Nushell
```

## 📋 同步内容清单

### 1. config.nu

- ✅ 颜色配置
- ✅ Prompt 自定义
- ✅ 命令补全加载（Git + Claude）
- ✅ 别名定义
- ✅ 代理设置
- ✅ 工具路径配置

### 2. custom-completions/

#### Git 补全
- 分支名称补全
- 远程仓库补全
- 文件名补全
- 命令参数补全

#### Claude 补全
- 子命令补全（auth, mcp, plugin, etc.）
- 参数补全（--model, --permission-mode, etc.）
- 选项值补全（sonnet, opus, haiku, etc.）

## 🎯 验证是否生效

### 测试 Claude 补全

```nu
# 主命令补全
claude <Tab>

# 应该看到：
# agents, auth, auto-mode, doctor, install, mcp, 
# plugin, plugins, project, setup-token, update, upgrade, ultrareview

# 子命令补全
claude auth <Tab>

# 应该看到：
# login, logout, status

# 参数补全
claude --model <Tab>

# 应该看到：
# sonnet, opus, haiku, best, sonnet1m, opus1m, opusplan
```

### 测试 Git 补全

```nu
git checkout <Tab>
git push origin <Tab>
git branch -d <Tab>
```

## ⚠️ 注意事项

### 1. 编码问题

脚本使用 UTF-8 编码保存 `config.nu`，确保中文字符正常显示。

### 2. 权限问题

同步脚本需要写入权限到 `C:\Users\Administrator\AppData\Roaming\nushell\`。

### 3. 备份建议

首次运行前，建议备份用户目录的配置：

```bash
copy C:\Users\Administrator\AppData\Roaming\nushell\config.nu C:\Users\Administrator\AppData\Roaming\nushell\config.nu.backup
```

### 4. 版本兼容性

- Nushell 版本：0.113.1
- 补全文件格式：nu-version 0.102.0
- 完全兼容 ✅

## 🐛 故障排除

### 问题 1：补全不工作

**检查步骤**：

```nu
# 1. 确认模块已加载
scope commands | where name =~ 'claude'

# 2. 检查 help 是否可用
help claude

# 3. 查看 config.nu 是否有 use 语句
open $env.NU_LIB_DIRS.0/config.nu | find "claude"
```

**解决方案**：

重新运行同步脚本并重启 Nushell。

### 问题 2：同步失败

**可能原因**：

- 文件被占用（Nushell 正在运行）
- 权限不足

**解决方案**：

1. 关闭所有 Nushell 窗口
2. 以管理员身份运行脚本

### 问题 3：中文乱码

**解决方案**：

确保 `config.nu` 使用 UTF-8 编码保存。PowerShell 命令已包含 `-Encoding UTF8` 参数。

## 📝 最佳实践

1. **始终在项目目录修改配置**，不要直接修改用户目录的文件
2. **每次修改后运行同步脚本**
3. **定期备份重要配置**
4. **使用 Git 跟踪项目目录的配置变更**

## 🔗 相关文档

- [CLAUDE_COMPLETIONS_DIAGNOSIS.md](./CLAUDE_COMPLETIONS_DIAGNOSIS.md) - 详细诊断报告
- [CLAUDE_COMPLETIONS_FIX.md](./CLAUDE_COMPLETIONS_FIX.md) - 原始修复指南
- [COMPLETIONS_GUIDE.md](./COMPLETIONS_GUIDE.md) - 补全开发指南

---

**最后更新**：2026-06-07  
**维护者**：WezTerm Config Project
