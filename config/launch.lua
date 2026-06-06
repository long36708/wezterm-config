local platform = require('utils.platform')()
local prefs = require('config.user_preferences')

local options = {
   default_prog = {},
   launch_menu = {},
}

if platform.is_win then
   options.default_prog = { 'powershell' }
   
   -- 构建 WSL 启动菜单
   local wsl_items = {}
   for _, distro in ipairs(prefs.wsl_distros) do
      table.insert(wsl_items, {
         label = "WSL: " .. distro.label,
         args = { 'wsl', '-d', distro.name },
      })
   end
   
   -- 合并启动菜单
   options.launch_menu = {
      { label = 'PowerShell', args = { 'powershell' } },
      { label = 'Cmd', args = { 'cmd' } },
      { label = 'Nushell', args = { 'nu' } },
      {
         label = 'Git Bash',
         args = { 'D:\\software\\GIT\\Git\\bin\\bash.exe' },
      },
   }
   
   -- 添加 WSL 选项
   for _, item in ipairs(wsl_items) do
      table.insert(options.launch_menu, item)
   end
   
   -- 添加其他选项
   table.insert(options.launch_menu, {
      label = '虚拟机',
      args = { 'ssh', 'tongwz@192.168.56.101'},
   })
   
elseif platform.is_mac then
   options.default_prog = { '/opt/homebrew/bin/fish' }
   options.launch_menu = {
      { label = 'Bash', args = { 'bash' } },
      { label = 'Fish', args = { '/opt/homebrew/bin/fish' } },
      { label = 'Nushell', args = { '/opt/homebrew/bin/nu' } },
      { label = 'Zsh', args = { 'zsh' } },
   }
end

return options
