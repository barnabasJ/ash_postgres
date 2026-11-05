# Delta snapshot developer stories

These stories cover the persisted delta protocol, reduction invariants and real migration-generator regressions. Codec and reducer checks supplement the public generation cases; they do not establish database execution.

| Story | Behavior |
| --- | --- |
| [US-APDELTA-01](US-APDELTA-01.md) | initial operations retain explicit drop-table opt-out through the squash codec |
| [US-APDELTA-02](US-APDELTA-02.md) | temporal and citext unique-index fields survive the delta round-trip |
| [US-APDELTA-03](US-APDELTA-03.md) | legacy unique-index deltas do not require the new renderer fields |
| [US-APDELTA-04](US-APDELTA-04.md) | temporal foreign-key operations retain their actual SQL period fields |
| [US-APDELTA-05](US-APDELTA-05.md) | initial temporal state survives codegen, the delta codec and reduction |
| [US-APDELTA-06](US-APDELTA-06.md) | schema moves survive the codec and update the reduced schema |
| [US-APDELTA-07](US-APDELTA-07.md) | serial sequence rendering preserves the paired attribute state |
| [US-APDELTA-08](US-APDELTA-08.md) | simple AddAttribute round-trips |
| [US-APDELTA-09](US-APDELTA-09.md) | CreateTable + AddAttribute round-trip |
| [US-APDELTA-10](US-APDELTA-10.md) | AddUniqueIndex with mixed atom/string keys round-trips |
| [US-APDELTA-11](US-APDELTA-11.md) | AddAttribute with references + nilify on_delete round-trips |
| [US-APDELTA-12](US-APDELTA-12.md) | rejects non-v2 JSON with an informative error |
| [US-APDELTA-13](US-APDELTA-13.md) | rejects malformed JSON with a parseable error message |
| [US-APDELTA-14](US-APDELTA-14.md) | rejects JSON that isn't a top-level object |
| [US-APDELTA-15](US-APDELTA-15.md) | OptOutDropTable round-trips |
| [US-APDELTA-16](US-APDELTA-16.md) | CreateTable carries base_filter and has_create_action through round-trip |
| [US-APDELTA-17](US-APDELTA-17.md) | CreateTable.has_create_action defaults to true when absent from a decoded op |
| [US-APDELTA-18](US-APDELTA-18.md) | empty state + CreateTable + AddAttribute produces populated state |
| [US-APDELTA-19](US-APDELTA-19.md) | AddAttribute on existing source raises ConflictError |
| [US-APDELTA-20](US-APDELTA-20.md) | RemoveAttribute on missing source is a conflict |
| [US-APDELTA-21](US-APDELTA-21.md) | AlterAttribute with unchanged references preserves the existing foreign key |
| [US-APDELTA-22](US-APDELTA-22.md) | AlterAttribute that changes references honors the new reference |
| [US-APDELTA-23](US-APDELTA-23.md) | RenameAttribute: missing source is reported BEFORE existing destination |
| [US-APDELTA-24](US-APDELTA-24.md) | RenameAttribute: existing destination throws after source-found check |
| [US-APDELTA-25](US-APDELTA-25.md) | AddCustomStatement / RemoveCustomStatement round-trip through apply_op |
| [US-APDELTA-26](US-APDELTA-26.md) | state.empty? after add-then-remove-all reflects 'state was touched', not 'state is empty now' |
| [US-APDELTA-27](US-APDELTA-27.md) | returns nil for an empty directory |
| [US-APDELTA-28](US-APDELTA-28.md) | rejects legacy full-state files with a clear error |
| [US-APDELTA-29](US-APDELTA-29.md) | reduces a single delta to state |
| [US-APDELTA-30](US-APDELTA-30.md) | CreateTable#create_table_options encode + decode preserves value |
| [US-APDELTA-31](US-APDELTA-31.md) | Reducer preserves create_table_options on CreateTable — squash round-trip |
| [US-APDELTA-32](US-APDELTA-32.md) | CreateTable hydrates base_filter and has_create_action on the reduced state |
| [US-APDELTA-33](US-APDELTA-33.md) | Add → Alter → Remove full lifecycle leaves attributes empty |
| [US-APDELTA-34](US-APDELTA-34.md) | Add → Rename → Remove (by new name) succeeds |
| [US-APDELTA-35](US-APDELTA-35.md) | Add → Rename → Rename again (chained renames) follows the new identity |
| [US-APDELTA-36](US-APDELTA-36.md) | AlterAttribute on missing source raises conflict |
| [US-APDELTA-37](US-APDELTA-37.md) | RenameAttribute where destination matches source (no-op rename) is allowed |
| [US-APDELTA-38](US-APDELTA-38.md) | Remove → Add at the same source is allowed (re-add cycle) |
| [US-APDELTA-39](US-APDELTA-39.md) | Add → Remove leaves identities empty |
| [US-APDELTA-40](US-APDELTA-40.md) | Add same identity twice raises conflict |
| [US-APDELTA-41](US-APDELTA-41.md) | Remove non-existent identity raises conflict |
| [US-APDELTA-42](US-APDELTA-42.md) | Add → Rename to a different name succeeds and updates state |
| [US-APDELTA-43](US-APDELTA-43.md) | Rename non-existent identity raises conflict |
| [US-APDELTA-44](US-APDELTA-44.md) | Add → Remove leaves check_constraints empty |
| [US-APDELTA-45](US-APDELTA-45.md) | Add same constraint twice raises conflict |
| [US-APDELTA-46](US-APDELTA-46.md) | Remove non-existent constraint raises conflict |
| [US-APDELTA-47](US-APDELTA-47.md) | Add → Remove cycles cleanly |
| [US-APDELTA-48](US-APDELTA-48.md) | Add same custom index twice raises conflict |
| [US-APDELTA-49](US-APDELTA-49.md) | CreateTable → DropTable resets to empty state |
| [US-APDELTA-50](US-APDELTA-50.md) | CreateTable → DropTable → CreateTable can rebuild after a drop |
| [US-APDELTA-51](US-APDELTA-51.md) | RenameTable updates state.table and rejects mismatched old_table |
| [US-APDELTA-52](US-APDELTA-52.md) | OptOutDropTable sets the flag without otherwise mutating state |
| [US-APDELTA-53](US-APDELTA-53.md) | two deltas with matching previous→resulting hashes reduce cleanly |
| [US-APDELTA-54](US-APDELTA-54.md) | previous_hash that doesn't match prior resulting_hash raises ConflictError |
| [US-APDELTA-55](US-APDELTA-55.md) | deltas without hash metadata still reduce — chain validation is opt-in |
| [US-APDELTA-56](US-APDELTA-56.md) | CreateTable flips empty? to false even before any attribute ops |
| [US-APDELTA-57](US-APDELTA-57.md) | reducing 100+ ops via direct apply_op yields the expected final state |
| [US-APDELTA-58](US-APDELTA-58.md) | reducing 60 delta files from disk in timestamp order yields the same state |
| [US-APDELTA-59](US-APDELTA-59.md) | encoding the same op list with different map key orders produces the same JSON |
| [US-APDELTA-60](US-APDELTA-60.md) | reducer applies deltas in timestamp order regardless of write order |
| [US-APDELTA-61](US-APDELTA-61.md) | reducer ignores non-delta files in the snapshot directory |
| [US-APDELTA-62](US-APDELTA-62.md) | Persist temporal relationship state through real code generation |
| [US-APDELTA-63](US-APDELTA-63.md) | Keep the full delta history when a resource moves schemas |
| [US-APDELTA-64](US-APDELTA-64.md) | Reject incomplete temporal foreign-key delta state |
