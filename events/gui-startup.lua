--- 窗口启动事件处理
--- 支持默认、居中、最大化等启动模式

local wezterm = require('wezterm')
local prefs = require('config.user_preferences')

local M = {}

M.setup = function()
   wezterm.on('gui-startup', function(cmd)
      local screen = wezterm.gui.screens().active
      local startup_mode = prefs.window_startup
      
      if startup_mode == 'centered' then
         -- 居中启动模式
         local width = screen.width * prefs.centered_window.width_ratio
         local height = screen.height * prefs.centered_window.height_ratio
         
         local tab, pane, window = wezterm.mux.spawn_window(cmd or {
            position = {
               x = (screen.width - width) / 2,
               y = (screen.height - height) / 2,
               origin = { Named = screen.name }
            }
         })
         
         window:gui_window():set_inner_size(width, height)
         
      elseif startup_mode == 'maximized' then
         -- 最大化启动模式
         local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
         window:gui_window():maximize()
         
      elseif startup_mode == 'fullscreen' then
         -- 全屏启动模式
         local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
         window:gui_window():toggle_fullscreen()
         
      else
         -- 默认启动模式
         wezterm.mux.spawn_window(cmd or {})
      end
   end)
end

return M
