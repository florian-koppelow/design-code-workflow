---
name: code-to-canvas-reconciliation
description: |-
  Reconcile Code-to-Canvas output with your design system.
  Converts generic Figma layers into governed DS components.
  Use when Code-to-Canvas has captured UI that needs to be system-aligned.
  
  Examples:
  - user: "Reconcile the captured screen with our design system" → analyze layers, replace with components
  - user: "Convert these layers to DS components" → map to DS, instantiate proper components
  - user: "Make this Code-to-Canvas output use our tokens" → bind variables instead of hardcoded values
  - user: "System-align the captured UI" → full reconciliation workflow
---

# Code-to-Canvas Reconciliation

Convert generic Code-to-Canvas layers into governed design system components.

## When to Use

Code-to-Canvas (`generate_figma_design`) captures running UI as editable layers but:
- Creates generic frames and shapes (not DS components)
- Uses hardcoded colors (not variables)
- Has no system awareness

This skill bridges the gap: **exploration speed + system governance**.

## Prerequisites

- Read `config/design-system.yaml` to check maturity level
- **Level 2+ required** for full component reconciliation
- **Level 1** can still bind variables to captured layers

## Reconciliation Workflow

### Step 1: Analyze Captured Layers

Take a screenshot and identify what was captured:

```
figma_take_screenshot to see the Code-to-Canvas output
```

Identify:
- UI patterns (buttons, cards, lists, inputs)
- Color usage (what should map to which tokens)
- Layout structure (navigation, content areas)

### Step 2: Create Parallel Structure

Create a new Section next to the captured content:

```
figma_execute:
  const originalSection = figma.getNodeById('captured-id');
  const section = figma.createSection();
  section.name = 'Reconciled - [Screen Name]';
  section.x = originalSection.x + originalSection.width + 100;
```

### Step 3: Map and Replace Components (Level 2+)

If component library exists (`maturity_level >= 2`):

**Cache components first:**
```
figma_search_components with query: "" (empty to load all)
```

**For each identified UI pattern:**

**Buttons:**
```
1. figma_search_components: query="Button"
2. figma_instantiate_component with matching variant
3. figma_set_instance_properties for label text
```

**Cards:**
```
1. figma_search_components: query="Card"
2. Instantiate card component
3. Add child components (list items, icons)
```

**Navigation:**
```
1. figma_search_components: query="Top Bar" or "Bottom Navigation"
2. Instantiate with correct variant
3. Configure via instance properties
```

### Step 4: Bind Variables (Level 1+)

Replace hardcoded values with design tokens:

```
figma_get_variables with:
  - fileUrl: (from config/design-system.yaml libraries.foundations)
  - format: "filtered"
  - collection: (from config naming_conventions.variable_collections)
```

Bind via `figma_execute`:

```javascript
const node = figma.getNodeById('nodeId');
const variable = figma.variables.getVariableById('variableId');
node.setBoundVariable('fills', 0, 'color', variable);
```

### Step 5: Visual Comparison

Compare original capture with reconciled version:

```
figma_take_screenshot of both sections
```

Verify:
- Visual fidelity maintained
- All elements use DS components (Level 2+)
- No hardcoded colors remain
- Layout matches original intent

### Step 6: Archive or Delete Original

Once reconciled version is verified:
- Keep original for reference (rename to "[Original] Screen Name")
- Or delete if no longer needed

## Common Layer-to-Component Mappings

Use these patterns for mapping captured layers to DS components:

| Captured Layer Pattern | Likely Component |
|------------------------|------------------|
| Rectangle with rounded corners | Card or Container |
| Text with button-like styling | Button |
| Row of icons at bottom | Bottom Navigation |
| Input field shape | Text Field |
| List of repeated items | List Item |
| Overlay with centered content | Dialog or Modal |
| Toggle/switch shape | Switch |
| Circular image | Avatar |
| Small label with background | Badge or Tag |

## Color Reconciliation

Map observed colors to semantic tokens:

| Visual Purpose | Token Category |
|----------------|----------------|
| Primary brand color | `content.brandPrimary` or `primary` |
| Background fills | `backgrounds.*` |
| Text colors | `content.*` |
| Border colors | `borders.*` |
| Error states | `content.error` or `error` |
| Success states | `content.success` or `success` |

Check `config/design-system.yaml` for exact collection and variable names.

## Level-Specific Workflows

### Level 1 (Tokens Only)

Can't replace with components, but can:
1. Bind colors to variables
2. Apply spacing tokens
3. Use typography variables

### Level 2+ (Components Available)

Full reconciliation:
1. Replace shapes with component instances
2. Bind all variables
3. Configure via instance properties
4. Maintain visual fidelity

## Key Principle

> "Code to Design isn't the point. System Parity is."

Code-to-Canvas is powerful for rapid exploration. Reconciliation ensures that exploration feeds back into the governed system.

## Troubleshooting

### Can't find matching component
- Try broader search terms
- Check component categories in config
- May need to create the component first

### Colors don't match variables
- Check mode (Light vs Dark)
- May need to create new variable
- Document for future DS updates

### Layout breaks after reconciliation
- Check auto-layout settings
- Verify padding and spacing
- May need manual adjustment

## Related Skills

- `code-to-canvas-bridge`: Capture running UI to Figma
- `figma-screen-creation`: Create new screens with DS components
- `design-system-ops`: Create missing tokens or components
