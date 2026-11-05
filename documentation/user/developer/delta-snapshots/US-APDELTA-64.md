# US-APDELTA-64 — Reject incomplete temporal foreign-key delta state

As a developer, I need an incomplete temporal delta to fail before code generation can use an incorrect resource state.

Given a persisted temporal foreign-key delta without its original logical attribute metadata.
When the native persisted-state reader reduces the delta.
Then it raises a contextual `ConflictError` that identifies the missing metadata.

Owned by `test/delta_generation_security_test.exs`.
