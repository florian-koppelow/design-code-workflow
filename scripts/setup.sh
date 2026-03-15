#!/bin/bash
# Design-Code Workflow Setup Script
# Interactive setup for the design-code workflow tools

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

echo "======================================"
echo "  Design-Code Workflow Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
prompt() {
    echo -e "${BLUE}$1${NC}"
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

warning() {
    echo -e "${YELLOW}! $1${NC}"
}

error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check prerequisites
echo "Checking prerequisites..."
echo ""

MISSING_DEPS=0

# Check for npm
if command -v npm &> /dev/null; then
    success "npm found"
else
    error "npm not found - install Node.js from https://nodejs.org"
    MISSING_DEPS=1
fi

# Check for Claude Code CLI
if command -v claude &> /dev/null; then
    success "Claude Code CLI found"
else
    warning "Claude Code CLI not found"
    read -p "Install Claude Code CLI? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g @anthropic-ai/claude-code
        success "Claude Code CLI installed"
    fi
fi

# Check for ngrok
if command -v ngrok &> /dev/null; then
    success "ngrok found"
else
    warning "ngrok not found"
    echo "Install ngrok for Code-to-Canvas:"
    echo "  macOS: brew install ngrok"
    echo "  npm: npm install -g ngrok"
    echo ""
fi

if [ $MISSING_DEPS -eq 1 ]; then
    error "Missing required dependencies. Please install them and run again."
    exit 1
fi

echo ""
echo "======================================"
echo "  Configuration"
echo "======================================"
echo ""

# Maturity Level
prompt "What's your current design system maturity?"
echo "  0 - Greenfield (no DS exists yet)"
echo "  1 - Tokens Only (variables in Figma, no components)"
echo "  2 - Components (Figma component library exists)"
echo "  3 - Full System (DS + documentation platform)"
echo ""
read -p "Enter maturity level (0-3): " MATURITY_LEVEL

if ! [[ "$MATURITY_LEVEL" =~ ^[0-3]$ ]]; then
    error "Invalid maturity level. Using 0."
    MATURITY_LEVEL=0
fi

# Design System Name
echo ""
read -p "Design system name (e.g., 'Acme DS', 'MyApp'): " DS_NAME
DS_NAME=${DS_NAME:-"My Design System"}

# Figma Access Token
echo ""
prompt "Figma Access Token"
echo "Create one at: https://www.figma.com/developers/api#access-tokens"
read -p "Enter your Figma access token: " FIGMA_TOKEN

if [ -z "$FIGMA_TOKEN" ]; then
    warning "No token provided. You'll need to add it manually to .vscode/mcp.json"
    FIGMA_TOKEN="YOUR_FIGMA_TOKEN_HERE"
fi

# Working File
echo ""
prompt "Figma Working File"
echo "This is your main file for creating designs."
echo "Paste the full URL or just the file key."
read -p "Figma file URL/key: " WORKING_FILE

# Extract file key from URL if needed
if [[ "$WORKING_FILE" == *"figma.com"* ]]; then
    WORKING_FILE=$(echo "$WORKING_FILE" | sed -E 's|.*figma.com/(design\|file)/([^/]+).*|\2|')
fi

# Library configuration based on maturity
FOUNDATIONS_ENABLED="false"
FOUNDATIONS_KEY=""
COMPONENTS_ENABLED="false"
COMPONENTS_KEY=""
ASSETS_ENABLED="false"
ASSETS_KEY=""

if [ "$MATURITY_LEVEL" -ge 1 ]; then
    echo ""
    prompt "Foundations/Tokens Library (Level 1+)"
    read -p "Figma file URL/key (or press Enter to skip): " FOUNDATIONS_KEY
    if [ -n "$FOUNDATIONS_KEY" ]; then
        FOUNDATIONS_ENABLED="true"
        if [[ "$FOUNDATIONS_KEY" == *"figma.com"* ]]; then
            FOUNDATIONS_KEY=$(echo "$FOUNDATIONS_KEY" | sed -E 's|.*figma.com/(design\|file)/([^/]+).*|\2|')
        fi
    fi
fi

if [ "$MATURITY_LEVEL" -ge 2 ]; then
    echo ""
    prompt "Components Library (Level 2+)"
    read -p "Figma file URL/key (or press Enter to skip): " COMPONENTS_KEY
    if [ -n "$COMPONENTS_KEY" ]; then
        COMPONENTS_ENABLED="true"
        if [[ "$COMPONENTS_KEY" == *"figma.com"* ]]; then
            COMPONENTS_KEY=$(echo "$COMPONENTS_KEY" | sed -E 's|.*figma.com/(design\|file)/([^/]+).*|\2|')
        fi
    fi
    
    echo ""
    prompt "Assets Library (Level 2+)"
    read -p "Figma file URL/key (or press Enter to skip): " ASSETS_KEY
    if [ -n "$ASSETS_KEY" ]; then
        ASSETS_ENABLED="true"
        if [[ "$ASSETS_KEY" == *"figma.com"* ]]; then
            ASSETS_KEY=$(echo "$ASSETS_KEY" | sed -E 's|.*figma.com/(design\|file)/([^/]+).*|\2|')
        fi
    fi
fi

# Documentation platform
DOC_ENABLED="false"
DOC_PLATFORM=""
DOC_URL=""

if [ "$MATURITY_LEVEL" -ge 3 ]; then
    echo ""
    prompt "Documentation Platform (Level 3)"
    echo "  1 - Storybook"
    echo "  2 - Widgetbook"
    echo "  3 - Other"
    echo "  4 - None"
    read -p "Select platform (1-4): " DOC_CHOICE
    
    case $DOC_CHOICE in
        1) DOC_ENABLED="true"; DOC_PLATFORM="storybook" ;;
        2) DOC_ENABLED="true"; DOC_PLATFORM="widgetbook" ;;
        3) DOC_ENABLED="true"; read -p "Platform name: " DOC_PLATFORM ;;
        *) ;;
    esac
    
    if [ "$DOC_ENABLED" = "true" ]; then
        read -p "Documentation URL (optional): " DOC_URL
    fi
fi

# Tech Stack
echo ""
echo "======================================"
echo "  Tech Stack Configuration"
echo "======================================"
echo ""

prompt "Framework"
echo "  Examples: react, vue, angular, flutter, svelte, nextjs"
read -p "Framework: " FRAMEWORK

prompt "Dev server command"
echo "  Examples: npm run dev, flutter run -d chrome --web-port=8080"
read -p "Command: " DEV_COMMAND

read -p "Default port (e.g., 3000, 8080): " DEV_PORT
DEV_PORT=${DEV_PORT:-3000}

# Generate configuration files
echo ""
echo "======================================"
echo "  Generating Configuration"
echo "======================================"
echo ""

# Update design-system.yaml
cat > "$ROOT_DIR/config/design-system.yaml" << EOF
# Design System Configuration
# Generated by setup.sh

name: "$DS_NAME"
maturity_level: $MATURITY_LEVEL

libraries:
  working_file:
    file_key: "$WORKING_FILE"
    description: "Main file for creating screens and prototypes"
  
  foundations:
    enabled: $FOUNDATIONS_ENABLED
    file_key: "$FOUNDATIONS_KEY"
    description: "Variables, colors, spacing, typography tokens"
  
  components:
    enabled: $COMPONENTS_ENABLED
    file_key: "$COMPONENTS_KEY"
    description: "UI components (buttons, cards, inputs, etc.)"
  
  assets:
    enabled: $ASSETS_ENABLED
    file_key: "$ASSETS_KEY"
    description: "Icons, illustrations, logos"

naming_conventions:
  component_prefix: ""
  variable_collections:
    colors: "Colors"
    spacing: "Spacing"
    typography: "Typography"
    corner_radius: "Corner Radius"

documentation:
  enabled: $DOC_ENABLED
  platform: "$DOC_PLATFORM"
  url: "$DOC_URL"

component_categories:
  navigation: ["Top Bar", "Bottom Navigation", "Tab Bar", "Drawer"]
  actions: ["Button", "Icon Button", "FAB", "Link"]
  content: ["Card", "List Item", "Tile", "Avatar"]
  inputs: ["Text Field", "Input", "Checkbox", "Switch", "Radio", "Slider"]
  feedback: ["Dialog", "Modal", "Snackbar", "Toast", "Alert"]
  status: ["Badge", "Tag", "Progress", "Indicator", "Spinner"]
EOF
success "Created config/design-system.yaml"

# Update tech-stack.yaml
cat > "$ROOT_DIR/config/tech-stack.yaml" << EOF
# Tech Stack Configuration
# Generated by setup.sh

framework: "$FRAMEWORK"
package_manager: ""

dev_server:
  command: "$DEV_COMMAND"
  default_port: $DEV_PORT
  env: {}

design_tokens:
  enabled: false
  location: ""
  format: ""
  patterns:
    colors: ""
    spacing: ""
    typography: ""

components:
  enabled: false
  location: ""
  naming_convention: "PascalCase"
  index_file: ""

mcp_tools: {}

code_generation:
  component_template: ""
  token_reference: ""
EOF
success "Created config/tech-stack.yaml"

# Generate MCP config
mkdir -p "$ROOT_DIR/.vscode"
cat > "$ROOT_DIR/.vscode/mcp.json" << EOF
{
  "mcpServers": {
    "figma-console": {
      "command": "npx",
      "args": ["-y", "figma-console-mcp@latest"],
      "env": {
        "FIGMA_ACCESS_TOKEN": "$FIGMA_TOKEN",
        "ENABLE_MCP_APPS": "true"
      }
    },
    "figma-code-to-canvas": {
      "type": "http",
      "url": "https://mcp.figma.com/mcp"
    }
  }
}
EOF
success "Created .vscode/mcp.json"

# Setup Claude Code Figma MCP
echo ""
echo "======================================"
echo "  Claude Code Setup"
echo "======================================"
echo ""

if command -v claude &> /dev/null; then
    echo "Adding Figma MCP to Claude Code..."
    claude mcp add --scope user --transport http figma https://mcp.figma.com/mcp 2>/dev/null || warning "Figma MCP may already be configured"
    success "Claude Code configured"
fi

echo ""
echo "======================================"
echo "  Setup Complete!"
echo "======================================"
echo ""
success "Configuration files generated"
echo ""

echo "NEXT STEPS:"
echo ""
echo "1. OPEN FIGMA DESKTOP"
echo "   - Go to Plugins menu"
echo "   - Run 'figma-desktop-bridge' plugin"
echo ""
echo "2. RESTART VS CODE"
echo "   - Restart to load the new MCP configuration"
echo ""
echo "3. AUTHENTICATE CLAUDE CODE (for Code-to-Canvas)"
echo "   - Run: claude"
echo "   - Type: /mcp"
echo "   - Select 'figma' and authorize"
echo ""

if [ -z "$WORKING_FILE" ]; then
    warning "Remember to add your Figma working file key to config/design-system.yaml"
fi

if [ "$FIGMA_TOKEN" = "YOUR_FIGMA_TOKEN_HERE" ]; then
    warning "Remember to add your Figma token to .vscode/mcp.json"
fi

echo ""
echo "======================================"
echo "  Ready to use!"
echo "======================================"
echo ""
echo "Try these commands in VS Code Agent chat:"
echo ""
if [ "$MATURITY_LEVEL" -eq 0 ]; then
    echo "  'Create a color palette in Figma'"
    echo "  'Set up spacing tokens'"
fi
if [ "$MATURITY_LEVEL" -ge 1 ]; then
    echo "  'Audit my design system health'"
    echo "  'Capture my running app to Figma'"
fi
if [ "$MATURITY_LEVEL" -ge 2 ]; then
    echo "  'Create a login screen in Figma'"
    echo "  'Reconcile captured layers to DS'"
fi
echo ""
echo "Documentation: docs/WORKFLOW-REFERENCE.md"
echo ""
