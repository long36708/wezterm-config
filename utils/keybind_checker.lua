--- 快捷键冲突检测工具
--- 用于检测 bindings.lua 中的快捷键冲突

local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

--- 将快捷键转换为唯一标识字符串
local function key_to_string(key, mods)
   local parts = {}
   if mods then
      -- 标准化修饰键顺序
      local mod_list = {}
      for mod in string.gmatch(mods, '([^|]+)') do
         table.insert(mod_list, mod)
      end
      table.sort(mod_list)
      if #mod_list > 0 then
         table.insert(parts, table.concat(mod_list, '|'))
      end
   end
   table.insert(parts, key)
   return table.concat(parts, '+')
end

--- 检测快捷键冲突
M.check_conflicts = function(keys, key_tables)
   local conflicts = {}
   local key_map = {}
   
   -- 检查主快捷键表
   for i, binding in ipairs(keys) do
      local key_str = key_to_string(binding.key, binding.mods)
      
      if key_map[key_str] then
         table.insert(conflicts, {
            key = key_str,
            first = key_map[key_str],
            second = { index = i, binding = binding },
            type = 'duplicate'
         })
      else
         key_map[key_str] = { index = i, binding = binding }
      end
   end
   
   -- 检查与 key_tables 的冲突
   if key_tables then
      for table_name, table_keys in pairs(key_tables) do
         for _, binding in ipairs(table_keys) do
            local key_str = key_to_string(binding.key, 'LEADER')
            
            if key_map[key_str] then
               table.insert(conflicts, {
                  key = key_str,
                  first = key_map[key_str],
                  second = { table = table_name, binding = binding },
                  type = 'leader_conflict'
               })
            end
         end
      end
   end
   
   return conflicts
end

--- 格式化冲突报告
M.format_report = function(conflicts)
   if #conflicts == 0 then
      return "✅ 未检测到快捷键冲突!"
   end
   
   local report = {}
   table.insert(report, "⚠️  检测到快捷键冲突:")
   table.insert(report, "")
   
   for i, conflict in ipairs(conflicts) do
      table.insert(report, string.format("%d. 冲突键: %s", i, conflict.key))
      
      if conflict.type == 'duplicate' then
         table.insert(report, string.format(
            "   - 位置 #%d: %s",
            conflict.first.index,
            tostring(conflict.first.binding.action)
         ))
         table.insert(report, string.format(
            "   - 位置 #%d: %s",
            conflict.second.index,
            tostring(conflict.second.binding.action)
         ))
      elseif conflict.type == 'leader_conflict' then
         table.insert(report, string.format(
            "   - 主快捷键 #%d: %s",
            conflict.first.index,
            tostring(conflict.first.binding.action)
         ))
         table.insert(report, string.format(
            "   - Leader键表 '%s': %s",
            conflict.second.table,
            tostring(conflict.second.binding.action)
         ))
      end
      
      table.insert(report, "")
   end
   
   return table.concat(report, "\n")
end

--- 运行检测并输出结果
M.run_check = function()
   local bindings = require('config.bindings')
   local conflicts = M.check_conflicts(bindings.keys, bindings.key_tables)
   local report = M.format_report(conflicts)
   
   wezterm.log_info(report)
   
   -- 如果有冲突,也输出到警告
   if #conflicts > 0 then
      wezterm.log_warn("发现 ", #conflicts, " 个快捷键冲突!")
   else
      wezterm.log_info("所有快捷键配置正常!")
   end
   
   return conflicts, report
end

return M
