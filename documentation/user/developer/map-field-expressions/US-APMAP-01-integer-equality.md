# US-APMAP-01 — Compare integer map values as integers

As a developer, I can compare a declared integer map field with an integer through an Ash query.

## Scenario

Given a stored Post whose keyword_map size field is declared as an integer and contains three.
When the normal Ash read filters that map field with integer equality to three.
Then it returns the same Post.

## Verification

The unique owning case is the integer-equality test in `test/map_field_type_expr_test.exs`. It uses the real PostgreSQL data layer and native SQL Sandbox.
