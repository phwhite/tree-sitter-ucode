#!/usr/bin/ucode

// Example: Functions in ucode
// This example demonstrates all function-related features in ucode

print("=== ucode Functions Example ===\n");

// ==========================================
// FUNCTION DECLARATIONS
// ==========================================

print("=== Function Declarations ===\n");

// Basic function declaration
function greet(name) {
    return "Hello, " + name + "!";
}

// Function with multiple parameters
function add(a, b) {
    return a + b;
}

// Function with no parameters
function getCurrentTime() {
    // Simulate getting current time
    return "2024-01-15 10:30:00";
}

// Function with no return value (returns null implicitly)
function logMessage(message) {
    printf("[LOG] %s\n", message);
}

print("Testing basic functions:\n");
printf("  greet('Alice') = %s\n", greet("Alice"));
printf("  add(5, 3) = %d\n", add(5, 3));
printf("  getCurrentTime() = %s\n", getCurrentTime());
logMessage("This is a log entry");

// ==========================================
// FUNCTION EXPRESSIONS
// ==========================================

print("\n=== Function Expressions ===\n");

// Function assigned to variable
let multiply = function(a, b) {
    return a * b;
};

// Anonymous function in variable
let square = function(x) {
    return x * x;
};

// Function expression with name (for recursion)
let factorial = function fact(n) {
    if (n <= 1) return 1;
    return n * fact(n - 1);
};

print("Testing function expressions:\n");
printf("  multiply(4, 6) = %d\n", multiply(4, 6));
printf("  square(7) = %d\n", square(7));
//printf("  factorial(5) = %d\n", factorial(5));

// ==========================================
// ARROW FUNCTIONS (LIMITED SUPPORT)
// ==========================================

print("\n=== Arrow Functions ===\n");

// Simple arrow function (if supported)
let double = (x) => x * 2;
let isEven = (n) => n % 2 == 0;

// Arrow function with block body
let processValue = (value) => {
    if (value < 0) return 0;
    return value * 3;
};

print("Testing arrow functions:\n");
printf("  double(8) = %d\n", double(8));
printf("  isEven(10) = %s\n", isEven(10) ? "true" : "false");
printf("  processValue(-5) = %d\n", processValue(-5));
printf("  processValue(4) = %d\n", processValue(4));

// ==========================================
// DEFAULT PARAMETERS
// ==========================================

/*

print("\n=== Default Parameters ===\n");

// Function with default parameters
function createUser(uname = "Anonymous", age = 0, active = true) {
    return {
        name: uname,
        age: age,
        active: active,
        created: getCurrentTime()
    };
}

// Function with mixed default and required parameters
function formatMessage(message, prefix = "[INFO]", timestamp = true) {
    let result = prefix + " " + message;
    if (timestamp) {
        result = getCurrentTime() + " " + result;
    }
    return result;
}

print("Testing default parameters:\n");
let user1 = createUser();
let user2 = createUser("Alice");
let user3 = createUser("Bob", 25);
let user4 = createUser("Charlie", 30, false);

printf("  user1 (no args): %J\n", user1);
printf("  user2 (name only): %J\n", user2);
printf("  user3 (name, age): %J\n", user3);
printf("  user4 (all args): %J\n", user4);

printf("  formatMessage('Hello'): %s\n", formatMessage("Hello"));
printf("  formatMessage('Error', '[ERROR]'): %s\n", formatMessage("Error", "[ERROR]"));
printf("  formatMessage('Debug', '[DEBUG]', false): %s\n", formatMessage("Debug", "[DEBUG]", false));
*/

// ==========================================
// REST PARAMETERS
// ==========================================

print("\n=== Rest Parameters ===\n");

// Function with rest parameters
function sum(...numbers) {
    let total = 0;
    for (n in numbers) {
        total += n;
    }
    return total;
}

// Function with regular and rest parameters
function logWithLevel(level, ...messages) {
    let timestamp = getCurrentTime();
    printf("[%s] %s: ", timestamp, level);
    for (msg in messages) {
        printf("%s ", msg);
    }
    print("\n");
}

// Function to find maximum
function findMax(...values) {
    if (length(values) == 0) return null;

    let maxVal = values[0];
    for (let i = 1; i < length(values); i++) {
        if (values[i] > maxVal) {
            maxVal = values[i];
        }
    }
    return maxVal;
}

print("Testing rest parameters:\n");
printf("  sum() = %d\n", sum());
printf("  sum(5) = %d\n", sum(5));
printf("  sum(1, 2, 3, 4, 5) = %d\n", sum(1, 2, 3, 4, 5));
printf("  findMax(10, 5, 8, 3, 12, 7) = %d\n", findMax(10, 5, 8, 3, 12, 7));

logWithLevel("INFO", "System", "started", "successfully");
logWithLevel("ERROR", "Connection", "failed");

// ==========================================
// FUNCTIONS AS FIRST-CLASS VALUES
// ==========================================

print("\n=== Functions as First-Class Values ===\n");

// Store functions in variables
let operations = {
    add: function(a, b) { return a + b; },
    subtract: function(a, b) { return a - b; },
    multiply: function(a, b) { return a * b; },
    divide: function(a, b) { return b != 0 ? a / b : null; }
};

// Array of functions
let validators = [
    function(x) { return x > 0; },          // positive
    function(x) { return x % 2 == 0; },     // even
    function(x) { return x < 100; }         // less than 100
];

// Function that accepts other functions as parameters
function calculate(operation, a, b) {
    return operation(a, b);
}

/*
print("Testing functions as first-class values:\n");
printf("  operations.add(10, 5) = %d\n", operations.add(10, 5));
printf("  operations.multiply(7, 3) = %d\n", operations.multiply(7, 3));
printf("  calculate(operations.subtract, 15, 8) = %d\n", calculate(operations.subtract, 15, 8));
*/

// Test validators
let testValue = 42;
printf("  Testing value %d:\n", testValue);
for (let i = 0; i < length(validators); i++) {
    let validator = validators[i];
    printf("    Validator %d: %s\n", i + 1, validator(testValue) ? "pass" : "fail");
}


// ==========================================
// ERROR HANDLING IN FUNCTIONS
// ==========================================

print("\n=== Error Handling in Functions ===\n");

function safeDivide(a, b) {
    if (b == 0) {
        return { error: "Division by zero", result: null };
    }
    return { error: null, result: a / b };
}

function parseNumber(str) {
    let num = int(str);
    if (num == 0 && str != "0") {
        return { error: "Invalid number format", result: null };
    }
    return { error: null, result: num };
}

function processInput(input) {
    try {
        assert(input, "Input cannot be empty");

        let parts = split(input, "/");
        assert(length(parts) == 2, "Input must be in format 'a/b'");

        let aResult = parseNumber(parts[0]);
        assert(!aResult.error, "First number: " + aResult.error);

        let bResult = parseNumber(parts[1]);
        assert(!bResult.error, "First number: " + bResult.error);

        let divResult = safeDivide(aResult.result, bResult.result);
        assert(!divResult.error, divResult.error);

        return { success: true, result: divResult.result };

    } catch (error) {
        return { success: false, error: error };
    }
}

print("Testing error handling:\n");
let testInputs = ["10/2", "15/3", "8/0", "abc/5", "10", "", "20/xyz"];

for (input in testInputs) {
    let result = processInput(input);
    if (result.success) {
        printf("  '%s' = %.2f\n", input, result.result);
    } else {
        printf("  '%s' -> Error: %s\n", input, result.error);
    }
}

// ==========================================
// ADVANCED FUNCTION PATTERNS
// ==========================================

print("\n=== Advanced Function Patterns ===\n");

// Memoization pattern
function memoize(func) {
    let cache = {};

    return function(...args) {
        let key = join(args, ",");

        if (!(key in cache)) {
            cache[key] = func(...args);
        }

        return cache[key];
    };
}

// Expensive function to memoize
function expensiveCalculation(n) {
    printf("    Computing expensive calculation for %d\n", n);
    let result = 0;
    for (let i = 0; i <= n; i++) {
        result += i * i;
    }
    return result;
}

let memoizedCalc = memoize(expensiveCalculation);

print("Testing memoization:\n");
printf("  First call memoizedCalc(100): %d\n", memoizedCalc(100));
printf("  Second call memoizedCalc(100): %d\n", memoizedCalc(100));
printf("  Third call memoizedCalc(50): %d\n", memoizedCalc(50));

print("\n=== End of Functions Example ===\n");
