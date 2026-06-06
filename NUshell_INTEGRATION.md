# WezTerm + Nushell 集成优化指南

## 📋 已完成的优化

### 1. WezTerm 配置优化 ✅

**文件**: `config/launch.lua`

**更改内容**:
```lua
-- 添加 -l 参数,以 login shell 模式启动 Nushell
options.default_prog = { 'C:\\Users\\Administrator\\AppData\\Local\\Programs\\nu\\bin\\nu.exe', '-l' }
```

**好处**:
- ✅ 加载完整的用户配置文件 (`config.nu`)
- ✅ 确保环境变量正确设置
- ✅ 支持更完整的 Shell 功能

---

## 🔧 需要手动应用的优化

### 2. Nushell 配置增强

**步骤**:

1. **打开 Nushell 配置文件**:
   ```powershell
   notepad C:\Users\Administrator\AppData\Roaming\nushell\config.nu
   ```

2. **复制以下内容到文件末尾**:
   
   参考文件: `nushell-integration-additions.nu`

3. **保存并重启 WezTerm**

---

## 🎯 新增功能详解

### 📂 快速目录导航

```nushell
ctf          # 进入 CTF_Tools 目录
scripts      # 进入 CTF_Script 目录
wsl-tools    # 进入 WSL 工具目录
```

**使用示例**:
```nushell
$ ctf
F:\CTF\ProgramFiles\CTF\CTF_Tools> 
```

---

### 🌐 代理管理增强

```nushell
proxy-on     # 启用代理 (socks5://127.0.0.1:10808)
proxy-off    # 禁用代理
proxy-test   # 测试代理连接
scan-proxy   # 一键设置并测试代理
```

**使用示例**:
```nushell
$ scan-proxy
Try to connect to Google...
Proxy setup succeeded!
```

---

### 🔔 WezTerm 通知

```nushell
notify "任务完成!"  # 在 WezTerm 中显示桌面通知
```

**使用场景**:
```nushell
# 长时间运行的任务完成后通知
$ long-running-command; notify "处理完成!"
```

---

### 🛠️ CTF 工具信息

```nushell
ctf-tools-info  # 查看已安装的 CTF 工具版本和路径
```

**输出示例**:
```
=== CTF Tools Info ===

Python: Python 3.11.5
Neovim: NVIM v0.9.4
Git: git version 2.42.0.windows.2

Tools Dir: F:\CTF\ProgramFiles\CTF\CTF_Tools\
Script Dir: F:\CTF\ProgramFiles\CTF\CTF_Script\
```

---

### 📁 文件操作增强

```nushell
here              # 用 VS Code 打开当前目录
find-large        # 查找大于 100MB 的文件
find-large "1GB"  # 查找大于 1GB 的文件
```

**使用示例**:
```nushell
$ find-large
╭───┬──────────────┬────────┬──────╮
│ # │     name     │  type  │ size │
├───┼──────────────┼────────┼──────┤
│ 0 │ largefile.iso│ file   │ 2.1G │
│ 1 │ backup.zip   │ file   │ 500M │
╰───┴──────────────┴────────┴──────╯
```

---

### 🔍 进程管理

```nushell
port-usage 8080  # 查看占用 8080 端口的进程
```

**使用示例**:
```nushell
$ port-usage 8080
TCP    0.0.0.0:8080    0.0.0.0:0    LISTENING    12345
```

---

### 💻 系统信息

```nushell
sys-info  # 显示系统详细信息
```

**输出示例**:
```
=== System Info ===
OS: Windows 11 Pro 24H2
CPU: 16 cores
Memory: 32.0 GB
Uptime: 2d 5h 30m
```

---

## 🚀 完整工作流程示例

### 场景 1: CTF 比赛准备

```nushell
# 1. 进入工具目录
$ ctf

# 2. 检查代理
$ proxy-test

# 3. 查看工具信息
$ ctf-tools-info

# 4. 开始工作
$ mimikatz
```

### 场景 2: 流量分析

```nushell
# 1. 进入脚本目录
$ scripts

# 2. 设置代理
$ proxy-on

# 3. 解密冰蝎流量
$ BehinderBuster capture.pcap key.txt

# 4. 完成后通知
$ notify "流量解密完成!"
```

### 场景 3: 系统诊断

```nushell
# 1. 查看系统信息
$ sys-info

# 2. 检查端口占用
$ port-usage 8080

# 3. 查找大文件
$ find-large "500MB"
```

---

## 📝 自定义建议

### 添加更多工具别名

根据你的实际需求,可以继续添加:

```nushell
# 示例: 添加新的 CTF 工具
alias new-tool = F:\path\to\tool.exe

# 示例: 添加 Python 脚本快捷方式
alias my-script = D:\Python\python.exe $"($ScriptDir)my-script/main.py"
```

### 创建自定义函数

```nushell
# 示例: 一键开始 CTF 会话
def start-ctf [] {
    ctf
    proxy-on
    ctf-tools-info
    notify "CTF 环境已就绪!"
}
```

---

## ⚙️ 故障排除

### 问题 1: `wezterm cli toast` 不可用

**原因**: WezTerm CLI 未添加到 PATH

**解决**:
```powershell
# 将 WezTerm 安装目录添加到系统 PATH
# 或使用完整路径
^"C:\Program Files\WezTerm\wezterm.exe" cli toast "消息"
```

### 问题 2: 别名不生效

**原因**: 配置文件未重新加载

**解决**:
```nushell
# 方法 1: 重启 WezTerm
# 方法 2: 重新加载配置
$ source $env.config-env.NUSHELL_CONFIG_PATH
```

### 问题 3: `-l` 参数导致启动缓慢

**原因**: Login shell 会加载额外的配置文件

**解决**:
```lua
-- 在 config/launch.lua 中移除 -l 参数
options.default_prog = { 'C:\\Users\\Administrator\\AppData\\Local\\Programs\\nu\\bin\\nu.exe' }
```

---

## 📚 相关资源

- [Nushell 官方文档](https://www.nushell.sh/)
- [WezTerm 配置指南](https://wezfurlong.org/wezterm/config/index.html)
- [Nushell 插件生态](https://www.nushell.sh/book/plugins.html)

---

## 🎉 总结

通过以上优化,你将获得:

✅ **更快的导航** - 一键进入常用目录  
✅ **更方便的代理管理** - 简化的代理切换命令  
✅ **更好的 WezTerm 集成** - 桌面通知支持  
✅ **完善的工具信息** - 快速查看 CTF 工具状态  
✅ **高效的文件操作** - 智能文件搜索和管理  
✅ **便捷的进程管理** - 快速定位端口占用  

享受你的 CTF 之旅! 🚀
