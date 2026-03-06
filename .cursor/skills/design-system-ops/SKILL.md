---
name: design-system-ops
description: |-
  Create and manage design system tokens, variables, and components in Figma.
  Works at any maturity level - from creating a DS from scratch to managing existing systems.
  Use proactively when creating tokens, organizing variables, or managing DS structure.
  
  Examples:
  - user: "Create a color palette in Figma" → use figma_setup_design_tokens
  - user: "Add spacing tokens" → use figma_batch_create_variables
  - user: "Organize my variables" → reorganize collections
  - user: "Create a design system from scratch" → full DS creation workflow
  - user: "Sync tokens from code to Figma" → extract and create variables
---

# Design System Operations

Create, organize, and manage design system elements in Figma. Works at any maturity level.

## Context

Read `config/design-system.yaml` to understand the current maturity level and available libraries.

## Maturity-Aware Workflows

### Level 0: Create Base Design System

For greenfield projects with no existing DS:

1. **Create a new Figma file** (or use existing working file)
2. **Set up token collections** using `figma_setup_design_tokens`:

```
figma_setup_design_tokens with:
  - collectionName: "Colors"
  - modes: ["Light", "Dark"]  # or just ["Default"]
  - variables: [
      { name: "primary", type: "COLOR", values: { "Light": "#0066FF", "Dark": "#3388FF" } },
      { name: "secondary", type: "COLOR", values: { "Light": "#6B7280", "Dark": "#9CA3AF" } },
      ...
    ]
```

3. **Create spacing tokens**:

```
figma_setup_design_tokens with:
  - collectionName: "Spacing"
  - modes: ["Default"]
  - variables: [
      { name: "xs", type: "FLOAT", values: { "Default": 4 } },
      { name: "sm", type: "FLOAT", values: { "Default": 8 } },
      { name: "md", type: "FLOAT", values: { "Default": 16 } },
      { name: "lg", type: "FLOAT", values: { "Default": 24 } },
      { name: "xl", type: "FLOAT", values: { "Default": 32 } },
    ]
```

4. **Create typography tokens** (if needed):

```
figma_setup_design_tokens with:
  - collectionName: "Typography"
  - variables for font sizes, line heights, etc.
```

5. **Update config** to Level 1 after tokens are created

### Level 1+: Manage Existing Tokens

**Reorganize variables:**
```
Reorganize the color variables by grouping them into semantic categories 
(backgrounds, text, borders, interactive)
```

**Add new variables:**
```
figma_batch_create_variables with:
  - collectionId: (from existing collection)
  - variables: [array of new variables]
```

**Update variable values:**
```
figma_batch_update_variables with:
  - updates: [{ variableId, modeId, value }]
```

### Level 2+: Component Operations

**Add component variants:**
```
figma_add_component_property with:
  - nodeId: component node
  - propertyName: "Size"
  - propertyType: "VARIANT"
  - values: ["Small", "Medium", "Large"]
```

**Document components:**
```
figma_set_description with:
  - nodeId: component node
  - description: "Usage guidelines..."
```

## Create DS from Existing Code

If you have tokens defined in code (check `config/tech-stack.yaml` for `design_tokens.enabled`):

1. **Analyze code tokens** by reading files at `design_tokens.location`
2. **Extract token values** (colors, spacing, typography)
3. **Map to Figma collections** using naming from `config/design-system.yaml`
4. **Create variables** using `figma_setup_design_tokens` or `figma_batch_create_variables`
5. **Verify parity** between code and Figma

## Key Tools

| Tool | Purpose | Level |
|------|---------|-------|
| `figma_setup_design_tokens` | Create complete token system atomically | 0+ |
| `figma_batch_create_variables` | Bulk create variables | 0+ |
| `figma_batch_update_variables` | Bulk update variable values | 1+ |
| `figma_create_variable_collection` | Create new collection | 0+ |
| `figma_add_mode` | Add mode to collection (e.g., Dark) | 1+ |
| `figma_add_component_property` | Add properties to components | 2+ |
| `figma_set_description` | Document components | 2+ |

## Visual Validation

After each operation:
```
figma_take_screenshot to verify changes
```

## Naming Conventions

Use names from `config/design-system.yaml`:
- Collection names: `variable_collections.colors`, etc.
- Prefix: `naming_conventions.component_prefix`
