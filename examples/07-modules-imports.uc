#!/usr/bin/ucode

// Example: Modules and Imports in ucode
// This example demonstrates the module system, import/export syntax, and built-in modules

print("=== ucode Modules and Imports Example ===\n");

// ==========================================
// BUILT-IN MODULE IMPORTS - MODERN SYNTAX
// ==========================================

print("=== Built-in Module Imports (Modern Syntax) ===\n");

// Import specific functions from fs module
import { readfile, writefile, stat, mkdir, lsdir } from 'fs';
import { openlog, syslog, ulog, LOG_INFO, LOG_ERR } from 'log';
import { cursor } from 'uci';

// Import entire modules with namespace
import * as fs from 'fs';
import * as log from 'log';

print("Modern import syntax examples:\n");
print("  import { readfile, writefile } from 'fs';\n");
print("  import { cursor } from 'uci';\n");
print("  import * as fs from 'fs';\n");
print("  import * as log from 'log';\n");

// Test imported functions
try {
    print("\nTesting fs module functions:\n");

    // Test file operations
    let testContent = "Hello from ucode!";
    let testFile = "/tmp/ucode_test.txt";

    printf("  Writing to %s...\n", testFile);
    writefile(testFile, testContent);

    printf("  Reading from %s...\n", testFile);
    let content = readfile(testFile);
    printf("  Content: %s\n", content);

    // Clean up
    fs.unlink(testFile);
    printf("  Test file cleaned up\n");

} catch (e) {
    printf("  File operations failed (expected in some environments): %s\n", e);
}

// ==========================================
// LEGACY REQUIRE SYNTAX
// ==========================================

print("\n=== Legacy require() Syntax ===\n");

// Legacy syntax for compatibility
let fsLegacy = require("fs");
let logLegacy = require("log");

print("Legacy require syntax examples:\n");
print("  let fs = require('fs');\n");
print("  let log = require('log');\n");

printf("  fsLegacy type: %s\n", type(fsLegacy));
printf("  logLegacy type: %s\n", type(logLegacy));

// ==========================================
// FS MODULE COMPREHENSIVE EXAMPLE
// ==========================================

print("\n=== File System Module (fs) ===\n");

// Note: Many fs operations may not work in all environments
// This demonstrates the API structure

print("File System Operations:\n");

try {
    // Directory operations
    let tempDir = "/tmp/ucode_test_dir";
    printf("  Creating directory: %s\n", tempDir);
    // mkdir(tempDir); // Commented out to avoid permission issues

    // File listing (try current directory)
    printf("  Listing current directory:\n");
    let files = lsdir(".");
    if (files && length(files) > 0) {
        for (let i = 0; i < min(5, length(files)); i++) {
            printf("    - %s\n", files[i]);
        }
        if (length(files) > 5) {
            printf("    ... and %d more files\n", length(files) - 5);
        }
    }

    // File information
    printf("  Getting file stats for current script:\n");
    let scriptStat = stat("tree-sitter-ucode/examples/07-modules-imports.uc");
    if (scriptStat) {
        printf("    Size: %d bytes\n", scriptStat.size);
        printf("    Type: %s\n", scriptStat.type);
    }

} catch (e) {
    printf("  FS operations may be limited in this environment: %s\n", e);
}

print("\nAvailable fs functions:\n");
print("  File operations: readfile(), writefile(), unlink(), rename()\n");
print("  Directory operations: mkdir(), rmdir(), lsdir(), chdir()\n");
print("  File info: stat(), access(), chmod(), chown()\n");
print("  Special operations: symlink(), readlink(), open(), pipe(), popen()\n");

// ==========================================
// LOGGING MODULE EXAMPLE
// ==========================================

print("\n=== Logging Module (log) ===\n");

print("Logging system examples:\n");

// System logging (may not output visibly in all environments)
try {
    // OpenWrt-style logging
    ulog(LOG_INFO, "This is an info message from ucode");
    ulog(LOG_ERR, "This is an error message from ucode");

    printf("  ulog() messages sent to system logger\n");

    // Traditional syslog (if available)
    syslog(LOG_INFO, "Traditional syslog message: %s", "Hello from ucode");

} catch (e) {
    printf("  System logging may not be available: %s\n", e);
}

print("\nLogging functions available:\n");
print("  ulog(priority, format, ...): OpenWrt-style logging\n");
print("  syslog(priority, format, ...): Traditional syslog\n");
print("  openlog(ident, options, facility): Configure logging\n");

print("\nLog priorities:\n");
print("  LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR\n");
print("  LOG_WARNING, LOG_NOTICE, LOG_INFO, LOG_DEBUG\n");

// ==========================================
// UCI MODULE (OpenWrt Configuration)
// ==========================================

print("\n=== UCI Module (OpenWrt Configuration) ===\n");

print("UCI (Unified Configuration Interface) for OpenWrt:\n");

try {
    // Create UCI context
    let uci = cursor();

    printf("  UCI cursor created: %s\n", type(uci));

    // These would work on actual OpenWrt systems
    print("  Example UCI operations (may not work outside OpenWrt):\n");
    print("    uci.get('system', 'system', 'hostname')\n");
    print("    uci.set('myconfig', 'section', 'option', 'value')\n");
    print("    uci.save('myconfig')\n");
    print("    uci.commit('myconfig')\n");

} catch (e) {
    printf("  UCI operations require OpenWrt environment: %s\n", e);
}

print("\nUCI functions:\n");
print("  cursor(): Create UCI context\n");
print("  get(config, section, option): Read values\n");
print("  set(config, section, option, value): Write values\n");
print("  save(config): Save changes\n");
print("  commit(config): Commit changes\n");

// ==========================================
// MODULE SEARCH PATHS
// ==========================================

print("\n=== Module Search Paths ===\n");

print("Module resolution in ucode:\n");
print("  1. Relative paths: './module', '../module'\n");
print("  2. Absolute paths: '/full/path/to/module'\n");
print("  3. Built-in modules: 'fs', 'uci', 'log', 'uloop', 'ubus'\n");
print("  4. Search paths from REQUIRE_SEARCH_PATH\n");

// Demonstrate search path manipulation
print("\nSearch path examples:\n");
if (exists(global, "REQUIRE_SEARCH_PATH")) {
    printf("  Current search paths: %J\n", REQUIRE_SEARCH_PATH);
} else {
    print("  REQUIRE_SEARCH_PATH not available in this context\n");
}

print("  To add search paths:\n");
print("    push(REQUIRE_SEARCH_PATH, '/usr/share/ucode/*.uc');\n");
print("    push(REQUIRE_SEARCH_PATH, './lib/*.uc');\n");

// ==========================================
// CREATING CUSTOM MODULES
// ==========================================

print("\n=== Creating Custom Modules ===\n");

print("Example custom module (math.uc):\n");
print("```\n");
print("// math.uc\n");
print("export let math = {\n");
print("    PI: 3.14159,\n");
print("    add: function(a, b) { return a + b; },\n");
print("    multiply: function(a, b) { return a * b; }\n");
print("};\n");
print("\n");
print("export function factorial(n) {\n");
print("    if (n <= 1) return 1;\n");
print("    return n * factorial(n - 1);\n");
print("}\n");
print("```\n");

print("Using the custom module:\n");
print("```\n");
print("import { math, factorial } from './math';\n");
print("import * as mathModule from './math';\n");
print("\n");
print("let sum = math.add(5, 3);\n");
print("let fact = factorial(5);\n");
print("let area = math.PI * 2 * 2;\n");
print("```\n");

// ==========================================
// SIMULATED CUSTOM MODULES
// ==========================================

print("\n=== Simulated Custom Module Usage ===\n");

// Since we can't actually create separate files in this example,
// let's simulate what custom modules would look like

// Simulate a utility module
let utilityModule = {
    formatBytes: function(bytes) {
        if (bytes == 0) return "0 Bytes";
        let k = 1024;
        let sizes = ["Bytes", "KB", "MB", "GB"];
        let i = floor(log(bytes) / log(k));
        return sprintf("%.2f %s", bytes / pow(k, i), sizes[i]);
    },

    formatTime: function(seconds) {
        let hours = floor(seconds / 3600);
        let minutes = floor((seconds % 3600) / 60);
        let secs = seconds % 60;
        return sprintf("%02d:%02d:%02d", hours, minutes, secs);
    },

    generateId: function() {
        return sprintf("id_%d_%d", int(time()), int(rand() * 1000));
    }
};

// Simulate a validation module
let validationModule = {
    isEmail: function(email) {
        return match(email, "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$") != null;
    },

    isPhoneUS: function(phone) {
        return match(phone, "^\\(?([0-9]{3})\\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$") != null;
    },

    isEmpty: function(value) {
        return value == null || value == "" || (type(value) == "array" && length(value) == 0);
    }
};

print("Testing simulated custom modules:\n");

// Test utility module
printf("  formatBytes(1536): %s\n", utilityModule.formatBytes(1536));
printf("  formatTime(3661): %s\n", utilityModule.formatTime(3661));
printf("  generateId(): %s\n", utilityModule.generateId());

// Test validation module
let testEmails = ["user@domain.com", "invalid-email", "test@test.org"];
for (email in testEmails) {
    printf("  isEmail('%s'): %s\n", email, validationModule.isEmail(email) ? "valid" : "invalid");
}

let testPhones = ["(555) 123-4567", "555-123-4567", "not-a-phone"];
for (phone in testPhones) {
    printf("  isPhoneUS('%s'): %s\n", phone, validationModule.isPhoneUS(phone) ? "valid" : "invalid");
}

// ==========================================
// MODULE PATTERNS AND BEST PRACTICES
// ==========================================

print("\n=== Module Patterns and Best Practices ===\n");

print("1. Export Patterns:\n");
print("   - Named exports: export let myFunction = ...\n");
print("   - Object exports: export let utils = { ... }\n");
print("   - Function exports: export function myFunc() { ... }\n");

print("\n2. Import Patterns:\n");
print("   - Selective imports: import { func1, func2 } from 'module'\n");
print("   - Namespace imports: import * as mod from 'module'\n");
print("   - Legacy imports: let mod = require('module')\n");

print("\n3. Module Organization:\n");
print("   - Keep modules focused on single responsibility\n");
print("   - Use clear, descriptive names\n");
print("   - Document exported functions\n");
print("   - Handle errors gracefully\n");

print("\n4. File Structure Example:\n");
print("   project/\n");
print("   ├── main.uc           # Main application\n");
print("   ├── lib/              # Custom modules\n");
print("   │   ├── utils.uc      # Utility functions\n");
print("   │   ├── validation.uc # Input validation\n");
print("   │   └── config.uc     # Configuration\n");
print("   └── tests/            # Test files\n");
print("       └── test_utils.uc\n");

// ==========================================
// ERROR HANDLING WITH MODULES
// ==========================================

print("\n=== Error Handling with Modules ===\n");

function safeRequire(moduleName) {
    try {
        return require(moduleName);
    } catch (e) {
        printf("Failed to load module '%s': %s\n", moduleName, e);
        return null;
    }
}

function safeImport(modulePath) {
    try {
        // In practice, you'd use actual import
        printf("Attempting to import: %s\n", modulePath);
        return { success: true, module: null }; // Simulated
    } catch (e) {
        return { success: false, error: e };
    }
}

print("Safe module loading examples:\n");

let testModules = ["fs", "nonexistent", "uci", "invalid_module"];
for (modName in testModules) {
    let result = safeRequire(modName);
    if (result) {
        printf("  '%s': loaded successfully (%s)\n", modName, type(result));
    } else {
        printf("  '%s': failed to load\n", modName);
    }
}

// ==========================================
// DYNAMIC MODULE LOADING
// ==========================================

print("\n=== Dynamic Module Loading ===\n");

function loadModuleByName(name) {
    let moduleMap = {
        "math": function() {
            return {
                add: function(a, b) { return a + b; },
                multiply: function(a, b) { return a * b; }
            };
        },
        "string": function() {
            return {
                reverse: function(s) { return join(reverse(split(s, "")), ""); },
                capitalize: function(s) { return uc(substr(s, 0, 1)) + lc(substr(s, 1)); }
            };
        }
    };

    if (name in moduleMap) {
        return moduleMap[name]();
    }
    return null;
}

print("Dynamic loading examples:\n");
let mathMod = loadModuleByName("math");
let stringMod = loadModuleByName("string");

if (mathMod) {
    printf("  math.add(5, 3) = %d\n", mathMod.add(5, 3));
    printf("  math.multiply(4, 7) = %d\n", mathMod.multiply(4, 7));
}

if (stringMod) {
    printf("  string.reverse('hello') = %s\n", stringMod.reverse("hello"));
    printf("  string.capitalize('world') = %s\n", stringMod.capitalize("world"));
}

// ==========================================
// MODULE CONFIGURATION AND INITIALIZATION
// ==========================================

print("\n=== Module Configuration ===\n");

// Simulate a configurable module
function createLogger(config) {
    let defaultConfig = {
        level: "INFO",
        prefix: "[LOG]",
        timestamp: true
    };

    // Merge config with defaults
    let finalConfig = {};
    for (key, value in defaultConfig) {
        finalConfig[key] = value;
    }
    for (key, value in config) {
        finalConfig[key] = value;
    }

    return {
        info: function(msg) {
            if (finalConfig.timestamp) {
                printf("%s %s INFO: %s\n", "2024-01-15 10:30:00", finalConfig.prefix, msg);
            } else {
                printf("%s INFO: %s\n", finalConfig.prefix, msg);
            }
        },
        error: function(msg) {
            if (finalConfig.timestamp) {
                printf("%s %s ERROR: %s\n", "2024-01-15 10:30:00", finalConfig.prefix, msg);
            } else {
                printf("%s ERROR: %s\n", finalConfig.prefix, msg);
            }
        }
    };
}

print("Configurable module example:\n");
let logger1 = createLogger({ prefix: "[APP]" });
let logger2 = createLogger({ prefix: "[SYS]", timestamp: false });

logger1.info("Application started");
logger1.error("Database connection failed");
logger2.info("System initialized");
logger2.error("Memory low");

// ==========================================
// CONCLUSION
// ==========================================

print("\n=== Module System Summary ===\n");

print("ucode Module System Features:\n");
print("✓ Modern ES6-style import/export syntax\n");
print("✓ Legacy require() compatibility\n");
print("✓ Built-in modules (fs, log, uci, uloop, ubus)\n");
print("✓ Custom module creation and loading\n");
print("✓ Module search path configuration\n");
print("✓ Error handling and safe loading\n");
print("✓ Dynamic and configurable modules\n");

print("\nBuilt-in Modules Available:\n");
print("  fs     - File system operations\n");
print("  log    - System logging (syslog, ulog)\n");
print("  uci    - OpenWrt configuration interface\n");
print("  uloop  - Event loop and timers\n");
print("  ubus   - OpenWrt message bus\n");
print("  math   - Mathematical functions\n");
print("  struct - Binary data packing/unpacking\n");

print("\nBest Practices:\n");
print("  1. Use import/export for new code\n");
print("  2. Handle module loading errors gracefully\n");
print("  3. Keep modules focused and well-documented\n");
print("  4. Use configuration objects for flexibility\n");
print("  5. Test modules independently\n");

print("\n=== End of Modules and Imports Example ===\n");
