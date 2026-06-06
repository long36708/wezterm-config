# 🛠️ WezTerm 高级工具使用指南

本文档介绍配置项目中包含的高级工具及其使用方法。

---

## 📋 目录

- [快捷键冲突检测工具](#快捷键冲突检测工具)
- [配置验证脚本](#配置验证脚本)
- [配置向导 GUI](#配置向导-gui)
- [性能监控面板](#性能监控面板)

---

## 🔍 快捷键冲突检测工具

**位置**: [`utils/keybind_checker.lua`](utils/keybind_checker.lua)

### 功能
- 自动检测 `bindings.lua` 中的快捷键冲突
- 检查主快捷键表与 Leader 键表的冲突
- 生成详细的冲突报告

### 使用方法

#### 方式1: 通过命令面板
1. 按 `F2` 打开命令面板
2. 搜索 "验证配置" 或 "快捷键冲突检测"
3. 查看检测结果

#### 方式2: 手动调用
在 WezTerm 调试控制台 (F12) 中执行:

```lua
local checker = require('utils.keybind_checker')
checker.run_check()
```

### 输出示例

```
✅ 未检测到快捷键冲突!
```

或

```
⚠️  检测到快捷键冲突:

1. 冲突键: CTRL+T
   - 位置 #5: SpawnTab 'DefaultDomain'
   - 位置 #12: SpawnCommandInNewTab {...}
```

---

## ✅ 配置验证脚本

**位置**: [`utils/config_validator.lua`](utils/config_validator.lua)

### 功能
- 验证 `user_preferences.lua` 配置的正确性
- 检查主题、字体、窗口模式等配置项
- 验证 WSL 发行版配置
- 自动生成验证报告

### 验证项目

| 项目 | 检查内容 |
|------|---------|
| 主题 | 是否为有效值 (gruvbox/catppuccin/dracula/one_dark) |
| 字体 | 是否为有效值 (jetbrains/caskaydia/fira_code) |
| 字体大小 | 是否在 6-72 范围内 |
| 窗口启动 | 是否为有效模式 (default/centered/maximized/fullscreen) |
| 透明度 | 是否在 0.0-1.0 范围内 |
| WSL配置 | 是否包含必需的 label 和 name 字段 |
| 快捷键 | 是否存在冲突 |

### 使用方法

#### 通过命令面板
1. 按 `F2` 打开命令面板
2. 选择 "✅ 验证配置"
3. 查看验证报告

#### 手动调用

```lua
local validator = require('utils.config_validator')
local result = validator.run_validation()
print(result.report)
```

### 验证报告示例

```
╔════════════════════════════════════════╗
║   WezTerm 配置验证报告                ║
╚════════════════════════════════════════╝

ℹ️  信息:
   [user_preferences] 主题配置正常: gruvbox
   [user_preferences] 字体配置正常: jetbrains
   [user_preferences] 已配置 1 个 WSL 发行版
   [themes] 主题 'gruvbox' 配置正常
   [themes] 主题 'catppuccin' 配置正常
   [bindings] 已定义 45 个快捷键
   [bindings] 快捷键无冲突

────────────────────────────────────────
状态: ✅ 通过
错误: 0 | 警告: 0 | 信息: 7
```

---

## ⚙️ 配置向导 GUI

**位置**: [`events/config-wizard.lua`](events/config-wizard.lua)

### 功能
- 提供交互式配置界面
- 快速切换主题和字体
- 查看当前配置
- 一键验证配置
- 快捷键冲突检测

### 打开方式

#### 方法1: 命令面板
1. 按 `F2` 打开命令面板
2. 搜索 "⚙️ 打开配置向导"
3. 回车进入向导界面

#### 方法2: 快捷键 (可选)
可以在 `bindings.lua` 中添加快捷键:

```lua
{
   key = 'C',
   mods = 'CTRL|SHIFT',
   action = act.Custom(require('events.config-wizard').show_main_menu),
},
```

### 向导菜单

```
⚙️ WezTerm 配置向导
━━━━━━━━━━━━━━━━━━━

🎨 切换主题
🔤 切换字体
📋 查看当前配置
✅ 验证配置
📊 快捷键冲突检测
```

### 使用流程

1. **切换主题**:
   - 选择 "🎨 切换主题"
   - 从列表中选择喜欢的主题
   - 立即预览效果

2. **切换字体**:
   - 选择 "🔤 切换字体"
   - 选择终端字体
   - 立即生效

3. **查看配置**:
   - 选择 "📋 查看当前配置"
   - 显示所有当前配置项

4. **验证配置**:
   - 选择 "✅ 验证配置"
   - 自动运行验证脚本
   - 显示验证报告

---

## 📊 性能监控面板

**位置**: [`events/performance-monitor.lua`](events/performance-monitor.lua)

### 功能
- 实时显示 FPS
- 显示帧时间
- 统计运行时间
- 统计标签页和窗格数量
- 在状态栏显示简化信息

### 自动显示

性能监控会自动在**左侧状态栏**显示简化信息:

```
⚡ FPS:60 | Tabs:3 | Panes:5
```

### 查看详细面板

可以通过以下方式查看详细性能面板:

#### 添加快捷键
在 `bindings.lua` 中添加:

```lua
{
   key = 'P',
   mods = 'CTRL|SHIFT',
   action = act.Custom(
      require('events.performance-monitor').toggle_panel
   ),
},
```

#### 面板内容

```
⚡ 性能监控
━━━━━━━━━━━━━━
FPS: 60
帧时间: 16.67 ms
运行时间: 02:35:42
标签页: 3
窗格数: 5
```

### 性能指标说明

| 指标 | 说明 | 正常范围 |
|------|------|---------|
| FPS | 每秒帧数 | 60+ 优秀, 30-60 良好 |
| 帧时间 | 每帧耗时 | <20ms 优秀, <33ms 良好 |
| 运行时间 | WezTerm 运行时长 | - |
| 标签页 | 当前打开的标签数 | - |
| 窗格数 | 所有标签的窗格总数 | - |

---

## 🎯 最佳实践

### 1. 定期验证配置

每次修改配置后,运行验证脚本:

```bash
# 通过命令面板
F2 → ✅ 验证配置
```

### 2. 检查快捷键冲突

添加新快捷键前,先运行冲突检测:

```bash
# 通过命令面板
F2 → 📊 快捷键冲突检测
```

### 3. 使用配置向导快速切换

需要更换主题或字体时,使用向导:

```bash
# 通过命令面板
F2 → ⚙️ 打开配置向导
```

### 4. 监控性能

如果发现终端卡顿,查看性能面板:

```bash
# 添加快捷键后按 Ctrl+Shift+P
# 或查看状态栏的 FPS 指示
```

---

## 🔧 自定义扩展

### 添加新的验证规则

编辑 `utils/config_validator.lua`:

```lua
M.validate_custom = function()
   local module = 'custom'
   
   -- 你的验证逻辑
   if some_condition then
      add_error(module, "发现错误")
   end
   
   return true
end
```

### 添加新的向导功能

编辑 `events/config-wizard.lua`:

```lua
M.show_custom_selector = function(window)
   window:perform_action(act.InputSelector({
      title = "自定义选择器",
      choices = { ... },
   })), nil)
end
```

### 扩展性能监控

编辑 `events/performance-monitor.lua`:

```lua
-- 添加新的性能指标
perf_data.custom_metric = calculate_something()
```

---

## 📝 注意事项

1. **配置保存**: 配置向导仅预览效果,不会自动保存文件。满意后需手动编辑 `user_preferences.lua` 保存。

2. **性能影响**: 性能监控会轻微影响性能,如需完全禁用可注释掉 `wezterm.lua` 中的相关行。

3. **日志查看**: 所有工具的详细输出都会记录在 WezTerm 日志中,可通过 F12 调试控制台查看。

4. **版本兼容**: 这些工具基于最新版本的 WezTerm API,确保你的 WezTerm 是最新版本。

---

## 🐛 故障排查

### 工具无法加载

检查 WezTerm 日志 (F12):
```lua
wezterm.log_info("检查日志")
```

### 配置向导不显示

确认已在 `wezterm.lua` 中正确加载:
```lua
require('events.config-wizard').setup()
```

### 性能监控数据不准确

重启 WezTerm 以重置统计数据。

---

## 🎉 结语

这些高级工具能帮助你更好地管理和优化 WezTerm 配置!

如有问题或建议,欢迎反馈。

Happy Configuring! 🚀
