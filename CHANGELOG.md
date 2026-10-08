# Changelog

## 2.1.0

- Add a Rails generator: `rails g freezer User` creates `lib/freezers/user_freezer.rb` with every column of the model, or only the attributes passed. Namespaced models go in matching subdirectories.
- Fix stale names and links in the README.

- `Base.reset!` now removes fixtures in subdirectories, so namespaced models (e.g. `Foo::Bar` in `foo/bars.yml`) are cleared too.

## 2.0.0

- Require Ruby >= 3.1 and ActiveRecord >= 7.1, < 9.0.
- Rewrite `Defrost.sql_for` on public Arel/ActiveRecord APIs (the private methods it relied on no longer exist).
- Load fixtures with `YAML.safe_load_file` (permits Date, Time, Symbol, BigDecimal and aliases).
- `Base.fixture_path=` now accepts a String or Pathname.
- Fix `freeze` stripping every `---` from output, which corrupted values containing it.
- Replace Travis/Codeship with GitHub Actions; test against in-memory SQLite instead of nulldb.
