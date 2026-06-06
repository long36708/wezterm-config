--- 主题配置模块
--- 支持多种配色方案快速切换

local wezterm = require('wezterm')

-- Catppuccin Mocha 配色 (来自 Blog 文档)
local catppuccin_mocha = {
   rosewater = "#f5e0dc",
   flamingo = "#f2cdcd",
   pink = "#f5c2e7",
   mauve = "#cba6f7",
   red = "#f38ba8",
   maroon = "#eba0ac",
   peach = "#fab387",
   yellow = "#f9e2af",
   green = "#a6e3a1",
   teal = "#94e2d5",
   sky = "#89dceb",
   sapphire = "#74c7ec",
   blue = "#89b4fa",
   lavender = "#b4befe",
   text = "#cdd6f4",
   subtext1 = "#bac2de",
   subtext0 = "#a6adc8",
   overlay2 = "#9399b2",
   overlay1 = "#7f849c",
   overlay0 = "#6c7086",
   surface2 = "#585b70",
   surface1 = "#45475a",
   surface0 = "#313244",
   base = "#1e1e2e",
   mantle = "#181825",
   crust = "#11111b",
}

-- Dracula 配色
local dracula = {
   bg = "#282a36",
   fg = "#f8f8f2",
   selection = "#44475a",
   comment = "#6272a4",
   red = "#ff5555",
   orange = "#ffb86c",
   yellow = "#f1fa8c",
   green = "#50fa7b",
   purple = "#bd93f9",
   cyan = "#8be9fd",
   pink = "#ff79c6",
}

-- One Dark 配色
local one_dark = {
   bg = "#282c34",
   fg = "#abb2bf",
   selection = "#3e4451",
   comment = "#5c6370",
   red = "#e06c75",
   orange = "#d19a66",
   yellow = "#e5c07b",
   green = "#98c379",
   purple = "#c678dd",
   cyan = "#56b6c2",
   white = "#abb2bf",
}

return {
   -- ==================== Gruvbox Dark Medium ====================
   gruvbox = {
      color_scheme = "Gruvbox dark, medium (base16)",
      colors = nil, -- 使用内置配色
      tab_bar_colors = {
         background = "#282828",
         active_tab = {
            bg_color = "#504945",
            fg_color = "#ebdbb2",
         },
         inactive_tab = {
            bg_color = "#3c3836",
            fg_color = "#a89984",
         },
         inactive_tab_hover = {
            bg_color = "#504945",
            fg_color = "#ebdbb2",
         },
         new_tab = {
            bg_color = "#282828",
            fg_color = "#ebdbb2",
         },
         new_tab_hover = {
            bg_color = "#504945",
            fg_color = "#ebdbb2",
         },
      },
   },

   -- ==================== Catppuccin Mocha ====================
   catppuccin = {
      color_scheme = "Catppuccin Mocha",
      colors = {
         foreground = catppuccin_mocha.text,
         background = catppuccin_mocha.base,
         cursor_bg = catppuccin_mocha.rosewater,
         cursor_border = catppuccin_mocha.rosewater,
         cursor_fg = catppuccin_mocha.crust,
         selection_bg = catppuccin_mocha.surface2,
         selection_fg = catppuccin_mocha.text,
         ansi = {
            "#0C0C0C", -- black
            "#C50F1F", -- red
            "#13A10E", -- green
            "#C19C00", -- yellow
            "#0037DA", -- blue
            "#881798", -- magenta/purple
            "#3A96DD", -- cyan
            "#CCCCCC", -- white
         },
         brights = {
            "#767676", -- black
            "#E74856", -- red
            "#16C60C", -- green
            "#F9F1A5", -- yellow
            "#3B78FF", -- blue
            "#B4009E", -- magenta/purple
            "#61D6D6", -- cyan
            "#F2F2F2", -- white
         },
         tab_bar = {
            background = catppuccin_mocha.crust,
            active_tab = {
               bg_color = catppuccin_mocha.surface2,
               fg_color = catppuccin_mocha.text,
            },
            inactive_tab = {
               bg_color = catppuccin_mocha.surface0,
               fg_color = catppuccin_mocha.subtext1,
            },
            inactive_tab_hover = {
               bg_color = catppuccin_mocha.surface0,
               fg_color = catppuccin_mocha.text,
            },
            new_tab = {
               bg_color = catppuccin_mocha.base,
               fg_color = catppuccin_mocha.text,
            },
            new_tab_hover = {
               bg_color = catppuccin_mocha.mantle,
               fg_color = catppuccin_mocha.text,
               italic = true,
            },
         },
         scrollbar_thumb = catppuccin_mocha.surface2,
         split = catppuccin_mocha.overlay0,
      },
      tab_bar_colors = {
         background = catppuccin_mocha.crust,
         active_tab = {
            bg_color = catppuccin_mocha.surface2,
            fg_color = catppuccin_mocha.text,
         },
         inactive_tab = {
            bg_color = catppuccin_mocha.surface0,
            fg_color = catppuccin_mocha.subtext1,
         },
         inactive_tab_hover = {
            bg_color = catppuccin_mocha.surface0,
            fg_color = catppuccin_mocha.text,
         },
         new_tab = {
            bg_color = catppuccin_mocha.base,
            fg_color = catppuccin_mocha.text,
         },
         new_tab_hover = {
            bg_color = catppuccin_mocha.mantle,
            fg_color = catppuccin_mocha.text,
         },
      },
   },

   -- ==================== Dracula ====================
   dracula = {
      color_scheme = "Dracula",
      colors = {
         foreground = dracula.fg,
         background = dracula.bg,
         cursor_bg = dracula.pink,
         cursor_border = dracula.pink,
         cursor_fg = dracula.bg,
         selection_bg = dracula.selection,
         selection_fg = dracula.fg,
         ansi = {
            "#21222C", -- black
            dracula.red, -- red
            dracula.green, -- green
            dracula.yellow, -- yellow
            "#BD93F9", -- blue
            dracula.purple, -- magenta/purple
            dracula.cyan, -- cyan
            "#F8F8F2", -- white
         },
         brights = {
            "#6272A4", -- black
            dracula.red, -- red
            dracula.green, -- green
            dracula.yellow, -- yellow
            "#D6ACFF", -- blue
            dracula.purple, -- magenta/purple
            dracula.cyan, -- cyan
            "#FFFFFF", -- white
         },
         tab_bar = {
            background = "#191A21",
            active_tab = {
               bg_color = dracula.selection,
               fg_color = dracula.fg,
            },
            inactive_tab = {
               bg_color = "#21222C",
               fg_color = dracula.comment,
            },
            inactive_tab_hover = {
               bg_color = dracula.selection,
               fg_color = dracula.fg,
            },
            new_tab = {
               bg_color = dracula.bg,
               fg_color = dracula.fg,
            },
            new_tab_hover = {
               bg_color = dracula.selection,
               fg_color = dracula.purple,
            },
         },
         scrollbar_thumb = dracula.selection,
         split = dracula.comment,
      },
      tab_bar_colors = {
         background = "#191A21",
         active_tab = {
            bg_color = dracula.selection,
            fg_color = dracula.fg,
         },
         inactive_tab = {
            bg_color = "#21222C",
            fg_color = dracula.comment,
         },
         inactive_tab_hover = {
            bg_color = dracula.selection,
            fg_color = dracula.fg,
         },
         new_tab = {
            bg_color = dracula.bg,
            fg_color = dracula.fg,
         },
         new_tab_hover = {
            bg_color = dracula.selection,
            fg_color = dracula.purple,
         },
      },
   },

   -- ==================== One Dark ====================
   one_dark = {
      color_scheme = "OneDark",
      colors = {
         foreground = one_dark.fg,
         background = one_dark.bg,
         cursor_bg = one_dark.white,
         cursor_border = one_dark.white,
         cursor_fg = one_dark.bg,
         selection_bg = one_dark.selection,
         selection_fg = one_dark.fg,
         ansi = {
            "#282c34", -- black
            one_dark.red, -- red
            one_dark.green, -- green
            one_dark.yellow, -- yellow
            "#61AFEF", -- blue
            one_dark.purple, -- magenta/purple
            one_dark.cyan, -- cyan
            one_dark.white, -- white
         },
         brights = {
            "#5C6370", -- black
            one_dark.red, -- red
            one_dark.green, -- green
            one_dark.yellow, -- yellow
            "#61AFEF", -- blue
            one_dark.purple, -- magenta/purple
            one_dark.cyan, -- cyan
            "#ABB2BF", -- white
         },
         tab_bar = {
            background = "#21252B",
            active_tab = {
               bg_color = one_dark.selection,
               fg_color = one_dark.fg,
            },
            inactive_tab = {
               bg_color = "#282c34",
               fg_color = one_dark.comment,
            },
            inactive_tab_hover = {
               bg_color = one_dark.selection,
               fg_color = one_dark.fg,
            },
            new_tab = {
               bg_color = one_dark.bg,
               fg_color = one_dark.fg,
            },
            new_tab_hover = {
               bg_color = one_dark.selection,
               fg_color = one_dark.blue,
            },
         },
         scrollbar_thumb = one_dark.selection,
         split = one_dark.comment,
      },
      tab_bar_colors = {
         background = "#21252B",
         active_tab = {
            bg_color = one_dark.selection,
            fg_color = one_dark.fg,
         },
         inactive_tab = {
            bg_color = "#282c34",
            fg_color = one_dark.comment,
         },
         inactive_tab_hover = {
            bg_color = one_dark.selection,
            fg_color = one_dark.fg,
         },
         new_tab = {
            bg_color = one_dark.bg,
            fg_color = one_dark.fg,
         },
         new_tab_hover = {
            bg_color = one_dark.selection,
            fg_color = one_dark.blue,
         },
      },
   },
}
