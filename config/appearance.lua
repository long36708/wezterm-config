local wezterm = require('wezterm')
local colors = require('colors.custom')
local prefs = require('config.user_preferences')
local themes = require('config.themes')
-- local fonts = require('config.fonts')
local gpus = wezterm.gui.enumerate_gpus()

-- 根据用户偏好选择主题
local selected_theme = themes[prefs.theme] or themes.gruvbox

return {
   term = 'xterm-256color',
   animation_fps = 60,
   max_fps = 60,
   webgpu_preferred_adapter = gpus[1],
   front_end = 'WebGpu', -- WebGpu OpenGL
   webgpu_power_preference = 'HighPerformance',

   -- color scheme - 根据偏好动态选择
   color_scheme = selected_theme.color_scheme,
   colors = selected_theme.colors,

   -- background
   window_background_opacity = prefs.window_opacity,
   -- win32_system_backdrop = 'Acrylic',
   --background = {
   --   {
   --      source = { File = wezterm.config_dir .. '/backdrops/space.jpg' },
   --   },
   --   {
   --      source = { Color = colors.background },
   --      height = '100%',
   --      width = '100%',
   --      opacity = 0.85,
   --   },
   --},

   -- scrollbar
   enable_scroll_bar = prefs.show_scrollbar,
   min_scroll_bar_height = '3cell',
   colors = {
      scrollbar_thumb = '#454545',
   },

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = prefs.use_fancy_tab_bar,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = true,
   switch_to_last_active_tab_when_closing_tab = true,

   -- cursor
   default_cursor_style = 'BlinkingBlock',
   cursor_blink_ease_in = 'Constant',
   cursor_blink_ease_out = 'Constant',
   cursor_blink_rate = 700,

   -- window
   window_decorations = 'INTEGRATED_BUTTONS|RESIZE',
   integrated_title_button_style = 'Windows',
   integrated_title_button_color = 'auto',
   integrated_title_button_alignment = 'Right',
   initial_cols = 120,
   initial_rows = 24,
   window_padding = {
      left = 5,
      right = 10,
      top = 12,
      bottom = 7,
   },
   window_close_confirmation = 'AlwaysPrompt',
   window_frame = {
      active_titlebar_bg = '#090909',
      -- font = fonts.font,
      -- font_size = fonts.font_size,
   },
   inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
}
