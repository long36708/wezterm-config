--- 用户偏好配置
--- 修改此文件可快速切换主题、字体、快捷键风格等

return {
   -- ==================== 主题配置 ====================
   -- 可选值: "gruvbox" | "catppuccin" | "dracula" | "one_dark"
   theme = "gruvbox",

   -- ==================== 字体配置 ====================
   -- 可选值: "jetbrains" | "caskaydia" | "fira_code"
   font_family = "jetbrains",
   
   -- 字体大小 (Windows/Mac 会自动适配,此处为基准大小)
   font_size = 11,

   -- ==================== 快捷键风格 ====================
   -- 可选值: "vim_like" (ALT+hjkl) | "traditional" (方向键)
   keybinding_style = "vim_like",
   
   -- 是否启用 Leader 键模式 (Ctrl+Shift+Space)
   enable_leader_keys = true,

   -- ==================== 窗口启动行为 ====================
   -- 可选值: "default" | "centered" | "maximized" | "fullscreen"
   window_startup = "default",
   
   -- 居中启动时的窗口尺寸 (仅在 window_startup = "centered" 时生效)
   centered_window = {
      width_ratio = 0.5,   -- 宽度占屏幕的 50%
      height_ratio = 0.5,  -- 高度占屏幕的 50%
   },

   -- ==================== WSL 配置 ====================
   -- 启用的 WSL 发行版列表
   wsl_distros = {
      { label = "Ubuntu", name = "Ubuntu" },
      -- 取消注释以启用更多发行版:
      -- { label = "Ubuntu 20.04", name = "Ubuntu-20.04" },
      -- { label = "Kali Linux", name = "kali-linux" },
   },

   -- ==================== 外观配置 ====================
   -- 使用 Fancy Tab Bar (自定义标签栏样式)
   use_fancy_tab_bar = true,
   
   -- 窗口透明度 (0.0 - 1.0)
   window_opacity = 0.95,
   
   -- 背景图片 (留空则不使用)
   background_image = "", -- 例如: "backdrops/space.jpg"

   -- ==================== 功能开关 ====================
   -- 显示滚动条
   show_scrollbar = true,
   
   -- 自动重载配置
   auto_reload_config = true,
   
   -- 检查更新
   check_updates = false,
}
