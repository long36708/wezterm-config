# Nushell Completions 资源大全

## 🎯 官方和社区资源

### 1. Awesome-Nu (⭐ 强烈推荐)

**GitHub**: https://github.com/nushell/awesome-nu

这是 Nushell 生态系统的**终极资源清单**,包含:
- 🔌 **插件**(Plugins) - 扩展 Nushell 功能
- 📜 **脚本**(Scripts) - 实用工具集合
- ✨ **自定义补全**(Custom Completions) - Git, npm, cargo 等
- 🛠️ **集成工具** - VS Code, Neovim, Starship 等

**快速开始**:
```bash
git clone https://github.com/nushell/awesome-nu.git
cd awesome-nu
```

---

### 2. Nu Scripts 仓库

**GitHub**: https://github.com/nushell/nu_scripts

Nushell 官方的脚本和模块分享平台,包含:
- Git 工作流脚本
- 系统管理工具
- 数据处理示例
- **补全脚本模板**

---

### 3. Nushell 官方文档

**补全指南**: https://www.nushell.sh/book/custom_completions.html

官方文档详细介绍了如何编写自定义补全。

---

## 📦 热门 Completions 推荐

### Git 补全 ⭐

**来源**: awesome-nu / nu_scripts

**功能**:
- `git branch` 分支名补全
- `git checkout` 分支/标签补全
- `git merge` 分支补全
- `git remote` 远程仓库补全
- `git tag` 标签补全

**安装**:
```nushell
# 从项目目录加载
use ./nushell/custom-completions/git/git-completions.nu *
```

---

### Cargo (Rust) 补全

**来源**: awesome-nu

**功能**:
- `cargo add` crate 名称补全
- `cargo build` target 补全
- `cargo run` bin 补全

**安装**:
```nushell
# 需要先克隆 awesome-nu
use ~/awesome-nu/completions/cargo-completions.nu *
```

---

### npm 补全

**来源**: awesome-nu

**功能**:
- `npm install` 包名补全
- `npm run` scripts 补全
- `npm uninstall` 已安装包补全

---

### Docker 补全

**来源**: nu_scripts

**功能**:
- `docker run` 镜像名补全
- `docker exec` 容器名补全
- `docker network` 网络名补全

---

### kubectl (Kubernetes) 补全

**来源**: community

**功能**:
- Pod 名称补全
- Namespace 补全
- Service 补全

---

## 🔍 如何查找更多 Completions

### 方法 1: 浏览 Awesome-Nu

```bash
# 克隆仓库
git clone https://github.com/nushell/awesome-nu.git

# 查看 completions 目录
ls awesome-nu/completions/

# 查看 README 了解所有资源
cat awesome-nu/README.md
```

---

### 方法 2: 搜索 GitHub

使用以下关键词搜索:

```
"nushell completions"
"nu-completions"
"nushell custom completion"
"nu_scripts completions"
```

**推荐搜索链接**:
- https://github.com/search?q=nushell+completions&type=repositories
- https://github.com/topics/nushell
- https://github.com/topics/nu-shell

---

### 方法 3: 查看 Nu Scripts 仓库

```bash
git clone https://github.com/nushell/nu_scripts.git
cd nu_scripts

# 查看可用的脚本和补全
ls -la
```

---

### 方法 4: Nushell Discord 和社区

- **Discord**: https://discord.gg/NtAbbGn
- **Reddit**: r/nushell
- **论坛**: https://github.com/nushell/nushell/discussions

在社区中询问:"Are there any completions for [tool name]?"

---

### 方法 5: 自己编写

参考官方文档和现有示例,为常用工具编写补全:

```nushell
# 示例: 为 mytool 创建补全
def mytool_commands [] {
    ["start", "stop", "restart", "status"]
}

def mytool [command: string@mytool_commands] {
    print $"Running: ($command)"
}
```

---

## 📁 推荐的本地组织结构

```
wezterm/
└── nushell/
    └── custom-completions/
        ├── git/
        │   └── git-completions.nu
        ├── cargo/
        │   └── cargo-completions.nu
        ├── docker/
        │   └── docker-completions.nu
        └── npm/
            └── npm-completions.nu
```

---

## 🔧 在 config.nu 中加载

```nushell
# 方式 1: 使用绝对路径
use ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu *

# 方式 2: 使用项目路径(如果配置在项目目录)
use ~/.config/wezterm/nushell/custom-completions/git/git-completions.nu *

# 方式 3: 批量加载
for file in (ls ~/.config/wezterm/nushell/custom-completions/**/*.nu | get name) {
    source $file
}
```

---

## 🌟 高质量 Completions 清单

根据 awesome-nu 整理:

| 工具 | 补全内容 | 来源 |
|------|---------|------|
| **Git** | branches, tags, remotes, commits | awesome-nu |
| **Cargo** | crates, targets, bins | awesome-nu |
| **npm** | packages, scripts | awesome-nu |
| **Docker** | images, containers, networks | nu_scripts |
| **kubectl** | pods, services, namespaces | community |
| **AWS CLI** | services, regions | community |
| **Terraform** | resources, modules | community |
| **pip** | packages | community |
| **brew** | formulas | community |
| **yarn** | packages, scripts | community |

---

## 💡 编写自己的 Completions

### 基础模板

```nushell
# 定义补全函数
def my-command-options [] {
    ["option1", "option2", "option3"]
}

# 在命令中使用补全
def my-command [
    option: string@my-command-options  # 关联补全函数
] {
    print $"Selected: ($option)"
}
```

### 动态补全示例

```nushell
# 从 git 获取分支列表
def git-branches [] {
    git branch --format "%(refname:short)" | where $it != "HEAD"
}

# 使用动态补全
def gco [branch: string@git-branches] {
    git checkout $branch
}
```

### 带描述的补全

```nushell
def advanced-completion [] {
    [
        {value: "opt1", description: "第一个选项"},
        {value: "opt2", description: "第二个选项"},
        {value: "opt3", description: "第三个选项"}
    ]
}
```

---

## 🚀 快速集成到你的项目

### 步骤 1: 克隆 Awesome-Nu

```bash
cd F:\learn-front\learn_cmd\wezterm
git clone https://github.com/nushell/awesome-nu.git nushell/awesome-nu
```

### 步骤 2: 复制需要的补全

```bash
# 复制 Git 补全
cp nushell/awesome-nu/completions/git-completions.nu nushell/custom-completions/git/

# 复制其他你需要的补全
```

### 步骤 3: 更新 .gitignore

确保忽略不需要的文件:

```gitignore
# 保留自定义补全
!nushell/custom-completions/

# 忽略克隆的仓库(可选,如果想单独管理)
nushell/awesome-nu/
```

### 步骤 4: 在 config.nu 中加载

```nushell
# 使用相对路径(如果在 WezTerm 配置目录)
use ~/.config/wezterm/nushell/custom-completions/git/git-completions.nu *
```

---

## 📚 学习资源

1. **官方补全文档**: https://www.nushell.sh/book/custom_completions.html
2. **Awesome-Nu**: https://github.com/nushell/awesome-nu
3. **Nu Scripts**: https://github.com/nushell/nu_scripts
4. **Nushell Book**: https://www.nushell.sh/book/
5. **社区示例**: 查看 `tests/fixtures/completions/` 目录

---

## 🎓 进阶技巧

### 1. 模糊匹配补全

```nushell
$env.config.completions.algorithm = "fuzzy"
```

### 2. 禁用默认排序

```nushell
def my-completion [] {
    {
        options: { sort: false },
        completions: ["z-last", "a-first", "m-middle"]
    }
}
```

### 3. 条件补全

```nushell
def smart-completion [] {
    if (git rev-parse --is-inside-work-tree | complete | get stdout) == "true" {
        git-branches
    } else {
        ["not-in-git-repo"]
    }
}
```

---

## 🔗 相关链接

- [Awesome-Nu GitHub](https://github.com/nushell/awesome-nu)
- [Nu Scripts GitHub](https://github.com/nushell/nu_scripts)
- [Nushell 官方文档](https://www.nushell.sh/)
- [Nushell Discord](https://discord.gg/NtAbbGn)
- [补全测试用例](https://github.com/nushell/nushell/tree/main/crates/nu-cli/tests/completions)

---

## 💬 贡献你的 Completions

如果你编写了有用的补全,可以:

1. **提交到 Nu Scripts**: https://github.com/nushell/nu_scripts
2. **添加到 Awesome-Nu**: https://github.com/nushell/awesome-nu
3. **分享到社区**: Discord 或 Reddit

帮助其他人也能受益! 🎉
