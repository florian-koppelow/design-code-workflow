# Design-Code Workflow

Bidirectional Figma-Code workflows powered by AI. Create, capture, and maintain design-code parity using MCP tools.

## What It Does

- **Creates screens in Figma** using design system components via natural language
- **Captures running apps** and converts them to editable Figma layers
- **Checks alignment** between Figma designs and code
- **Audits design system health** and token usage
- **Enables seamless back-and-forth** between designing and coding

## Quick Start

### 1. Clone and Setup

```bash
git clone https://github.com/your-org/design-code-workflow.git
cd design-code-workflow
./scripts/setup.sh
```

### 2. Answer the Prompts

The setup wizard asks about:
- Your **design system maturity** (0-3)
- Your **Figma access token**
- Your **tech stack** (framework, dev server)
- Optional: **library file keys**, **documentation platform**

### 3. Start Using

After setup, try these in VS Code Agent chat:

```
"Create a color palette in Figma"          # Level 0+
"Capture my running app to Figma"          # Level 0+
"Create a login screen in Figma"           # Level 2+
"Audit my design system health"            # Level 1+
```

## Design System Maturity Levels

| Level | What You Have | What You Can Do |
|-------|---------------|-----------------|
| **0** | Empty Figma file | Create tokens, capture UI |
| **1** | Tokens in Figma | + Bind variables, check health |
| **2** | Component library | + Create screens, reconcile |
| **3** | + Storybook/Widgetbook | + Cross-platform health |

**Most projects start at Level 0 or 1.** Storybook/Widgetbook are optional.

## Use Cases

| Use Case | Min Level | Skill/Agent |
|----------|-----------|-------------|
| Create Base DS | 0 | `design-system-ops` |
| Create DS from Code | 0 | `design-system-ops` |
| Code to Canvas | 0 | `code-to-canvas-bridge` |
| Create Screens | 2 | `figma-screen-creation` |
| Build from Figma | 1 | `design-to-code` agent |
| Reconcile Layers | 1 | `code-to-canvas-reconciliation` |
| DS Health Check | 1 | `design-system-health` |
| Iterate Code | 1 | Parity checks |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Your IDE (VS Code)                       │
│                                                              │
│  ┌─────────────────┐    ┌─────────────────────────────────┐ │
│  │ Your Code       │    │ Figma Console MCP               │ │
│  │                 │    │ - Create screens                │ │
│  │                 │    │ - Manage tokens                 │ │
│  │                 │    │ - Health audits                 │ │
│  └────────┬────────┘    └─────────────────────────────────┘ │
│           │                           ▲                      │
│           │ localhost                 │                      │
│           ▼                           │                      │
│  ┌─────────────────┐                  │                      │
│  │ Claude Code CLI │──────────────────┘                      │
│  │ (Code-to-Canvas)│                                         │
│  │                 │───────► Figma Desktop                  │
│  └─────────────────┘                                         │
└─────────────────────────────────────────────────────────────┘
```

## Requirements

| Component | Required? | Purpose |
|-----------|-----------|---------|
| Figma account + token | Yes | API access |
| Figma Desktop + Bridge | Yes | Write operations |
| Claude Code CLI | Yes | Code-to-Canvas |
| ngrok | Yes | Expose localhost |
| Component library | No | Level 2+ features |
| Storybook/Widgetbook | No | Level 3 features |

## Project Structure

```
design-code-workflow/
├── .vscode/
│   └── mcp.json              # MCP configuration (VS Code)
├── .github/
│   ├── copilot-instructions.md # Workspace instructions
│   └── agents/
│       └── design-to-code.agent.md
├── config/
│   ├── design-system.yaml    # DS configuration
│   └── tech-stack.yaml       # Framework configuration
├── scripts/
│   ├── setup.sh              # Initial setup
│   └── customize.sh          # Update configuration
└── docs/
    ├── WORKFLOW-REFERENCE.md # Detailed workflows
    ├── USE-CASES.md          # Step-by-step guides
    └── MCP-TOOLS-REFERENCE.md
```

## Configuration

### design-system.yaml

```yaml
name: "My Design System"
maturity_level: 0  # 0-3

libraries:
  working_file:
    file_key: "your-file-key"
  foundations:
    enabled: false
    file_key: ""
  components:
    enabled: false
    file_key: ""
```

### tech-stack.yaml

```yaml
framework: "react"
dev_server:
  command: "npm run dev"
  default_port: 3000
```

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for full reference.

## Key Principle

> "Code to Design isn't the point. System Parity is."

The goal is maintaining a trustworthy bidirectional loop where design and code stay aligned.

## Documentation

- [CUSTOMIZATION.md](CUSTOMIZATION.md) - Configuration reference
- [docs/WORKFLOW-REFERENCE.md](docs/WORKFLOW-REFERENCE.md) - Detailed workflows
- [docs/USE-CASES.md](docs/USE-CASES.md) - Step-by-step guides

## Upgrading Maturity

As your design system grows:

```bash
./scripts/customize.sh
# Select "Upgrade maturity level"
```

Or edit `config/design-system.yaml` directly.

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Figma Console not connecting | Open Figma Desktop, run Desktop Bridge plugin |
| Code-to-Canvas shows ngrok page | Open ngrok URL in browser first |
| generate_figma_design unavailable | Only works in Claude Code CLI |

## License

MIT
