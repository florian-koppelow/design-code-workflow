---
name: figma-screen-creation
description: |-
  Create screens in Figma using design system components and variables.
  Adapts to maturity level - uses DS components when available, creates layouts when not.
  Use proactively when creating, building, or designing screens in Figma via MCP.
  
  Examples:
  - user: "Create a login screen in Figma" → search components, instantiate from library
  - user: "Build a settings page in Figma" → use DS components if available
  - user: "Design a card layout in Figma" → instantiate or create Card
  - user: "Add a button to the Figma screen" → search Button component, instantiate with variant
  - user: "Create UI mockup in Figma" → compose from library or create structure
---

# Figma Screen Creation

Create screens in Figma using design system components when available, or structured layouts when not.

## Context

Read `config/design-system.yaml` to determine:
- `maturity_level`: What's available (0-3)
- `libraries.components.file_key`: Component library (if Level 2+)
- `libraries.foundations.file_key`: Token library (if Level 1+)
- `naming_conventions`: Component prefix and collection names

## Maturity-Aware Workflow

### Level 0-1: No Component Library

Create screens with manual layouts:

1. **Create container structure**:
```
figma_execute:
  const page = figma.currentPage;
  const frame = figma.createFrame();
  frame.name = 'Screen Name';
  frame.resize(375, 812); // Mobile viewport
  frame.layoutMode = 'VERTICAL';
  frame.paddingTop = frame.paddingBottom = 16;
  frame.paddingLeft = frame.paddingRight = 16;
  frame.itemSpacing = 16;
```

2. **Add layout frames** (not visual elements):
```
figma_create_child with:
  - parentId: frame id
  - type: FRAME
  - name: "Header"
  - layoutMode: "HORIZONTAL"
```

3. **Bind variables if available** (Level 1):
```
figma_get_variables to find available tokens
figma_execute to bind: node.setBoundVariable('fills', 0, 'color', variable)
```

4. **Add text placeholders**:
```
figma_create_child with:
  - type: TEXT
  - characters: "Heading"
```

### Level 2+: With Component Library

Use the full component workflow:

#### Step 1: Session Setup

Cache the component library at session start:

```
figma_search_components with:
  - query: "" (empty to load all)
```

This populates the component index. NodeIds are session-specific.

#### Step 2: Create Container

Create a Section or Frame for the screen:

```
figma_execute:
  const section = figma.createSection();
  section.name = 'Screen Name';
  section.resizeWithoutConstraints(375, 812);
```

**CRITICAL**: Never place components directly on blank canvas.

#### Step 3: Search and Instantiate Components

For every UI element:

1. **Search** for the component:
```
figma_search_components with:
  - query: "Button"
  - category: (from config component_categories)
```

2. **Instantiate** from library:
```
figma_instantiate_component with:
  - componentKey: (from search)
  - nodeId: (from search)
  - variant: { "Type": "Primary", "State": "Default" }
  - parentId: (section/frame id)
```

3. **Configure** via instance properties:
```
figma_set_instance_properties with:
  - nodeId: (instance id)
  - properties: { "Label": "Submit" }
```

#### Step 4: Apply Variables

Bind to design tokens instead of hardcoding:

```
figma_get_variables with:
  - fileUrl: (foundations library from config)
  - collection: "Colors"
```

```javascript
// Via figma_execute
const node = figma.getNodeById('nodeId');
const variable = figma.variables.getVariableById('variableId');
node.setBoundVariable('fills', 0, 'color', variable);
```

## Component Discovery

Use categories from `config/design-system.yaml`:

| Need | Search Query |
|------|--------------|
| Navigation | "Top Bar", "Bottom Navigation", "Tab Bar" |
| Actions | "Button", "Icon Button", "FAB" |
| Content | "Card", "List Item", "Tile" |
| Input | "Text Field", "Input", "Checkbox", "Switch" |
| Feedback | "Dialog", "Modal", "Snackbar" |
| Status | "Badge", "Tag", "Progress" |

If component prefix is configured, include it: `{prefix} Button`

## Visual Validation Loop

After creating elements:

```
Create → Screenshot → Analyze → Iterate → Verify
```

**Process:**
1. `figma_take_screenshot` to capture result
2. Analyze for issues
3. Fix and iterate
4. Verify final output

**Check for:**
- Proper alignment and spacing
- Correct component usage (Level 2+)
- No floating elements outside containers
- Variables bound (not hardcoded)
- Consistent with design patterns

## Prohibited Actions (Level 2+)

When component library exists, avoid snowflakes:

| Don't | Do Instead |
|-------|------------|
| Create rectangles for UI | Instantiate a component |
| Hardcode colors | Bind variables |
| Create custom text styles | Use text component |
| Invent new variants | Use existing variants |

## Allowed at Any Level

- Create FRAMEs for layout containers
- Bind variables via `figma_execute`
- Update text content on instances
- Adjust auto-layout properties

## Troubleshooting

**Component not found:**
- Try broader search terms
- Check if prefix is needed
- List all with empty query

**Instance properties not working:**
- Check `componentProperties` for available props
- Property names may have `#nodeId` suffixes
- Use `figma_get_component_details` to inspect

**Variables not binding:**
- Ensure variable is from correct collection
- Check type matches (COLOR for fills)
- Use `resolveAliases: true` when getting variables
