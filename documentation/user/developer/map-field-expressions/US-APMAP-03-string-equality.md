# US-APMAP-03 — Preserve string map comparisons

As a developer, I can compare a declared string map field with a string without changing its type.

## Scenario

Given a stored Post whose declared string display_template field contains the fixture template.
When the normal Ash read filters that map field by the exact template string.
Then it returns the same Post.

## Verification

The unique owning case is the string-equality test in `test/map_field_type_expr_test.exs`. It uses the real PostgreSQL data layer and native SQL Sandbox.
