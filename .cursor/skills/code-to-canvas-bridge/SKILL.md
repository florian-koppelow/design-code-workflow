---
name: code-to-canvas-bridge
description: |-
  Capture running UI to Figma using Claude Code CLI as a bridge.
  VS Code doesn't support generate_figma_design, so we use Claude Code for this specific task.
  Works at any maturity level - captures any running web UI.
  Use when the user wants to capture localhost/staging UI into Figma.

  Examples:
  - user: "Capture this app to Figma" → run code-to-canvas via Claude Code
  - user: "Send this screen to Figma" → invoke Claude Code bridge
  - user: "Code to canvas" → use this bridge workflow
  - user: "Push my UI to Figma" → capture via ngrok tunnel
---

# Code-to-Canvas Bridge via Claude Code CLI

Capture running UI to Figma using Claude Code as a bridge. Works at any maturity level.

## Prerequisites

### 1. Install Claude Code CLI

```bash
npm install -g @anthropic-ai/claude-code
```

### 2. Add Figma MCP to Claude Code

```bash
claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp
```

### 3. Authenticate with Figma

Run Claude Code and authenticate:

```bash
claude
```

Then in Claude Code:
```
/mcp
```

Select **figma** and click **Allow Access** in the browser window.

### 4. Install ngrok (for localhost capture)

```bash
# macOS
brew install ngrok

# npm (cross-platform)
npm install -g ngrok
```

Sign up at https://dashboard.ngrok.com and configure:
```bash
ngrok config add-authtoken YOUR_TOKEN
```

## Usage Workflow

### Step 1: Start Your Dev Server

Read `config/tech-stack.yaml` for the dev server command:

```bash
# Example commands by framework:
# React/Vue/Angular: npm run dev
# Flutter web: flutter run -d chrome --web-port=8080
# Next.js: npm run dev
# Your command: {{DEV_COMMAND}}
```

### Step 2: Start ngrok Tunnel

The Figma MCP server captures from the public internet, not localhost.

```bash
ngrok http {{PORT}}  # e.g., ngrok http 3000
```

Copy the ngrok URL (e.g., `https://abc123.ngrok-free.dev`).

**Important:** Open the ngrok URL in your browser first and click through any interstitial pages.

### Step 3: Invoke Claude Code

From terminal:

```bash
claude --print "Use generate_figma_design to capture the UI at https://YOUR_NGROK_URL and send it to the Figma file at https://www.figma.com/design/YOUR_FILE_KEY. Create a new page called 'Code Capture - $(date +%Y-%m-%d)'."
```

Or interactively:

```bash
claude
```

Then ask:
```
Capture the running app at https://YOUR_NGROK_URL to my Figma file https://figma.com/design/FILE_KEY
Create a page called "Code Capture"
```

### Parameters for generate_figma_design

| Parameter | Description |
|-----------|-------------|
| `urls` | Array of URLs to capture (ngrok URL, staging, production) |
| `figma_file_url` | Target Figma file URL (from `config/design-system.yaml` working_file) |
| `page_name` | Name for the new page in Figma |
| `frame_name` | Name for the captured frame |

## Automation Script

Create a helper script for quick captures:

```bash
#!/bin/bash
# code-to-canvas.sh

# Read from config or use defaults
URL="${1:-http://localhost:3000}"
FIGMA_FILE="${2:-YOUR_DEFAULT_FILE}"
PAGE_NAME="${3:-Code Capture - $(date +%Y-%m-%d_%H-%M)}"

echo "Starting ngrok tunnel..."
ngrok http $(echo $URL | grep -oE '[0-9]+$') &
NGROK_PID=$!
sleep 3

NGROK_URL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
echo "ngrok URL: $NGROK_URL"

echo "Capturing to Figma..."
claude --print "Use generate_figma_design to capture $NGROK_URL to $FIGMA_FILE. Create page: $PAGE_NAME"

kill $NGROK_PID
```

## Post-Capture: What's Next?

After Code-to-Canvas captures the UI, you have options based on maturity level:

### Level 0-1: Keep as Reference

The captured layers serve as visual reference for design work.

### Level 2+: Reconcile to DS

Use `code-to-canvas-reconciliation` skill to convert generic layers to DS components:

1. Return to VS Code
2. Use reconciliation skill
3. Replace generic layers with component instances
4. Bind variables instead of hardcoded colors

## Troubleshooting

### "generate_figma_design not available"
- Ensure you're using Claude Code CLI, not VS Code
- Verify Figma MCP is added: `claude mcp list`
- Re-authenticate: `/mcp` in Claude Code

### "Cannot connect to localhost"
- Claude Code's MCP runs remotely
- **Must use ngrok** to expose localhost
- Check ngrok is running: `curl http://localhost:4040/api/tunnels`

### Captures ngrok interstitial page
- Open ngrok URL in browser first
- Click through any "Visit Site" buttons
- Then run the capture

### OAuth errors
- Re-run `/mcp` in Claude Code
- Select figma and re-authenticate
- Ensure Figma account has appropriate access

## Limitations

- **Remote capture**: Figma MCP captures from public internet
- **Localhost requires ngrok**: No direct localhost access
- **Rate limits**: Check your Figma plan for API limits

## Integration Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     Your IDE (VS Code)                       │
│                                                              │
│  ┌─────────────────┐    ┌─────────────────────────────────┐ │
│  │ Your Code       │    │ Figma Console MCP               │ │
│  │ Development     │    │ - Design System ops             │ │
│  │                 │    │ - Screenshots                   │ │
│  │                 │    │ - Reconciliation                │ │
│  └────────┬────────┘    └─────────────────────────────────┘ │
│           │                           ▲                      │
│           │ localhost:{{PORT}}        │ reconcile            │
│           ▼                           │                      │
│  ┌─────────────────┐                  │                      │
│  │ Claude Code CLI │──────────────────┘                      │
│  │ (Bridge)        │                                         │
│  │                 │                                         │
│  │ generate_figma_ │───────► Figma File                     │
│  │ design          │         (captured layers)              │
│  └─────────────────┘                                         │
└─────────────────────────────────────────────────────────────┘
```

## Related Skills

- `figma-screen-creation`: Create screens from scratch with DS components
- `code-to-canvas-reconciliation`: Convert captured layers to DS components
- `design-system-ops`: Manage tokens and variables
