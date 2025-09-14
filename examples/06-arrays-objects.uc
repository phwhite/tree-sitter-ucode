#!/usr/bin/ucode

// Example: Arrays and Objects in ucode
// This example demonstrates detailed array and object manipulation in ucode

print("=== ucode Arrays and Objects Example ===\n");

// ==========================================
// ARRAY CREATION AND BASIC OPERATIONS
// ==========================================

print("=== Array Creation and Basic Operations ===\n");

// Different ways to create arrays
let emptyArray = [];
let numberArray = [1, 2, 3, 4, 5];
let mixedArray = [1, "two", true, null, { key: "value" }];
let nestedArray = [[1, 2], [3, 4], [5, [6, 7]]];

print("Array creation:\n");
printf("  emptyArray = %J\n", emptyArray);
printf("  numberArray = %J\n", numberArray);
printf("  mixedArray = %J\n", mixedArray);
printf("  nestedArray = %J\n", nestedArray);

// Array length and type
printf("\nArray properties:\n");
printf("  length(numberArray) = %d\n", length(numberArray));
printf("  type(numberArray) = %s\n", type(numberArray));

// ==========================================
// ARRAY ACCESS AND MODIFICATION
// ==========================================

print("\n=== Array Access and Modification ===\n");

// Standard indexing (0-based)
printf("Array access:\n");
printf("  numberArray[0] = %d (first element)\n", numberArray[0]);
printf("  numberArray[2] = %d (third element)\n", numberArray[2]);
printf("  numberArray[4] = %d (last element)\n", numberArray[4]);

// Negative indexing (from end)
printf("  numberArray[-1] = %d (last element)\n", numberArray[-1]);
printf("  numberArray[-2] = %d (second to last)\n", numberArray[-2]);

// Setting elements
let modifiableArray = [10, 20, 30];
printf("\nArray modification:\n");
printf("  Before: modifiableArray = %J\n", modifiableArray);
modifiableArray[1] = 99;
printf("  After modifiableArray[1] = 99: %J\n", modifiableArray);

// Adding elements beyond length
modifiableArray[5] = 60;
printf("  After modifiableArray[5] = 60: %J\n", modifiableArray);

// Check if index exists
printf("\nIndex existence:\n");
printf("  0 in numberArray = %s\n", (0 in numberArray) ? "true" : "false");
printf("  5 in numberArray = %s\n", (5 in numberArray) ? "true" : "false");
printf("  10 in modifiableArray = %s\n", (10 in modifiableArray) ? "true" : "false");

// ==========================================
// ARRAY ITERATION
// ==========================================

print("\n=== Array Iteration ===\n");

let fruits = ["apple", "banana", "cherry", "date", "elderberry"];

// For-in iteration (values)
print("Iterating over values:\n");
for (fruit in fruits) {
    printf("  - %s\n", fruit);
}

// Traditional for loop with indices
print("\nIterating with indices:\n");
for (let i = 0; i < length(fruits); i++) {
    printf("  [%d]: %s\n", i, fruits[i]);
}

// Reverse iteration
print("\nReverse iteration:\n");
for (let i = length(fruits) - 1; i >= 0; i--) {
    printf("  [%d]: %s\n", i, fruits[i]);
}

// ==========================================
// ARRAY MANIPULATION METHODS
// ==========================================

print("\n=== Array Manipulation Methods ===\n");

let workingArray = ["a", "b", "c"];

// Adding elements
printf("Original: %J\n", workingArray);

push(workingArray, "d");
printf("After push('d'): %J\n", workingArray);

push(workingArray, "e", "f", "g");
printf("After push('e', 'f', 'g'): %J\n", workingArray);

unshift(workingArray, "start");
printf("After unshift('start'): %J\n", workingArray);

// Removing elements
let popped = pop(workingArray);
printf("pop() returned '%s', array: %J\n", popped, workingArray);

let shifted = shift(workingArray);
printf("shift() returned '%s', array: %J\n", shifted, workingArray);

// Slicing (non-destructive)
let originalSlice = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
printf("\nSlicing operations on %J:\n", originalSlice);
printf("  slice(2, 6): %J\n", slice(originalSlice, 2, 6));
printf("  slice(3): %J\n", slice(originalSlice, 3));
printf("  slice(-3): %J\n", slice(originalSlice, -3));
printf("  Original unchanged: %J\n", originalSlice);

// Splicing (destructive)
let spliceDemo = [1, 2, 3, 4, 5];
printf("\nSplicing operations:\n");
printf("  Original: %J\n", spliceDemo);
let removed1 = splice(spliceDemo, 2, 1);
printf("  splice(2, 1) removed %J, array: %J\n", removed1, spliceDemo);

let removed2 = splice(spliceDemo, 1, 0, "X", "Y");
printf("  splice(1, 0, 'X', 'Y') removed %J, array: %J\n", removed2, spliceDemo);

// ==========================================
// ARRAY SORTING AND REVERSING
// ==========================================

print("\n=== Array Sorting and Reversing ===\n");

// Numeric sorting
let numbers = [3, 1, 4, 1, 5, 9, 2, 6];
printf("Numbers before sort: %J\n", numbers);
sort(numbers);
printf("Numbers after sort: %J\n", numbers);

// String sorting
let words = ["banana", "apple", "cherry", "date"];
printf("Words before sort: %J\n", words);
sort(words);
printf("Words after sort: %J\n", words);

// Custom sorting
let customNumbers = [10, 5, 100, 20, 1];
printf("Custom sort (by string length): %J\n", customNumbers);
sort(customNumbers, function(a, b) {
    let aStr = a + "";
    let bStr = b + "";
    return length(aStr) - length(bStr);
});
printf("After custom sort: %J\n", customNumbers);

// Reverse array
let reverseDemo = [1, 2, 3, 4, 5];
printf("Before reverse: %J\n", reverseDemo);
reverse(reverseDemo);
printf("After reverse: %J\n", reverseDemo);

// ==========================================
// ARRAY SEARCHING AND UTILITIES
// ==========================================

print("\n=== Array Searching and Utilities ===\n");

let searchArray = ["red", "green", "blue", "green", "yellow"];
printf("Search array: %J\n", searchArray);

printf("index('green'): %d\n", index(searchArray, "green"));
printf("rindex('green'): %d\n", rindex(searchArray, "green"));
printf("index('purple'): %d\n", index(searchArray, "purple"));

// Join array elements
printf("join(', '): %s\n", join(searchArray, ", "));
printf("join(' | '): %s\n", join(searchArray, " | "));
printf("join(''): %s\n", join(searchArray, ""));

// Remove duplicates
let duplicateArray = [1, 2, 3, 2, 4, 1, 5, 3];
printf("With duplicates: %J\n", duplicateArray);
let uniqueArray = uniq(duplicateArray);
printf("After uniq(): %J\n", uniqueArray);

// ==========================================
// MULTI-DIMENSIONAL ARRAYS
// ==========================================

print("\n=== Multi-dimensional Arrays ===\n");

// Creating 2D array (matrix)
let matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

printf("Matrix:\n");
for (let row = 0; row < length(matrix); row++) {
    printf("  Row %d: ", row);
    for (let col = 0; col < length(matrix[row]); col++) {
        printf("%d ", matrix[row][col]);
    }
    printf("\n");
}

// Access elements
printf("matrix[1][2] = %d\n", matrix[1][2]);
printf("matrix[0][0] = %d\n", matrix[0][0]);

// Modify 2D array
matrix[1][1] = 99;
printf("After matrix[1][1] = 99:\n");
for (row in matrix) {
    printf("  %J\n", row);
}

// Jagged array (rows of different lengths)
let jaggedArray = [
    [1, 2],
    [3, 4, 5, 6],
    [7],
    [8, 9, 10]
];

printf("\nJagged array:\n");
for (let i = 0; i < length(jaggedArray); i++) {
    printf("  Row %d (length %d): %J\n", i, length(jaggedArray[i]), jaggedArray[i]);
}

// ==========================================
// OBJECT CREATION AND BASIC OPERATIONS
// ==========================================

print("\n=== Object Creation and Basic Operations ===\n");

// Different ways to create objects
let emptyObject = {};
let person = {
    name: "Alice",
    age: 30,
    city: "New York"
};
let complexObject = {
    "quoted-key": "value with spaces",
    nested: {
        level1: {
            level2: "deep value"
        }
    },
    array: [1, 2, 3],
    func: function(x) { return x * 2; }
};

print("Object creation:\n");
printf("  emptyObject = %J\n", emptyObject);
printf("  person = %J\n", person);
printf("  complexObject keys: %J\n", keys(complexObject));

// Object properties
printf("\nObject properties:\n");
printf("  length(person) = %d\n", length(person));
printf("  type(person) = %s\n", type(person));

// ==========================================
// OBJECT PROPERTY ACCESS
// ==========================================

print("\n=== Object Property Access ===\n");

// Dot notation
printf("Dot notation access:\n");
printf("  person.name = %s\n", person.name);
printf("  person.age = %d\n", person.age);
printf("  person.city = %s\n", person.city);

// Bracket notation
printf("\nBracket notation access:\n");
printf("  person['name'] = %s\n", person["name"]);
printf("  person['age'] = %d\n", person["age"]);

// Quoted keys require bracket notation
printf("  complexObject['quoted-key'] = %s\n", complexObject["quoted-key"]);

// Dynamic property access
let propertyName = "age";
printf("  person[propertyName] = %d (dynamic access)\n", person[propertyName]);

// Nested object access
printf("\nNested object access:\n");
printf("  complexObject.nested.level1.level2 = %s\n", complexObject.nested.level1.level2);

// ==========================================
// OBJECT PROPERTY MODIFICATION
// ==========================================

print("\n=== Object Property Modification ===\n");

let modifiableObject = {
    name: "Bob",
    age: 25
};

printf("Before modification: %J\n", modifiableObject);

// Add new properties
modifiableObject.city = "Boston";
modifiableObject["occupation"] = "Engineer";

printf("After adding properties: %J\n", modifiableObject);

// Modify existing properties
modifiableObject.age = 26;
modifiableObject["name"] = "Robert";

printf("After modifying properties: %J\n", modifiableObject);

// ==========================================
// OBJECT PROPERTY EXISTENCE AND DELETION
// ==========================================

print("\n=== Object Property Existence and Deletion ===\n");

let testObject = {
    a: 1,
    b: 2,
    c: null,
    d: false,
    e: ""
};

printf("Test object: %J\n", testObject);

// Check property existence
printf("\nProperty existence ('in' operator):\n");
printf("  'a' in testObject = %s\n", ("a" in testObject) ? "true" : "false");
printf("  'c' in testObject = %s (null value)\n", ("c" in testObject) ? "true" : "false");
printf("  'd' in testObject = %s (false value)\n", ("d" in testObject) ? "true" : "false");
printf("  'z' in testObject = %s\n", ("z" in testObject) ? "true" : "false");

// Check with exists() function
printf("\nProperty existence (exists function):\n");
printf("  exists(testObject, 'a') = %s\n", exists(testObject, "a") ? "true" : "false");
printf("  exists(testObject, 'z') = %s\n", exists(testObject, "z") ? "true" : "false");

// Delete properties
printf("\nDeleting properties:\n");
printf("  Before delete: %J\n", testObject);
delete testObject.b;
printf("  After delete testObject.b: %J\n", testObject);
delete testObject["c"];
printf("  After delete testObject['c']: %J\n", testObject);

// ==========================================
// OBJECT ITERATION
// ==========================================

print("\n=== Object Iteration ===\n");

let iterationObject = {
    name: "Charlie",
    age: 35,
    city: "Chicago",
    occupation: "Designer",
    active: true
};

// Iterate over keys only
printf("Iterating over keys:\n");
for (key in iterationObject) {
    printf("  Key: %s\n", key);
}

// Iterate over key-value pairs
printf("\nIterating over key-value pairs:\n");
for (key, value in iterationObject) {
    printf("  %s: %J\n", key, value);
}

// Using keys() and values() functions
printf("\nUsing keys() function:\n");
let objKeys = keys(iterationObject);
for (key in objKeys) {
    printf("  %s = %J\n", key, iterationObject[key]);
}

printf("\nUsing values() function:\n");
let objValues = values(iterationObject);
for (value in objValues) {
    printf("  Value: %J\n", value);
}

// ==========================================
// NESTED OBJECTS AND ARRAYS
// ==========================================

print("\n=== Nested Objects and Arrays ===\n");

let nestedData = {
    users: [
        {
            id: 1,
            name: "Alice",
            contacts: {
                email: "alice@example.com",
                phones: ["555-1234", "555-5678"]
            }
        },
        {
            id: 2,
            name: "Bob",
            contacts: {
                email: "bob@example.com",
                phones: ["555-9876"]
            }
        }
    ],
    metadata: {
        created: "2024-01-15",
        version: "1.0",
        settings: {
            theme: "dark",
            notifications: true
        }
    }
};

printf("Nested data structure:\n");
printf("  Total users: %d\n", length(nestedData.users));
printf("  First user: %s\n", nestedData.users[0].name);
printf("  First user's email: %s\n", nestedData.users[0].contacts.email);
printf("  First user's first phone: %s\n", nestedData.users[0].contacts.phones[0]);
printf("  Theme setting: %s\n", nestedData.metadata.settings.theme);

// Iterate through nested structure
printf("\nUser details:\n");
for (let i = 0; i < length(nestedData.users); i++) {
    let user = nestedData.users[i];
    printf("  User %d:\n", user.id);
    printf("    Name: %s\n", user.name);
    printf("    Email: %s\n", user.contacts.email);
    printf("    Phones: %s\n", join(user.contacts.phones, ", "));
}

// ==========================================
// OBJECT AS DICTIONARY/MAP
// ==========================================

print("\n=== Object as Dictionary/Map ===\n");

// Using object as a counter/frequency map
let text = "hello world hello universe hello";
let words2 = split(text, " ");
let wordCount = {};

printf("Counting words in: '%s'\n", text);
for (word in words2) {
    if (word in wordCount) {
        wordCount[word]++;
    } else {
        wordCount[word] = 1;
    }
}

printf("Word frequencies:\n");
for (word, count in wordCount) {
    printf("  '%s': %d\n", word, count);
}

// Using object as lookup table
let statusCodes = {
    "200": "OK",
    "404": "Not Found",
    "500": "Internal Server Error",
    "403": "Forbidden",
    "401": "Unauthorized"
};

let testCodes = ["200", "404", "999", "500"];
printf("\nStatus code lookup:\n");
for (code in testCodes) {
    let message = statusCodes[code] ?? "Unknown Status";
    printf("  %s: %s\n", code, message);
}

// ==========================================
// ARRAY OF OBJECTS OPERATIONS
// ==========================================

print("\n=== Array of Objects Operations ===\n");

let employees = [
    { id: 1, name: "Alice Johnson", department: "Engineering", salary: 80000, active: true },
    { id: 2, name: "Bob Smith", department: "Marketing", salary: 65000, active: true },
    { id: 3, name: "Charlie Brown", department: "Engineering", salary: 75000, active: false },
    { id: 4, name: "Diana Prince", department: "HR", salary: 70000, active: true },
    { id: 5, name: "Eve Wilson", department: "Engineering", salary: 85000, active: true }
];

printf("Employee database (%d employees):\n", length(employees));

// Find employee by ID
function findEmployeeById(id) {
    for (emp in employees) {
        if (emp.id == id) {
            return emp;
        }
    }
    return null;
}

let emp = findEmployeeById(3);
printf("  Employee ID 3: %s\n", emp ? emp.name : "Not found");

// Filter active employees
let activeEmployees = filter(employees, function(emp) {
    return emp.active;
});
printf("  Active employees: %d\n", length(activeEmployees));

// Filter by department
let engineers = filter(employees, function(emp) {
    return emp.department == "Engineering";
});
printf("  Engineers: %d\n", length(engineers));

// Group by department
let departments = {};
for (emp in employees) {
    let dept = emp.department;
    if (!(dept in departments)) {
        departments[dept] = [];
    }
    push(departments[dept], emp.name);
}

printf("  Employees by department:\n");
for (dept, empList in departments) {
    printf("    %s: %s\n", dept, join(empList, ", "));
}

// ==========================================
// COPYING AND CLONING
// ==========================================

print("\n=== Copying and Cloning ===\n");

let original = {
    name: "Original",
    numbers: [1, 2, 3],
    nested: { value: 42 }
};

// Shallow copy (references are shared)
let shallowCopy = {};
for (key, value in original) {
    shallowCopy[key] = value;
}

// Deep copy function
function deepCopy(obj) {
    if (type(obj) != "object" && type(obj) != "array") {
        return obj;
    }

    let copy = type(obj) == "array" ? [] : {};
    for (key, value in obj) {
        copy[key] = deepCopy(value);
    }
    return copy;
}

let deepCopyObj = deepCopy(original);

printf("Testing copy behavior:\n");
printf("  Original: %J\n", original);
printf("  Shallow copy: %J\n", shallowCopy);
printf("  Deep copy: %J\n", deepCopyObj);

// Modify original
original.name = "Modified";
push(original.numbers, 4);
original.nested.value = 99;

printf("\nAfter modifying original:\n");
printf("  Original: %J\n", original);
printf("  Shallow copy: %J (nested refs changed)\n", shallowCopy);
printf("  Deep copy: %J (unchanged)\n", deepCopyObj);

// ==========================================
// PERFORMANCE CONSIDERATIONS
// ==========================================

print("\n=== Performance Considerations ===\n");

// Efficient property access in loops
let largeObject = {};
for (let i = 0; i < 1000; i++) {
    largeObject["key" + i] = "value" + i;
}

printf("Large object created with %d properties\n", length(largeObject));

// Cache property access in loops
let iterations = 1000;
let startTime = 0; // Simulated timing

printf("Demonstrating efficient property access patterns:\n");
printf("  Direct access in loop: object.prop (less efficient for repeated access)\n");
printf("  Cached access: let cached = object.prop; use cached (more efficient)\n");

// Memory management with arrays
let memoryDemo = [];
printf("  Building large array...\n");
for (let i = 0; i < 10000; i++) {
    push(memoryDemo, { id: i, data: "item" + i });
}
printf("  Large array created with %d items\n", length(memoryDemo));

// Clear array efficiently
memoryDemo = []; // This allows garbage collection of old array
printf("  Array cleared, memory available for GC\n");

print("\n=== End of Arrays and Objects Example ===\n");
