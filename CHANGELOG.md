# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](Https://conventionalcommits.org) for commit guidelines.

<!-- changelog -->

## [v1.3.18](https://github.com/ash-project/ash_postgres/compare/v1.3.17...v1.3.18) (2023-03-23)




## [v1.3.17](https://github.com/ash-project/ash_postgres/compare/v1.3.16...v1.3.17) (2023-03-20)




### Bug Fixes:

* properly map `parent` bindings in `exists`

## [v1.3.16](https://github.com/ash-project/ash_postgres/compare/v1.3.15...v1.3.16) (2023-03-03)




### Improvements:

* support new date expressions

## [v1.3.15](https://github.com/ash-project/ash_postgres/compare/v1.3.14...v1.3.15) (2023-02-23)




### Improvements:

* add aggregates used by sorts

## [v1.3.14](https://github.com/ash-project/ash_postgres/compare/v1.3.13...v1.3.14) (2023-02-21)




### Improvements:

* Implement string_join expr (#132)

## [v1.3.13](https://github.com/ash-project/ash_postgres/compare/v1.3.12...v1.3.13) (2023-02-17)




### Bug Fixes:

* don't use `:distinct` when `uniq?` is not `true`

## [v1.3.12](https://github.com/ash-project/ash_postgres/compare/v1.3.11...v1.3.12) (2023-02-16)




### Bug Fixes:

* exclude `order_by` when building aggregates

## [v1.3.11](https://github.com/ash-project/ash_postgres/compare/v1.3.10...v1.3.11) (2023-02-16)




### Bug Fixes:

* properly find migration directories in umbrella apps

* don't double-cast to array for list aggregates

### Improvements:

* significantly optimize aggregate queries

* better type casting for concat operator

## [v1.3.10](https://github.com/ash-project/ash_postgres/compare/v1.3.9...v1.3.10) (2023-02-09)




### Bug Fixes:

* sorting on optimized first aggregates

## [v1.3.9](https://github.com/ash-project/ash_postgres/compare/v1.3.8...v1.3.9) (2023-02-09)




### Bug Fixes:

* do limit/offset outside of query if distinct is required

* load by __order__ ascending

### Improvements:

* support new `uniq?` option on count/list aggregates

* optimized `first` aggregates where possible

## [v1.3.8](https://github.com/ash-project/ash_postgres/compare/v1.3.7...v1.3.8) (2023-02-06)




### Bug Fixes:

* Actually use `AshPostgres.Repo` behaviour (#129)

### Improvements:

* authorization filters are now attached by ash core

## [v1.3.7](https://github.com/ash-project/ash_postgres/compare/v1.3.6...v1.3.7) (2023-02-06)




### Bug Fixes:

* Actually use `AshPostgres.Repo` behaviour (#129)

### Improvements:

* authorization filters are now attached by ash core

## [v1.3.6](https://github.com/ash-project/ash_postgres/compare/v1.3.5...v1.3.6) (2023-02-03)




### Bug Fixes:

* properly set next migration name

* override `insert` function for proper ecto interop

### Improvements:

* add `migration_ignore_attributes`

## [v1.3.5](https://github.com/ash-project/ash_postgres/compare/v1.3.4...v1.3.5) (2023-01-29)




### Bug Fixes:

* properly convert to/from ecto, only when necessary

## [v1.3.4](https://github.com/ash-project/ash_postgres/compare/v1.3.3...v1.3.4) (2023-01-28)




### Bug Fixes:

* support latest ecto interop changes in ash core

### Improvements:

* properly cast division to floats for elixir-y behavior

* support for dynamically set repo

* update ash

## [v1.3.3](https://github.com/ash-project/ash_postgres/compare/v1.3.2...v1.3.3) (2023-01-18)




### Improvements:

* update to new docs patterns

## [v1.3.2](https://github.com/ash-project/ash_postgres/compare/v1.3.1...v1.3.2) (2023-01-17)




### Bug Fixes:

* nest subqueries when required for distinct

* replace `{:in, ...}` type with `{:array, ...}`

## [v1.3.1](https://github.com/ash-project/ash_postgres/compare/v1.3.0...v1.3.1) (2023-01-11)




### Bug Fixes:

* allow for non attribute aggregate references for first/list

## [v1.3.0](https://github.com/ash-project/ash_postgres/compare/v1.3.0-rc.4...v1.3.0) (2023-01-11)




### Improvements:

* update to latest ash

## [v1.3.0-rc.4](https://github.com/ash-project/ash_postgres/compare/v1.3.0-rc.3...v1.3.0-rc.4) (2023-01-09)




### Bug Fixes:

* properly join to all required relationships

## [v1.3.0-rc.3](https://github.com/ash-project/ash_postgres/compare/v1.3.0-rc.2...v1.3.0-rc.3) (2023-01-09)




### Bug Fixes:

* properly type cast in fragments (and elsewhere)

## [v1.3.0-rc.2](https://github.com/ash-project/ash_postgres/compare/v1.3.0-rc.1...v1.3.0-rc.2) (2023-01-06)




### Bug Fixes:

* undo changes that caused type casting bugs

## [v1.3.0-rc.1](https://github.com/ash-project/ash_postgres/compare/v1.3.0-rc.0...v1.3.0-rc.1) (2023-01-06)




### Bug Fixes:

* undo changes that caused type casting bugs

## [v1.3.0-rc.1](https://github.com/ash-project/ash_postgres/compare/v1.3.0-rc.0...v1.3.0-rc.1) (2023-01-06)




### Bug Fixes:

* use `parent_expr` instead of `this`

* various expression & type building fixes

## [v1.3.0-rc.0](https://github.com/ash-project/ash_postgres/compare/v1.2.6...v1.3.0-rc.0) (2023-01-04)




### Features:

* support latest ash

### Bug Fixes:

* honor calculation constraints

* handle lists with expressions inside

### Improvements:

* support calc constraints

* support new `cast_in_query?/2`

* support calculations as aggregate targets

## [v1.2.6](https://github.com/ash-project/ash_postgres/compare/v1.2.5...v1.2.6) (2022-12-27)




### Bug Fixes:

* properly set `migrations_path` default in umbrellas

* don't subquery unless we have to

## [v1.2.5](https://github.com/ash-project/ash_postgres/compare/v1.2.4...v1.2.5) (2022-12-21)




### Bug Fixes:

* don't group aggregates that reference relationships in their filters

* properly skip unique indexes when configured

### Improvements:

* add like and ilike

## [v1.2.4](https://github.com/ash-project/ash_postgres/compare/v1.2.3...v1.2.4) (2022-12-18)




### Bug Fixes:

* properly add aggregates to query when referenced from calculations

### Improvements:

* distinct on source of query, not relationship destination

## [v1.2.3](https://github.com/ash-project/ash_postgres/compare/v1.2.2...v1.2.3) (2022-12-15)




### Bug Fixes:

* properly combine sort + to many join filter

## [v1.2.2](https://github.com/ash-project/ash_postgres/compare/v1.2.1...v1.2.2) (2022-12-15)




### Improvements:

* udpate to latest ash, fix array issues

## [v1.2.1](https://github.com/ash-project/ash_postgres/compare/v1.2.0...v1.2.1) (2022-12-13)




### Bug Fixes:

* pattern match error in `lazy_non_matching_defaults/1`

* use attribute name not attribute for default funs

* *actually* fix `default_fun` upserts

* fix upserting update_defaults

## [v1.2.0](https://github.com/ash-project/ash_postgres/compare/v1.2.0-rc.1...v1.2.0) (2022-12-13)




### Bug Fixes:

* make migration generator work better for umbrellas

## [v1.2.0-rc.1](https://github.com/ash-project/ash_postgres/compare/v1.2.0-rc.0...v1.2.0-rc.1) (2022-12-10)




### Bug Fixes:

* don't make migration generation recursive

* nevermind, can't make migrate recursive

### Improvements:

* make migrate task recursive as well

* mark generate_migrations as recursive for umbrellas

## [v1.2.0-rc.0](https://github.com/ash-project/ash_postgres/compare/v1.1.3...v1.2.0-rc.0) (2022-12-10)




### Features:

* avg/min/max/custom aggregate support

### Bug Fixes:

* various broken behavior from new aggregate work

* forgot a

* fix various problems with the model behind aggregates

* properly set binding names for many to many join filters

### Improvements:

* better error messages from mix tasks

* validate that references refer to relationships

* avg/min/max/custom aggregate support

* upgrade and depend on ash version

* fix lateral many to many joins

* inform users about postgres incompatibility with multidimensional arrays

## [v1.1.3](https://github.com/ash-project/ash_postgres/compare/v1.1.2...v1.1.3) (2022-12-01)




### Bug Fixes:

* properly turn custom index keys into atoms

### Improvements:

* update ash, add test for transaction hooks

* support new transaction info with hooks

* add unique constraints to changeset for custom unique indexes

* separate out concurrent index creations and do them in a separate transaction

## [v1.1.2](https://github.com/ash-project/ash_postgres/compare/v1.1.1...v1.1.2) (2022-11-21)




### Bug Fixes:

* don't use hard-coded join assoc name (#118)

### Improvements:

* add `migration_defaults` for customizing default values

## [v1.1.1](https://github.com/ash-project/ash_postgres/compare/v1.1.0...v1.1.1) (2022-10-25)




### Bug Fixes:

* && operator in expressions to point to ash_elixir_and (#115)

### Improvements:

* add check for unsupported expression

## [v1.1.0](https://github.com/ash-project/ash_postgres/compare/v1.0.0...v1.1.0) (2022-10-20)




### Features:

* support `now()` in latest Ash

## [v1.0.0](https://github.com/ash-project/ash_postgres/compare/v0.43.0...v1.0.0) (2022-10-17)


### Bug Fixes:

* no unnecessary type cast on count/sum aggregates

* don't apply `filter` to `array_agg`

### Improvements:

* update to Ash 2.0

* handle UUID types better

* set lateral join source for latest ash

* use `prepend?: true` option when applying relationship sorts

## [v1.0.0-rc.9](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.8...v1.0.0-rc.9) (2022-10-07)




### Bug Fixes:

* handle custom calculation selects properly

* use attribute source for identity fields

### Improvements:

* update to the latest ash

* remove the need to dynamically expand fragments

* when casting string to uuid, dump to binary

* update to latest ash

## [v1.0.0-rc.8](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.7...v1.0.0-rc.8) (2022-09-29)




### Bug Fixes:

* never attempt to group custom operations

* wrap case statement in parens

### Improvements:

* `exists` filters necessitate multiple aggregate joins (for now)

## [v1.0.0-rc.7](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.6...v1.0.0-rc.7) (2022-09-28)




### Bug Fixes:

* properly type cast top level fragments

### Improvements:

* update to the latest ash

* upgrade to new `exists` usage

## [v1.0.0-rc.6](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.5...v1.0.0-rc.6) (2022-09-21)




### Improvements:

* support latest ash

## [v1.0.0-rc.5](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.4...v1.0.0-rc.5) (2022-09-15)




### Improvements:

* update to latest ash

* implement Length function (#111)

* upgrade to latest ash

## [v1.0.0-rc.4](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.3...v1.0.0-rc.4) (2022-09-14)




### Improvements:

* support latest ash

* support manual relationships with joins

## [v1.0.0-rc.3](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.2...v1.0.0-rc.3) (2022-09-12)




### Bug Fixes:

* keep unique index keys in order in migrations

## [v1.0.0-rc.2](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.1...v1.0.0-rc.2) (2022-09-06)




### Improvements:

* support latest ash `exists/2` expr

## [v1.0.0-rc.1](https://github.com/ash-project/ash_postgres/compare/v1.0.0-rc.0...v1.0.0-rc.1) (2022-09-04)




## [v0.43.0](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.7...v0.43.0) (2022-08-05)




### Bug Fixes:

* properly order check constraints

* remove check constraints before adding them

### Improvements:

* fix typecasting for calculations & embed access

* add custom_statements to migration generator

* support `||` and `&&`

## [v0.42.0-rc.7](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.6...v0.42.0-rc.7) (2022-07-14)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* use new doc_index patterns

* support upsert_identity with base_filter

* support upsert_identity with base filters

* handle various join bugs

* use attribute.name if attribute.source is nil

* set attribute source properly

* ensure source is always set on attributes in snapshots

* handle paths for aggregates w/ > 2 relationships

* rename attributes correctly in down migration (#98)

* don't generate modify commands for attributes due to schema changes

* default schema to primary schema

* test and confirm behavior of schemas

* use correct bindings for filtered relationships

* cast calcs in query expressions

* explicitly type cast aggregate/calc selects

* don't try and match reference schema to table schema

* don't use `table` where we should use `schema` in migration generator

* handle combinations of distinct & sort

* ensure all single actions are explicitly marked as primary? (#95)

* only rename schema when necessary

* inspect un-defaultable value in error message

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* add default guide, and empty ash postgres guide

* set `update_defaults` on upsert results

* handle fallback ecto migration default elegantly (#94)

* add `ignore?` option to `references`

* check_migrations, rename to `--check`

* add explicit timeout capability declaration

* add static schema specification in DSL

* support static schema specification in migration generator

* implement decimal ecto migration default (#91)

* support float as Ecto migration default (#89)

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.42.0-rc.6](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.5...v0.42.0-rc.6) (2022-07-10)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* use new doc_index patterns

* support upsert_identity with base_filter

* support upsert_identity with base filters

* handle various join bugs

* use attribute.name if attribute.source is nil

* set attribute source properly

* ensure source is always set on attributes in snapshots

* handle paths for aggregates w/ > 2 relationships

* rename attributes correctly in down migration (#98)

* don't generate modify commands for attributes due to schema changes

* default schema to primary schema

* test and confirm behavior of schemas

* use correct bindings for filtered relationships

* cast calcs in query expressions

* explicitly type cast aggregate/calc selects

* don't try and match reference schema to table schema

* don't use `table` where we should use `schema` in migration generator

* handle combinations of distinct & sort

* ensure all single actions are explicitly marked as primary? (#95)

* only rename schema when necessary

* inspect un-defaultable value in error message

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* set `update_defaults` on upsert results

* handle fallback ecto migration default elegantly (#94)

* add `ignore?` option to `references`

* check_migrations, rename to `--check`

* add explicit timeout capability declaration

* add static schema specification in DSL

* support static schema specification in migration generator

* implement decimal ecto migration default (#91)

* support float as Ecto migration default (#89)

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.42.0-rc.5](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.4...v0.42.0-rc.5) (2022-07-06)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* support upsert_identity with base_filter

* support upsert_identity with base filters

* handle various join bugs

* use attribute.name if attribute.source is nil

* set attribute source properly

* ensure source is always set on attributes in snapshots

* handle paths for aggregates w/ > 2 relationships

* rename attributes correctly in down migration (#98)

* don't generate modify commands for attributes due to schema changes

* default schema to primary schema

* test and confirm behavior of schemas

* use correct bindings for filtered relationships

* cast calcs in query expressions

* explicitly type cast aggregate/calc selects

* don't try and match reference schema to table schema

* don't use `table` where we should use `schema` in migration generator

* handle combinations of distinct & sort

* ensure all single actions are explicitly marked as primary? (#95)

* only rename schema when necessary

* inspect un-defaultable value in error message

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* set `update_defaults` on upsert results. For most users, this means that where previously `updated_at` would not get set on an upsert that ultimately resulted in an update, it will now.

* handle fallback ecto migration default elegantly (#94)

* add `ignore?` option to `references`

* check_migrations, rename to `--check`

* add explicit timeout capability declaration

* add static schema specification in DSL

* support static schema specification in migration generator

* implement decimal ecto migration default (#91)

* support float as Ecto migration default (#89)

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.42.0-rc.4](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.3...v0.42.0-rc.4) (2022-06-28)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* use attribute.name if attribute.source is nil

* set attribute source properly

* ensure source is always set on attributes in snapshots

* handle paths for aggregates w/ > 2 relationships

* rename attributes correctly in down migration (#98)

* don't generate modify commands for attributes due to schema changes

* default schema to primary schema

* test and confirm behavior of schemas

* use correct bindings for filtered relationships

* cast calcs in query expressions

* explicitly type cast aggregate/calc selects

* don't try and match reference schema to table schema

* don't use `table` where we should use `schema` in migration generator

* handle combinations of distinct & sort

* ensure all single actions are explicitly marked as primary? (#95)

* only rename schema when necessary

* inspect un-defaultable value in error message

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* handle fallback ecto migration default elegantly (#94)

* add `ignore?` option to `references`

* check_migrations, rename to `--check`

* add explicit timeout capability declaration

* add static schema specification in DSL

* support static schema specification in migration generator

* implement decimal ecto migration default (#91)

* support float as Ecto migration default (#89)

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.42.0-rc.3](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.2...v0.42.0-rc.3) (2022-06-28)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* set attribute source properly

* ensure source is always set on attributes in snapshots

* handle paths for aggregates w/ > 2 relationships

* rename attributes correctly in down migration (#98)

* don't generate modify commands for attributes due to schema changes

* default schema to primary schema

* test and confirm behavior of schemas

* use correct bindings for filtered relationships

* cast calcs in query expressions

* explicitly type cast aggregate/calc selects

* don't try and match reference schema to table schema

* don't use `table` where we should use `schema` in migration generator

* handle combinations of distinct & sort

* ensure all single actions are explicitly marked as primary? (#95)

* only rename schema when necessary

* inspect un-defaultable value in error message

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* handle fallback ecto migration default elegantly (#94)

* add `ignore?` option to `references`

* check_migrations, rename to `--check`

* add explicit timeout capability declaration

* add static schema specification in DSL

* support static schema specification in migration generator

* implement decimal ecto migration default (#91)

* support float as Ecto migration default (#89)

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.42.0-rc.2](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.1...v0.42.0-rc.2) (2022-05-18)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* don't try and match reference schema to table schema

* don't use `table` where we should use `schema` in migration generator

* handle combinations of distinct & sort

* ensure all single actions are explicitly marked as primary? (#95)

* only rename schema when necessary

* inspect un-defaultable value in error message

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* check_migrations, rename to `--check`

* add explicit timeout capability declaration

* add static schema specification in DSL

* support static schema specification in migration generator

* implement decimal ecto migration default (#91)

* support float as Ecto migration default (#89)

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.42.0-rc.1](https://github.com/ash-project/ash_postgres/compare/v0.42.0-rc.0...v0.42.0-rc.1) (2022-05-18)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* don't use `table` where we should use `schema` in migration generator

* handle combinations of distinct & sort

* ensure all single actions are explicitly marked as primary? (#95)

* only rename schema when necessary

* inspect un-defaultable value in error message

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* check_migrations, rename to `--check`

* add explicit timeout capability declaration

* add static schema specification in DSL

* support static schema specification in migration generator

* implement decimal ecto migration default (#91)

* support float as Ecto migration default (#89)

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.42.0-rc.0](https://github.com/ash-project/ash_postgres/compare/v0.41.7...v0.42.0-rc.0) (2022-04-26)




### Features:

* support `cast_in_query?/0` and `source`

### Bug Fixes:

* select custom aggregates properly

* don't add reference when renaming column if unnecessary

* don't cast `nil` to `""`

* `!is_atom/1` -> `!is_boolean/1`

* sanitize lists to stringify atoms

* cast embedded atoms to strings first

* don't cast `{:in, :any}` types

* more don't cast any types

* don't cast if there is no type

* properly handle relationship filter bindings

* don't consider fields changed with only source -> name changes

* handle name -> source change in more places

* handle name -> source rename in operation ordering

* fix aggregate/base filters

* don't select more fields than necessary

* don't call `ecto_type` twice when resolving types

* place expressions in the proper order in selects

* match on count in expr

* remove incorrect param count tracking

* properly track param count

* properly reverse parameters before/after expansion

* don't use the base ecto type

* don't sort when joining

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* update ecto

* add atom impl for `EctoMigrationDefault`

* Add EctoMigrationDefault protocol and implement defaults (#87)

* update ecto, fix dialyzer

* support new timeouts

* make select unique before running query

* add doc_index

* add exclusion_constraint_names (#83)

* support referencing aggregates from aggregate filters

* support access syntax

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.41.7](https://github.com/ash-project/ash_postgres/compare/v0.41.6...v0.41.7) (2021-12-21)




### Bug Fixes:

* ensure repo is compiled (#80)

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.41.6](https://github.com/ash-project/ash_postgres/compare/v0.41.5...v0.41.6) (2021-12-21)




### Bug Fixes:

* properly construct nested join relationships

* use `CiStringWrapper` type in ash_postgres

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.41.5](https://github.com/ash-project/ash_postgres/compare/v0.41.4...v0.41.5) (2021-11-26)




### Bug Fixes:

* ensure we are returning * on upserts (#79)

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.41.4](https://github.com/ash-project/ash_postgres/compare/v0.41.3...v0.41.4) (2021-11-25)




### Bug Fixes:

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* don't upsert defaults on conflict (#77)

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.41.3](https://github.com/ash-project/ash_postgres/compare/v0.41.2...v0.41.3) (2021-11-13)




### Bug Fixes:

* handle new if types

* copy query prefix to newly created query (#74)

### Improvements:

* relax ash version requirement

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.41.2](https://github.com/ash-project/ash_postgres/compare/v0.41.1...v0.41.2) (2021-11-10)




### Bug Fixes:

* copy query prefix to newly created query (#74)

### Improvements:

* add custom migration types, and repo level override

* update to latest version of ash

## [v0.41.1](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.9...v0.41.1) (2021-11-03)




### Bug Fixes:

* copy query prefix to newly created query (#74)

### Improvements:

* update to latest version of ash

## [v0.41.0-rc.9](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.8...v0.41.0-rc.9) (2021-11-01)




### Bug Fixes:

* use proper ecto types everywhere

* try to fix missing paren issue in array_agg

* fix can? for :joins (#73)

* remove unused default value

* use proper identity names for polymorphic resources

* set identity names propertly for polymorphic resources

* handle nil values in snapshots better

* remove unused field from snapshot parsing

### Improvements:

* support `default` on aggregates

* support `custom_indexes`

## [v0.41.0-rc.8](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.7...v0.41.0-rc.8) (2021-10-25)




### Bug Fixes:

* fix can? for :joins (#73)

* remove unused default value

* use proper identity names for polymorphic resources

* set identity names propertly for polymorphic resources

* handle nil values in snapshots better

* remove unused field from snapshot parsing

### Improvements:

* support `default` on aggregates

* support `custom_indexes`

## [v0.41.0-rc.7](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.6...v0.41.0-rc.7) (2021-10-24)




### Bug Fixes:

* fix can? for :joins (#73)

* remove unused default value

* use proper identity names for polymorphic resources

* set identity names propertly for polymorphic resources

* handle nil values in snapshots better

* remove unused field from snapshot parsing

### Improvements:

* support `custom_indexes`

## [v0.41.0-rc.6](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.5...v0.41.0-rc.6) (2021-09-26)




### Bug Fixes:

* remove unused default value

* use proper identity names for polymorphic resources

* set identity names propertly for polymorphic resources

* handle nil values in snapshots better

* remove unused field from snapshot parsing

### Improvements:

* support `custom_indexes`

## [v0.41.0-rc.5](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.4...v0.41.0-rc.5) (2021-09-21)




### Bug Fixes:

* use proper identity names for polymorphic resources

* set identity names propertly for polymorphic resources

* handle nil values in snapshots better

* remove unused field from snapshot parsing

### Improvements:

* support `custom_indexes`

## [v0.41.0-rc.4](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.3...v0.41.0-rc.4) (2021-09-21)




### Bug Fixes:

* set identity names propertly for polymorphic resources

* handle nil values in snapshots better

* remove unused field from snapshot parsing

### Improvements:

* support `custom_indexes`

## [v0.41.0-rc.3](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.2...v0.41.0-rc.3) (2021-09-21)




### Bug Fixes:

* handle nil values in snapshots better

* remove unused field from snapshot parsing

### Improvements:

* support `custom_indexes`

## [v0.41.0-rc.2](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.1...v0.41.0-rc.2) (2021-09-21)




### Bug Fixes:

* remove unused field from snapshot parsing

### Improvements:

* support `custom_indexes`

## [v0.41.0-rc.1](https://github.com/ash-project/ash_postgres/compare/v0.41.0-rc.0...v0.41.0-rc.1) (2021-09-20)




### Improvements:

* support `custom_indexes`

## [v0.41.0-rc.0](https://github.com/ash-project/ash_postgres/compare/v0.40.11...v0.41.0-rc.0) (2021-09-13)
### Breaking Changes:

* update to latest ash/ecto versions w/ parameterized types



### Improvements:

* Support default tenant migration path in releases (#69)

## [v0.40.11](https://github.com/ash-project/ash_postgres/compare/v0.40.10...v0.40.11) (2021-07-28)




### Bug Fixes:

* set subquery prefix properly

## [v0.40.10](https://github.com/ash-project/ash_postgres/compare/v0.40.9...v0.40.10) (2021-07-27)




### Bug Fixes:

* set subquery source correctly

* create parameter for ci strings

* explicitly set prefix at each level

* interaction w/ attribute and context tenancy

### Improvements:

* info on migration generator output

* use match: :full on attr multitenancy

* update to latest ash

* update to latest ash

* upgrade ash dep

## [v0.40.9](https://github.com/ash-project/ash_postgres/compare/v0.40.8...v0.40.9) (2021-07-22)




### Bug Fixes:

* don't add a non-list to a list

### Improvements:

* add sort + select test

## [v0.40.8](https://github.com/ash-project/ash_postgres/compare/v0.40.7...v0.40.8) (2021-07-19)




### Bug Fixes:

* ensure source table is sorted in lateral join

### Improvements:

* fix significant performance issue in lateral joins

## [v0.40.7](https://github.com/ash-project/ash_postgres/compare/v0.40.6...v0.40.7) (2021-07-12)




### Improvements:

* support default_prefix configuration

## [v0.40.6](https://github.com/ash-project/ash_postgres/compare/v0.40.5...v0.40.6) (2021-07-08)




### Bug Fixes:

* fix migrator mix tasks w/ only/except tenants

* drop foreign keys after table create properly

* drop foreign keys before dropping table

* left_lateral_join for many_to_many aggregates

* properly reference nested aggregate fields for join

* properly determine fallback table for polymorphic resources

* ensure non-tenant resources can be aggregates

* properly set aggregate query sources

* retain parent as bindings

* don't add `rel_source` at all

* properly build atoms list

* horribly hack ecto for dynamic bindings

* properly coalesce aggregate values

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* `--name` when generating migrations

* add `mix ash_postgres.rollback`

* update to latest ash

* update to latest ash

* leverage new `private_vars` for errs

## [v0.40.5](https://github.com/ash-project/ash_postgres/compare/v0.40.4...v0.40.5) (2021-07-08)




### Bug Fixes:

* fix migrator mix tasks w/ only/except tenants

* drop foreign keys after table create properly

* drop foreign keys before dropping table

* left_lateral_join for many_to_many aggregates

* properly reference nested aggregate fields for join

* properly determine fallback table for polymorphic resources

* ensure non-tenant resources can be aggregates

* properly set aggregate query sources

* retain parent as bindings

* don't add `rel_source` at all

* properly build atoms list

* horribly hack ecto for dynamic bindings

* properly coalesce aggregate values

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* add `mix ash_postgres.rollback`

* update to latest ash

* update to latest ash

* leverage new `private_vars` for errs

## [v0.40.4](https://github.com/ash-project/ash_postgres/compare/v0.40.3...v0.40.4) (2021-07-05)




### Bug Fixes:

* left_lateral_join for many_to_many aggregates

* properly reference nested aggregate fields for join

* properly determine fallback table for polymorphic resources

* ensure non-tenant resources can be aggregates

* properly set aggregate query sources

* retain parent as bindings

* don't add `rel_source` at all

* properly build atoms list

* horribly hack ecto for dynamic bindings

* properly coalesce aggregate values

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* update to latest ash

* update to latest ash

* leverage new `private_vars` for errs

## [v0.40.3](https://github.com/ash-project/ash_postgres/compare/v0.40.2...v0.40.3) (2021-07-03)




### Bug Fixes:

* ensure non-tenant resources can be aggregates

* properly set aggregate query sources

* retain parent as bindings

* don't add `rel_source` at all

* properly build atoms list

* horribly hack ecto for dynamic bindings

* properly coalesce aggregate values

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* update to latest ash

* leverage new `private_vars` for errs

## [v0.40.2](https://github.com/ash-project/ash_postgres/compare/v0.40.1...v0.40.2) (2021-07-02)




### Bug Fixes:

* properly set aggregate query sources

* retain parent as bindings

* don't add `rel_source` at all

* properly build atoms list

* horribly hack ecto for dynamic bindings

* properly coalesce aggregate values

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* update to latest ash

* leverage new `private_vars` for errs

## [v0.40.1](https://github.com/ash-project/ash_postgres/compare/v0.40.0-rc5...v0.40.1) (2021-07-02)




### Bug Fixes:

* properly coalesce aggregate values

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* update to latest ash

* leverage new `private_vars` for errs

## [v0.40.0-rc5](https://github.com/ash-project/ash_postgres/compare/v0.40.0-rc4...v0.40.0-rc5) (2021-07-01)




### Bug Fixes:

* properly coalesce aggregate values

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* leverage new `private_vars` for errs

## [v0.40.0-rc4](https://github.com/ash-project/ash_postgres/compare/v0.40.0-rc3...v0.40.0-rc4) (2021-06-23)




### Bug Fixes:

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

### Improvements:

* leverage new `private_vars` for errs

## [v0.40.0-rc3](https://github.com/ash-project/ash_postgres/compare/v0.40.0-rc2...v0.40.0-rc3) (2021-06-15)




### Bug Fixes:

* always add nullability flag

* sort references only after other same-table ops

* generate multitenant foreign keys properly

## [v0.40.0-rc2](https://github.com/ash-project/ash_postgres/compare/v0.40.0-rc1...v0.40.0-rc2) (2021-06-08)




### Bug Fixes:

* sort references only after other same-table ops

* generate multitenant foreign keys properly

## [v0.40.0-rc1](https://github.com/ash-project/ash_postgres/compare/v0.40.0-rc.0...v0.40.0-rc1) (2021-06-05)




## [v0.39.0-rc.0](https://github.com/ash-project/ash_postgres/compare/v0.38.11...v0.39.0-rc.0) (2021-06-04)




### Features:

* support expression based calculations

* support concat + if expressions

### Improvements:

* various other improvements

## [v0.38.11](https://github.com/ash-project/ash_postgres/compare/v0.38.10...v0.38.11) (2021-05-23)




### Bug Fixes:

* set prefix to "public" for fkeys to public schema

### Improvements:

* set explicit prefix on join filters

## [v0.38.10](https://github.com/ash-project/ash_postgres/compare/v0.38.9...v0.38.10) (2021-05-19)




### Improvements:

* support new ash upsert specifying targets

* update to latest ash

## [v0.38.9](https://github.com/ash-project/ash_postgres/compare/v0.38.8...v0.38.9) (2021-05-12)




### Bug Fixes:

* properly group many_to_many aggregates

## [v0.38.8](https://github.com/ash-project/ash_postgres/compare/v0.38.7...v0.38.8) (2021-05-09)




### Improvements:

* update to the latest ash version

## [v0.38.7](https://github.com/ash-project/ash_postgres/compare/v0.38.6...v0.38.7) (2021-05-09)




### Improvements:

* support latest ash/filtering on related aggregates

## [v0.38.6](https://github.com/ash-project/ash_postgres/compare/v0.38.5...v0.38.6) (2021-05-07)




### Bug Fixes:

* properly construct sources for lateral joins

* copy the correct data for lateral join queries

* better errors in error cases

### Improvements:

* update to latest ash

## [v0.38.5](https://github.com/ash-project/ash_postgres/compare/v0.38.4...v0.38.5) (2021-05-07)




### Bug Fixes:

* don't cast booleans to string in last_ditch_cast

## [v0.38.4](https://github.com/ash-project/ash_postgres/compare/v0.38.3...v0.38.4) (2021-05-07)




### Improvements:

* support latest ash version resource sorts

## [v0.38.3](https://github.com/ash-project/ash_postgres/compare/v0.38.2...v0.38.3) (2021-05-06)




### Improvements:

* update to latest ash

* document script to iterate migrations (#65)

## [v0.38.2](https://github.com/ash-project/ash_postgres/compare/v0.38.1...v0.38.2) (2021-05-04)




### Bug Fixes:

* join to join table in lateral join query

* multitenancy + lateral join sources

* don't distinct in lateral joins

## [v0.38.1](https://github.com/ash-project/ash_postgres/compare/v0.38.0...v0.38.1) (2021-05-04)




### Bug Fixes:

* fix fragment processing broken (#64)

## [v0.38.0](https://github.com/ash-project/ash_postgres/compare/v0.37.8...v0.38.0) (2021-04-29)




### Features:

* support new side load improvements

### Improvements:

* Preserve attribute order (#63)

## [v0.37.8](https://github.com/ash-project/ash_postgres/compare/v0.37.7...v0.37.8) (2021-04-27)




### Bug Fixes:

* simpler index names

* don't prefix unique indices with prefix()

* sort index operations last

### Improvements:

* custom index names

## [v0.37.7](https://github.com/ash-project/ash_postgres/compare/v0.37.6...v0.37.7) (2021-04-27)




### Bug Fixes:

* remove inspects that were left in by accident

## [v0.37.6](https://github.com/ash-project/ash_postgres/compare/v0.37.5...v0.37.6) (2021-04-27)




### Bug Fixes:

* type cast atoms to strings in last ditch cast

* properly type cast

* Remove duplicate file extension (#60)

## [v0.37.5](https://github.com/ash-project/ash_postgres/compare/v0.37.4...v0.37.5) (2021-04-27)




### Bug Fixes:

* properly type cast

## [v0.37.4](https://github.com/ash-project/ash_postgres/compare/v0.37.3...v0.37.4) (2021-04-26)




### Improvements:

* support `list` aggregate

## [v0.37.3](https://github.com/ash-project/ash_postgres/compare/v0.37.2...v0.37.3) (2021-04-26)




### Bug Fixes:

* stringify struct defaults in migration generator

* properly comment out extension uninstallation code

## [v0.37.2](https://github.com/ash-project/ash_postgres/compare/v0.37.1...v0.37.2) (2021-04-21)




### Improvements:

* support ash enums

## [v0.37.1](https://github.com/ash-project/ash_postgres/compare/v0.37.0...v0.37.1) (2021-04-19)




### Bug Fixes:

* include type in references (because it is *not* automatic)

## [v0.37.0](https://github.com/ash-project/ash_postgres/compare/v0.36.5...v0.37.0) (2021-04-19)




### Features:

* add check_constraints, both for validation and migrations

## [v0.36.5](https://github.com/ash-project/ash_postgres/compare/v0.36.4...v0.36.5) (2021-04-13)




### Bug Fixes:

* always drop constraints before modifying

* properly compare old references and new references

## [v0.36.4](https://github.com/ash-project/ash_postgres/compare/v0.36.3...v0.36.4) (2021-04-12)




### Bug Fixes:

* don't explicitly set type in `references`

### Improvements:

* default integers to `:bigint`

## [v0.36.3](https://github.com/ash-project/ash_postgres/compare/v0.36.2...v0.36.3) (2021-04-12)




### Improvements:

* primary autoincrement key as bigserial (#54)

## [v0.36.2](https://github.com/ash-project/ash_postgres/compare/v0.36.1...v0.36.2) (2021-04-09)




### Improvements:

* support new ash select feature

## [v0.36.1](https://github.com/ash-project/ash_postgres/compare/v0.36.0...v0.36.1) (2021-04-04)




### Bug Fixes:

* raise when `all_tenants/0` default impl is called

### Improvements:

* add sum aggregate (#53)

## [v0.36.0](https://github.com/ash-project/ash_postgres/compare/v0.35.5...v0.36.0) (2021-04-01)




### Features:

* support configuring references

* support configuring polymorphic references

* support `distinct` Ash queries

## [v0.35.5](https://github.com/ash-project/ash_postgres/compare/v0.35.4...v0.35.5) (2021-03-29)




### Bug Fixes:

* Made AshPostgres.Repo.init/2 overridable (#51)

### Improvements:

* only count resources w/ create action for nullability

* better error message on missing table

## [v0.35.4](https://github.com/ash-project/ash_postgres/compare/v0.35.3...v0.35.4) (2021-03-21)




### Bug Fixes:

* reroute `Ash.Type.UUID` to `:uuid` in migrations

* force create extensions snapshot

### Improvements:

* consistent foreign key names

* support custom foreign key error messages

## [v0.35.3](https://github.com/ash-project/ash_postgres/compare/v0.35.2...v0.35.3) (2021-03-19)




### Bug Fixes:

* force create extensions snapshot

* more conservative inner join checks

* add back in inner join detection logic

### Improvements:

* consistent foreign key names

* support custom foreign key error messages

## [v0.35.2](https://github.com/ash-project/ash_postgres/compare/v0.35.1...v0.35.2) (2021-03-05)




### Bug Fixes:

* more conservative inner join checks

* add back in inner join detection logic

## [v0.35.1](https://github.com/ash-project/ash_postgres/compare/v0.35.0...v0.35.1) (2021-03-02)




### Bug Fixes:

* don't start the whole app in migrate

## [v0.35.0](https://github.com/ash-project/ash_postgres/compare/v0.34.7...v0.35.0) (2021-03-02)




### Features:

* automatically install extensions from repo

## [v0.34.7](https://github.com/ash-project/ash_postgres/compare/v0.34.6...v0.34.7) (2021-03-02)




### Bug Fixes:

* typo in references for multitenancy

* `null: true` when attr isn't on all resources for a table

## [v0.34.6](https://github.com/ash-project/ash_postgres/compare/v0.34.5...v0.34.6) (2021-02-24)




### Bug Fixes:

* better embedded filters, switch to latest ash

## [v0.34.5](https://github.com/ash-project/ash_postgres/compare/v0.34.4...v0.34.5) (2021-02-23)




### Improvements:

* support latest ash

## [v0.34.4](https://github.com/ash-project/ash_postgres/compare/v0.34.3...v0.34.4) (2021-02-08)




### Bug Fixes:

* trim when choosing new attribute name

## [v0.34.3](https://github.com/ash-project/ash_postgres/compare/v0.34.2...v0.34.3) (2021-02-06)




### Bug Fixes:

* don't reference polymorphic tables to belongs_to relationships

## [v0.34.2](https://github.com/ash-project/ash_postgres/compare/v0.34.1...v0.34.2) (2021-02-06)




### Bug Fixes:

* set up references properly

## [v0.34.1](https://github.com/ash-project/ash_postgres/compare/v0.34.0...v0.34.1) (2021-02-06)




### Bug Fixes:

* reference the configured table if set

## [v0.34.0](https://github.com/ash-project/ash_postgres/compare/v0.33.1...v0.34.0) (2021-02-06)




### Features:

* support polymorphic relationships

## [v0.33.1](https://github.com/ash-project/ash_postgres/compare/v0.33.0...v0.33.1) (2021-01-27)




### Bug Fixes:

* actually insert the tracking row

## [v0.33.0](https://github.com/ash-project/ash_postgres/compare/v0.32.2...v0.33.0) (2021-01-27)




### Features:

* add `mix ash_postgres.create`

* add `mix ash_postgres.migrate`

* add `mix ash_postgres.migrate --tenants`

* add `mix ash_postgres.drop`

### Bug Fixes:

* rework the way multitenant migrations work

## [v0.32.2](https://github.com/ash-project/ash_postgres/compare/v0.32.1...v0.32.2) (2021-01-26)




### Bug Fixes:

* un-break the `in` filter type casting code

### Improvements:

* better errors for multitenant unique constraints

## [v0.32.1](https://github.com/ash-project/ash_postgres/compare/v0.32.0...v0.32.1) (2021-01-24)




### Bug Fixes:

* `ago` was adding, not subtracting

## [v0.32.0](https://github.com/ash-project/ash_postgres/compare/v0.31.1...v0.32.0) (2021-01-24)




### Features:

* support latest ash + contains

## [v0.31.1](https://github.com/ash-project/ash_postgres/compare/v0.31.0...v0.31.1) (2021-01-22)




### Improvements:

* update to latest ash

## [v0.31.0](https://github.com/ash-project/ash_postgres/compare/v0.30.1...v0.31.0) (2021-01-22)




### Features:

* support fragments

* support type casting

* update to latest ash to support expressions

### Bug Fixes:

* update CI versions

## [v0.30.1](https://github.com/ash-project/ash_postgres/compare/v0.30.0...v0.30.1) (2021-01-13)




## [v0.30.0](https://github.com/ash-project/ash_postgres/compare/v0.29.6...v0.30.0) (2021-01-13)




### Features:

* Add check_migrated option to migration generator (#40) (#43)

## [v0.29.6](https://github.com/ash-project/ash_postgres/compare/v0.29.5...v0.29.6) (2021-01-12)




### Bug Fixes:

* rename out of phase, small migration fix

## [v0.29.5](https://github.com/ash-project/ash_postgres/compare/v0.29.4...v0.29.5) (2021-01-10)




### Improvements:

* Use ecto_sql formatter settings (#38)

## [v0.29.4](https://github.com/ash-project/ash_postgres/compare/v0.29.3...v0.29.4) (2021-01-10)




### Improvements:

* Omit field opts if they are default values (#37)

## [v0.29.3](https://github.com/ash-project/ash_postgres/compare/v0.29.2...v0.29.3) (2021-01-08)




### Improvements:

* support latest ash

## [v0.29.2](https://github.com/ash-project/ash_postgres/compare/v0.29.1...v0.29.2) (2021-01-08)




### Improvements:

* Make integer serial if generated

## [v0.29.1](https://github.com/ash-project/ash_postgres/compare/v0.29.0...v0.29.1) (2021-01-08)




### Improvements:

* support latest ash version

## [v0.29.0](https://github.com/ash-project/ash_postgres/compare/v0.28.1...v0.29.0) (2021-01-08)




### Features:

* retain snapshot history

### Improvements:

* support latest ash version

## [v0.28.1](https://github.com/ash-project/ash_postgres/compare/v0.28.0...v0.28.1) (2021-01-07)




### Improvements:

* Add :binary migration type (#33)

## [v0.28.0](https://github.com/ash-project/ash_postgres/compare/v0.27.0...v0.28.0) (2020-12-29)




### Features:

* support latest Ash version

## [v0.27.0](https://github.com/ash-project/ash_postgres/compare/v0.26.2...v0.27.0) (2020-12-23)




### Features:

* support refs on both sides of operators

### Bug Fixes:

* bump ash version

## [v0.26.2](https://github.com/ash-project/ash_postgres/compare/v0.26.1...v0.26.2) (2020-12-06)




### Bug Fixes:

* properly accept the `tenant_migration_path`

## [v0.26.1](https://github.com/ash-project/ash_postgres/compare/v0.26.0...v0.26.1) (2020-12-01)




### Bug Fixes:

* set default properly when modifying

## [v0.26.0](https://github.com/ash-project/ash_postgres/compare/v0.25.5...v0.26.0) (2020-11-25)




### Features:

* don't drop columns unless explicitly told to

### Bug Fixes:

* various migration generator bug fixes

## [v0.25.5](https://github.com/ash-project/ash_postgres/compare/v0.25.4...v0.25.5) (2020-11-17)




### Bug Fixes:

* drop constraints outside of phases (#29)

## [v0.25.4](https://github.com/ash-project/ash_postgres/compare/v0.25.3...v0.25.4) (2020-11-07)




### Bug Fixes:

* only alter the things that have changed

## [v0.25.3](https://github.com/ash-project/ash_postgres/compare/v0.25.2...v0.25.3) (2020-11-06)




### Improvements:

* add utc_datetime migration type

## [v0.25.2](https://github.com/ash-project/ash_postgres/compare/v0.25.1...v0.25.2) (2020-11-03)




### Bug Fixes:

* access data_layer_query with function

## [v0.25.1](https://github.com/ash-project/ash_postgres/compare/v0.25.0...v0.25.1) (2020-10-29)




### Improvements:

* mark repo as not requiring compile-time dep

## [v0.25.0](https://github.com/ash-project/ash_postgres/compare/v0.24.0...v0.25.0) (2020-10-29)




### Features:

* multitenancy (#25)

### Bug Fixes:

* verify repo using ensure_compiled

## [v0.24.0](https://github.com/ash-project/ash_postgres/compare/v0.23.2...v0.24.0) (2020-10-17)




### Features:

* support latest ash

## [v0.23.2](https://github.com/ash-project/ash_postgres/compare/v0.23.1...v0.23.2) (2020-10-07)




## [v0.23.1](https://github.com/ash-project/ash_postgres/compare/v0.23.0...v0.23.1) (2020-10-06)




## [v0.23.0](https://github.com/ash-project/ash_postgres/compare/v0.22.1...v0.23.0) (2020-10-06)




### Features:

* update to latest ash, trigram filter

## [v0.22.1](https://github.com/ash-project/ash_postgres/compare/v0.22.0...v0.22.1) (2020-10-01)




### Bug Fixes:

* don't group alters with creates (#22)

* add jason dependency, clean lockfile (#21)

## [v0.22.0](https://github.com/ash-project/ash_postgres/compare/v0.21.0...v0.22.0) (2020-09-24)




### Features:

* fix error when filtering with `true`

### Bug Fixes:

* broken types for `in` operator

## [v0.21.0](https://github.com/ash-project/ash_postgres/compare/v0.20.1...v0.21.0) (2020-09-19)




### Features:

* support base_filter (#18)

## [v0.20.1](https://github.com/ash-project/ash_postgres/compare/v0.20.0...v0.20.1) (2020-09-11)




### Bug Fixes:

* document/update migration path logic

## [v0.20.0](https://github.com/ash-project/ash_postgres/compare/v0.19.0...v0.20.0) (2020-09-11)




### Features:

* snapshot-based migration generator

## [v0.19.0](https://github.com/ash-project/ash_postgres/compare/v0.18.0...v0.19.0) (2020-09-02)

### Features:

- support inner joins when possible (#15)

### Bug Fixes:

- better support for aggregates/calculations when delegating

- don't fail w/ no extensions configured

## [v0.18.0](https://github.com/ash-project/ash_postgres/compare/v0.17.0...v0.18.0) (2020-08-26)

### Features:

- update to ash 1.11 (#13)

- support Ash v1.10 (#12)

- support latest ash

- update to latest ash

## [v0.17.0](https://github.com/ash-project/ash_postgres/compare/v0.16.1...v0.17.0) (2020-08-26)

### Features:

- update to ash 1.11 (#13)

- support Ash v1.10 (#12)

- support latest ash

- update to latest ash

## [v0.16.1](https://github.com/ash-project/ash_postgres/compare/v0.16.0...v0.16.1) (2020-08-19)

### Bug Fixes:

- fix compile/dialyzer issues

## [v0.16.0](https://github.com/ash-project/ash_postgres/compare/v0.15.0...v0.16.0) (2020-08-19)

### Features:

- update to latest ash

- update to latest version of ash

## [v0.15.0](https://github.com/ash-project/ash_postgres/compare/v0.14.0...v0.15.0) (2020-08-18)

### Features:

- update to latest version of ash

## [v0.14.0](https://github.com/ash-project/ash_postgres/compare/v0.13.0...v0.14.0) (2020-08-17)

### Features:

- support ash 1.7

- support named aggregates

## [v0.13.0](https://github.com/ash-project/ash_postgres/compare/v0.12.1...v0.13.0) (2020-07-25)

### Features:

- update to latest ash

- support latest ash

## [v0.12.1](https://github.com/ash-project/ash_postgres/compare/v0.12.0...v0.12.1) (2020-07-24)

### Bug Fixes:

- add can? for `:aggregate`

## [v0.12.0](https://github.com/ash-project/ash_postgres/compare/0.11.2...v0.12.0) (2020-07-24)

### Features:

- update to latest ash

## [v0.11.2](https://github.com/ash-project/ash_postgres/compare/0.11.1...v0.11.2) (2020-07-23)

### Bug Fixes:

## [v0.11.1](https://github.com/ash-project/ash_postgres/compare/0.11.0...v0.11.1) (2020-07-23)

### Bug Fixes:

## [v0.11.0](https://github.com/ash-project/ash_postgres/compare/0.10.0...v0.11.0) (2020-07-23)

### Features:

- support ash 13.0 aggregates

## [v0.10.0](https://github.com/ash-project/ash_postgres/compare/0.9.0...v0.10.0) (2020-07-15)

### Features:

- update to latest ash

## [v0.9.0](https://github.com/ash-project/ash_postgres/compare/0.8.0...v0.9.0) (2020-07-13)

### Features:

- update to latest ash

## [v0.8.0](https://github.com/ash-project/ash_postgres/compare/0.7.0...v0.8.0) (2020-07-09)

### Features:

- update to latest ash

## [v0.7.0](https://github.com/ash-project/ash_postgres/compare/0.6.0...v0.7.0) (2020-07-09)

### Features:

- update to latest ash

- update to latest ash, add docs

- update to ash 0.9.1 for transactions

## [v0.6.0](https://github.com/ash-project/ash_postgres/compare/0.5.0...v0.6.0) (2020-06-29)

### Features:

- update to latest ash

## [v0.5.0](https://github.com/ash-project/ash_postgres/compare/0.4.0...v0.5.0) (2020-06-29)

### Features:

- upgrade to latest ash

## [v0.4.0](https://github.com/ash-project/ash_postgres/compare/0.3.0...v0.4.0) (2020-06-27)

### Features:

- update to latest ash

## [v0.3.0](https://github.com/ash-project/ash_postgres/compare/0.2.1...v0.3.0) (2020-06-19)

### Features:

- New filter style (#10)

## [v0.2.1](https://github.com/ash-project/ash_postgres/compare/0.2.0...v0.2.1) (2020-06-15)

### Bug Fixes:

- update .formatter.exs

## [v0.2.0](https://github.com/ash-project/ash_postgres/compare/0.1.4...v0.2.0) (2020-06-14)

### Features:

- use the new DSL builder for config (#7)

## [v0.1.4](https://github.com/ash-project/ash_postgres/compare/0.1.3...v0.1.4) (2020-06-05)

### Bug Fixes:

- update ash version dependency

- account for removal of name

## [v0.1.3](https://github.com/ash-project/ash_postgres/compare/0.1.2...v0.1.3) (2020-06-03)

This release was a test of our automatic hex.pm package deployment

## Begin Changelog
