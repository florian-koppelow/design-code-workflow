# Use Cases

Step-by-step guides for all supported design-code workflows.

## Quick Reference

| Use Case | Min Level | Prompt Example |
|----------|-----------|----------------|
| [Create Base DS](#1-create-base-design-system) | 0 | "Create a color palette" |
| [DS from Code](#2-create-ds-from-existing-code) | 0 | "Sync my code tokens to Figma" |
| [Code to Canvas](#3-code-to-canvas) | 0 | "Capture my app to Figma" |
| [Create Screens](#4-create-screens-in-figma) | 2 | "Create a login screen" |
| [Build from Figma](#5-build-code-from-figma) | 1 | "Implement this Figma design" |
| [Reconcile Layers](#6-reconcile-code-to-canvas-output) | 1 | "Convert to DS components" |
| [DS Health](#7-design-system-health-check) | 1 | "Audit my design system" |
| [Iterate Code](#8-iterate-code) | 1 | "Check design-code parity" |

---

## 1. Create Base Design System

**Maturity Level:** 0 (Greenfield)

**Goal:** Create a design system from scratch in Figma.

### Step by Step

1. **Start with colors:**
   ```
   Create a color palette in Figma with:
   - Primary: blue (#0066FF)
   - Secondary: gray (#6B7280)
   - Success: green (#10B981)
   - Warning: orange (#F59E0B)
   - Error: red (#EF4444)
   Add light and dark mode variants.
   ```

2. **Add spacing tokens:**
   ```
   Create spacing tokens: 4px (xs), 8px (sm), 16px (md), 24px (lg), 32px (xl)
   ```

3. **Add typography tokens:**
   ```
   Create typography scale with sizes for headings (h1-h6) and body text.
   ```

4. **Verify and screenshot:**
   ```
   Take a screenshot of the variables panel.
   ```

5. **Update maturity:** Edit `config/design-system.yaml`:
   ```yaml
   maturity_level: 1
   libraries:
     foundations:
       enabled: true
       file_key: "your-file-key"
   ```

### Example Prompts

- "Set up a minimal design system with 5 colors and 5 spacing values"
- "Create brand colors based on #7C3AED as primary"
- "Add semantic color tokens for backgrounds, text, and borders"

---

## 2. Create DS from Existing Code

**Maturity Level:** 0 (Figma) + Existing code tokens

**Goal:** Sync your code's design tokens to Figma.

### Prerequisites

Configure `config/tech-stack.yaml`:
```yaml
design_tokens:
  enabled: true
  location: "src/tokens/"  # Your token file location
  format: "typescript"     # Your format
```

### Step by Step

1. **Ask for sync:**
   ```
   Read my design tokens from src/tokens/ and create matching 
   Figma variables. Preserve the naming structure.
   ```

2. **Agent reads code files:**
   - Parses token values
   - Maps to Figma collections
   - Creates variables

3. **Verify naming:**
   ```
   Compare the Figma variables with my code tokens. 
   Are there any mismatches?
   ```

4. **Update config to Level 1**

### Example Prompts

- "Import my Tailwind colors to Figma"
- "Sync CSS custom properties to Figma variables"
- "Create Figma tokens from my theme.dart file"

---

## 3. Code to Canvas

**Maturity Level:** 0+

**Goal:** Capture your running app as editable Figma layers.

### Prerequisites

- Claude Code CLI installed
- ngrok installed and configured
- Figma MCP added to Claude Code

### Step by Step

1. **Start your app:**
   ```bash
   npm run dev  # or your dev command
   ```

2. **Start ngrok:**
   ```bash
   ngrok http 3000  # your port
   ```

3. **Open ngrok URL in browser** to clear interstitial

4. **In Claude Code CLI:**
   ```
   Capture the app at https://abc123.ngrok-free.dev 
   to my Figma file https://figma.com/design/FILE_KEY
   Create a page called "App Capture - March 2026"
   ```

5. **Result:** New page in Figma with captured UI

### Example Prompts (in Claude Code)

- "Capture https://myapp.ngrok.dev to Figma file [URL]"
- "Screenshot my running app at localhost via ngrok to Figma"
- "Push this UI to my Figma working file"

---

## 4. Create Screens in Figma

**Maturity Level:** 2+ (requires component library)

**Goal:** Build screens using DS components.

### Step by Step

1. **Request a screen:**
   ```
   Create a login screen in Figma with:
   - App logo at top
   - Email and password fields
   - Login button (primary)
   - "Forgot password" link
   - "Sign up" link at bottom
   ```

2. **Agent workflow:**
   - Creates Section container
   - Searches component library
   - Instantiates components
   - Configures properties
   - Binds variables

3. **Review and iterate:**
   ```
   Move the logo higher and add more spacing between the inputs.
   ```

4. **Validate:**
   ```
   Take a screenshot of the login screen.
   ```

### Example Prompts

- "Create a settings page with toggle switches for notifications"
- "Build a product card with image, title, price, and add-to-cart button"
- "Design a navigation drawer with 5 menu items"
- "Create a modal dialog for delete confirmation"

---

## 5. Build Code from Figma

**Maturity Level:** 1+

**Goal:** Get implementation guidance from Figma designs.

### Step by Step

1. **Share Figma link:**
   ```
   Implement this Figma design:
   https://figma.com/design/FILE_KEY/File-Name?node-id=1-2
   ```

2. **Agent extracts:**
   - Layout structure
   - Component mappings
   - Token references
   - Implementation guidance

3. **Receive mapping:**
   ```markdown
   ## Component Mapping
   | Figma Element | Code Component |
   | Button/Primary | <Button variant="primary"> |
   
   ## Token Mapping
   | Figma Token | Code Reference |
   | Colors/Primary | var(--color-primary) |
   ```

4. **Implement based on guidance**

### Example Prompts

- "What components do I need for this Figma screen?"
- "Map this Figma design to my React components"
- "Analyze this design and tell me what tokens it uses"

---

## 6. Reconcile Code-to-Canvas Output

**Maturity Level:** 1+ (2+ for full component replacement)

**Goal:** Convert generic captured layers to DS components.

### Step by Step

1. **After Code-to-Canvas capture:**
   ```
   Reconcile the captured screen with our design system.
   Replace generic layers with DS components.
   ```

2. **Agent workflow:**
   - Analyzes captured layers
   - Identifies UI patterns
   - Creates parallel section
   - Instantiates DS components (Level 2+)
   - Binds variables (Level 1+)

3. **Compare:**
   ```
   Take screenshots of both original and reconciled versions.
   ```

4. **Cleanup:**
   ```
   The reconciled version looks good. Delete the original capture.
   ```

### Example Prompts

- "Convert these captured layers to use our component library"
- "Replace hardcoded colors with design tokens"
- "System-align the captured UI"
- "Make this Code-to-Canvas output use our variables"

---

## 7. Design System Health Check

**Maturity Level:** 1+

**Goal:** Audit design system quality.

### Step by Step

1. **Request audit:**
   ```
   Audit my design system health.
   ```

2. **Agent runs audit** on configured libraries

3. **Review report:**
   - Naming conventions score
   - Token architecture score
   - Component metadata score
   - Recommendations

4. **Address issues:**
   ```
   Fix the naming inconsistencies found in the audit.
   ```

### Example Prompts

- "Check if my design system is well-organized"
- "Is my DS ready for AI-powered workflows?"
- "Find inconsistencies in my component library"
- "What's the health score of my Figma tokens?"

---

## 8. Iterate Code

**Maturity Level:** 1+

**Goal:** Keep design and code synchronized.

### Design-First Flow

1. **Update design in Figma** (manually or via skills)
2. **Get changes:**
   ```
   What changed in this Figma design since last sync?
   https://figma.com/design/FILE_KEY?node-id=1-2
   ```
3. **Update code based on guidance**

### Code-First Flow

1. **Update code** (new components, tokens)
2. **Capture to Figma:**
   ```
   Capture my updated app to Figma.
   ```
3. **Reconcile:**
   ```
   Reconcile captured changes with our DS.
   ```

### Parity Check

```
Compare this Figma design with my current code implementation.
Are there any differences?
```

### Example Prompts

- "Sync Figma changes to my codebase"
- "What's different between design and code?"
- "Update my code to match the new Figma design"
- "The design changed—what code needs updating?"

---

## Tips for Success

1. **Start small:** Begin with Level 0 workflows, upgrade gradually
2. **Validate often:** Use screenshots after each change
3. **Check config:** Skills read from config files—keep them updated
4. **Use specific prompts:** Include details like colors, sizes, component names
5. **Iterate:** Don't expect perfect results first try—refine as needed
