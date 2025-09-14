#!/usr/bin/ucode

// Example: Data Types and Variables in ucode
// This example demonstrates all the basic data types, variable declarations, and type checking

print("=== ucode Data Types and Variables Example ===\n");

// ==========================================
// VARIABLE DECLARATIONS
// ==========================================

// Global variable (no keyword)
globalVar = "I am global";

// Local variable (function/block scoped)
let localVar = "I am local";

// Constant (cannot be reassigned)
const CONSTANT_VAR = 300;
const PI = 3.14159;

print("Variables declared:\n");
printf("  globalVar = %s\n", globalVar);
printf("  localVar = %s\n", localVar);
printf("  CONSTANT_VAR = %d\n", CONSTANT_VAR);
printf("  PI = %.5f\n\n", PI);

// ==========================================
// PRIMITIVE DATA TYPES
// ==========================================

print("=== Primitive Data Types ===\n");

// Boolean values
let boolTrue = true;
let boolFalse = false;

printf("Boolean values:\n");
printf("  boolTrue = %J (type: %s)\n", boolTrue, type(boolTrue));
printf("  boolFalse = %J (type: %s)\n", boolFalse, type(boolFalse));

// Integer values (64-bit signed)
let smallInt = 42;
let largeInt = 9223372036854775807;  // Max 64-bit signed integer
let negativeInt = -1234567890;
let hexInt = 0xFF;
let octInt = 0o777;

printf("\nInteger values:\n");
printf("  smallInt = %d (type: %s)\n", smallInt, type(smallInt));
printf("  largeInt = %d (type: %s)\n", largeInt, type(largeInt));
printf("  negativeInt = %d (type: %s)\n", negativeInt, type(negativeInt));
printf("  hexInt = %d (0x%X) (type: %s)\n", hexInt, hexInt, type(hexInt));
printf("  octInt = %d (0o%o) (type: %s)\n", octInt, octInt, type(octInt));

// Double/Float values
let smallFloat = 3.14;
let scientificFloat = 1.7e308;  // Close to max double
let negativeFloat = -2.5;
let verySmallFloat = 1.2e-10;

printf("\nFloat/Double values:\n");
printf("  smallFloat = %.2f (type: %s)\n", smallFloat, type(smallFloat));
printf("  scientificFloat = %g (type: %s)\n", scientificFloat, type(scientificFloat));
printf("  negativeFloat = %.1f (type: %s)\n", negativeFloat, type(negativeFloat));
printf("  verySmallFloat = %g (type: %s)\n", verySmallFloat, type(verySmallFloat));

// String values
let singleQuoteString = 'Hello with single quotes';
let doubleQuoteString = "Hello with double quotes";
let emptyString = "";
let stringWithEscapes = "Line 1\nLine 2\tTabbed\n\"Quoted\" text \\backslash";

printf("\nString values:\n");
printf("  singleQuoteString = %s (type: %s, length: %d)\n", singleQuoteString, type(singleQuoteString), length(singleQuoteString));
printf("  doubleQuoteString = %s (type: %s, length: %d)\n", doubleQuoteString, type(doubleQuoteString), length(doubleQuoteString));
printf("  emptyString = '%s' (type: %s, length: %d)\n", emptyString, type(emptyString), length(emptyString));
printf("  stringWithEscapes:\n%s\n", stringWithEscapes);
printf("  (type: %s, length: %d)\n", type(stringWithEscapes), length(stringWithEscapes));

// Null value
let nullValue = null;
printf("\nNull value:\n");
printf("  nullValue = %J (type: %s)\n", nullValue, type(nullValue));

// ==========================================
// COMPLEX DATA TYPES - ARRAYS
// ==========================================

print("\n=== Array Data Type ===\n");

// Array creation
let emptyArray = [];
let numberArray = [1, 2, 3, 4, 5];
let mixedArray = [1, "two", true, null, { key: "value" }];
let nestedArray = [[1, 2], [3, 4], [5, 6]];

printf("Array examples:\n");
printf("  emptyArray = %J (type: %s, length: %d)\n", emptyArray, type(emptyArray), length(emptyArray));
printf("  numberArray = %J (type: %s, length: %d)\n", numberArray, type(numberArray), length(numberArray));
printf("  mixedArray = %J (type: %s, length: %d)\n", mixedArray, type(mixedArray), length(mixedArray));
printf("  nestedArray = %J (type: %s, length: %d)\n", nestedArray, type(nestedArray), length(nestedArray));

// Array access (including negative indexing)
printf("\nArray access:\n");
printf("  numberArray[0] = %d (first element)\n", numberArray[0]);
printf("  numberArray[-1] = %d (last element)\n", numberArray[-1]);
printf("  numberArray[2] = %d (third element)\n", numberArray[2]);

// Check if index exists
printf("\nArray index existence:\n");
printf("  Index 2 exists in numberArray: %s\n", (2 in numberArray) ? "yes" : "no");
printf("  Index 10 exists in numberArray: %s\n", (10 in numberArray) ? "yes" : "no");

// ==========================================
// COMPLEX DATA TYPES - OBJECTS
// ==========================================

print("\n=== Object Data Type ===\n");

// Object creation
let emptyObject = {};
let simpleObject = {
    name: "Alice",
    age: 30,
    active: true
};
let complexObject = {
    "quoted-key": "value with quoted key",
    nested: {
        level2: {
            value: "deeply nested"
        }
    },
    array: [1, 2, 3],
    func: function(x) { return x * 2; }
};

printf("Object examples:\n");
printf("  emptyObject = %J (type: %s, length: %d)\n", emptyObject, type(emptyObject), length(emptyObject));
printf("  simpleObject = %J (type: %s, length: %d)\n", simpleObject, type(simpleObject), length(simpleObject));

// Object property access
printf("\nObject property access:\n");
printf("  simpleObject.name = %s\n", simpleObject.name);
printf("  simpleObject['age'] = %d\n", simpleObject["age"]);
printf("  complexObject['quoted-key'] = %s\n", complexObject["quoted-key"]);
printf("  complexObject.nested.level2.value = %s\n", complexObject.nested.level2.value);

// Check if property exists
printf("\nObject property existence:\n");
printf("  'name' exists in simpleObject: %s\n", ("name" in simpleObject) ? "yes" : "no");
printf("  'email' exists in simpleObject: %s\n", ("email" in simpleObject) ? "yes" : "no");
printf("  exists(simpleObject, 'name'): %s\n", exists(simpleObject, "name") ? "yes" : "no");

// ==========================================
// TYPE CHECKING AND CONVERSION
// ==========================================

print("\n=== Type Checking and Information ===\n");

let testValues = [
    true,
    42,
    3.14,
    "hello",
    null,
    [1, 2, 3],
    { key: "value" },
    function() { return "I'm a function"; }
];

printf("Type checking for various values:\n");
for (let i = 0; i < length(testValues); i++) {
    let value = testValues[i];
    printf("  Value %J has type: %s\n", value, type(value));
}

// type() function for checking data types
printf("\nUsing type() function:\n");
printf("  type(42) = %s\n", type(42));
printf("  type('string') = %s\n", type("string"));
printf("  type([]) = %s\n", type([]));
printf("  type({}) = %s\n", type({}));

// ==========================================
// VARIABLE SCOPE DEMONSTRATION
// ==========================================

print("\n=== Variable Scope ===\n");

function demonstrateScope() {
    let functionScoped = "I'm function scoped";

    if (true) {
        let blockScoped = "I'm block scoped";
        printf("  Inside block: functionScoped = %s\n", functionScoped);
        printf("  Inside block: blockScoped = %s\n", blockScoped);
    }

    // blockScoped is not accessible here
    printf("  Outside block: functionScoped = %s\n", functionScoped);
    // Uncomment next line to see error:
    // printf("  Outside block: blockScoped = %s\n", blockScoped);
}

print("Variable scope demonstration:\n");
demonstrateScope();

// ==========================================
// CONST BEHAVIOR
// ==========================================

print("\n=== Constant Behavior ===\n");

const UNCHANGEABLE = "This cannot be reassigned";
printf("UNCHANGEABLE = %s\n", UNCHANGEABLE);

// Attempting to reassign const will cause error
// Uncomment next line to see error:
// UNCHANGEABLE = "New value";  // This would cause an error

// However, const objects and arrays can have their contents modified
const CONST_ARRAY = [1, 2, 3];
const CONST_OBJECT = { count: 0 };

printf("Before modification:\n");
printf("  CONST_ARRAY = %J\n", CONST_ARRAY);
printf("  CONST_OBJECT = %J\n", CONST_OBJECT);

// Modify contents (this is allowed)
push(CONST_ARRAY, 4);
CONST_OBJECT.count = 42;

printf("After modification:\n");
printf("  CONST_ARRAY = %J\n", CONST_ARRAY);
printf("  CONST_OBJECT = %J\n", CONST_OBJECT);

print("\n=== End of Data Types and Variables Example ===\n");
