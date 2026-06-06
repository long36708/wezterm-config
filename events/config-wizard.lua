--- WezTerm 配置向导
--- 通过命令面板提供交互式配置界面

local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

--- 主题选项
local theme_options = {
   { label = "🎨 Gruvbox (暖色调)", value = "gruvbox" },
   { label = "💜 Catppuccin (现代柔和)", value = "catppuccin" },
   { label = "🧛 Dracula (高对比度)", value = "dracula" },
   { label = "🌑 One Dark (VSCode风格)", value = "one_dark" },
}

--- 字体选项
local font_options = {
   { label = "JetBrains Mono (默认)", value = "jetbrains" },
   { label = "CaskaydiaCove Nerd Font", value = "caskaydia" },
   { label = "Fira Code", value = "fira_code" },
}

--- 窗口启动模式选项
local startup_options = {
   { label = "默认位置", value = "default" },
   { label = "屏幕居中", value = "centered" },
   { label = "最大化", value = "maximized" },
   { label = "全屏", value = "fullscreen" },
}

--- 加载当前配置
M.load_current_config = function()
   local ok, prefs = pcall(require, 'config.user_preferences')
   if not ok then
      wezterm.log_error("无法加载配置: " .. tostring(prefs))
      return nil
   end
   return prefs
end

--- 保存配置
M.save_config = function(prefs)
   -- 注意: Lua 无法直接写入文件,这里提供复制配置的指令
   local config_str = "return {\n"
   
   for key, value in pairs(prefs) do
      if type(value) == "string" then
         config_str = config_str .. string.format('   %s = "%s",\n', key, value)
      elseif type(value) == "number" or type(value) == "boolean" then
         config_str = config_str .. string.format('   %s = %s,\n', key, tostring(value))
      elseif type(value) == "table" then
         config_str = config_str .. string.format('   %s = {...},\n', key)
      end
   end
   
   config_str = config_str .. "}\n"
   
   return config_str
end

--- 显示主题选择器
M.show_theme_selector = function(window)
   if not window then
      window = wezterm.gui.gui_window()
      if not window then 
         wezterm.log_error("无法获取窗口")
         return 
      end
   end
   
   wezterm.log_info("正在打开主题选择器...")
   
   window:perform_action(act.InputSelector({
      action = wezterm.action_callback(function(win, pane, id, label)
         if label then
            wezterm.log_info(string.format("选择了主题: %s", label))
            for _, option in ipairs(theme_options) do
               if option.label == label then
                  M.apply_theme(win, option.value)
                  break
               end
            end
         else
            wezterm.log_info("取消选择")
         end
      end),
      title = "🎨 选择主题",
      description = "使用上下箭头选择，回车确认",
      choices = (function()
         local choices = {}
         for _, opt in ipairs(theme_options) do
            table.insert(choices, { label = opt.label, id = opt.value })
         end
         return choices
      end)(),
   }))
end

--- 应用主题
M.apply_theme = function(window, theme)
   local prefs = M.load_current_config()
   if prefs then
      prefs.theme = theme
      
      -- 显示确认信息
      window:perform_action(act.ShowOverlay(wezterm.format({
         { Text = string.format("✅ 主题已切换为: %s\n请手动保存到配置文件", theme) },
      })))
      
      wezterm.log_info(string.format("主题已切换为: %s (请手动保存到配置文件)", theme))
   end
end

--- 显示字体选择器
M.show_font_selector = function(window)
   if not window then
      window = wezterm.gui.gui_window()
      if not window then return end
   end
   window:perform_action(act.InputSelector({
      action = wezterm.action_callback(function(win, pane, id, label)
         if label then
            for _, option in ipairs(font_options) do
               if option.label == label then
                  M.apply_font(win, option.value)
                  break
               end
            end
         end
      end),
      title = "选择字体",
      description = "选择终端字体",
      choices = (function()
         local choices = {}
         for _, opt in ipairs(font_options) do
            table.insert(choices, { label = opt.label, id = opt.value })
         end
         return choices
      end)(),
   }))
end

--- 应用字体
M.apply_font = function(window, font_family)
   local prefs = M.load_current_config()
   if prefs then
      prefs.font_family = font_family
      wezterm.log_info(string.format("字体已切换为: %s (请手动保存到配置文件)", font_family))
   end
end

--- 显示主菜单
M.show_main_menu = function(window, pane)
   if not window then
      window = wezterm.gui.gui_window()
      if not window then
         wezterm.log_error("无法获取当前窗口")
         return
      end
   end
   window:perform_action(act.InputSelector({
      action = wezterm.action_callback(function(win, pane, id, label)
         if not label then return end
         
         if label == "🎨 切换主题" then
            M.show_theme_selector(win)
         elseif label == "🔤 切换字体" then
            M.show_font_selector(win)
         elseif label == "📋 查看当前配置" then
            M.show_current_config(win)
         elseif label == "✅ 验证配置" then
            M.validate_config(win)
         elseif label == "📊 快捷键冲突检测" then
            M.check_keybinds(win)
         end
      end),
      title = "⚙️ WezTerm 配置向导",
      description = "选择要执行的配置操作",
      choices = {
         { label = "🎨 切换主题", id = "theme" },
         { label = "🔤 切换字体", id = "font" },
         { label = "📋 查看当前配置", id = "view" },
         { label = "✅ 验证配置", id = "validate" },
         { label = "📊 快捷键冲突检测", id = "check" },
      },
   }))
end

--- 显示当前配置
M.show_current_config = function(window)
   if not window then
      window = wezterm.gui.gui_window()
      if not window then return end
   end
   local prefs = M.load_current_config()
   if not prefs then return end
   
   local config_text = string.format(
      "当前配置:\n\n" ..
      "主题: %s\n" ..
      "字体: %s\n" ..
      "字体大小: %s\n" ..
      "窗口启动: %s\n" ..
      "透明度: %s\n" ..
      "Fancy标签栏: %s\n",
      prefs.theme or "N/A",
      prefs.font_family or "N/A",
      prefs.font_size or "N/A",
      prefs.window_startup or "N/A",
      prefs.window_opacity or "N/A",
      tostring(prefs.use_fancy_tab_bar or false)
   )
   
   window:perform_action(act.ShowOverlay(wezterm.format({
      { Text = config_text },
   })))
end

--- 验证配置
M.validate_config = function(window)
   if not window then
      window = wezterm.gui.gui_window()
      if not window then return end
   end
   local validator = require('utils.config_validator')
   local result = validator.run_validation()
   
   window:perform_action(act.ShowOverlay(wezterm.format({
      { Text = result.report },
   })))
end

--- 检查快捷键冲突
M.check_keybinds = function(window)
   if not window then
      window = wezterm.gui.gui_window()
      if not window then return end
   end
   local checker = require('utils.keybind_checker')
   local conflicts, report = checker.run_check()
   
   window:perform_action(act.ShowOverlay(wezterm.format({
      { Text = report },
   })))
end

--- 注册事件处理器
M.setup = function()
   -- 注意: augment-command-palette 已移至 command-palette-enhanced.lua 中统一注册
   -- 这里保留 setup 函数以便兼容,但不再重复注册
   wezterm.log_info("配置向导模块已加载")
end

return M
