--- 增强命令面板 - 添加中文快捷入口
local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- 导入配置向导功能
local config_wizard = require('events.config-wizard')

-- 切换主题并写入配置文件
M.switch_theme = function(theme_name)
   local valid_themes = { 'gruvbox', 'catppuccin', 'dracula', 'one_dark' }
   
   -- 验证主题名称
   local is_valid = false
   for _, t in ipairs(valid_themes) do
      if t == theme_name then
         is_valid = true
         break
      end
   end
   
   if not is_valid then
      wezterm.log_error("无效的主题: " .. theme_name)
      return
   end
   
   -- 获取配置文件路径
   local config_dir = wezterm.config_dir
   local prefs_file = config_dir .. '/config/user_preferences.lua'
   
   -- 读取文件内容
   local file = io.open(prefs_file, 'r')
   if not file then
      wezterm.log_error("无法打开配置文件: " .. prefs_file)
      return
   end
   
   local content = file:read('*all')
   file:close()
   
   -- 替换主题配置
   content = content:gsub('(theme%s*=%s*")[^"]*(")', '%1' .. theme_name .. '%2')
   
   -- 写回文件
   file = io.open(prefs_file, 'w')
   if not file then
      wezterm.log_error("无法写入配置文件: " .. prefs_file)
      return
   end
   
   file:write(content)
   file:flush()
   file:close()
   
   wezterm.log_info("✅ 主题已切换为: " .. theme_name)
   
   -- 重载配置
   local win = wezterm.gui.gui_window()
   if win then
      win:perform_action(act.ReloadConfiguration)
   end
end

M.setup = function()
   wezterm.on('augment-command-palette', function(window, pane)
      return {
         -- ==================== 配置向导 ====================
         {
            brief = "⚙️ 打开配置向导",
            icon = "md_settings",
            action = wezterm.action_callback(function(win, pane)
               config_wizard.show_main_menu(win, pane)
            end),
         },
         
         -- ==================== 快速切换主题 ====================
         {
            brief = "🎨 切换到 Gruvbox",
            icon = "md_palette",
            action = wezterm.action_callback(function(win, pane)
               M.switch_theme('gruvbox')
            end),
         },
         {
            brief = "🎨 切换到 Catppuccin",
            icon = "md_palette",
            action = wezterm.action_callback(function(win, pane)
               M.switch_theme('catppuccin')
            end),
         },
         {
            brief = "🎨 切换到 Dracula",
            icon = "md_palette",
            action = wezterm.action_callback(function(win, pane)
               M.switch_theme('dracula')
            end),
         },
         {
            brief = "🎨 切换到 One Dark",
            icon = "md_palette",
            action = wezterm.action_callback(function(win, pane)
               M.switch_theme('one_dark')
            end),
         },
         -- ==================== 标签页管理 ====================
         {
            brief = "📑 新建标签页",
            icon = "md_tab_plus",
            action = act.SpawnTab("CurrentPaneDomain"),
         },
         {
            brief = "❌ 关闭当前标签页",
            icon = "md_close_box",
            action = act.CloseCurrentTab({ confirm = true }),
         },
         {
            brief = "✏️ 重命名标签页",
            icon = "md_rename_box",
            action = act.PromptInputLine({
               description = "输入新标签页名称:",
               action = wezterm.action_callback(function(win, _, line)
                  if line then
                     win:active_tab():set_title(line)
                  end
               end),
            }),
         },

         -- ==================== 窗格管理 ====================
         {
            brief = "↔️ 水平拆分窗格",
            icon = "md_split_horizontal",
            action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
         },
         {
            brief = "↕️ 垂直拆分窗格",
            icon = "md_split_vertical",
            action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
         },
         {
            brief = "❌ 关闭当前窗格",
            icon = "md_close_circle",
            action = act.CloseCurrentPane({ confirm = true }),
         },
         {
            brief = "🔲 最大化当前窗格",
            icon = "md_fullscreen",
            action = act.TogglePaneZoomState,
         },

         -- ==================== 外观设置 ====================
         {
            brief = "🔄 重载配置",
            icon = "md_refresh",
            action = act.ReloadConfiguration,
         },
         {
            brief = "🔍 增大字体",
            icon = "md_format_font_size_increase",
            action = act.IncreaseFontSize,
         },
         {
            brief = "🔍 减小字体",
            icon = "md_format_font_size_decrease",
            action = act.DecreaseFontSize,
         },
         {
            brief = "🔍 重置字体大小",
            icon = "md_format_font",
            action = act.ResetFontSize,
         },

         -- ==================== 搜索与选择 ====================
         {
            brief = "🔎 搜索缓冲区",
            icon = "md_magnify",
            action = act.Search({ CaseSensitiveString = "" }),
         },
         {
            brief = "📋 复制模式",
            icon = "md_content_copy",
            action = act.ActivateCopyMode,
         },

         -- ==================== 其他功能 ====================
         {
            brief = "🖥️ 切换全屏",
            icon = "md_fullscreen_exit",
            action = act.ToggleFullScreen,
         },
         {
            brief = "📊 显示调试信息",
            icon = "md_bug",
            action = act.ShowDebugOverlay,
         },
         {
            brief = "😀 Emoji 选择器",
            icon = "md_emoticon",
            action = act.CharSelect({
               copy_on_select = true,
            }),
         },
      }
   end)
end

return M
