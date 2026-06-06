# ========================================= WezTerm + Nushell 集成优化 =========================================
# 将以下内容添加到 C:\Users\Administrator\AppData\Roaming\nushell\config.nu 末尾

# 1. 快速目录导航
alias ctf = cd $ToolsDir
alias scripts = cd $ScriptDir
alias wsl-tools = cd $WSLDir

# 2. 代理管理增强
alias proxy-on = proxy set
alias proxy-off = proxy unset
alias proxy-test = proxy check

# 3. WezTerm 专用功能
# 检测是否在 WezTerm 中运行
def is-wezterm [] {
    ($env.WEZTERM_PANE_ID? | is-not-empty) or ($env.WEZTERM_WINDOW_ID? | is-not-empty)
}

# WezTerm 通知 (需要 wezterm cli)
def notify [message: string] {
    if (is-wezterm) {
        try {
            ^wezterm cli toast $message
        } catch {
            print $"(ansi yellow)⚠️ WezTerm CLI 不可用(ansi reset)"
        }
    }
}

# 4. CTF 工作流快捷命令
# 一键设置代理并测试
alias scan-proxy = do { proxy set; proxy check }

# 快速查看常用工具版本
def ctf-tools-info [] {
    print "=== CTF Tools Info ==="
    print ""
    
    # Python
    if (which python | is-not-empty) {
        print $"Python: (python --version | get stdout | str trim)"
    }
    
    # Nvim
    if (which nvim | is-not-empty) {
        print $"Neovim: (nvim --version | first | str trim)"
    }
    
    # Git
    if (which git | is-not-empty) {
        print $"Git: (git --version | str trim)"
    }
    
    print ""
    print $"Tools Dir: ($ToolsDir)"
    print $"Script Dir: ($ScriptDir)"
}

# 5. 文件操作增强
# 快速打开当前目录
alias here = code .

# 快速查找大文件
def find-large [size: string = "100MB"] {
    ls -la | where size > ($size | into filesize) | sort-by size -r
}

# 6. 进程管理
# 快速查找占用端口的进程
def port-usage [port: int] {
    netstat -ano | find $"(:$port)"
}

# 7. 系统信息
def sys-info [] {
    print "=== System Info ==="
    print $"OS: (sys host | get name) (sys host | get os_version)"
    print $"CPU: (sys cpu | length) cores"
    print $"Memory: ((sys mem | get total) / 1GB | math round -p 2) GB"
    print $"Uptime: (sys host | get uptime | format duration)"
}
