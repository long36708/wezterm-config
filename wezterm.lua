local Config = require('config')

-- 加载事件处理器
require('events.right-status').setup()
require('events.tab-title').setup()
require('events.new-tab-button').setup()
require('events.gui-startup').setup() -- 窗口启动事件
require('events.config-wizard').setup() -- 配置向导
require('events.performance-monitor').setup() -- 性能监控

return Config:init()
   :append(require('config.appearance'))
   :append(require('config.bindings'))
   :append(require('config.domains'))
   :append(require('config.fonts'))
   :append(require('config.general'))
   :append(require('config.launch')).options
