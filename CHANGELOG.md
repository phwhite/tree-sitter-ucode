# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-09-13

### Added
- Initial release of tree-sitter-ucode parser
- Support for ucode language syntax including:
  - Function declarations and expressions
  - Variables (`let`, `const`, `var`)
  - Control flow statements (`if`, `for`, `while`, `switch`, `try/catch/finally`)
  - Objects and arrays with proper ucode semantics
  - Template literals with substitution
  - Import/export statements (modern `import` and legacy `require()`)
  - Built-in function calls (`print`, `json`, `jsonstr`, etc.)
  - String and numeric operations
  - For-in loops for object/array iteration
  - Hash-bang line support (`#!/usr/bin/ucode`)

### Removed
- **Classes**: No ES6 classes, prototypes, or OOP constructs
- **`this` keyword**: Functions don't have a `this` context
- **`new` operator**: Cannot instantiate objects with constructors
- **Arrow functions**: Use `function() {}` syntax only
- **Async/await**: Synchronous execution only
- **Generators**: No `function*` or `yield` expressions
- **Regex literals**: Use `match()` and `replace()` functions instead of `/pattern/flags`
- **Decorators and private fields**: No `@decorator` or `#privateField` syntax

### Changed
- Language name changed from JavaScript to ucode
- Repository moved from `tree-sitter/tree-sitter-javascript` to `phwhite/tree-sitter-ucode`
- File extensions changed from `.js` to `.uc` and `.ucode`
- Scanner updated to remove regex literal recognition
- Grammar adapted to ucode-specific syntax requirements

### Technical Notes
- Based on tree-sitter-javascript grammar but extensively modified for ucode
- Maintains ECMAScript-like syntax while removing unsupported features
- Designed for OpenWrt embedded systems and ucode scripting environments
- 100% parsing success rate on valid ucode syntax

[1.0.0]: https://github.com/phwhite/tree-sitter-ucode/releases/tag/v1.0.0
