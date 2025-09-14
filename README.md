# tree-sitter-ucode

[![CI][ci]](https://github.com/phwhite/tree-sitter-ucode/actions/workflows/ci.yml)
[![discord][discord]](https://discord.gg/w7nTvsVJhm)
[![matrix][matrix]](https://matrix.to/#/#tree-sitter-chat:matrix.org)
[![crates][crates]](https://crates.io/crates/tree-sitter-ucode)
[![npm][npm]](https://www.npmjs.com/package/tree-sitter-ucode)
[![pypi][pypi]](https://pypi.org/project/tree-sitter-ucode)

ucode grammar for [tree-sitter](https://github.com/tree-sitter/tree-sitter).

This grammar provides parsing support for [ucode](https://ucode.mein.io), a lightweight scripting language used by OpenWrt with ECMAScript-like syntax. ucode is designed for system scripting, configuration management, and template processing in embedded Linux environments.

It was originally forked from [tree-sitter-javascript](https://github.com/tree-sitter/tree-sitter-javascript) and then modified to fit the needs of ucode.

## Key Differences from JavaScript

This grammar is based on tree-sitter-javascript but removes features not supported in ucode:

- **No classes**: No ES6 classes, prototypes, or object-oriented programming constructs
- **No `this` keyword**: Functions don't have a `this` context
- **No `new` operator**: Cannot instantiate objects with constructors
- **No arrow functions**: Use `function() {}` syntax only
- **No async/await**: Synchronous execution only
- **No generators**: No `function*` or `yield` expressions
- **No regex literals**: Use `match()` and `replace()` functions instead of `/pattern/flags`
- **No decorators or private fields**: No `@decorator` or `#privateField` syntax

## Supported Features

- Function declarations and expressions
- Variables (`let`, `const`, `var`)
- Control flow (`if`, `for`, `while`, `switch`, `try/catch`)
- Objects and arrays (with bracket notation for arrays only)
- Template literals with substitution
- Import/export statements (modern `import` and legacy `require()`)
- Built-in function calls (`print`, `json`, `jsonstr`, etc.)

## References

- [ucode Documentation](https://ucode.mein.io)
- [OpenWrt ucode](https://openwrt.org/docs/guide-developer/ucode)

[ci]: https://img.shields.io/github/actions/workflow/status/phwhite/tree-sitter-ucode/ci.yml?logo=github&label=CI
[discord]: https://img.shields.io/discord/1063097320771698699?logo=discord&label=discord
[matrix]: https://img.shields.io/matrix/tree-sitter-chat%3Amatrix.org?logo=matrix&label=matrix
[npm]: https://img.shields.io/npm/v/tree-sitter-ucode?logo=npm
[crates]: https://img.shields.io/crates/v/tree-sitter-ucode?logo=rust
[pypi]: https://img.shields.io/pypi/v/tree-sitter-ucode?logo=pypi&logoColor=ffd242
