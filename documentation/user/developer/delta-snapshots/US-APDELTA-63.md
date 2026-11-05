# US-APDELTA-63 — Keep the full delta history when a resource moves schemas

As a developer, I need delta code generation to preserve the complete desired resource state across subsequent runs.

- **Given** a resource has a persisted initial delta in its original schema.
- **When** public generation moves it to archive with native confirmation.
- **Then** the target directory retains initial history plus the move, the state is correct, and unchanged generation writes no files.

Owned by `test/delta_generation_security_test.exs`.
