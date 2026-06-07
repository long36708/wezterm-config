# nu-version: 0.102.0
# Claude Code CLI completions for Nushell
# Translated from bash completion script

def "nu-complete claude commands" [] {
    [agents auto-mode auth mcp plugin plugins project setup-token doctor update upgrade install ultrareview]
}

def "nu-complete claude output-format" [] {
    [text json stream-json]
}

def "nu-complete claude input-format" [] {
    [text stream-json]
}

def "nu-complete claude permission-mode" [] {
    [acceptEdits bypassPermissions default dontAsk plan auto]
}

def "nu-complete claude models" [] {
    [sonnet opus haiku best sonnet1m opus1m opusplan]
}

def "nu-complete claude effort" [] {
    [low medium high xhigh max]
}

def "nu-complete claude scope" [] {
    [local user project]
}

def "nu-complete claude scope-with-managed" [] {
    [local user project managed]
}

def "nu-complete claude transport" [] {
    [stdio sse http]
}

def "nu-complete claude install-channel" [] {
    [stable latest]
}

def "nu-complete claude bool" [] {
    [true false]
}

def "nu-complete claude plugin-component" [] {
    [skills agents hooks mcp lsp output-style channel]
}

# Claude Code - starts an interactive session by default, use -p/--print for non-interactive output
export extern claude [
    --debug(-d)                                             # Enable debug mode
    --debug-file: path                                      # Debug output file
    --verbose                                               # Verbose output
    --print(-p)                                             # Print mode
    --output-format: string@"nu-complete claude output-format"  # Output format
    --json-schema: string                                   # JSON schema
    --include-hook-events                                    # Include hook lifecycle events
    --include-partial-messages                               # Include partial messages
    --input-format: string@"nu-complete claude input-format"    # Input format
    --mcp-debug                                             # MCP debug mode
    --dangerously-skip-permissions                          # Skip permissions (dangerous)
    --allow-dangerously-skip-permissions                    # Allow skip permissions
    --max-budget-usd: number                                # Max budget in USD
    --replay-user-messages                                  # Replay user messages
    --allowedTools: string                                  # Allowed tools (deprecated)
    --allowed-tools: string                                 # Allowed tools
    --tools: string                                         # Tools
    --disallowedTools: string                               # Disallowed tools (deprecated)
    --disallowed-tools: string                              # Disallowed tools
    --mcp-config: path                                      # MCP config file
    --system-prompt: string                                 # System prompt
    --append-system-prompt: string                          # Append system prompt
    --exclude-dynamic-system-prompt-sections                # Move per-machine sections to first user message (default system prompt only)
    --permission-mode: string@"nu-complete claude permission-mode"  # Permission mode
    --continue(-c)                                          # Continue last session
    --resume(-r): string                                    # Resume session by ID
    --fork-session                                          # Fork session
    --no-session-persistence                                # Disable session persistence
    --model: string@"nu-complete claude models"             # Model to use
    --agent: string                                         # Agent name
    --betas: string                                         # Beta features
    --fallback-model: string@"nu-complete claude models"    # Fallback model
    --settings: path                                        # Settings file
    --add-dir: path                                         # Additional directory
    --ide                                                    # Automatically connect to IDE on startup
    --strict-mcp-config                                     # Strict MCP config
    --session-id: string                                    # Session ID
    --agents: string                                        # Agents config
    --setting-sources: string@"nu-complete claude scope"    # Setting sources
    --plugin-dir: path                                      # Plugin directory
    --plugin-url: string                                    # Fetch a plugin .zip from a URL for this session only
    --disable-slash-commands                                 # Disable slash commands
    --chrome                                                # Enable Chrome
    --no-chrome                                             # Disable Chrome
    --from-pr: string                                       # From PR
    --file: string                                          # File resources (file_id:relative_path)
    --worktree(-w): string                                  # Git worktree
    --tmux                                                  # Tmux mode
    --bare                                                  # Minimal mode: skip hooks, LSP, and auto-discovery
    --brief                                                 # Enable SendUserMessage tool for agent-to-user communication
    --prompt-suggestions: string@"nu-complete claude bool"  # Enable prompt suggestions
    --remote-control: string                                # Start an interactive session with Remote Control enabled (optionally named)
    --remote-control-session-name-prefix: string            # Remote Control session name prefix
    --effort: string@"nu-complete claude effort"            # Effort level
    --name(-n): string                                      # Name for the conversation
    --version(-v)                                           # Show version
    --help(-h)                                              # Show help
    ...args: string                                         # Command or prompt
]

# --- auth ---

# Manage authentication
export extern "claude auth" [
    --help(-h)
    ...args: string
]

# Sign in to your Anthropic account
export extern "claude auth login" [
    --claudeai          # Use Claude subscription (default)
    --console           # Use Anthropic Console (API usage billing)
    --email: string     # Pre-populate email address on the login page
    --sso               # Force SSO login flow
    --help(-h)
]

# Log out from your Anthropic account
export extern "claude auth logout" [
    --help(-h)
]

def "nu-complete claude auth-status-format" [] {
    [json text]
}

# Show authentication status
export extern "claude auth status" [
    --json               # Output as JSON
    --text               # Output as text
    --help(-h)
]

# --- mcp ---

# Configure and manage MCP servers
export extern "claude mcp" [
    --help(-h)
    ...args: string
]

# Add an MCP server to Claude Code
export extern "claude mcp add" [
    --scope(-s): string@"nu-complete claude scope"              # Scope
    --transport(-t): string@"nu-complete claude transport"      # Transport type
    --env(-e): string                                           # Environment variable
    --header(-H): string                                        # Header
    --callback-port: int                                        # Callback port
    --client-id: string                                         # Client ID
    --client-secret                                              # Client secret (interactive prompt)
    --help(-h)
    ...args: string
]

# Import MCP servers from Claude Desktop (Mac and WSL only)
export extern "claude mcp add-from-claude-desktop" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Add an MCP server (stdio or SSE) with a JSON string
export extern "claude mcp add-json" [
    --scope(-s): string@"nu-complete claude scope"
    --client-secret                                              # Client secret (interactive prompt)
    --help(-h)
    ...args: string
]

# Get details about an MCP server
export extern "claude mcp get" [
    --help(-h)
    ...args: string
]

# List configured MCP servers
export extern "claude mcp list" [
    --help(-h)
]

# Remove an MCP server
export extern "claude mcp remove" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Reset all approved and rejected project-scoped (.mcp.json) servers
export extern "claude mcp reset-project-choices" [
    --help(-h)
]

# Start the Claude Code MCP server
export extern "claude mcp serve" [
    --debug(-d)
    --verbose
    --help(-h)
]

# --- plugin ---

# Manage Claude Code plugins
export extern "claude plugin" [
    --help(-h)
    ...args: string
]

# Show a plugin's component inventory and projected token cost
export extern "claude plugin details" [
    --help(-h)
    ...args: string
]

# Disable an enabled plugin
export extern "claude plugin disable" [
    --all(-a)                                               # Disable all
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Enable a disabled plugin
export extern "claude plugin enable" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Scaffold a new plugin
export extern "claude plugin init" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Scaffold a new plugin (alias for init)
export extern "claude plugin new" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Install a plugin from available marketplaces
export extern "claude plugin install" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# List installed plugins
export extern "claude plugin list" [
    --available
    --json
    --help(-h)
]

# Manage Claude Code marketplaces
export extern "claude plugin marketplace" [
    --help(-h)
    ...args: string
]

# Add a marketplace
export extern "claude plugin marketplace add" [
    --scope: string@"nu-complete claude scope"              # Where to declare the marketplace
    --sparse: string                                         # Limit checkout to specific directories
    --help(-h)
    ...args: string
]

# List configured marketplaces
export extern "claude plugin marketplace list" [
    --json
    --help(-h)
]

# Remove a marketplace
export extern "claude plugin marketplace remove" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# Update a marketplace
export extern "claude plugin marketplace update" [
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin
export extern "claude plugin uninstall" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove auto-installed dependencies that are no longer needed
export extern "claude plugin prune" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Remove auto-installed dependencies (alias for prune)
export extern "claude plugin autoremove" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Update a plugin to the latest version
export extern "claude plugin update" [
    --scope(-s): string@"nu-complete claude scope-with-managed"
    --help(-h)
    ...args: string
]

# Validate a plugin or marketplace manifest
export extern "claude plugin validate" [
    --strict                                                # Treat warnings as errors (exit 1)
    --help(-h)
    ...args: string
]

# Create a {name}--v{version} git tag for a plugin release
export extern "claude plugin tag" [
    --dry-run                                               # Print what would be tagged without creating it
    --force(-f)                                             # Skip dirty-working-tree and tag-already-exists checks
    --message(-m): string                                   # Tag annotation message (use %s for the version)
    --push                                                  # Push the tag to --remote after creating it
    --remote: string                                        # Remote to push to with --push (default: "origin")
    --help(-h)
    path?: path                                             # Plugin directory path
]

# Install a plugin (alias for install)
export extern "claude plugin i" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin (alias for uninstall)
export extern "claude plugin remove" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove a marketplace (alias for remove)
export extern "claude plugin marketplace rm" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# --- plugins (alias for plugin) ---

# Manage Claude Code plugins
export extern "claude plugins" [
    --help(-h)
    ...args: string
]

# Show a plugin's component inventory and projected token cost
export extern "claude plugins details" [
    --help(-h)
    ...args: string
]

# Disable an enabled plugin
export extern "claude plugins disable" [
    --all(-a)                                               # Disable all
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Enable a disabled plugin
export extern "claude plugins enable" [
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Scaffold a new plugin
export extern "claude plugins init" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Scaffold a new plugin (alias for init)
export extern "claude plugins new" [
    --author: string                                        # Author name (default: git config user.name)
    --author-email: string                                  # Author email (default: git config user.email)
    --description: string                                   # Manifest description
    --force(-f)                                             # Overwrite an existing .claude-plugin/ at the target
    --with: string@"nu-complete claude plugin-component"    # Also scaffold components (repeatable)
    --help(-h)
    name?: string                                           # Plugin name
]

# Install a plugin from available marketplaces
export extern "claude plugins install" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# List installed plugins
export extern "claude plugins list" [
    --available
    --json
    --help(-h)
]

# Manage Claude Code marketplaces
export extern "claude plugins marketplace" [
    --help(-h)
    ...args: string
]

# Add a marketplace
export extern "claude plugins marketplace add" [
    --scope: string@"nu-complete claude scope"              # Where to declare the marketplace
    --sparse: string                                         # Limit checkout to specific directories
    --help(-h)
    ...args: string
]

# List configured marketplaces
export extern "claude plugins marketplace list" [
    --json
    --help(-h)
]

# Remove a marketplace
export extern "claude plugins marketplace remove" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# Update a marketplace
export extern "claude plugins marketplace update" [
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin
export extern "claude plugins uninstall" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove auto-installed dependencies that are no longer needed
export extern "claude plugins prune" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Remove auto-installed dependencies (alias for prune)
export extern "claude plugins autoremove" [
    --dry-run                                               # List what would be removed without removing
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the confirmation prompt
    --help(-h)
]

# Update a plugin to the latest version
export extern "claude plugins update" [
    --scope(-s): string@"nu-complete claude scope-with-managed"
    --help(-h)
    ...args: string
]

# Validate a plugin or marketplace manifest
export extern "claude plugins validate" [
    --strict                                                # Treat warnings as errors (exit 1)
    --help(-h)
    ...args: string
]

# Create a {name}--v{version} git tag for a plugin release
export extern "claude plugins tag" [
    --dry-run                                               # Print what would be tagged without creating it
    --force(-f)                                             # Skip dirty-working-tree and tag-already-exists checks
    --message(-m): string                                   # Tag annotation message (use %s for the version)
    --push                                                  # Push the tag to --remote after creating it
    --remote: string                                        # Remote to push to with --push (default: "origin")
    --help(-h)
    path?: path                                             # Plugin directory path
]

# Install a plugin (alias for install)
export extern "claude plugins i" [
    --config: string                                        # Set a userConfig option from the plugin manifest (repeatable)
    --scope(-s): string@"nu-complete claude scope"
    --help(-h)
    ...args: string
]

# Uninstall an installed plugin (alias for uninstall)
export extern "claude plugins remove" [
    --keep-data                                             # Preserve plugin persistent data
    --prune                                                 # Also remove auto-installed dependencies that are no longer needed
    --scope(-s): string@"nu-complete claude scope"
    --yes(-y)                                               # Skip the --prune confirmation prompt
    --help(-h)
    ...args: string
]

# Remove a marketplace (alias for remove)
export extern "claude plugins marketplace rm" [
    --scope: string@"nu-complete claude scope"               # Remove from specific settings scope
    --help(-h)
    ...args: string
]

# --- project ---

# Manage Claude Code project state
export extern "claude project" [
    --help(-h)
    ...args: string
]

# Delete all Claude Code state for a project (transcripts, tasks, file history, config entry)
export extern "claude project purge" [
    --all                  # Purge state for every project (mutually exclusive with [path])
    --dry-run              # List what would be deleted without deleting anything
    --interactive(-i)      # Prompt for each item before deleting
    --yes(-y)              # Skip confirmation prompt
    --help(-h)
    path?: path            # Project directory path
]

# --- agents ---

# Manage background agents
export extern "claude agents" [
    --add-dir: path                                         # Additional directory to allow tool access (repeatable)
    --agent: string                                         # Default agent for dispatched sessions
    --allow-dangerously-skip-permissions                    # Make bypass-permissions mode available to dispatched sessions
    --cwd: path                                             # Show only background sessions started under path
    --dangerously-skip-permissions                          # Alias for --permission-mode bypassPermissions
    --effort: string@"nu-complete claude effort"            # Default effort level for dispatched sessions
    --json                                                  # Print live sessions as a JSON array and exit (for scripting)
    --mcp-config: path                                      # MCP server configuration (repeatable)
    --model: string@"nu-complete claude models"             # Default model for dispatched sessions
    --permission-mode: string@"nu-complete claude permission-mode"  # Default permission mode for dispatched sessions
    --plugin-dir: path                                      # Load plugins from directory (repeatable)
    --setting-sources: string@"nu-complete claude scope"    # Setting sources
    --settings: path                                        # Settings file or JSON string
    --strict-mcp-config                                     # Only use MCP servers from --mcp-config
    --help(-h)
]

# --- setup-token ---

# Set up a long-lived authentication token (requires Claude subscription)
export extern "claude setup-token" [
    --help(-h)
]

# --- doctor ---

# Check the health of your Claude Code auto-updater
export extern "claude doctor" [
    --help(-h)
]

# --- update / upgrade ---

# Check for updates and install if available
export extern "claude update" [
    --help(-h)
]

# Check for updates and install if available
export extern "claude upgrade" [
    --help(-h)
]

# --- install ---

# Install Claude Code native build
export extern "claude install" [
    --force
    --help(-h)
    channel?: string@"nu-complete claude install-channel"   # Install channel
]

# --- auto-mode ---

# Inspect auto mode classifier configuration
export extern "claude auto-mode" [
    --help(-h)
    ...args: string
]

# Show auto mode classifier configuration
export extern "claude auto-mode config" [
    --help(-h)
]

# Run auto mode critique on a conversation
export extern "claude auto-mode critique" [
    --model: string@"nu-complete claude models"             # Model for the critique
    --help(-h)
]

# Show default auto mode classifier configuration
export extern "claude auto-mode defaults" [
    --help(-h)
]

# --- ultrareview ---

# Run a cloud-hosted multi-agent code review of the current branch (or a PR number / base branch)
export extern "claude ultrareview" [
    --json                                                  # Print the raw bugs.json payload instead of formatted findings
    --timeout: int                                          # Maximum minutes to wait for the review to finish (default: 30)
    --help(-h)
    target?: string                                         # PR number, branch, or other target
]
