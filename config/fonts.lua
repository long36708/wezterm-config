local wezterm = require('wezterm')
local platform = require('utils.platform')
local prefs = require('config.user_preferences')

-- 字体映射表
local font_map = {
   jetbrains = 'JetBrains Mono',
   caskaydia = 'CaskaydiaCove Nerd Font',
   fira_code = 'Fira Code',
}

-- 根据用户偏好选择字体
local font_name = font_map[prefs.font_family] or font_map.jetbrains
local font_size = prefs.font_size

return {
   font = wezterm.font(font_name),
   font_size = font_size,
   warn_about_missing_glyphs = false,

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
