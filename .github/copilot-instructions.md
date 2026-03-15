# Design-Code Workflow Instructions

These instructions apply to all work in this repository. Follow them to maintain design-code parity.

## Configuration Awareness

Before any design operation, read the configuration files:
- `config/design-system.yaml` - DS maturity level, libraries, naming
- `config/tech-stack.yaml` - Framework, tokens, components

## Maturity-Level Behavior

### Level 0 (Greenfield)
- Create tokens using `figma_setup_design_tokens`
- Use Code-to-Canvas for capturing UI
- Do not assume component library exists

### Level 1 (Tokens Only)
- Bind variables instead of hardcoding
- Use `design-system-ops` for token management
- Health checks are available

### Level 2+ (Components)
- Always search for existing components first
- Never create snowflake UI elements
- Use component instances, not raw shapes
- Bind all values to variables

## Visual Validation

After any Figma modification:
1. Take screenshot with `figma_take_screenshot`
2. Analyze for issues
3. Iterate if needed
4. Verify before completing

## No Snowflakes (Level 2+)

When component library exists:
- Do not create rectangles for UI elements; use components
- Do not hardcode colors; bind variables
- Do not invent new variants; use existing ones
- Do not create custom text styles; use text components

## Code-to-Canvas Workflow

For capturing running UI:
1. Ensure app is running on localhost
2. Use ngrok to expose
3. Open ngrok URL in browser first (clear interstitial)
4. Use Claude Code CLI with `generate_figma_design`
5. Consider reconciliation for Level 2+ projects

## Token Naming

Follow conventions from `config/design-system.yaml`:
- Use collection names from `variable_collections`
- Apply component prefix from `component_prefix`
- Maintain consistency with code tokens

## Key Principle

"Code to Design isn't the point. System Parity is."

The goal is maintaining alignment between design and code, not just moving assets between tools.
