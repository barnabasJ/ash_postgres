# US-APMAP-02 — Order integer map values numerically

As a developer, I can filter integer map fields by numeric value.

## Scenario

Given two stored Posts whose declared integer size fields contain three and ten.
When the normal Ash read filters for values greater than nine.
Then only the Post containing ten matches.

## Verification

The unique owning case is the numeric-comparison test in `test/map_field_type_expr_test.exs`. It uses the real PostgreSQL data layer and native SQL Sandbox.
