#!/bin/bash
# Design-Code Workflow Customization Script
# Update configuration after initial setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

prompt() { echo -e "${BLUE}$1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
warning() { echo -e "${YELLOW}! $1${NC}"; }

echo "======================================"
echo "  Design-Code Workflow Customization"
echo "======================================"
echo ""

echo "What would you like to update?"
echo ""
echo "  1 - Upgrade maturity level"
echo "  2 - Add/update Figma libraries"
echo "  3 - Update tech stack settings"
echo "  4 - Add documentation platform"
echo "  5 - Update Figma access token"
echo "  6 - Add framework MCP tools"
echo "  7 - Exit"
echo ""
read -p "Select option (1-7): " CHOICE

case $CHOICE in
    1)
        echo ""
        prompt "Current maturity level can be found in config/design-system.yaml"
        echo ""
        echo "Maturity levels:"
        echo "  0 - Greenfield (no DS)"
        echo "  1 - Tokens Only"
        echo "  2 - Components"
        echo "  3 - Full System"
        echo ""
        read -p "New maturity level (0-3): " NEW_LEVEL
        
        if [[ "$NEW_LEVEL" =~ ^[0-3]$ ]]; then
            # Use sed to update the maturity level
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "s/^maturity_level: .*/maturity_level: $NEW_LEVEL/" "$ROOT_DIR/config/design-system.yaml"
            else
                sed -i "s/^maturity_level: .*/maturity_level: $NEW_LEVEL/" "$ROOT_DIR/config/design-system.yaml"
            fi
            success "Updated maturity level to $NEW_LEVEL"
            
            if [ "$NEW_LEVEL" -ge 1 ]; then
                warning "Don't forget to add library file keys if needed (option 2)"
            fi
        else
            echo "Invalid level"
        fi
        ;;
        
    2)
        echo ""
        prompt "Which library to update?"
        echo "  1 - Working file"
        echo "  2 - Foundations (tokens)"
        echo "  3 - Components"
        echo "  4 - Assets"
        read -p "Select (1-4): " LIB_CHOICE
        
        read -p "Figma file URL or key: " FILE_KEY
        if [[ "$FILE_KEY" == *"figma.com"* ]]; then
            FILE_KEY=$(echo "$FILE_KEY" | sed -E 's|.*figma.com/(design\|file)/([^/]+).*|\2|')
        fi
        
        echo ""
        echo "File key extracted: $FILE_KEY"
        echo ""
        warning "Please manually update config/design-system.yaml with this key"
        echo "Look for the appropriate library section and update file_key and enabled fields"
        ;;
        
    3)
        echo ""
        prompt "Tech stack settings"
        echo ""
        read -p "Framework (react/vue/flutter/etc): " FRAMEWORK
        read -p "Dev server command: " DEV_CMD
        read -p "Default port: " PORT
        
        warning "Please manually update config/tech-stack.yaml with these values"
        echo ""
        echo "framework: $FRAMEWORK"
        echo "dev_server.command: $DEV_CMD"
        echo "dev_server.default_port: $PORT"
        ;;
        
    4)
        echo ""
        prompt "Documentation platform"
        echo "  1 - Storybook"
        echo "  2 - Widgetbook"  
        echo "  3 - Other"
        read -p "Select (1-3): " DOC_CHOICE
        
        case $DOC_CHOICE in
            1) PLATFORM="storybook" ;;
            2) PLATFORM="widgetbook" ;;
            3) read -p "Platform name: " PLATFORM ;;
        esac
        
        read -p "Documentation URL (optional): " DOC_URL
        
        warning "Please manually update config/design-system.yaml:"
        echo ""
        echo "documentation:"
        echo "  enabled: true"
        echo "  platform: \"$PLATFORM\""
        echo "  url: \"$DOC_URL\""
        ;;
        
    5)
        echo ""
        read -p "New Figma access token: " TOKEN
        
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/FIGMA_ACCESS_TOKEN\": \"[^\"]*\"/FIGMA_ACCESS_TOKEN\": \"$TOKEN\"/" "$ROOT_DIR/.cursor/mcp.json"
        else
            sed -i "s/FIGMA_ACCESS_TOKEN\": \"[^\"]*\"/FIGMA_ACCESS_TOKEN\": \"$TOKEN\"/" "$ROOT_DIR/.cursor/mcp.json"
        fi
        success "Updated Figma token in .cursor/mcp.json"
        warning "Restart Cursor to apply changes"
        ;;
        
    6)
        echo ""
        prompt "Framework MCP tools"
        echo ""
        echo "Example configurations:"
        echo ""
        echo "For Dart/Flutter:"
        echo '  "dart": {'
        echo '    "command": "dart",'
        echo '    "args": ["mcp-server"]'
        echo '  }'
        echo ""
        echo "For TypeScript:"
        echo '  "typescript": {'
        echo '    "command": "npx",'
        echo '    "args": ["typescript-language-server", "--stdio"]'
        echo '  }'
        echo ""
        warning "Please manually add MCP tools to:"
        echo "  - .cursor/mcp.json (for Cursor)"
        echo "  - config/tech-stack.yaml (for documentation)"
        ;;
        
    7)
        echo "Bye!"
        exit 0
        ;;
        
    *)
        echo "Invalid option"
        ;;
esac

echo ""
echo "Done! Run this script again to make more changes."
