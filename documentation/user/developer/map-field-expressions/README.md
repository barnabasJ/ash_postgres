# Typed map expressions

Developers can filter typed map fields through the normal Ash query API. These cases use the real PostgreSQL data layer and ordinary per-case SQL Sandbox ownership.

| Story                                            | Behavior                                       | Owning test                              |
| ------------------------------------------------ | ---------------------------------------------- | ---------------------------------------- |
| [US-APMAP-01](US-APMAP-01-integer-equality.md)   | Compare integer values as integers             | MapFieldTypeExprTest: integer equality   |
| [US-APMAP-02](US-APMAP-02-numeric-comparison.md) | Apply numeric ordering to integer map fields   | MapFieldTypeExprTest: numeric comparison |
| [US-APMAP-03](US-APMAP-03-string-equality.md)    | Preserve string equality for string map fields | MapFieldTypeExprTest: string equality    |
