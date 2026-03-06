# MCP Tools Reference

Quick reference for Figma Console MCP tools.

## Token Management

| Tool | Purpose | Example |
|------|---------|---------|
| `figma_setup_design_tokens` | Create complete token system | Create collection with modes and variables atomically |
| `figma_batch_create_variables` | Bulk create variables | Add multiple variables to existing collection |
| `figma_batch_update_variables` | Bulk update values | Update variable values across modes |
| `figma_create_variable_collection` | Create collection | New collection for tokens |
| `figma_create_variable` | Create single variable | Add one variable |
| `figma_add_mode` | Add mode to collection | Add "Dark" mode |
| `figma_get_variables` | Retrieve variables | Get tokens for mapping |

## Component Operations

| Tool | Purpose | Example |
|------|---------|---------|
| `figma_search_components` | Find components | Search "Button" in library |
| `figma_instantiate_component` | Create instance | Add Button to frame |
| `figma_set_instance_properties` | Configure instance | Set label text |
| `figma_get_component` | Get component info | Retrieve component data |
| `figma_get_component_details` | Deep inspection | View all properties |
| `figma_add_component_property` | Add property | Add "Size" variant |

## Layout & Structure

| Tool | Purpose | Example |
|------|---------|---------|
| `figma_execute` | Run Plugin API code | Create frame, bind variables |
| `figma_create_child` | Add child node | Add Frame or Text |
| `figma_clone_node` | Duplicate node | Copy existing element |
| `figma_delete_node` | Remove node | Delete element |

## Visual & Documentation

| Tool | Purpose | Example |
|------|---------|---------|
| `figma_take_screenshot` | Capture image | Visual validation |
| `figma_audit_design_system` | Health audit | Get scored report |
| `figma_set_description` | Add description | Document component |
| `figma_generate_component_doc` | Generate docs | Create component documentation |

## Comments & Collaboration

| Tool | Purpose | Example |
|------|---------|---------|
| `figma_get_comments` | Retrieve comments | Read feedback |
| `figma_delete_comment` | Remove comment | Clean up resolved |

## Usage Patterns

### Create Token Collection

```
figma_setup_design_tokens with:
  collectionName: "Colors"
  modes: ["Light", "Dark"]
  variables: [
    { name: "primary", type: "COLOR", values: { Light: "#0066FF", Dark: "#3388FF" } }
  ]
```

### Search and Instantiate Component

```
1. figma_search_components with query: "Button"
2. figma_instantiate_component with:
   - componentKey: (from search)
   - nodeId: (from search)
   - variant: { "Type": "Primary" }
   - parentId: (container id)
```

### Bind Variable

```
figma_execute with code:
  const node = figma.getNodeById('nodeId');
  const variable = figma.variables.getVariableById('variableId');
  node.setBoundVariable('fills', 0, 'color', variable);
```

### Visual Validation

```
figma_take_screenshot
// Analyze result
// If issues: fix and repeat
// If good: continue
```

## Tool Categories by Maturity Level

### Level 0+
- `figma_setup_design_tokens`
- `figma_batch_create_variables`
- `figma_create_variable_collection`
- `figma_execute`
- `figma_take_screenshot`

### Level 1+
- `figma_get_variables`
- `figma_batch_update_variables`
- `figma_audit_design_system`

### Level 2+
- `figma_search_components`
- `figma_instantiate_component`
- `figma_set_instance_properties`
- `figma_get_component_details`
- `figma_add_component_property`
