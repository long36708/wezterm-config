# 🐚 Nushell 配置指南

Nushell 是一款现代化的跨平台 Shell，配置文件位于：
- **Windows**: `~/AppData/Roaming/nushell/config.nu` + `env.nu`
- **Linux/macOS**: `~/.config/nushell/config.nu` + `env.nu`

---

## 一键初始化配置

在新电脑上，将以下内容追加到 `config.nu` 尾部即可完成基础配置：

<details>
<summary>📋 点击展开完整配置块（复制粘贴到 config.nu）</summary>

```nu
# ========================================= 自定义配置 =========================================
# 自定义 PROMPT（显示最近 3 层目录）
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_COMMAND = {||
    let parts = (pwd | path split)

    let display = if ($parts | length) > 3 {
        "..\\" + ($parts | last 3 | path join)
    } else {
        ($parts | path join)
    }

    $"($display) "
}

# 不显示启动信息
$env.config.show_banner = false;
# 避免输入回车出现位移情况
$env.config.shell_integration.osc133 = false;

# 命令补全
use ~/AppData/Roaming/nushell/custom-completions/git/git-completions.nu *
# use ~/AppData/Roaming/nushell/custom-completions/uv/uv-completions.nu *

# 基础别名
alias vim = nvim

# 代理（按需修改）
# def --env "proxy set" [] {
#     load-env { "HTTP_PROXY": "socks5://127.0.0.1:10808", "HTTPS_PROXY": "socks5://127.0.0.1:10808" }
# }
# def --env "proxy unset" [] {
#     load-env { "HTTP_PROXY": "", "HTTPS_PROXY": "" }
# }
```
</details>

> ⚠️ 注意：补全功能需先执行下方 [命令补全 → git 补全安装](#git-补全安装) 步骤。

---

## 配置详解

### 颜色主题

```nu
$env.config.color_config = {
    separator: default
    header: green_bold
    bool: light_cyan
    int: default
    string: default
    # 自动补全提示字符颜色
    hints: '#6c6c6c'
    search_result: { bg: red fg: default }
    # ... 更多颜色配置见 config.nu
}
```

### 自定义 Prompt

显示路径最近 3 层目录，避免路径过长：

```nu
$env.config.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_COMMAND = {||
    let parts = (pwd | path split)
    let display = if ($parts | length) > 3 {
        "..\\" + ($parts | last 3 | path join)
    } else {
        ($parts | path join)
    }
    $"($display) "
}
```

### 隐藏启动信息和避免回车位移

```nu
$env.config.show_banner = false
$env.config.shell_integration.osc133 = false
```

### 代理配置

```nu
# 设置代理（socks5 端口 10808）
def --env "proxy set" [] {
    load-env { "HTTP_PROXY": "socks5://127.0.0.1:10808", "HTTPS_PROXY": "socks5://127.0.0.1:10808" }
}

# 取消代理
def --env "proxy unset" [] {
    load-env { "HTTP_PROXY": "", "HTTPS_PROXY": "" }
}

# 检查代理是否生效
def "proxy check" [] {
    print "Try to connect to Google..."
    let resp = (curl -I -s --connect-timeout 2 -m 2 -w "%{http_code}" -o /dev/null www.google.com)
    if $resp == "200" {
        print "Proxy setup succeeded!"
    } else {
        print "Proxy setup failed!"
    }
}
```

### 目录常量

用 `const` 定义常用路径，方便引用：

```nu
const ToolsDir = "F:\\CTF\\ProgramFiles\\CTF\\CTF_Tools\\"
const ScriptDir = "F:\\CTF\\ProgramFiles\\CTF\\CTF_Script\\"
const WSLDir = "C:\\Users\\97766\\Downloads\\WSL\\"
```

### 工具别名示例

```nu
# 可执行文件别名
alias MemProcFS = F:\\CTF\\ProgramFiles\\CTF\\CTF_Tools\\取证\\MemProcFS\\MemProcFS.exe
alias bkcrack = F:\\CTF\\ProgramFiles\\CTF\\CTF_Tools\\爆破\\bkcrack-1.7.1-win64\\bkcrack.exe
alias upx = F:\\CTF\\ProgramFiles\\CTF\\CTF_Tools\\逆向\\upx-4.1.0-win64\\upx.exe

# Python 脚本别名
alias crc32 = D:\\Python\\python.exe $"($ScriptDir)1.Compression/CRC-Tools/main.py"
alias BaseSeries = D:\\Python\\python.exe $"($ScriptDir)BaseSeries/main.py"

# PHP 脚本别名
alias phpstan = D:\phpstudy_pro\Extensions\php\php7.4.3nts\php.exe "F:/CTF/ProgramFiles/CTF/CTF_APP/Web/静态分析/phpstan.phar"
```

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

## 相关链接

- [Nushell 官方文档](https://www.nushell.sh/)
- [nu_scripts 仓库](https://github.com/nushell/nu_scripts)
