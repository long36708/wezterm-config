# Nushell 自动补全配置指南

## 问题分析

Claude Code 的自动补全配置不生效的原因是：**配置文件已同步到用户目录，但未在 config.nu 中加载**。

### 当前状态

✅ **文件已存在**：`C:\Users\Administrator\AppData\Roaming\nushell\custom-completions\claude\claude-completions.nu`

❌ **未加载**：`config.nu` 中没有 `use` 语句来导入这个模块

### 对比 Git 补全

查看你的 [config.nu](file://C:\Users\Administrator\AppData\Roaming\nushell\config.nu#L94)：

```nu
# 命令补全
use ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu *
# use ~/AppData/Roaming/nushell/custom-completions/uv/uv-completions.nu *
```

Git 补全能工作是因为有 `use` 语句，而 Claude 补全缺少这一行。

## 解决方案

### 方法 1：手动编辑（推荐）

1. 打开 `C:\Users\Administrator\AppData\Roaming\nushell\config.nu`

2. 在第 95 行附近添加：

```nu
# 命令补全
use ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu *
use ~/AppData/Roaming/nushell/custom-completions/claude/claude-completions.nu *
# use ~/AppData/Roaming/nushell/custom-completions/uv/uv-completions.nu *
```

3. 保存文件

4. 重启 Nushell 或执行：

```nu
source-env $env.config.env_config
```

### 方法 2：使用同步脚本

运行项目中的同步脚本：

```bash
F:\learn-front\learn_cmd\wezterm\sync_nushell_config.bat
```

脚本会：
- ✅ 同步补全文件到用户目录
- ⚠️ 提示你需要手动添加 `use` 语句（因为安全原因无法自动修改用户配置文件）

## 验证是否生效

重启 Nushell 后，输入以下命令测试：

```nu
claude <Tab>
```

应该能看到所有子命令的补全提示，如：
- `agents`
- `auth`
- `mcp`
- `plugin`
- `project`
- 等等...

## 文件结构说明

```
F:\learn-front\learn_cmd\wezterm\nushell\
├── custom-completions/
│   ├── claude/
│   │   └── claude-completions.nu    # Claude Code 补全定义
│   └── git/
│       └── git-completions.nu       # Git 补全定义
└── COMPLETIONS_GUIDE.md             # 补全指南文档

C:\Users\Administrator\AppData\Roaming\nushell\
├── config.nu                        # 主配置文件（需要添加 use 语句）
└── custom-completions/
    ├── claude/
    │   └── claude-completions.nu    # 需要同步到这里
    └── git/
        └── git-completions.nu       # 已经在这里
```

## 注意事项

1. **每次更新补全文件后**，需要重新运行同步脚本
2. **修改 config.nu 后**，需要重启 Nushell 或重新加载配置
3. **安全性**：Nushell 不会自动执行未明确 `use` 的模块，这是设计特性

## 常见问题

### Q: 为什么 Git 补全能用，Claude 不能用？
A: Git 补全在 config.nu 中有 `use` 语句，Claude 没有。

### Q: 可以直接在项目目录使用补全吗？
A: 不行。Nushell 只从用户配置目录加载模块，必须同步到 `AppData/Roaming/nushell`。

### Q: 如何调试补全问题？
A: 在 Nushell 中运行：
```nu
help claude
```
如果能看到帮助信息，说明模块已正确加载。
