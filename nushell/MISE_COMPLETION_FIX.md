# Mise Nushell 补全问题解决方案

## 🔍 问题分析

根据 [GitHub Discussion #4974](https://github.com/jdx/mise/discussions/4974)，mise 目前**没有原生的 Nushell 补全支持**。

### 原因

1. **mise 使用 `usage` 工具生成补全**
2. **`usage` 还不支持 Nushell**（只支持 bash, zsh, fish 等）
3. **Fish 补全器作为 fallback 效果不好**（会显示目录而不是命令）

### 讨论中的解决方案

```nu
# 方案 1: 使用 Fish 补全器（不推荐，有问题）
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
}

# 方案 2: 使用 Carapace（✅ 推荐）
let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}
```

---

## ✅ 推荐方案：安装 Carapace

### 什么是 Carapace？

Carapace 是一个强大的自动补全引擎，支持 **100+ 命令**的 Nushell 补全，包括：
- ✅ npm, yarn, pnpm
- ✅ git, gh
- ✅ cargo, rustup
- ✅ docker, kubectl
- ✅ python, pip, go, java
- ❌ **mise**（不支持，使用手动 fallback）
- ❌ **uv**（不支持，使用手动 fallback）

### 安装步骤

#### 方法 1: 离线安装（✅ 你的环境）

参见 [OFFLINE_INSTALL_CARAPACE.md](./OFFLINE_INSTALL_CARAPACE.md)

**步骤概览**：
1. 在有网络的机器上下载 `carapace_windows_amd64.zip`
2. 传输到内网机器
3. 解压到 `D:\bin\`
4. 配置已完成（config.nu 已指向 `D:\bin\carapace.exe`）

#### 方法 2: 在线安装（如果有网络）

```powershell
# 1. 安装 Scoop（如果还没有）
iwr -useb get.scoop.sh | iex

# 2. 安装 Carapace
scoop install carapace

# 3. 验证安装
carapace --version
```

---

## 🔧 配置说明

### config.nu 已更新

你的 `config.nu` 已经配置为使用 **混合方案**：

```nu
let multi_completer = {|spans|
    match $spans.0 {
        # Mise: Carapace 不支持，使用手动解析
        "mise" => {|s| 
            if ($s | length) == 1 {
                # 从 mise help --all 解析子命令
                ^mise help --all | lines | skip 2 | where $it != ""
                | each {|line|
                    let parts = ($line | split row " " -n 2)
                    {value: ($parts.0 | str trim), description: ...}
                }
            } else {
                []  # 深层补全暂不支持
            }
        }
        
        # UV: Carapace 不支持，使用手动解析
        "uv" => {|s|
            if ($s | length) == 1 {
                # 从 uv --help 解析子命令
                ^uv --help | lines | where $it starts-with "  "
                | each {|line| ... }
            } else {
                []
            }
        }
        
        # 其他命令使用 Carapace
        "git" | "cargo" | "npm" | "yarn" | "pnpm" | "docker" => {|s|
            try {
                ^$carapace_path $s.0 nushell ...$s | from json
            } catch {
                []
            }
        }
        
        _ => {[]}
    } | do $in $spans
}

$env.config.completions.external = {
    enable: true
    completer: $multi_completer
}
```

### 工作流程

```
用户输入: mise <TAB>
    ↓
Nushell 调用 multi_completer
    ↓
match "mise" → 调用 carapace
    ↓
执行: carapace mise nushell mise ""
    ↓
返回 JSON 格式的补全列表
    ↓
显示: install, use, ls, current, ...
```

---

## 🚀 使用步骤

### 1. 安装 Carapace（可选）

**对于 mise/uv 补全**：不需要 Carapace，已使用手动 fallback。

**对于其他命令**（git/cargo/npm 等）：需要安装 Carapace。

#### 离线安装（你的环境）

```powershell
# 1. 确认 carapace.exe 在 D:\bin\
Test-Path "D:\bin\carapace.exe"

# 2. 测试版本
& "D:\bin\carapace.exe" --version
```

详细步骤参见：[OFFLINE_INSTALL_CARAPACE.md](./OFFLINE_INSTALL_CARAPACE.md)

### 2. 同步配置

```bash
F:\learn-front\learn_cmd\wezterm\sync_nushell_config.bat
```

### 3. 重启 Nushell

关闭所有窗口并重新打开。

### 4. 测试补全

```nu
# Mise 补全（手动 fallback）
mise <TAB>              # 显示子命令（从 mise help 解析）
mise install <TAB>      # 暂不支持深层补全
mise use <TAB>          # 暂不支持深层补全

# Git/Cargo/NPM 补全（Carapace）
git <TAB>               # Git 智能补全（需要 Carapace）
cargo <TAB>             # Cargo 智能补全（需要 Carapace）
npm <TAB>               # NPM 智能补全（需要 Carapace）
```

---

## 📊 方案对比

| 方案 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| **手动 Fallback** | ✅ 无需额外安装<br>✅ 基本补全可用 | ❌ 仅支持子命令<br>❌ 无深层补全 | ⭐⭐⭐⭐ |
| **Carapace** | ✅ 智能补全<br>✅ 支持 100+ 命令<br>✅ 维护良好 | ❌ 需要安装<br>❌ 不支持 mise/uv | ⭐⭐⭐⭐⭐ |
| **Fish Completer** | ✅ 无需额外安装 | ❌ 补全不准确<br>❌ 显示目录而非命令 | ⭐⭐ |
| **Static Extern** | ✅ 快速 | ❌ 需要手动维护<br>❌ mise 参数变化快 | ⭐⭐⭐ |

---

## 🐛 故障排除

### 问题 1: Carapace 未找到

**错误信息**：
```
Error: command not found: carapace
```

**说明**：
- 对于 **mise/uv**：这是正常的，已使用手动 fallback，不需要 Carapace
- 对于 **git/cargo/npm** 等：需要安装 Carapace

**解决方案**：
```powershell
# 检查是否安装
Test-Path "D:\bin\carapace.exe"

# 如果未安装，参见离线安装指南
# OFFLINE_INSTALL_CARAPACE.md
```

### 问题 2: 补全仍然不工作

**检查步骤**：

```nu
# 1. 确认外部补全已启用
$env.config.completions.external.enable
# 应该输出: true

# 2. 测试 carapace 命令
^carapace mise nushell mise ""

# 3. 检查 mise 是否可用
^mise --version
```

**解决方案**：
- 确保 Carapace 和 mise 都已正确安装
- 重启 Nushell
- 检查 config.nu 是否正确同步

### 问题 3: 补全慢

**原因**：Carapace 需要执行命令来获取补全数据。

**优化**：这是正常的，Carapace 通常响应时间在 100-300ms。

---

## 💡 最佳实践

### 1. 优先使用 Carapace

对于支持的命令（mise, npm, git, cargo 等），Carapace 是最好的选择。

### 2. 保留静态补全作为补充

对于 Claude Code 这样的自定义工具，继续使用静态补全（extern）。

### 3. 定期更新 Carapace

```powershell
scoop update carapace
```

---

## 📝 总结

### 当前状态

- ❌ mise **没有原生 Nushell 补全**
- ❌ **Carapace 也不支持 mise**（截至 v1.6.6）
- ✅ **使用手动 fallback 方案**（从 `mise help` 解析）
- ✅ Carapace 可用于其他命令（git/cargo/npm 等）

### 下一步

1. **mise/uv 补全已可用**（手动 fallback）
2. **可选**：安装 Carapace 以增强 git/cargo/npm 等命令的补全
3. **重启 Nushell**
4. **测试补全**！

---

**参考资源**：
- [GitHub Discussion #4974](https://github.com/jdx/mise/discussions/4974)
- [Carapace GitHub](https://github.com/rsteube/carapace)
- [Nushell External Completers](https://www.nushell.sh/cookbook/external_completers.html)

**最后更新**：2026-06-07
