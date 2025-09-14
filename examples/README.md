# ucode Examples

This directory contains comprehensive examples demonstrating all features of the ucode programming language. Each example is designed to showcase specific aspects of ucode syntax, built-in functions, modules, and real-world usage patterns.

## Example Files Overview

### 01-data-types-variables.uc
**Demonstrates:** Variable declarations, primitive data types, arrays, objects, type checking
- Global, local, and constant variable declarations
- Boolean, integer, double, string, and null types
- Array creation, access, and manipulation
- Object creation, property access, and iteration
- Type checking with `type()` and `typeof`
- Variable scoping and const behavior

### 02-operators.uc
**Demonstrates:** All operators available in ucode
- Arithmetic operators: `+`, `-`, `*`, `/`, `%`, `++`, `--`
- Bitwise operators: `&`, `|`, `^`, `~`, `<<`, `>>`
- Comparison operators: `==`, `!=`, `<`, `<=`, `>`, `>=`, `===`, `!==`
- Logical operators: `&&`, `||`, `!`, `??`
- Assignment operators: `=`, `+=`, `-=`, `*=`, `/=`, `%=`, etc.
- Special operators: `in`, `delete`, `typeof`, `...` (spread)
- Ternary operator and operator precedence

### 03-control-flow.uc
**Demonstrates:** Control flow structures and patterns
- Conditional statements: `if`, `else if`, `else`
- Ternary operator for conditional expressions
- While and do-while loops
- For loops with various patterns
- For-in loops for arrays and objects
- Switch statements with multiple cases
- `break`, `continue`, and `return` statements
- Complex nested control flow examples

### 04-functions.uc
**Demonstrates:** Function declarations, expressions, and advanced patterns
- Function declarations and expressions
- Arrow functions (limited support)
- Default parameters and rest parameters
- Functions as first-class values
- Recursive functions and tail recursion
- Higher-order functions (map, filter, reduce)
- Closures and scope demonstration
- Error handling in functions
- Advanced patterns: memoization, partial application, composition

### 05-builtin-functions.uc
**Demonstrates:** All built-in functions available in ucode
- Type and information functions: `type()`, `length()`, `exists()`
- I/O functions: `print()`, `warn()`, `printf()`, `sprintf()`
- Array functions: `push()`, `pop()`, `slice()`, `sort()`, etc.
- Array higher-order functions: `map()`, `filter()`, `reduce()`
- Object functions: `keys()`, `values()`, `delete`
- String functions: `substr()`, `split()`, `join()`, `trim()`, etc.
- Number functions: `int()`, `min()`, `max()`, `abs()`, rounding functions
- JSON functions: `json()`, `jsonstr()`
- Regular expression functions: `match()`, `replace()`
- System functions: `gc()`, `sourcepath()`

### 06-arrays-objects.uc
**Demonstrates:** Detailed array and object manipulation
- Array creation, access, and modification
- Negative indexing and sparse arrays
- Array iteration patterns
- Multi-dimensional arrays and jagged arrays
- Object creation and property access
- Object iteration and property existence checking
- Nested objects and arrays
- Objects as dictionaries/maps
- Array of objects operations
- Copying and cloning strategies
- Performance considerations

### 07-modules-imports.uc
**Demonstrates:** Module system and import/export syntax
- Modern ES6-style import/export syntax
- Legacy `require()` compatibility
- Built-in module imports (fs, log, uci)
- Module search paths and resolution
- Creating custom modules (simulated)
- Error handling with modules
- Dynamic module loading
- Module configuration patterns
- Best practices and patterns

### 08-builtin-modules.uc
**Demonstrates:** Built-in modules available in ucode
- **fs module**: File system operations (read, write, stat, mkdir, etc.)
- **log module**: System logging (syslog, ulog, priorities, facilities)
- **uci module**: OpenWrt configuration interface
- **uloop module**: Event loop (timers, processes, signals, file descriptors)
- **ubus module**: OpenWrt message bus communication
- **math module**: Mathematical functions (if available)
- **struct module**: Binary data packing/unpacking
- Environment dependencies and error handling
- Best practices for module usage

### 09-template-mode.uc
**Demonstrates:** Template processing with Jinja-like syntax
- Template variables: `{{ variable }}`
- Template comments: `{# comment #}`
- Control structures: `{% if %}`, `{% for %}`, `{% endif %}`
- Conditional rendering and loops
- Variable filtering and formatting
- HTML generation with dynamic content
- JavaScript generation with ucode data
- Template inheritance concepts
- Whitespace control and advanced features

### 10-regex-strings.uc
**Demonstrates:** POSIX regex syntax and comprehensive string operations
- String functions: length, character access, substring extraction
- String splitting and joining
- Whitespace handling and trimming
- String replacement and case conversion
- Character code operations
- POSIX regular expressions (not JavaScript regex)
- Character classes and quantifiers
- Email and phone validation examples
- Text parsing and data extraction
- URL parsing and log file analysis
- Performance considerations

### 11-error-handling-memory.uc
**Demonstrates:** Error handling patterns and memory management
- Try-catch-finally blocks
- Throwing custom errors
- Error propagation patterns
- File operation error handling
- Memory management basics
- Reference counting and circular references
- Garbage collection usage
- Resource management patterns (RAII-style)
- Memory leak prevention
- Error recovery strategies (retry, circuit breaker)
- Best practices for robust code

### 12-practical-examples.uc
**Demonstrates:** Real-world usage patterns and applications
- Configuration file parser (INI format)
- Log file analyzer with statistics
- Network service monitor
- Data processing pipeline
- Web API client with retry logic
- Task scheduler with cron-like functionality
- Cache manager with LRU eviction
- Complete practical applications

## Running the Examples

### Basic Execution
```bash
# Run an example file
ucode tree-sitter-ucode/examples/01-data-types-variables.uc

# Run with specific flags
ucode -g tree-sitter-ucode/examples/05-builtin-functions.uc  # Enable GC
ucode -S tree-sitter-ucode/examples/04-functions.uc         # Strict mode
```

### Template Mode
```bash
# Run template example (outputs HTML)
ucode -T tree-sitter-ucode/examples/09-template-mode.uc > output.html
```

### Interactive Execution
```bash
# Execute inline code
ucode -e "print('Hello from ucode\n')"

# Print expression result
ucode -p "1 + 2 + 3"
```

## Key ucode Differences from JavaScript

These examples highlight important differences from JavaScript:

### Missing Features
- **No classes**: No `class` keyword or prototype-based inheritance
- **No `this` keyword**: Functions don't have execution context
- **No arrow functions**: Use `function() {}` syntax only
- **No destructuring**: Cannot destructure objects or arrays
- **No template literals**: Use string concatenation with `+`
- **No async/await**: Synchronous execution only

### String Access
- **No bracket notation for strings**: Use `substr(string, index, 1)` instead of `string[index]`
- **Different function signatures**: `join(separator, array)` instead of `array.join(separator)`

### Built-in Functions
- **No `console.log()`**: Use `print()` or `warn()`
- **No `JSON.parse()`**: Use `json(string)`
- **No `JSON.stringify()`**: Use `jsonstr(obj)`
- **POSIX regex**: Use `match()` and `replace()` functions, not `/pattern/` literals

### Error Handling
- **Limited Error object**: Cannot extend Error class
- **No custom error types**: Use string messages

## Environment Requirements

Some examples may require specific environments:

- **File System Operations**: UNIX-like systems with proper permissions
- **System Logging**: Systems with syslog daemon
- **OpenWrt Modules**: uci, ubus, uloop require OpenWrt environment
- **Mathematical Functions**: Some systems may not have full math module

## Best Practices Demonstrated

1. **Error Handling**: Always use try-catch for risky operations
2. **Memory Management**: Clear references and use `gc()` when needed
3. **Type Checking**: Use `type()` function for runtime type validation
4. **Resource Cleanup**: Always clean up timers, file handles, and connections
5. **Modular Design**: Separate concerns into focused functions/modules
6. **Input Validation**: Validate all inputs before processing
7. **Performance**: Cache expensive operations and use efficient algorithms

## Testing the Examples

Each example includes comprehensive test cases and demonstrates:
- Normal operation scenarios
- Error conditions and edge cases
- Performance considerations
- Memory usage patterns
- Real-world application patterns

## Contributing

When adding new examples:
1. Follow the naming convention: `NN-topic-name.uc`
2. Include comprehensive comments explaining each feature
3. Demonstrate both success and error cases
4. Add entry to this README
5. Test syntax highlighting and error handling

## Additional Resources

- [ucode Language Reference](../UCODE.md) - Complete language specification
- [OpenWrt Documentation](https://openwrt.org/docs/guide-developer/ucode) - OpenWrt-specific features
- [Tree-sitter ucode](https://github.com/tree-sitter/tree-sitter-ucode) - Syntax highlighting support

These examples serve as both learning materials and reference implementations for common ucode programming patterns.