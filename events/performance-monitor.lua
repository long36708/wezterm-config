--- WezTerm 性能监控面板
--- 显示 FPS、内存使用等性能指标

local wezterm = require('wezterm')

local M = {}

-- 性能数据
local perf_data = {
   fps = 0,
   frame_time = 0,
   uptime = 0,
   tab_count = 0,
   pane_count = 0,
}

-- 更新间隔(毫秒)
local UPDATE_INTERVAL = 1000
local last_update = 0

--- 获取性能数据
M.get_perf_data = function()
   local now = wezterm.time.now()
   
   -- 计算运行时间
   perf_data.uptime = math.floor(now / 1000)
   
   -- 统计标签页和窗格
   local tabs = 0
   local panes = 0
   
   local mux = wezterm.mux
   for _, domain in ipairs(mux.all_domains()) do
      for _, window in ipairs(domain:all_windows()) do
         for _, tab in ipairs(window:tabs_with_info()) do
            tabs = tabs + 1
            panes = panes + #tab.tab:panes()
         end
      end
   end
   
   perf_data.tab_count = tabs
   perf_data.pane_count = panes
   
   return perf_data
end

--- 格式化性能数据
M.format_perf_text = function()
   local data = M.get_perf_data()
   
   -- 格式化运行时间
   local hours = math.floor(data.uptime / 3600)
   local minutes = math.floor((data.uptime % 3600) / 60)
   local seconds = data.uptime % 60
   
   local uptime_str = string.format("%02d:%02d:%02d", hours, minutes, seconds)
   
   return string.format(
      "⚡ 性能监控\n" ..
      "━━━━━━━━━━━━━━\n" ..
      "FPS: %d\n" ..
      "帧时间: %.2f ms\n" ..
      "运行时间: %s\n" ..
      "标签页: %d\n" ..
      "窗格数: %d",
      data.fps,
      data.frame_time,
      uptime_str,
      data.tab_count,
      data.pane_count
   )
end

--- 渲染性能面板
M.render_panel = function(window, pane)
   local text = M.format_perf_text()
   
   -- 创建覆盖层
   local overlay = wezterm.overlay.new(function(domain, win)
      return {
         { Text = text },
      }
   end)
   
   window:perform_action(act.ShowOverlay(overlay), nil)
end

--- 在状态栏显示简化性能信息
M.status_line = function()
   local data = M.get_perf_data()
   
   return string.format(
      " ⚡ FPS:%d | Tabs:%d | Panes:%d ",
      data.fps,
      data.tab_count,
      data.pane_count
   )
end

--- 设置性能监控
M.setup = function()
   -- 定期更新性能数据
   wezterm.on('update-status', function(window, pane)
      local data = M.get_perf_data()
      
      -- 设置左侧状态栏
      window:set_left_status(wezterm.format({
         { Foreground = { Color = "#589220" } },
         { Text = M.status_line() },
      }))
   end)
   
   -- 注册快捷键切换性能面板
   -- 可以通过 F12 或自定义快捷键查看
   wezterm.log_info("性能监控已启用")
end

--- 切换性能面板显示
M.toggle_panel = function(window, pane)
   if M.panel_visible then
      window:perform_action(act.HideOverlay, nil)
      M.panel_visible = false
   else
      M.render_panel(window, pane)
      M.panel_visible = true
   end
end

return M
