# 测试 Claude 补全是否加载成功

# 方法 1: 检查模块是否可以被 use
print "=== 测试 1: 尝试加载模块 ==="
try {
    use ~/AppData/Roaming/nushell/custom-completions/claude/claude-completions.nu *
    print "✅ 模块加载成功"
} catch {
    print $"❌ 模块加载失败: ($in)"
}

# 方法 2: 检查 help 命令
print "\n=== 测试 2: 检查 help claude ==="
try {
    help claude | first 5
    print "✅ help claude 可用"
} catch {
    print $"❌ help claude 不可用: ($in)"
}

# 方法 3: 列出所有 extern 定义
print "\n=== 测试 3: 检查已注册的补全 ==="
scope commands | where name =~ 'claude' | select name type
