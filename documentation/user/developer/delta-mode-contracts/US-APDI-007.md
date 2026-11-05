# US-APDI-007 — renaming an attribute produces a RenameAttribute op

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through structural changes.

## Scenario

Given a resource changes one attribute name while retaining its other fields.
When native interactive generation receives an explicit yes answer to the rename prompt.
Then the encoded delta contains the rename rather than treating it as an unrelated field.

Coverage: `US-APDI-007` in `test/delta_mode_structural_changes_test.exs`.
