# 🐚 Nushell 配置指南

Nushell 是一款现代化的跨平台 Shell，配置文件位于 `~/AppData/Roaming/nushell/`（Windows）或 `~/.config/nushell/`（Linux/macOS）。

---

## 命令补全

### git 补全安装

**方式一：从官方仓库下载（推荐）**

```bash
# 创建目录
mkdir ~/AppData/Roaming/nushell/custom-completions/git

# 下载补全文件
http get https://raw.githubusercontent.com/nushell/nu_scripts/main/custom-completions/git/git-completions.nu |
    save -f ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu
```

**方式二：通过新版 git 生成（git >= 2.45）**

```bash
git completions nushell | save -f ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu
```

### 启用补全

在 `config.nu` 中添加：

```nu
use ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu *
```

---

## 验证安装

重启 nushell 后，输入 `git` 命令按 <kbd>Tab</kbd> 键测试：

```bash
# 1. 子命令补全
git <Tab>              # 应列出 git 子命令列表

# 2. 自动补全
git comm<Tab>          # → 自动补全为 git commit
git chec<Tab>          # → 自动补全为 git checkout

# 3. 参数/选项补全
git commit -<Tab>      # → 列出 --amend, --message, --all 等选项

# 4. 分支名补全
git checkout <Tab>     # → 列出本地分支列表
```

如果补全不生效，检查：

```bash
# 确认文件存在
ls ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu

# 确认 config.nu 中 use 语句未被注释
rg "git-completions" ~/AppData/Roaming/nushell/config.nu
```

---

## 常见问题

### `Module not found` 错误

```
Error: nu::parser::module_not_found
  × Module not found.
```

原因：`custom-completions` 目录不存在或补全文件缺失。按上述步骤下载即可。

### `Directory not found` 错误

`save` 命令不会自动创建父目录，需要先 `mkdir`：

```bash
mkdir ~/AppData/Roaming/nushell/custom-completions/git
```

---

## 常用配置

### 隐藏启动信息

```nu
$env.config.show_banner = false
```

### 避免输入回车位移

```nu
$env.config.shell_integration.osc133 = false
```

---

## 别名

```nu
alias vim = nvim
```

---

## 相关链接

- [Nushell 官方文档](https://www.nushell.sh/)
- [nu_scripts 仓库](https://github.com/nushell/nu_scripts)
