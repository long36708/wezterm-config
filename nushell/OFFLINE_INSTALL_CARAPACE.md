# Carapace 离线安装指南

## 🎯 适用场景

- ✅ 离线内网环境
- ✅ 无法访问互联网
- ✅ 无法使用 Scoop/Chocolatey 等包管理器

---

## 📥 步骤 1: 下载 Carapace（在有网络的机器上）

### 方法 A: 从 GitHub 下载

1. 访问：https://github.com/rsteube/carapace-bin/releases
2. 下载最新版本：`carapace_windows_amd64.zip`
3. 或使用 PowerShell 下载：

```powershell
# 下载最新版
Invoke-WebRequest -Uri "https://github.com/rsteube/carapace-bin/releases/latest/download/carapace_windows_amd64.zip" -OutFile "carapace.zip"

# 或下载指定版本（例如 v1.8.0）
Invoke-WebRequest -Uri "https://github.com/rsteube/carapace-bin/releases/download/v1.8.0/carapace_windows_amd64.zip" -OutFile "carapace.zip"
```

### 方法 B: 使用浏览器下载

1. 打开浏览器访问：https://github.com/rsteube/carapace-bin/releases/latest
2. 找到 `carapace_windows_amd64.zip`
3. 点击下载

---

## 📦 步骤 2: 传输到内网机器

### 方式选择

| 方式 | 说明 |
|------|------|
| **U盘** | 最简单直接 |
| **内网文件共享** | SMB/NFS 共享文件夹 |
| **内部邮件** | 通过公司邮件系统 |
| **光盘刻录** | 高安全性要求 |

### 推荐目录结构

```
D:\tools\
└── carapace\
    ├── carapace.exe          # 主程序
    ├── LICENSE               # 许可证
    └── README.md             # 说明文档
```

---

## 🔧 步骤 3: 解压和安装

### 解压文件

```powershell
# 创建目标目录
New-Item -ItemType Directory -Path "D:\tools\carapace" -Force

# 解压（假设 zip 文件在 D:\Downloads）
Expand-Archive -Path "D:\Downloads\carapace.zip" -DestinationPath "D:\tools\carapace" -Force
```

### 验证文件

```powershell
# 检查文件是否存在
Test-Path "D:\tools\carapace\carapace.exe"
# 应该输出: True

# 查看版本
& "D:\tools\carapace\carapace.exe" --version
```

---

## ⚙️ 步骤 4: 配置 PATH（二选一）

### 方法 A: 添加到系统 PATH（推荐）

#### 图形界面方式

1. 右键"此电脑" → "属性"
2. 点击"高级系统设置"
3. 点击"环境变量"
4. 在"用户变量"或"系统变量"中找到 `Path`
5. 点击"编辑" → "新建"
6. 添加：`D:\tools\carapace`
7. 点击"确定"保存

#### PowerShell 方式（管理员权限）

```powershell
# 添加到用户 PATH
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = $currentPath + ";D:\tools\carapace"
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# 验证
$env:PATH += ";D:\tools\carapace"
carapace --version
```

### 方法 B: 不修改 PATH（使用完整路径）

如果不想修改 PATH，config.nu 已经配置为使用完整路径：

```nu
let carapace_path = "D:\\bin\\carapace.exe"
```

**优点**：
- ✅ 无需修改系统配置
- ✅ 不影响其他程序
- ✅ 便于管理多个版本

**缺点**：
- ❌ 每次调用都需要完整路径
- ❌ 移动文件后需要更新配置

---

## ✅ 步骤 5: 验证安装

### 测试命令

```powershell
# 方法 1: 如果已添加到 PATH
carapace --version

# 方法 2: 使用完整路径
& "D:\bin\carapace.exe" --version
```

**预期输出**：
```
carapace version 1.x.x
```

### 测试 Nushell 补全

```nu
# 重启 Nushell 后测试
mise <TAB>              # 应该显示子命令列表
git <TAB>               # 应该显示 git 子命令
```

---

## 🔄 步骤 6: 同步配置

```bash
F:\learn-front\learn_cmd\wezterm\sync_nushell_config.bat
```

然后重启 Nushell。

---

## 🐛 故障排除

### 问题 1: "carapace" 不是内部或外部命令

**原因**：PATH 未正确配置

**解决方案**：

```powershell
# 检查 PATH
echo $env:PATH

# 临时添加（当前会话有效）
$env:PATH += ";D:\bin"

# 永久添加（需要管理员权限）
[Environment]::SetEnvironmentVariable(
    "Path", 
    [Environment]::GetEnvironmentVariable("Path", "User") + ";D:\bin", 
    "User"
)
```

### 问题 2: 补全仍然不工作

**检查步骤**：

```nu
# 1. 确认 carapace 可执行
^carapace --version

# 2. 测试 carapace 补全生成
^carapace mise nushell mise ""

# 3. 检查 config.nu 中的路径
open $env.NU_LIB_DIRS.0/config.nu | find "carapace_path"
```

**解决方案**：
- 确保 `carapace_path` 指向正确的文件
- 确保文件有执行权限
- 重启 Nushell

### 问题 3: 文件被阻止执行

**原因**：Windows Defender 或杀毒软件阻止

**解决方案**：

```powershell
# 解除文件阻止
Unblock-File -Path "D:\bin\carapace.exe"

# 或添加到杀毒软件白名单
```

---

## 📝 配置示例

### config.nu 中的配置

```nu
# Carapace 路径配置（当前实际配置）
let carapace_path = "D:\\bin\\carapace.exe"

# 使用 Carapace 的补全器
let multi_completer = {|spans|
    match $spans.0 {
        "mise" => {|s| 
            try {
                ^$carapace_path $s.0 nushell ...$s | from json
            } catch {
                []
            }
        }
        _ => {[]}
    } | do $in $spans
}

# 启用外部补全
$env.config.completions.external = {
    enable: true
    completer: $multi_completer
}
```

---

## 💡 最佳实践

### 1. 版本管理

```
D:\bin\
└── carapace.exe              # Carapace 主程序
```

### 2. 定期更新

即使在内网环境，也可以：
1. 在有网络的机器上下载新版本
2. 传输到内网
3. 替换旧版本
4. 测试兼容性

### 3. 备份配置

```powershell
# 备份 config.nu
Copy-Item "C:\Users\Administrator\AppData\Roaming\nushell\config.nu" `
          "C:\Users\Administrator\AppData\Roaming\nushell\config.nu.backup"
```

---

## 📊 离线 vs 在线安装对比

| 特性 | 在线安装 | 离线安装 |
|------|---------|---------|
| **便利性** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **速度** | 快 | 取决于传输方式 |
| **自动化** | ✅ 自动 | ❌ 手动 |
| **更新** | 一键更新 | 需手动替换 |
| **适用场景** | 有网络 | 内网/隔离环境 |

---

## 🔗 相关资源

- **Carapace Releases**: https://github.com/rsteube/carapace-bin/releases
- **Carapace Docs**: https://rsteube.github.io/carapace/
- **Nushell Completions**: https://www.nushell.sh/cookbook/external_completers.html

---

## ✅ 检查清单

- [ ] 从 GitHub 下载 carapace_windows_amd64.zip
- [ ] 传输到内网机器
- [ ] 解压到 D:\bin\（或自定义目录）
- [ ] 验证 carapace.exe 存在
- [ ] 添加到 PATH 或配置完整路径
- [ ] 运行 `carapace --version` 验证
- [ ] 同步 config.nu
- [ ] 重启 Nushell
- [ ] 测试 `mise <TAB>` 补全

---

**最后更新**：2026-06-07  
**适用环境**：离线内网 Windows 系统
