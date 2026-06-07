# nu-version: 0.102.0
# Mise CLI completions for Nushell
# Based on mise skill documentation

def "nu-complete mise scope" [] {
    [local user project]
}

def "nu-complete mise env-format" [] {
    [json bash fish zsh nu]
}

def "nu-complete mise output-format" [] {
    [json table]
}

def "nu-complete mise tool-backend" [] {
    [asdf npm cargo pipx go github ubi spm]
}

def "nu-complete mise task-run-output" [] {
    [prefix prefix-interleaved keep-order]
}

def "nu-complete mise watch-watch-path" [] {
    [change create delete]
}

def "nu-complete mise bool" [] {
    [true false]
}

# Mise - polyglot development tool manager
export extern mise [
    --help(-h)                                              # Show help
    --version(-V)                                           # Show version
    ...args: string                                         # Subcommand
]

# --- Tool Management ---

# Install a tool version
export extern "mise install" [
    tool?: string                                           # Tool name (e.g., node@20)
    --force                                                 # Force reinstall even if already installed
    --jobs(-j): int                                         # Number of parallel installs (default: 4)
    --quiet(-q)                                             # Suppress non-error output
    --verbose(-v)                                           # Show verbose output
    --yes(-y)                                               # Skip confirmation prompts
    --help(-h)                                              # Show help
]

# Pin a tool version to mise.toml
export extern "mise use" [
    tool: string                                            # Tool and version (e.g., node@20, python@3.11)
    --global(-g)                                            # Pin to global config (~/.config/mise/config.toml)
    --env(-e)                                               # Set as environment variable
    --parent                                                # Pin to parent directory's mise.toml
    --path                                                  # Use file path instead of version
    --latest                                                # Use latest available version
    --pin                                                   # Pin exact version (don't use semver range)
    --fuzzy                                                 # Use fuzzy version matching
    --quiet(-q)                                             # Suppress output
    --verbose(-v)                                           # Show verbose output
    --help(-h)                                              # Show help
]

# List installed tools and versions
export extern "mise ls" [
    --current(-c)                                           # Only show current directory's tools
    --global(-g)                                            # Only show global tools
    --parseable(-p)                                         # Simple parseable output
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# List available tool versions from remote registries
export extern "mise ls-remote" [
    tool?: string                                           # Tool name (e.g., node, python, rust)
    --all(-a)                                               # Show all available tools
    --prefix: string                                        # Filter by version prefix
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Show currently active tool versions
export extern "mise current" [
    tool?: string                                           # Filter by tool name
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Show outdated tools
export extern "mise outdated" [
    tool?: string                                           # Filter by tool name
    --current(-c)                                           # Only check current directory's tools
    --global(-g)                                            # Only check global tools
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Upgrade tools to latest versions
export extern "mise upgrade" [
    tool?: string                                           # Specific tool to upgrade
    --dry-run(-n)                                           # Show what would be upgraded
    --interactive(-i)                                       # Prompt for each upgrade
    --yes(-y)                                               # Skip confirmation
    --help(-h)                                              # Show help
]

# Remove unused tool versions
export extern "mise prune" [
    --dry-run(-n)                                           # Show what would be removed
    --yes(-y)                                               # Skip confirmation
    --help(-h)                                              # Show help
]

# Uninstall a tool version
export extern "mise uninstall" [
    tool: string                                            # Tool and version to uninstall
    --help(-h)                                              # Show help
]

# Reshim a tool (recreate shims)
export extern "mise reshim" [
    tool?: string                                           # Tool to reshim
    --force(-f)                                             # Force reshim even if not needed
    --help(-h)                                              # Show help
]

# Where is a tool installed?
export extern "mise where" [
    tool?: string                                           # Tool name
    --help(-h)                                              # Show help
]

# Which version of a tool is active?
export extern "mise which" [
    tool: string                                            # Tool name
    --help(-h)                                              # Show help
]

# Link a tool version to a path
export extern "mise link" [
    tool: string                                            # Tool and version
    path: path                                              # Path to link to
    --force(-f)                                             # Force overwrite existing link
    --help(-h)                                              # Show help
]

# Show the latest available version of a tool
export extern "mise latest" [
    tool: string                                            # Tool name (e.g., node@20)
    --installed(-i)                                         # Show latest installed version
    --minimum-release-age: string                           # Minimum release age filter
    --help(-h)                                              # Show help
]

# Install a tool into a specific path
export extern "mise install-into" [
    tool: string                                            # Tool and version
    path: path                                              # Installation path
    --help(-h)                                              # Show help
]

# Set environment variables
export extern "mise set" [
    env_var?: string                                        # Environment variable name
    value?: string                                          # Variable value
    --global(-g)                                            # Set globally
    --local(-l)                                             # Set locally
    --help(-h)                                              # Show help
]

# Activate shell with mise environment
export extern "mise shell" [
    tool: string                                            # Tool and version
    --help(-h)                                              # Show help
]

# --- Task Runner ---

# Run a task defined in mise.toml
export extern "mise run" [
    task?: string                                           # Task name
    --dry-run(-n)                                           # Show what would run without executing
    --interactive(-i)                                       # Run tasks interactively
    --quiet(-q)                                             # Suppress output
    --verbose(-v)                                           # Show verbose output
    --output: string@"nu-complete mise task-run-output"     # Output mode
    --prefix: string                                        # Prefix for task output
    --no-timing                                             # Don't show timing information
    --help(-h)                                              # Show help
    ...args: string                                         # Arguments to pass to task
]

# List available tasks
export extern "mise tasks" [
    --all(-a)                                               # Show all tasks including hidden
    --json                                                  # JSON output
    --sort: string                                          # Sort by field (name, alias, description)
    --help(-h)                                              # Show help
]

# Add a new task
export extern "mise tasks add" [
    task: string                                            # Task name
    run?: string                                            # Command to run
    --depends: string                                       # Task dependencies
    --description: string                                   # Task description
    --dir: path                                             # Working directory
    --env: string                                           # Environment variables
    --sources: string                                       # Source files
    --outputs: string                                       # Output files
    --help(-h)                                              # Show help
]

# Show task dependencies
export extern "mise tasks deps" [
    tasks?: string                                          # Task names
    --dot                                                   # Output in DOT format
    --hidden                                                # Include hidden tasks
    --help(-h)                                              # Show help
]

# Edit a task
export extern "mise tasks edit" [
    task: string                                            # Task name
    --path(-p)                                              # Show file path instead of editing
    --help(-h)                                              # Show help
]

# Show task information
export extern "mise tasks info" [
    task: string                                            # Task name
    --json(-J)                                              # JSON output
    --help(-h)                                              # Show help
]

# List tasks
export extern "mise tasks ls" [
    --all(-a)                                               # Show all tasks
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Run a task
export extern "mise tasks run" [
    task?: string                                           # Task name
    --dry-run(-n)                                           # Dry run mode
    --interactive(-i)                                       # Interactive mode
    --quiet(-q)                                             # Quiet mode
    --verbose(-v)                                           # Verbose mode
    --output: string                                        # Output mode
    --prefix: string                                        # Output prefix
    --no-timing                                             # Don't show timing
    --help(-h)                                              # Show help
    ...args: string                                         # Arguments to pass
]

# Validate tasks
export extern "mise tasks validate" [
    tasks?: string                                          # Tasks to validate
    --errors-only                                           # Only show errors
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Watch files and rerun task on changes
export extern "mise watch" [
    task: string                                            # Task to watch
    --glob(-g): string                                      # Glob pattern to watch
    --watch: string@"nu-complete mise watch-watch-path"     # Watch event type
    --debounce: int                                         # Debounce time in milliseconds
    --help(-h)                                              # Show help
]

# --- Environment Management ---

# Show environment variables
export extern "mise env" [
    --json                                                  # JSON output
    --bash                                                  # Bash format
    --fish                                                  # Fish format
    --zsh                                                   # Zsh format
    --nu                                                    # Nushell format
    --activate                                              # Activation script
    --help(-h)                                              # Show help
]

# Execute command with mise environment
export extern "mise exec" [
    --tool(-t): string                                      # Tool to use (e.g., node@20)
    --command(-c): string                                   # Command to execute
    --help(-h)                                              # Show help
    ...args: string                                         # Command and arguments
]

# Activate mise in current shell
export extern "mise activate" [
    shell?: string                                          # Shell type (bash, fish, zsh, nu)
    --status                                                # Include status in prompt
    --quiet(-q)                                             # Suppress output
    --help(-h)                                              # Show help
]

# Deactivate mise in current shell
export extern "mise deactivate" [
    --help(-h)                                              # Show help
]

# --- Configuration Management ---

# Edit configuration files
export extern "mise edit" [
    path?: path                                             # Config file path
    --global(-g)                                            # Edit global config
    --local(-l)                                             # Edit local config
    --help(-h)                                              # Show help
]

# Trust a mise.toml configuration file
export extern "mise trust" [
    dir?: path                                              # Directory to trust
    --all                                                   # Trust all directories
    --untrust                                               # Untrust a directory
    --help(-h)                                              # Show help
]

# Format configuration files
export extern "mise fmt" [
    --check                                                 # Check formatting without modifying
    --help(-h)                                              # Show help
]

# Lock dependencies
export extern "mise lock" [
    tool?: string                                           # Tool to lock
    --update                                                # Update lockfile
    --help(-h)                                              # Show help
]

# Config management
export extern "mise config" [
    --help(-h)                                              # Show help
]

# Get config value
export extern "mise config get" [
    key?: string                                            # Config key
    --file(-f): path                                        # Config file
    --help(-h)                                              # Show help
]

# List configs
export extern "mise config ls" [
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Set config value
export extern "mise config set" [
    key: string                                             # Config key
    value?: string                                          # Config value
    --file(-f): path                                        # Config file
    --type(-t): string                                      # Value type
    --help(-h)                                              # Show help
]

# Show configuration settings
export extern "mise settings" [
    key?: string                                            # Setting key
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Set a configuration setting
export extern "mise settings set" [
    setting: string                                         # Setting key
    value?: string                                          # Setting value
    --local(-l)                                             # Set in local config
    --help(-h)                                              # Show help
]

# Get a configuration setting
export extern "mise settings get" [
    setting: string                                         # Setting key
    --local(-l)                                             # Get from local config
    --help(-h)                                              # Show help
]

# List all settings
export extern "mise settings ls" [
    setting?: string                                        # Filter by setting name
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Unset a configuration setting
export extern "mise settings unset" [
    key: string                                             # Setting key
    --local(-l)                                             # Unset from local config
    --help(-h)                                              # Show help
]

# Add a setting value
export extern "mise settings add" [
    setting: string                                         # Setting key
    value?: string                                          # Value to add
    --local(-l)                                             # Add to local config
    --help(-h)                                              # Show help
]

# Show aliases
export extern "mise aliases" [
    tool?: string                                           # Tool name
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Set an alias
export extern "mise alias set" [
    tool: string                                            # Tool name
    from: string                                            # Source version
    to: string                                              # Target version
    --help(-h)                                              # Show help
]

# Get an alias
export extern "mise alias get" [
    tool: string                                            # Tool name
    alias_name: string                                      # Alias name
    --help(-h)                                              # Show help
]

# List aliases
export extern "mise alias ls" [
    tool?: string                                           # Tool name
    --no-header                                             # Hide header
    --help(-h)                                              # Show help
]

# Remove an alias
export extern "mise alias unset" [
    tool: string                                            # Tool name
    alias_name?: string                                     # Alias name to remove
    --help(-h)                                              # Show help
]

# Shell aliases
export extern "mise shell-alias" [
    --help(-h)                                              # Show help
]

export extern "mise shell-alias get" [
    shell_alias: string                                     # Alias name
    --help(-h)                                              # Show help
]

export extern "mise shell-alias ls" [
    --no-header                                             # Hide header
    --help(-h)                                              # Show help
]

export extern "mise shell-alias set" [
    shell_alias: string                                     # Alias name
    command?: string                                        # Command to alias
    --help(-h)                                              # Show help
]

export extern "mise shell-alias unset" [
    shell_alias: string                                     # Alias name
    --help(-h)                                              # Show help
]

# --- Diagnostics & Info ---

# Check mise installation health
export extern "mise doctor" [
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Show doctor paths
export extern "mise doctor path" [
    --full(-f)                                              # Show full paths
    --help(-h)                                              # Show help
]

# Show detailed information about mise
export extern "mise info" [
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Show today's activity
export extern "mise today" [
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Usage statistics
export extern "mise usage" [
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Search for tools
export extern "mise search" [
    name?: string                                           # Tool name to search
    --all(-a)                                               # Show all results
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Show binary paths
export extern "mise bin-paths" [
    tool?: string                                           # Tool and version
    --bin-names                                             # Show binary names
    --json(-J)                                              # JSON output
    --help(-h)                                              # Show help
]

# Show registry information
export extern "mise registry" [
    name?: string                                           # Registry name
    --json                                                  # JSON output
    --help(-h)                                              # Show help
]

# Show patrons
export extern "mise patrons" [
    --json(-J)                                              # JSON output
    --refresh                                               # Refresh data
    --help(-h)                                              # Show help
]

# Show sponsors
export extern "mise sponsors" [
    --help(-h)                                              # Show help
]

# Update mise itself
export extern "mise self-update" [
    --version(-v): string                                   # Target version
    --force                                                 # Force update
    --help(-h)                                              # Show help
]

# Cache management
export extern "mise cache" [
    --help(-h)                                              # Show help
]

# Clear cache
export extern "mise cache clear" [
    tool?: string                                           # Tool to clear cache for
    --all                                                   # Clear all caches
    --help(-h)                                              # Show help
]

# Show cache path
export extern "mise cache path" [
    --help(-h)                                              # Show help
]

# Prune cache
export extern "mise cache prune" [
    tool?: string                                           # Tool to prune
    --verbose(-v)                                           # Verbose output
    --dry-run                                               # Dry run mode
    --help(-h)                                              # Show help
]

# Plugin management
export extern "mise plugins" [
    --help(-h)                                              # Show help
]

# List plugins
export extern "mise plugins ls" [
    --core                                                  # Show only core plugins
    --user                                                  # Show only user plugins
    --outdated(-o)                                          # Show outdated plugins
    --urls(-u)                                              # Show plugin URLs
    --help(-h)                                              # Show help
]

# Install a plugin
export extern "mise plugins install" [
    name?: string                                           # Plugin name or URL
    git_url?: string                                        # Git URL for plugin
    --force                                                 # Force reinstall
    --help(-h)                                              # Show help
]

# Uninstall a plugin
export extern "mise plugins uninstall" [
    plugin?: string                                         # Plugin name
    --all(-a)                                               # Uninstall all plugins
    --purge(-p)                                             # Purge plugin data
    --help(-h)                                              # Show help
]

# Link a plugin
export extern "mise plugins link" [
    name: string                                            # Plugin name
    path?: path                                             # Plugin path
    --force(-f)                                             # Force overwrite
    --help(-h)                                              # Show help
]

# Update plugins
export extern "mise plugins update" [
    plugin?: string                                         # Plugin to update
    --jobs(-j): int                                         # Parallel jobs
    --help(-h)                                              # Show help
]

# List remote plugins
export extern "mise plugins ls-remote" [
    --urls(-u)                                              # Show URLs
    --only-names                                            # Only show names
    --help(-h)                                              # Show help
]

# Backends
export extern "mise backends" [
    --help(-h)                                              # Show help
]

export extern "mise backends ls" [
    --help(-h)                                              # Show help
]

# Dependencies
export extern "mise deps" [
    provider?: string                                       # Dependency provider
    --help(-h)                                              # Show help
]

export extern "mise deps add" [
    packages: string                                        # Packages to add
    --dev(-D)                                               # Add as dev dependency
    --help(-h)                                              # Show help
]

export extern "mise deps install" [
    provider?: string                                       # Dependency provider
    --help(-h)                                              # Show help
]

export extern "mise deps remove" [
    packages: string                                        # Packages to remove
    --help(-h)                                              # Show help
]

# Sync tools
export extern "mise sync" [
    --help(-h)                                              # Show help
]

export extern "mise sync node" [
    --help(-h)                                              # Show help
]

export extern "mise sync python" [
    --pyenv                                                 # Sync with pyenv
    --uv                                                    # Sync with uv
    --help(-h)                                              # Show help
]

export extern "mise sync ruby" [
    --brew                                                  # Sync with Homebrew
    --help(-h)                                              # Show help
]

# OCI container support
export extern "mise oci" [
    --help(-h)                                              # Show help
]

export extern "mise oci build" [
    --help(-h)                                              # Show help
]

export extern "mise oci push" [
    ref: string                                             # Container reference
    --help(-h)                                              # Show help
]

export extern "mise oci run" [
    cmd?: string                                            # Command to run
    --help(-h)                                              # Show help
]

# MCP (Model Context Protocol)
export extern "mise mcp" [
    --help(-h)                                              # Show help
]

# Token management
export extern "mise token" [
    --help(-h)                                              # Show help
]

export extern "mise token forgejo" [
    host?: string                                           # Forgejo host
    --unmask                                                # Show token value
    --help(-h)                                              # Show help
]

export extern "mise token gitea" [
    host?: string                                           # Gitea host
    --unmask                                                # Show token value
    --help(-h)                                              # Show help
]

export extern "mise token github" [
    --unmask                                                # Show token value
    --help(-h)                                              # Show help
]

# Environment activation
export extern "mise en" [
    dir?: path                                              # Directory to activate
    --shell(-s): string                                     # Shell type
    --help(-h)                                              # Show help
]

# Generate various files
export extern "mise generate" [
    --help(-h)                                              # Show help
]

export extern "mise generate bootstrap" [
    --help(-h)                                              # Show help
]

export extern "mise generate config" [
    path?: path                                             # Config file path
    --help(-h)                                              # Show help
]

export extern "mise generate devcontainer" [
    --help(-h)                                              # Show help
]

export extern "mise generate git-pre-commit" [
    --help(-h)                                              # Show help
]

export extern "mise generate github-action" [
    --help(-h)                                              # Show help
]

export extern "mise generate task-docs" [
    --help(-h)                                              # Show help
]

export extern "mise generate task-stubs" [
    --dir(-d): path                                         # Output directory
    --mise-bin: string                                      # Mise binary path
    --help(-h)                                              # Show help
]

export extern "mise generate tool-stub" [
    output: string                                          # Output file
    --help(-h)                                              # Show help
]

# Completion generation
export extern "mise completion" [
    shell?: string                                          # Shell type (bash, fish, zsh, nu)
    --include-bash-completion-lib                           # Include bash completion library
    --help(-h)                                              # Show help
]

# Test tool
export extern "mise test-tool" [
    tools?: string                                          # Tools to test
    --help(-h)                                              # Show help
]

# Direnv integration
export extern "mise direnv" [
    --help(-h)                                              # Show help
]

# Export direnv config
export extern "mise direnv export" [
    --help(-h)                                              # Show help
]

# Implies (shortcut commands)
export extern "mise implode" [
    --dry-run(-n)                                           # Show what would be removed
    --yes(-y)                                               # Skip confirmation
    --help(-h)                                              # Show help
]

# Regenerate shims
export extern "mise regenerate-shims" [
    --help(-h)                                              # Show help
]

# Short aliases
export extern "mise i" [                                    # Alias for 'install'
    tool?: string
    --force
    --jobs(-j): int
    --quiet(-q)
    --verbose(-v)
    --yes(-y)
    --help(-h)
]

export extern "mise u" [                                    # Alias for 'use'
    tool: string
    --global(-g)
    --env(-e)
    --parent
    --path
    --latest
    --pin
    --fuzzy
    --quiet(-q)
    --verbose(-v)
    --help(-h)
]

export extern "mise x" [                                    # Alias for 'exec'
    --tool(-t): string
    --command(-c): string
    --help(-h)
    ...args: string
]
