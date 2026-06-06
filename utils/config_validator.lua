--- WezTerm 配置验证工具
--- 验证所有配置文件的正确性

local wezterm = require('wezterm')

local M = {}

--- 验证结果收集
local validation_results = {
   errors = {},
   warnings = {},
   info = {}
}

--- 添加错误
local function add_error(module, message)
   table.insert(validation_results.errors, {
      module = module,
      message = message
   })
end

--- 添加警告
local function add_warning(module, message)
   table.insert(validation_results.warnings, {
      module = module,
      message = message
   })
end

--- 添加信息
local function add_info(module, message)
   table.insert(validation_results.info, {
      module = module,
      message = message
   })
end

--- 验证用户偏好配置
M.validate_preferences = function()
   local module = 'user_preferences'
   
   local ok, prefs = pcall(require, 'config.user_preferences')
   if not ok then
      add_error(module, "无法加载配置文件: " .. tostring(prefs))
      return false
   end
   
   -- 验证主题
   local valid_themes = { 'gruvbox', 'catppuccin', 'dracula', 'one_dark' }
   local theme_valid = false
   for _, t in ipairs(valid_themes) do
      if prefs.theme == t then
         theme_valid = true
         break
      end
   end
   if not theme_valid then
      add_warning(module, string.format(
         "未知主题 '%s',可用值: %s",
         prefs.theme,
         table.concat(valid_themes, ', ')
      ))
   else
      add_info(module, "主题配置正常: " .. prefs.theme)
   end
   
   -- 验证字体
   local valid_fonts = { 'jetbrains', 'caskaydia', 'fira_code' }
   local font_valid = false
   for _, f in ipairs(valid_fonts) do
      if prefs.font_family == f then
         font_valid = true
         break
      end
   end
   if not font_valid then
      add_warning(module, string.format(
         "未知字体 '%s',可用值: %s",
         prefs.font_family,
         table.concat(valid_fonts, ', ')
      ))
   else
      add_info(module, "字体配置正常: " .. prefs.font_family)
   end
   
   -- 验证字体大小
   if type(prefs.font_size) ~= 'number' or prefs.font_size < 6 or prefs.font_size > 72 then
      add_warning(module, "字体大小应在 6-72 之间")
   end
   
   -- 验证窗口启动模式
   local valid_startup = { 'default', 'centered', 'maximized', 'fullscreen' }
   local startup_valid = false
   for _, s in ipairs(valid_startup) do
      if prefs.window_startup == s then
         startup_valid = true
         break
      end
   end
   if not startup_valid then
      add_warning(module, string.format(
         "未知启动模式 '%s'",
         prefs.window_startup
      ))
   end
   
   -- 验证透明度
   if prefs.window_opacity and (prefs.window_opacity < 0 or prefs.window_opacity > 1) then
      add_error(module, "窗口透明度应在 0.0-1.0 之间")
   end
   
   -- 验证 WSL 配置
   if prefs.wsl_distros then
      if type(prefs.wsl_distros) ~= 'table' then
         add_error(module, "wsl_distros 必须是表格类型")
      else
         for i, distro in ipairs(prefs.wsl_distros) do
            if not distro.label or not distro.name then
               add_error(module, string.format(
                  "WSL 发行版 #%d 缺少 label 或 name 字段",
                  i
               ))
            end
         end
         add_info(module, string.format("已配置 %d 个 WSL 发行版", #prefs.wsl_distros))
      end
   end
   
   return #validation_results.errors == 0
end

--- 验证主题配置
M.validate_themes = function()
   local module = 'themes'
   
   local ok, themes = pcall(require, 'config.themes')
   if not ok then
      add_error(module, "无法加载主题配置: " .. tostring(themes))
      return false
   end
   
   -- 检查必需的主题是否存在
   local required_themes = { 'gruvbox', 'catppuccin' }
   for _, theme_name in ipairs(required_themes) do
      if not themes[theme_name] then
         add_error(module, string.format("缺少必需主题: %s", theme_name))
      else
         local theme = themes[theme_name]
         
         -- 验证主题结构
         if not theme.color_scheme then
            add_warning(module, string.format("主题 '%s' 缺少 color_scheme", theme_name))
         end
         
         add_info(module, string.format("主题 '%s' 配置正常", theme_name))
      end
   end
   
   return #validation_results.errors == 0
end

--- 验证绑定配置
M.validate_bindings = function()
   local module = 'bindings'
   
   local ok, bindings = pcall(require, 'config.bindings')
   if not ok then
      add_error(module, "无法加载绑定配置: " .. tostring(bindings))
      return false
   end
   
   -- 检查必需的字段
   if not bindings.keys then
      add_error(module, "缺少 keys 配置")
   else
      add_info(module, string.format("已定义 %d 个快捷键", #bindings.keys))
   end
   
   if not bindings.mouse_bindings then
      add_warning(module, "未配置鼠标绑定")
   end
   
   -- 使用冲突检测工具
   local checker = require('utils.keybind_checker')
   local conflicts = checker.check_conflicts(bindings.keys, bindings.key_tables)
   
   if #conflicts > 0 then
      add_error(module, string.format("检测到 %d 个快捷键冲突", #conflicts))
   else
      add_info(module, "快捷键无冲突")
   end
   
   return #validation_results.errors == 0
end

--- 生成验证报告
M.generate_report = function()
   local report = {}
   
   table.insert(report, "╔════════════════════════════════════════╗")
   table.insert(report, "║   WezTerm 配置验证报告                ║")
   table.insert(report, "╚════════════════════════════════════════╝")
   table.insert(report, "")
   
   -- 错误
   if #validation_results.errors > 0 then
      table.insert(report, "❌ 错误:")
      for _, err in ipairs(validation_results.errors) do
         table.insert(report, string.format("   [%s] %s", err.module, err.message))
      end
      table.insert(report, "")
   end
   
   -- 警告
   if #validation_results.warnings > 0 then
      table.insert(report, "⚠️  警告:")
      for _, warn in ipairs(validation_results.warnings) do
         table.insert(report, string.format("   [%s] %s", warn.module, warn.message))
      end
      table.insert(report, "")
   end
   
   -- 信息
   if #validation_results.info > 0 then
      table.insert(report, "ℹ️  信息:")
      for _, info in ipairs(validation_results.info) do
         table.insert(report, string.format("   [%s] %s", info.module, info.message))
      end
      table.insert(report, "")
   end
   
   -- 总结
   table.insert(report, "────────────────────────────────────────")
   local status = "✅ 通过"
   if #validation_results.errors > 0 then
      status = "❌ 失败"
   elseif #validation_results.warnings > 0 then
      status = "⚠️  通过(有警告)"
   end
   
   table.insert(report, string.format("状态: %s", status))
   table.insert(report, string.format("错误: %d | 警告: %d | 信息: %d",
      #validation_results.errors,
      #validation_results.warnings,
      #validation_results.info
   ))
   
   return table.concat(report, "\n")
end

--- 运行完整验证
M.run_validation = function()
   -- 重置结果
   validation_results = { errors = {}, warnings = {}, info = {} }
   
   -- 执行各项验证
   M.validate_preferences()
   M.validate_themes()
   M.validate_bindings()
   
   -- 生成并输出报告
   local report = M.generate_report()
   wezterm.log_info(report)
   
   -- 返回验证结果
   return {
      success = #validation_results.errors == 0,
      errors = validation_results.errors,
      warnings = validation_results.warnings,
      info = validation_results.info,
      report = report
   }
end

return M
