---
name: design-system-health
description: |-
  Analyze and audit design system health in Figma files.
  Evaluates naming conventions, token architecture, component metadata, and consistency.
  Use when checking DS quality, preparing for scale, or troubleshooting issues.
  
  Examples:
  - user: "Audit my design system" → run figma_audit_design_system
  - user: "Check design system health" → full health analysis
  - user: "Are my tokens well organized?" → token architecture evaluation
  - user: "Find inconsistencies in my DS" → consistency check
  - user: "Is my DS ready for AI workflows?" → AI-readiness assessment
---

# Design System Health Analysis

Audit and analyze design system quality in Figma. Works at Level 1+ (requires at least tokens).

## Prerequisites

- Read `config/design-system.yaml` to get library file keys
- Requires at least `maturity_level: 1` (tokens exist)

## Quick Health Check

Run a full audit:

```
figma_audit_design_system with:
  - fileUrl: (from config/design-system.yaml libraries.foundations or components)
```

This produces a scored dashboard evaluating:
- **Naming conventions** - Consistent, semantic naming
- **Token architecture** - Well-structured collections and modes
- **Component metadata** - Descriptions, documentation
- **Accessibility** - Color contrast, touch targets
- **Consistency** - Uniform patterns across components
- **Coverage** - Completeness of the system

## Detailed Analysis Workflows

### Token Architecture Review (Level 1+)

1. **Get all variables**:
```
figma_get_variables with:
  - fileUrl: (foundations library)
  - format: "summary"
```

2. **Check for issues**:
   - Missing semantic categories (backgrounds, text, borders)
   - Hardcoded values instead of aliases
   - Inconsistent naming patterns
   - Missing modes (e.g., Dark mode)

3. **Recommendations**:
   - Group by use case, not color name
   - Use aliases for derived values
   - Follow naming from `config/design-system.yaml`

### Component Quality Review (Level 2+)

1. **Search all components**:
```
figma_search_components with:
  - query: "" (empty to list all)
```

2. **Check each component for**:
   - Has description
   - Uses variables (not hardcoded colors)
   - Proper variant structure
   - Consistent naming with prefix

3. **Get detailed component info**:
```
figma_get_component_details with:
  - nodeId: (component id)
```

### Consistency Check

Compare design tokens with code tokens (if `tech-stack.yaml` has `design_tokens.enabled: true`):

1. **Extract Figma tokens** via `figma_get_variables`
2. **Read code tokens** from `design_tokens.location`
3. **Compare**:
   - Missing tokens in either direction
   - Value mismatches
   - Naming inconsistencies

### AI-Readiness Assessment

For effective AI workflows, check:

| Criterion | Why It Matters | How to Check |
|-----------|----------------|--------------|
| Semantic naming | AI understands intent | Review variable/component names |
| Descriptions | AI uses as context | Check component descriptions |
| Consistent structure | Predictable patterns | Review variant organization |
| Variable binding | Themeable output | Check for hardcoded values |
| Clear categories | Easier discovery | Review collection organization |

## Health Metrics

### Scoring Guide

| Score | Status | Action |
|-------|--------|--------|
| 90-100 | Excellent | Maintain current practices |
| 70-89 | Good | Minor improvements needed |
| 50-69 | Fair | Significant gaps to address |
| <50 | Poor | Major restructuring recommended |

### Common Issues and Fixes

| Issue | Impact | Fix |
|-------|--------|-----|
| Hardcoded colors | Breaks theming | Bind to variables |
| No component descriptions | AI can't understand usage | Add descriptions |
| Inconsistent naming | Discovery fails | Standardize with prefix |
| Missing dark mode | Limited theming | Add mode to collections |
| No semantic grouping | Hard to maintain | Reorganize by use case |

## Integration with Documentation Platforms (Level 3)

If `config/design-system.yaml` has `documentation.enabled: true`:

- Compare Figma components with Storybook/Widgetbook stories
- Check for undocumented components
- Verify prop coverage

## Reporting

After analysis, provide:

1. **Summary score** (0-100)
2. **Top 3 issues** to address
3. **Quick wins** (easy fixes)
4. **Roadmap** for improvement

## Tools Reference

| Tool | Purpose |
|------|---------|
| `figma_audit_design_system` | Full automated audit |
| `figma_get_variables` | Retrieve token data |
| `figma_search_components` | List all components |
| `figma_get_component_details` | Deep component inspection |
| `figma_take_screenshot` | Visual verification |
