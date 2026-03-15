# Customization Guide

This guide explains how to configure the design-code workflow for your specific project.

## Table of Contents

- [Configuration Files](#configuration-files)
- [Design System Configuration](#design-system-configuration)
- [Tech Stack Configuration](#tech-stack-configuration)
- [Upgrading Maturity Levels](#upgrading-maturity-levels)
- [Adding Optional Integrations](#adding-optional-integrations)
- [Framework-Specific Setup](#framework-specific-setup)

## Configuration Files

| File | Purpose |
|------|---------|
| `config/design-system.yaml` | Figma libraries, naming conventions, DS settings |
| `config/tech-stack.yaml` | Framework, dev server, code patterns |
| `.vscode/mcp.json` | MCP server configuration (VS Code) |
| `.github/copilot-instructions.md` | Workspace instructions for VS Code Agent |
| `.github/agents/*.agent.md` | Custom agents for VS Code Agent |

## Design System Configuration

### config/design-system.yaml

```yaml
# Required: Name your design system
name: "My Design System"

# Required: Current maturity level (0-3)
maturity_level: 0

# Figma Libraries
libraries:
  # Always required - your main working file
  working_file:
    file_key: "abc123def456"  # From figma.com/design/{FILE_KEY}/...
    description: "Main file for creating screens"
  
  # Level 1+: Token/foundations library
  foundations:
    enabled: true              # Set true when you have tokens
    file_key: "xyz789"
    description: "Colors, spacing, typography"
  
  # Level 2+: Component library
  components:
    enabled: true
    file_key: "comp456"
    description: "Buttons, cards, inputs"
  
  # Level 2+: Asset library
  assets:
    enabled: false
    file_key: ""
    description: "Icons, illustrations"

# Naming conventions for component discovery
naming_conventions:
  # Prefix for DS components (empty = no prefix)
  component_prefix: "DS"  # e.g., "DS Button", "DS Card"
  
  # Variable collection names in Figma
  variable_collections:
    colors: "Colors"
    spacing: "Spacing"
    typography: "Typography"
    corner_radius: "Corner Radius"

# Level 3: Documentation platform
documentation:
  enabled: false
  platform: ""     # storybook, widgetbook, or custom
  url: ""          # https://storybook.myapp.dev

# Component categories for search
component_categories:
  navigation: ["Top Bar", "Nav Bar", "Tab Bar"]
  actions: ["Button", "Icon Button", "FAB"]
  content: ["Card", "List Item", "Tile"]
  inputs: ["Text Field", "Checkbox", "Switch"]
  feedback: ["Dialog", "Modal", "Toast"]
  status: ["Badge", "Tag", "Progress"]
```

### Extracting File Keys

From a Figma URL like:
```
https://www.figma.com/design/abc123def456/My-File-Name?node-id=1-2
```

The file key is: `abc123def456`

## Tech Stack Configuration

### config/tech-stack.yaml

```yaml
# Your frontend framework
framework: "react"  # react, vue, angular, flutter, svelte, nextjs, etc.

# Package manager
package_manager: "npm"  # npm, yarn, pnpm, bun, pub, etc.

# Dev server settings
dev_server:
  command: "npm run dev"           # Command to start dev server
  default_port: 3000               # Default port
  env:                             # Optional env vars
    NODE_ENV: "development"

# Code token configuration (optional)
design_tokens:
  enabled: true                    # Set true if you have tokens in code
  location: "src/tokens/"          # Path to token files
  format: "typescript"             # css-vars, scss, typescript, dart, json
  patterns:
    colors: "colors.ts"
    spacing: "spacing.ts"
    typography: "typography.ts"

# Code component configuration (optional)
components:
  enabled: true                    # Set true if you have a component library
  location: "src/components/"      # Path to components
  naming_convention: "PascalCase"  # PascalCase, kebab-case, camelCase
  index_file: "index.ts"           # Optional barrel file

# Framework-specific MCP tools (optional)
mcp_tools:
  dart:
    enabled: false
    command: "dart"
    args: ["mcp-server"]

# Code generation patterns (optional)
code_generation:
  # How to reference tokens in generated code
  token_reference: "tokens.{{COLLECTION}}.{{TOKEN}}"
  
  # Component template (advanced)
  component_template: ""
```

### Token Format Examples

| Format | Example Reference |
|--------|------------------|
| `css-vars` | `var(--color-primary)` |
| `scss` | `$color-primary` |
| `typescript` | `tokens.colors.primary` |
| `dart` | `context.colors.primary` |
| `tailwind` | `text-primary` |
| `json` | Direct value lookup |

## Upgrading Maturity Levels

### Level 0 → Level 1 (Add Tokens)

1. Create tokens in Figma using `design-system-ops` skill
2. Update config:
   ```yaml
   maturity_level: 1
   libraries:
     foundations:
       enabled: true
       file_key: "your-foundations-file-key"
   ```

### Level 1 → Level 2 (Add Components)

1. Create component library in Figma
2. Update config:
   ```yaml
   maturity_level: 2
   libraries:
     components:
       enabled: true
       file_key: "your-components-file-key"
   ```

### Level 2 → Level 3 (Add Documentation)

1. Set up Storybook, Widgetbook, or similar
2. Update config:
   ```yaml
   maturity_level: 3
   documentation:
     enabled: true
     platform: "storybook"
     url: "https://storybook.myapp.dev"
   ```

## Adding Optional Integrations

### Storybook Integration

```yaml
# config/design-system.yaml
documentation:
  enabled: true
  platform: "storybook"
  url: "https://storybook.myapp.dev"
```

### Widgetbook Integration (Flutter)

```yaml
documentation:
  enabled: true
  platform: "widgetbook"
  url: "http://localhost:4000"
```

### Framework MCP Tools

Add to `.vscode/mcp.json`:

```json
{
  "mcpServers": {
    "figma-console": { ... },
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    },
    "typescript": {
      "command": "npx",
      "args": ["typescript-language-server", "--stdio"]
    }
  }
}
```

### Linear/Jira Integration

Add to `.vscode/mcp.json`:

```json
{
  "mcpServers": {
    "Linear": {
      "url": "https://mcp.linear.app/mcp"
    }
  }
}
```

## Framework-Specific Setup

### React / Next.js

```yaml
# tech-stack.yaml
framework: "react"
package_manager: "npm"
dev_server:
  command: "npm run dev"
  default_port: 3000
design_tokens:
  format: "typescript"
  location: "src/tokens/"
components:
  location: "src/components/"
  naming_convention: "PascalCase"
```

### Vue / Nuxt

```yaml
framework: "vue"
package_manager: "npm"
dev_server:
  command: "npm run dev"
  default_port: 5173
design_tokens:
  format: "typescript"
components:
  location: "src/components/"
```

### Flutter

```yaml
framework: "flutter"
package_manager: "pub"
dev_server:
  command: "flutter run -d chrome --web-port=8080"
  default_port: 8080
design_tokens:
  format: "dart"
  location: "lib/theme/"
components:
  location: "lib/widgets/"
  naming_convention: "PascalCase"
```

Add Dart MCP to `.vscode/mcp.json`:
```json
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": ["mcp-server"]
    }
  }
}
```

### Angular

```yaml
framework: "angular"
package_manager: "npm"
dev_server:
  command: "ng serve"
  default_port: 4200
components:
  location: "src/app/components/"
  naming_convention: "kebab-case"
```

### Svelte / SvelteKit

```yaml
framework: "svelte"
package_manager: "npm"
dev_server:
  command: "npm run dev"
  default_port: 5173
components:
  location: "src/lib/components/"
  naming_convention: "PascalCase"
```

## Customization Script

For interactive configuration updates:

```bash
./scripts/customize.sh
```

Options:
1. Upgrade maturity level
2. Add/update Figma libraries
3. Update tech stack settings
4. Add documentation platform
5. Update Figma access token
6. Add framework MCP tools

## Troubleshooting Configuration

### Config not loading
- Check YAML syntax (use a validator)
- Ensure file paths are correct
- Restart VS Code after changes

### Components not found
- Verify `component_prefix` matches your naming
- Check `component_categories` include your component names
- Run empty search to see all available components

### Tokens not binding
- Ensure `foundations.enabled: true`
- Verify `variable_collections` names match Figma
- Check collection exists in Figma file
