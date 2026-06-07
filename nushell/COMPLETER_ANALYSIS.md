# Nushell 补全方案对比分析

## 📋 两种补全方式对比

### 方案 1: Static Completer (当前使用)

使用 `export extern` 定义命令签名和补全规则。

#### ✅ 优点
- **性能好**：静态定义，无需运行时计算
- **类型安全**：Nushell 可以验证参数类型
- **IDE 支持**：编辑器可以提供智能提示
- **成熟稳定**：Git 补全文件已验证可行
- **详细控制**：可以为每个参数指定补全函数

#### ❌ 缺点
- **维护成本高**：需要手动更新所有参数
- **不够灵活**：无法动态获取最新命令列表
- **冗长**：670 行代码只为一个命令
- **版本依赖**：需要标记 `# nu-version: 0.102.0`

#### 📝 示例
```nu
# claude-completions.nu
def "nu-complete claude models" [] {
    [sonnet opus haiku best sonnet1m opus1m opusplan]
}

export extern claude [
    --model: string@"nu-complete claude models"
    --help(-h)
    ...args: string
]

export extern "claude auth" [
    --help(-h)
]

export extern "claude auth login" [
    --claudeai
    --console
]
```

---

### 方案 2: External Completer (文档推荐)

使用闭包动态生成补全列表。

#### ✅ 优点
- **灵活性高**：可以调用外部命令获取实时数据
- **代码简洁**：逻辑集中，易于维护
- **动态更新**：可以查询 CLI 的 `--help` 获取最新参数
- **组合性强**：可以为不同命令使用不同补全器
- **可扩展**：轻松添加新命令的补全

#### ❌ 缺点
- **性能稍差**：每次补全都需要执行闭包
- **无类型检查**：返回格式错误可能导致问题
- **调试困难**：错误信息不够明确
- **需要配置**：必须设置 `$env.config.completions.external`

#### 📝 示例
```nu
let claude_completer = {|spans: list<string>|
    match $spans.0 {
        "claude" => {
            if ($spans | length) == 1 {
                # 子命令补全
                [
                    {value: "auth", description: "Manage authentication"},
                    {value: "mcp", description: "Configure MCP servers"}
                ]
            } else {
                match $spans.1 {
                    "auth" => [
                        {value: "login", description: "Sign in"},
                        {value: "logout", description: "Log out"}
                    ]
                    _ => []
                }
            }
        }
        _ => []
    }
}

$env.config = {
    completions: {
        external: {
            enable: true
            completer: $claude_completer
        }
    }
}
```

---

## 🔍 Multiple Completer 模式详解

### 核心思想

**为不同命令选择最合适的补全器**，而不是使用单一的全局补全器。

```nu
let external_completer = {|spans|
    match $spans.0 {
        # Claude 使用自定义补全器
        "claude" => $claude_completer
        
        # Git 使用 Fish 补全器（分支/提交补全更好）
        "git" => $fish_completer
        
        # Cargo 使用 Carapace 补全器
        "cargo" => $carapace_completer
        
        # 其他命令使用默认补全
        _ => $default_completer
    } | do $in $spans
}
```

### 工作流程

1. **用户输入**：`claude auth <TAB>`
2. **Nushell 调用**：`$external_completer ["claude" "auth" ""]`
3. **匹配命令**：`match $spans.0` → `"claude"` → `$claude_completer`
4. **执行补全器**：`$claude_completer ["claude" "auth" ""]`
5. **返回结果**：`[{value: "login"}, {value: "logout"}, {value: "status"}]`
6. **显示补全**：Nushell 展示三个选项

### `$spans` 参数解析

| 输入 | `$spans` | 说明 |
|------|----------|------|
| `claude <TAB>` | `["claude" ""]` | 命令 + 空字符串 |
| `claude auth <TAB>` | `["claude" "auth" ""]` | 命令 + 子命令 + 空字符串 |
| `claude --model s<TAB>` | `["claude" "--model" "s"]` | 命令 + 参数 + 部分值 |

---

## 🎯 推荐的混合方案

结合两种方案的优点：

### 架构设计

```
F:\learn-front\learn_cmd\wezterm\nushell\
├── config.nu                           # 主配置
├── external-completers.nu              # 外部补全器定义
└── custom-completions/
    ├── claude/
    │   └── claude-completions.nu      # 保留作为 fallback
    └── git/
        └── git-completions.nu         # 继续使用 static completer
```

### 实现步骤

#### 1. 创建外部补全器文件

```nu
# external-completers.nu

# Claude Code external completer
let claude_external_completer = {|spans|
    # 动态逻辑...
}

# Multiple completer
let multi_completer = {|spans|
    match $spans.0 {
        "claude" => $claude_external_completer
        _ => {[]}  # 其他命令使用内置补全
    } | do $in $spans
}

# 导出供 config.nu 使用
export-env {
    $env.config = {
        completions: {
            external: {
                enable: true
                completer: $multi_completer
            }
        }
    }
}
```

#### 2. 修改 config.nu

```nu
# config.nu

# 加载外部补全器
use ~/AppData/Roaming/nushell/external-completers.nu *

# 保留 static completers 作为补充
use ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu *
use ~/AppData/Roaming/nushell/custom-completions/claude/claude-completions.nu *
```

---

## 📊 性能对比

| 指标 | Static Completer | External Completer |
|------|------------------|-------------------|
| 启动时间 | 快（预加载） | 慢（需初始化） |
| 补全响应 | < 10ms | 10-100ms |
| 内存占用 | 低 | 中 |
| CPU 使用 | 极低 | 中等 |
| 可维护性 | 低 | 高 |
| 灵活性 | 低 | 高 |

---

## 🚀 最佳实践建议

### 场景 1: 简单命令补全

**推荐**：Static Completer (`extern`)

```nu
# 适合：参数少、结构简单的命令
export extern "my-tool" [
    --help(-h)
    --version(-v)
    input?: path
]
```

### 场景 2: 复杂命令补全

**推荐**：External Completer

```nu
# 适合：子命令多、参数动态变化的命令
let complex_completer = {|spans|
    # 可以调用 `my-tool --help` 动态解析
    # 可以查询 API 获取实时数据
    # 可以根据上下文提供智能补全
}
```

### 场景 3: 混合使用（推荐）

```nu
# config.nu

# 1. 常用命令使用 static completer（性能好）
use ~/custom-completions/git/git-completions.nu *

# 2. 复杂命令使用 external completer（灵活）
use ~/external-completers.nu *

# 3. 配置 multiple completer
$env.config = {
    completions: {
        external: {
            enable: true
            completer: $multi_completer
        }
    }
}
```

---

## 🛠️ 实际应用：Claude Code 补全优化

### 当前问题

你的 `claude-completions.nu` 有 670 行，维护成本高。

### 优化方案

#### 方案 A: 完全替换为 External Completer

```nu
let claude_completer = {|spans|
    # 调用 `claude --help` 动态解析
    let help_output = (^claude --help | str trim)
    
    # 解析输出生成补全列表
    # ...
}
```

**优点**：自动同步 Claude Code 的最新参数  
**缺点**：每次补全都执行 `claude --help`，性能差

#### 方案 B: 缓存 + External Completer

```nu
let claude_cache = ref {}

let claude_completer = {|spans|
    # 首次使用时缓存
    if ($claude_cache | get "commands" | is-empty) {
        let help = ^claude --help
        # 解析并缓存
        $claude_cache.commands = parse_help $help
    }
    
    # 使用缓存数据生成补全
    generate_completions $claude_cache $spans
}
```

**优点**：平衡性能和灵活性  
**缺点**：需要手动刷新缓存

#### 方案 C: 保留 Static + 关键动态补全（推荐）

```nu
# 保留基本的 extern 定义（快速）
export extern claude [
    --model: string@"nu-complete claude models"
    ...args: string
]

# 为复杂子命令添加 external completer
let claude_dynamic = {|spans|
    match $spans.1 {
        "plugin" => {
            # 动态查询已安装的插件
            ^claude plugin list --json | from json
        }
        "mcp" => {
            # 动态查询配置的 MCP 服务器
            ^claude mcp list --json | from json
        }
        _ => []
    }
}
```

**优点**：兼顾性能和动态性  
**缺点**：实现复杂度中等

---

## 📝 总结

| 方案 | 适用场景 | 推荐度 |
|------|---------|--------|
| **Static Completer** | 简单命令、追求性能 | ⭐⭐⭐⭐ |
| **External Completer** | 复杂命令、需要动态数据 | ⭐⭐⭐⭐⭐ |
| **Multiple Completer** | 多个命令混合使用 | ⭐⭐⭐⭐⭐ |
| **混合方案** | 生产环境最佳实践 | ⭐⭐⭐⭐⭐ |

### 对你的建议

1. **短期**：保持当前的 static completer（已经工作良好）
2. **中期**：为动态部分（plugin list, mcp list）添加 external completer
3. **长期**：考虑迁移到完整的 multiple completer 架构

---

**参考资源**：
- [Nushell External Completers 文档](https://www.nushell.sh/cookbook/external_completers.html)
- [Carapace 项目](https://github.com/rsteube/carapace)
- [Fish Shell Completions](https://fishshell.com/docs/current/completions.html)
